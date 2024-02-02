###################################################
# check.output.R
# Rich Stockey 20240202
# designed to enable you to check the output of an R script runnning on an HPC facility using runR.R
###################################################
# full comments to follow...

check.output <- function(ssh,
                 rscript,
                 local.dir = "~/", # note local dir needs to be followed by backslash!
                 remote.dir = "~/",
                 output.file="default",
                 verbose = TRUE){


  library(ssh)

  # initiate ssh session (will prompt you for password!)
  session <- ssh_connect(ssh)

  if(output.file == "default"){
    output.file.name <- paste0(rscript, ".out")
  }
  # download output.file
  scp_download(session, files = output.file.name, to = local.dir)
  ssh_disconnect(session)

  text <- read.csv(paste0(local.dir, output.file.name), header=FALSE, comment.char="#")

  if(verbose == TRUE){
    print(text)
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
# check.output(ssh = "rgs1e22@iridis5.soton.ac.uk",
#              rscript = "test.R",
#              local.dir = "~/", # note local dir needs to be followed by backslash!
#              remote.dir = "~/",
#              output.file="default")  # default sbatch name will be the same name as your rscript with different file type

# or
# x <- check.output(ssh = "rgs1e22@iridis5.soton.ac.uk",
#              rscript = "test2.R",
#              local.dir = "~/", # note local dir needs to be followed by backslash!
#              remote.dir = "~/",
#              output.file="default")  # default sbatch name will be the same name as your rscript with different file type



######## test function call ########
# check.output(ssh = "rgs1e22@iridis5.soton.ac.uk",
#              rscript = "test2.R",
#              local.dir = "~/", # note local dir needs to be followed by backslash!
#              remote.dir = "~/",
#              output.file="default")  # default sbatch name will be the same name as your rscript with different file type
