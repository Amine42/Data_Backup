require './lib/app/scrapper.rb'

email = ScrapTownhall.new
email.get_townhall_name
email.get_townhall_url

puts email.get_name_and_email_townhall
