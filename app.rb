# Récupère tous les gems

require 'bundler'
Bundler.require

# Récupère toutes les classes pour pouvoir les appeler plus simplement

$:.unshift File.expand_path("./../lib/app", __FILE__)
require 'scrapper'

# Initialize un nouvelle objet

email = ScrapTownhall.new

# stock tout les nom et email dans une variable de class

email.get_name_and_email_townhall

# sauvegarde les nom de ville et leur email dans un csv

email.save_as_csv

# sauvegarde les nom de ville et leur email dans un json

email.save_as_JSON

# sauvegarde les nom de ville et leur email dans le spreadsheet

email.save_as_spreadsheet