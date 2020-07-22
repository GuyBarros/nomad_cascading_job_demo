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
  task "Third_Job" {
       constraint {
        attribute = "${meta.name}"
        value     = "EU-guystack-server-0"
      }
      volume_mount {
        volume      = "shared_vol"
        destination = "/tmp/shared"
        }
      
      
    driver = "raw_exec"
template {
      data = <<EOH
set -v
echo "get your nomad groove on"

cd /tmp/shared
ls -lia

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
 } #group
} #jobs