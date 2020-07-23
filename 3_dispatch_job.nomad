job "dispatch_job" {
 region = "eu-west-2"
  datacenters = ["eu-west-2a","eu-west-2b","eu-west-2c"]
   type = "batch"
   parameterized {
       payload       = "optional"
    meta_required = ["keyname"] 
  }
   
 group "jobs" {
         count = 1

         volume "shared_vol" {
      type = "host"
        source = "shared_mount"
    }
  task "finish the demo" {
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
template {
      data = <<EOH
set -v

echo "I get the parameter and add it here: ${NOMAD_META_keyname} "

cat ${NOMAD_TASK_DIR}/config.json

echo "finished"

EOH
destination = "script.sh"
perms = "755"
}
dispatch_payload {
        file = "config.json"
      }
        config {
      command = "bash"
      args    = ["script.sh"]
    }
  }

 } #group
} #jobs