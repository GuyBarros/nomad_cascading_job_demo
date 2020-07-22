job "vaultupdater" {
  datacenters = ["dc1","eu-west-2"]
  type = "batch"

periodic {
    cron             = "* * * * *"
    prohibit_overlap = true
  }

  group "calltoupdate" {
    count = 1
    
     task "createKeys" {
      driver = "exec"
      vault {
  policies = ["superuser"]
}


      env {
        VAULT_ADDR = "https://active.vault.service.consul:8200"
      }

      artifact {
           source   = "git::https://github.com/GuyBarros/nomad_cascading_job_demo.git"
           destination = "local/repo/1/"
           
         }

      config {
        command = "local/repo/1/run.sh"
      }

      resources {
        network {
          port "proxy" {}
        }
      }
    } 

  }

}
