job "cascading_bash_jobs" {
 region = "eu-west-2"
  datacenters = ["eu-west-2a","eu-west-2b","eu-west-2c"]
   type = "batch"
   
 group "jobs" {
         count = 1
         volume "shared_vol" {
      type = "host"
        source = "share_mount"
    }
  task "Third_Job" {
       constraint {
        attribute = "${meta.type}"
        value     = "server"
      }
      volume_mount {
        volume      = "shared_vol"
        destination = "/tmp/shared"
        }
      env {
        VAULT_ADDR = "https://active.vault.service.consul:8200"
      }
      
    driver = "raw_exec"
template {
      data = <<EOH
set -v

# Generate a 2048 bit RSA Key
echo "get your nomad groove on"

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