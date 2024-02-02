###################################################
# download.results.R
# Rich Stockey 20240202
# designed to enable you to download the results of an R script that has run on an HPC facility using runR.R
###################################################
# full comments to follow...

download.results <- function(ssh,
                         results.file,
                         local.dir = "~/", # note local dir needs to be followed by backslash!
                         remote.dir = "~/",
                         load.rdata = FALSE){


  library(ssh)

  # initiate ssh session (will prompt you for password!)
  session <- ssh_connect(ssh)

  # download output.file
  scp_download(session, files = results.file, to = local.dir)
  ssh_disconnect(session)


  if(load.rdata == TRUE){
    load(paste0(local.dir, results.file))
  }
}


######## test parameters: ########
# nodes = 1
# ntasks = 1
# hours = 60
# email.updates = TRUE
# ssh = "rgs1e22@iridis5.soton.ac.uk"
# local.dir = "~/"
# remote.dir = "~/"
# sbatch.name = "default"
# email = "r.g.stockey@soton.ac.uk"
# output.file="default"
# rscript = "test.R"

######## test function call ########
# download.results(ssh = "rgs1e22@iridis5.soton.ac.uk",
#              results.file = "test.plot.pdf",
#              local.dir = "~/", # note local dir needs to be followed by backslash!
#              remote.dir = "~/")  # default sbatch name will be the same name as your rscript with different file type
