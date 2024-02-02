###################################################
# install.R.packages.R
# Rich Stockey 20240202
# designed to enable you to install R packages on a HPC facility with just one command
###################################################
# full comments to follow...
# right now this may only work for iridis accounds because of the custom library being hard coded...

install.R.packages <- function(ssh,
                 packages, # this should be a vector like the one you would pass to install.packages on a local machine
                 local.dir = "~/", # note local dir needs to be followed by backslash!
                 remote.dir = "~/",
                 R.file.name = "install.R.packages.R",
                 gcc.version = "gcc",
                 R.version = "R/4.1.1") { # default sbatch name will be the same name as your rscript with different file type


  library(ssh)

  # define sbatch file
  R.file <- paste0(
    "
    if(dir.exists('~/R/x86_64-pc-linux-gnu-library/4.1')){
    }else{
    system(paste0('mkdir ~/R/x86_64-pc-linux-gnu-library/4.1'))}
    install.packages(", packages,", lib = '~/R/x86_64-pc-linux-gnu-library/4.1', repos = 'https://cloud.r-project.org')
")
  #install.packages(", packages,")
  writeLines(R.file, paste0(local.dir, R.file.name))

  # initiate ssh session (will prompt you for password!)
  session <- ssh_connect(ssh)

  # upload R script file
  scp_upload(session, files = paste0(local.dir, R.file.name), verbose=TRUE)

  ssh_exec_wait(session, command = paste0("cd ", remote.dir, "; module load ", gcc.version, "; module load ", R.version, "; Rscript ", R.file.name))
  ssh_disconnect(session)
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
# packages = "c('ggplot2')" # this should be a vector like the one you would pass to install.packages on a local machine
# sh.file.name = "install.R.packages.sh"
# R.file.name = "install.R.packages.R"
# gcc.version = "gcc"
# R.version = "R/4.1.1"

######## test function call ########
# install.R.packages(ssh = "rgs1e22@iridis5.soton.ac.uk",
#      packages = "c('ggplot2')" # this should be a vector like the one you would pass to install.packages on a local machine
# )

