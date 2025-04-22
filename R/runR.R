###################################################
# runR.R
# Rich Stockey 20240202
# designed to enable you to run an R script on a HPC facility with just one command
###################################################
# full comments to follow...

runR <- function(ssh,
                 rscript,
                 local.dir = "~/", # note local dir needs to be followed by backslash!
                 remote.dir = "~/",
                 email.updates = TRUE,
                 email,
                 nodes = 1, # Should always be 1 for now!
                 ntasks = 1, # Number of cores requested (should be 1 if script is not parallelized - e.g. with foreach)
                 hours = 60, # keep hours as an integer for now
                 sbatch.name = "default", # default sbatch name will be the same name as your rscript with different file type
                 output.file = "default",
                 gcc.version = "gcc",
                 R.version = "R/4.1.1") { # default sbatch name will be the same name as your rscript with different file type


  library(ssh)

  # define sbatch file
  config.file <- paste0(
"#!/bin/sh

#SBATCH --nodes=", nodes, "                # Number of nodes requested
#SBATCH --ntasks=", ntasks,"
#SBATCH --time=", hours, ":00:00
", if(email.updates == TRUE){
paste0("#SBATCH --mail-user=", email, "")
},"
#SBATCH --mail-type=BEGIN,FAIL,END,TIME_LIMIT
#SBATCH --output=", rscript, ".out


cd ", remote.dir,"
module purge
", if(ntasks > 1){
  paste0("export OMP_NUM_THREADS=$SLURM_NTASKS")
},"
module load gcc
module load R/4.1.1

Rscript ", rscript, "
")

# write sbatch file - two options based on sbatch name
  if(sbatch.name == "default"){
    sbatch.file.local <- paste0(local.dir, rscript, ".sbatch")
    sbatch.file.short <- paste0(rscript, ".sbatch")
    writeLines(config.file, paste0(local.dir, rscript, ".sbatch"))
  }else{
    sbatch.file.local <- paste0(local.dir, sbatch.name)
    sbatch.file.short <- sbatch.name
    writeLines(config.file, paste0(local.dir, sbatch.name))
  }

# initiate ssh session (will prompt you for password!)
session <- ssh_connect(ssh)

# upload R script file
scp_upload(session, files =  paste0(local.dir, rscript), verbose=TRUE)

# upload sbatch file
if(remote.dir == "~/"){
  scp_upload(session, files = sbatch.file.local, verbose=TRUE)
}else {
  scp_upload(session, files = sbatch.file.local, to = remote.dir, verbose=TRUE)
}
ssh_exec_wait(session, command=paste0("cd ", remote.dir, "; module load gdal; module load ", gcc.version, "; module load ", R.version, "; sbatch ", sbatch.file.short))
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

######## test function call ########
# runR(ssh = "rgs1e22@iridis5.soton.ac.uk",
#      rscript = "test2.R",
#      local.dir = "~/",
#      remote.dir = "~/",
#      email.updates = TRUE,
#      email = "r.g.stockey@soton.ac.uk",
#      nodes = 1, # Should always be 1 for now!
#      ntasks = 1, # Number of cores requested (should be 1 if script is not parallelized - e.g. with foreach)
#      hours = 60, # keep hours as an integer for now
#      sbatch.name = "default", # default sbatch name will be the same name as your rscript with different file type
#      output.file="default"
# )

