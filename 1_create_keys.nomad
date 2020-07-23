job "Dispatch" {
  region = "eu-west-2"
  datacenters = ["eu-west-2a","eu-west-2b","eu-west-2c"]
   type = "batch"

  group "calltoupdate" {
    count = 1
    volume "shared_vol" {
      type = "host"
        source = "shared_mount"
    }
     task "createKeys" {
         constraint {
        attribute = "${meta.name}"
        value     = "EU-guystack-server-0"
      }
      driver = "exec"
      lifecycle {
        hook    = "prestart"
      }
      volume_mount {
        volume      = "shared_vol"
        destination = "/tmp/shared"
        }

      artifact {
           source   = "git::https://github.com/GuyBarros/nomad_cascading_job_demo.git"
           destination = "local/repo/1/"
           
         }

      config {
        command = "local/repo/1/create_keys.sh"
      }

      
    }  #task
    task "call_next_nomad_job" {
      driver = "exec"
      env {
        NOMAD_ADDR = "https://nomad-server.service.consul:4646"
      }
      
      artifact {
           source   = "git::https://github.com/GuyBarros/nomad_cascading_job_demo.git"
           destination = "local/repo/1/"
           
         }

     config {
    command = "/usr/local/bin/nomad"
    args    = ["job","run","local/repo/1/2_upload_to_vault.nomad"]
  }

     
    }
  } #group

}#job
