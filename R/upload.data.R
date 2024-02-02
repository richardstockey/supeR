###################################################
# upload.data.R
# Rich Stockey 20240202
# designed to enable you to upload data to an HPC facility
###################################################
# full comments to follow...
# note that for now this only uploads to the home directory of your cluster account...

upload.data <- function(ssh,
                        data.file,
                        local.dir = "~/", # note local dir needs to be followed by backslash!
                        remote.dir = "~/"){


  library(ssh)

  # initiate ssh session (will prompt you for password!)
  session <- ssh_connect(ssh)

  # download output.file
  scp_upload(session, files = paste0(local.dir, data.file))
  ssh_disconnect(session)
}

######## test function call ########
upload.data(ssh = "rgs1e22@iridis5.soton.ac.uk",
            data.file = "biogem_series_ocn_O2.res",
            local.dir = "~/", # note local dir needs to be followed by backslash!
            remote.dir = "~/")
