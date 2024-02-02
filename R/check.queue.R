###################################################
# check.queue.R
# Rich Stockey 20240202
# designed to enable you to upload data to an HPC facility
###################################################
# full comments to follow...
# note that for now this only uploads to the home directory of your cluster account...
# this particular one will only really work on IRIDIS...

check.queue <- function(ssh,
                          ssh.address = "@iridis5.soton.ac.uk"
                          ){
  library(ssh)
  library(stringr)

  # initiate ssh session (will prompt you for password!)
  session <- ssh_connect(ssh)

  user.id <- sub(ssh.address, "", ssh)

  ssh_exec_wait(session, command=paste0("squeue -lu ", user.id))

  ssh_disconnect(session)
}

######## test function call ########
check.queue(ssh = "rgs1e22@iridis5.soton.ac.uk")
