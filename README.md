## Freecycle Alerts

Configure a system (e.g. Raspberry Pi) to:

- check your Freecycle groups frequently for your search terms
- report e.g. daily on all new listings

Reports by email using `mailR` package.

#### Setup

E.g. for Rasbian:

	sudo apt-get install r-cran-rjava
    git clone https://github.com/geotheory/freecycle_alerts.git
    cd freecycle

Modify the script with your folder path, groups and search terms.

Install R - follow generic instructions elsewhere e.g. [here](http://raspberrypi.stackexchange.com/questions/41226/getting-the-latest-version-of-r-on-the-raspberry-pi).  [This workflow](https://gist.github.com/geotheory/4a1989c277401c6f12cf139e8614bb39) seems to work for me, and also configures the e.g. library location.

In R install the following packages: mailR, rvest, dplyr, stringr, tibble.

Configure your email account for `mailR` - see package instructions. Gmail definitely works.

Add a crontab job, e.g. `crontab -e` and add lines:

    0 12 * * * Rscript /pathto/freecycle/dail_email.R > /pathto/freecycle/log_daily 2>&1
    0,15,30,45 8-23 * * * Rscript /pathto/freecycle/search_freecycle.R > /pathto/freecycle/log_search 2>&1

You should now receive emails on your Freecycle group posts!
