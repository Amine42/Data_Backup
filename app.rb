# Récupère la class ScapTownhall

require './lib/app/scrapper.rb'

# Initialize un nouvelle objet

email = ScrapTownhall.new 

# Affiche tous les ville et les emails qui y corresponde

email.get_name_and_email_townhall
