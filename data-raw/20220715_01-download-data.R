

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


