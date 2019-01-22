require 'bundler'
Bundler.require

# Récupère la class ScapTownhall

$:.unshift File.expand_path("./../lib/app", __FILE__)
require 'scrapper'

# Initialize un nouvelle objet

email = ScrapTownhall.new

# Affiche tous les ville et les emails qui y corresponde

email.get_name_and_email_townhall
