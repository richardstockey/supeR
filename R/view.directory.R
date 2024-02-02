###################################################
# view.directory.R
# Rich Stockey 20240202
# designed to enable you to upload data to an HPC facility
###################################################
# full comments to follow...
# note that for now this only uploads to the home directory of your cluster account...

view.directory <- function(ssh,
                        remote.dir = "~/",
                        simple = FALSE){


  library(ssh)

  # initiate ssh session (will prompt you for password!)
  session <- ssh_connect(ssh)

  # download output.file
  if(simple == FALSE){
  ssh_exec_wait(session, command=paste0("cd ", remote.dir, "; ls -lh"))
  }
  if(simple == TRUE){
    ssh_exec_wait(session, command=paste0("cd ", remote.dir, "; ls"))
  }
  ssh_disconnect(session)
}

######## test function call ########
# view.directory(ssh = "rgs1e22@iridis5.soton.ac.uk",
#             remote.dir = "~/",
#             simple = FALSE)
