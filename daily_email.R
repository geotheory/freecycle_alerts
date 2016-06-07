require(rvest)
require(dplyr)
require(stringr)
require(tibble)
library(methods)

setwd('.../freecycle/')

fgroups = c('freecycle-kingston','richmonduponthamesfreecycle')

last_id = readLines('last_daily_id.txt') %>% str_trim()
root = 'https://groups.freecycle.org/group/'
tail = '/posts/offer?page=1&resultsperpage=100'

session_ids = character(0)
report = character(0)

for(grp in fgroups){
  url = paste0(root, grp, tail)
  doc = read_html(url)
  d = doc %>% html_nodes(xpath = '//*[@id="group_posts_table"]') %>% 
    html_table() %>% as.data.frame() %>% as_data_frame() %>%
    mutate(id = str_extract(X1, '#[0-9]+'))
  session_ids = c(session_ids, d$id)
  d = d %>% filter(id > last_id)
  matches = d$X2 %>% str_replace_all('See details','') %>% str_trim()
  report = c(report, '', toupper(grp), '', matches)
}

if(length(report) > 0){
  report = paste0(report, collapse='\n')
  require(mailR)
  send.mail(from = "myemail@gmail.com", to = "myemail@gmail.com",
            subject = "freecycle alert", body = report,
            smtp = list(host.name = "smtp.gmail.com", port = 465, user.name = "myusername", passwd = "mykey", ssl = TRUE),
            authenticate = TRUE, send = TRUE)
}

last_id = max(session_ids)
sink('last_daily_id.txt')
cat(last_id, '\n')
sink()

