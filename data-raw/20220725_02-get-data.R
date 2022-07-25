


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

# get undescore names to facilitate data manipulation
percent_positive <- janitor::clean_names(percent_positive)
case_rate <- janitor::clean_names(case_rate)
test_rate <- janitor::clean_names(test_rate)

# see structure
case_rate |> dplyr::glimpse()

# clean and reshape caserates data
case_rate_long <- case_rate|> 
    
    # remove initial columns
    dplyr::select(-c(caserate_city:caserate_si)) |> 
    
    # reshape data
    tidyr::pivot_longer(
        cols = caserate_10001:caserate_11697,
        names_to = "modczta",
        names_prefix = "caserate_",
        values_to = "case_rate"
    )

# see structure
case_rate_long |> dplyr::glimpse()


# clean and reshape percent_positives data
percent_positive |> dplyr::glimpse() # see structure

percent_positive_long <- percent_positive |> 
    dplyr::select(-c(pctpos_city:pctpos_si)) |> 
    tidyr::pivot_longer(
        cols = pctpos_10001:pctpos_11697,
        names_to = "modzcta",
        names_prefix = "pctpos_",
        values_to = "percent_positive"
    )

percent_positive_long |> dplyr::glimpse() # see structure
 