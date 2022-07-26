
# Script 2 - Get data
# Objective: reading each useful data that was downloaded, cleaning it and joining
# then in the shapefile to consolidate a base that will be used in shiny app.
# Sorce: https://www.youtube.com/watch?v=eIpiL6y1oQQ&ab_channel=RockEDUScienceOutreach

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
        names_to = "modzcta",
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


# clean and reshape test_rates data
test_rate |> dplyr::glimpse() # see structure

test_rate_long <- test_rate |> 
    dplyr::select(-c(testrate_city:testrate_si)) |> 
    tidyr::pivot_longer(
        cols = testrate_10001:testrate_11697,
        names_to = "modzcta",
        names_prefix = "testrate_",
        values_to = "test_rate"
    )

test_rate_long |> dplyr::glimpse() # see structure



# Merge in geography data -------------------------------------------------

# join case_rate with percent positive + test rate
all_data <- case_rate_long |> 
    dplyr::left_join(
        y = percent_positive_long,
        by = c("week_ending", "modzcta")
    ) |> 
    dplyr::left_join(
        y = test_rate_long,
        by = c("week_ending", "modzcta")
    )


# merge covid data with czta shapefile
all_modzcta <- modzcta |> 
    
    # function utilized in the video
    # tigris::geo_join(
    #     data_frame = all_data,
    #     by_sp = "MODZCTA",
    #     by_df = "modczta",
    #     how = "inner"
    # )
    # R recommends using this function instead of the one above
    dplyr::inner_join(
        y = all_data,
        by = c("MODZCTA" = "modczta")
    )


all_modzcta


# Clear geography data ----------------------------------------------------

all_modzcta |> dplyr::glimpse()  # see structure

# convert date columns to class data
all_modzcta <- all_modzcta |> 
    dplyr::mutate(
        week_ending = lubridate::mdy(week_ending)
    )



# Export data -------------------------------------------------------------

# export in rds extension to use in shiny
all_modzcta |> saveRDS("data/all_modzcta.rds")
