job "cascading_bash_jobs" {
 region = "eu-west-2"
  datacenters = ["eu-west-2a","eu-west-2b","eu-west-2c"]
   type = "batch"
   
 group "jobs" {
         count = 1

         volume "shared_vol" {
      type = "host"
        source = "shared_mount"
    }
  task "Load_to_vault" {
    lifecycle {
        hook    = "prestart"
      }
       constraint {
        attribute = "${meta.name}"
        value     = "EU-guystack-server-0"
      }
      volume_mount {
        volume      = "shared_vol"
        destination = "/tmp/shared"
        }
      
      
    driver = "exec"
    env {
        VAULT_ADDR = "https://active.vault.service.consul:8200"
      }
template {
      data = <<EOH
set -v
echo "get your nomad groove on"

cd /tmp/shared
ls -lia
vault kv put kv/nomad_keys keypairs=@keypair.pem
vault kv patch kv/nomad_keys publickey=@publickey.crt
vault kv patch kv/nomad_keys private_unencrypted=@private_unencrypted.pem
vault kv patch kv/nomad_keys pkcs8=@pkcs8.key

echo "finished"

EOH
destination = "script.sh"
perms = "755"
}
        config {
      command = "bash"
      args    = ["script.sh"]
    }
  }

  task "Dispatch_Job" {
    driver = "exec"
       constraint {
        attribute = "${meta.name}"
        value     = "EU-guystack-server-0"
      }
           env {
        NOMAD_ADDR = "https://nomad-server.service.consul:4646"
      }
      
    
template {
      data = <<EOH
set -v

nomad job dispatch -meta "keyname=example" dispatch_job

EOH
destination = "script.sh"
perms = "755"
}
        config {
      command = "bash"
      args    = ["script.sh"]
    }
  }

 } #group
} #jobs