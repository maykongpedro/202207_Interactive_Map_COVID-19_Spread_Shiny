

# Download data -----------------------------------------------------------

# get url
url <- "https://github.com/nychealth/coronavirus-data/archive/refs/heads/master.zip"

# download
download.file(
    url = url,
    destfile = "./inst/downloads/corona-virus-data-master.zip"
)

# unzip
unzip(
    zipfile = "./inst/downloads/corona-virus-data-master.zip"
)

# move files
fs::dir_copy(
    path = "coronavirus-data-master/",
    new_path = "inst/downloads/coronavirus-data-master/"
)

# delete root files
fs::dir_delete(path = "coronavirus-data-master/")


# Get data ----------------------------------------------------------------


