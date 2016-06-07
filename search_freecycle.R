require(rvest)
require(dplyr)
require(stringr)
require(tibble)
library(methods)

setwd('.../freecycle/')

search_terms = c('television','sofa','bookcase')
fgroups = c('freecycle-kingston','richmonduponthamesfreecycle')

last_id = readLines('last_id.txt') %>% str_trim()
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
  
  for(txt in search_terms){
    matches = d$X2[ str_detect(d$X2, txt) ] %>% 
      str_replace_all('See details','') %>%
      str_trim()
    if(length(matches) > 0) report = c(report, matches)
  }
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
sink('last_id.txt')
cat(last_id, '\n')
sink()

