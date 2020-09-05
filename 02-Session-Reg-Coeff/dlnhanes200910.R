library(lodown)
# examine all available NHANES microdata files
nhanes_cat <-
    get_catalog( "nhanes" ,
                 output_dir = file.path( path.expand( "~" ) , "NHANES" ) )
# 2015-2016 only
nhanes_cat <- subset( nhanes_cat , years == "2009-2010" &
    grepl("glu_f", nhanes_cat$file_name, ignore.case = TRUE))
# download the microdata to your local computer
nhanes_cat <- lodown( "nhanes" , nhanes_cat )




