## Freecycle Alerts

Configure a system (e.g. Raspberry Pi) to check your Freecycle groups for your search terms and/or to report on everything.  Reports by email using `mailR` package.

#### Setup

E.g. for Rasbian:

	sudo apt-get install r-cran-rjava
    git clone https://github.com/geotheory/freecycle_alerts.git
    cd freecycle

Install R - follow generic instructions elsewhere

In R install the following packages: mailR, rvest, dplyr, stringr, tibble.

Configure your email account for `mailR` - see package instructions. Gmail definitely works.

Add a crontab job, e.g. `crontab -l` and add lines:

    0 12 * * * Rscript /pathto/freecycle/dail_email.R > /pathto/freecycle/log_daily 2>&1
    0,15,30,45 8-23 * * * Rscript /pathto/freecycle/search_freecycle.R > /pathto/freecycle/log_search 2>&1

You should now receive emails on your Freecycle group posts!
