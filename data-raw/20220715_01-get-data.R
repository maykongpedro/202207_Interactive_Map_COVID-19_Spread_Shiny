

# Download data -----------------------------------------------------------

# get url
url <- "https://github.com/nychealth/coronavirus-data/archive/refs/heads/master.zip"

# download
download.file(
    url = url,
    destfile = "./inst/downloads/corona-virus-data-master.zip"
)

# unzip
unzip(zipfile = "./inst/downloads/corona-virus-data-master.zip")



# Organize data -----------------------------------------------------------

# move files
fs::dir_copy(
    path = "coronavirus-data-master/",
    new_path = "inst/downloads/coronavirus-data-master/"
)

# delete root files
fs::dir_delete(path = "coronavirus-data-master/")


# move data to data-raw
# percent positive
fs::file_copy(
    path = "inst/downloads/coronavirus-data-master/trends/percentpositive-by-modzcta.csv",
    new_path = "data-raw/csv/percentpositive-by-modzcta.csv"
)

# case rate
fs::file_copy(
    path = "inst/downloads/coronavirus-data-master/trends/caserate-by-modzcta.csv",
    new_path = "data-raw/csv/caserate-by-modzcta.csv"
)


# test rate
fs::file_copy(
    path = "inst/downloads/coronavirus-data-master/trends/testrate-by-modzcta.csv",
    new_path = "data-raw/csv/testrate-by-modzcta.csv"
)


# shapefile
fs::dir_copy(
    path = "inst/downloads/coronavirus-data-master/Geography-resources/",
    new_path = "data-raw/shp/Geography-resources/"
)


# Get data ----------------------------------------------------------------

# read data
percent_positive <- vroom::vroom("data-raw/csv/percentpositive-by-modzcta.csv")
case_rate <- vroom::vroom("data-raw/csv/caserate-by-modzcta.csv")
test_rate <- vroom::vroom("data-raw/csv/testrate-by-modzcta.csv")


# read geodata
modzcta <- sf::st_read(
    dsn = "data-raw/shp/Geography-resources/MODZCTA_2010.shp"
)

# modzcta <- sf::read_sf(
#     "data-raw/shp/Geography-resources/MODZCTA_2010.shp",
# )


# read conversion table
zcta_cov <- vroom::vroom(
    file = "data-raw/shp/Geography-resources/ZCTA-to-MODZCTA.csv",
    delim = ","
    )


# Clean data --------------------------------------------------------------


