# Récuperation des gem

require 'nokogiri'
require 'open-uri'
require 'json'
require 'csv'

# Création de la class ScrapTownhall :
# Variables : contient une variable doc qui accède a l'url et 3 varibles qui contienne des tableau
# Method : 
# - Une method initialize qui recupère les nom est les url
# - Une method qui recupère une email (pour pouvoir boucler sur cette method ) 
# - Une method qui recupère le nom des ville et les email tous sa lier dans un hash
# - Une method qui recupère le tableaux de nom de ville et d'email pour l'ecrire dans un fichier JSON

class ScrapTownhall
  # Initialisation de mes variables

  @@doc = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))
  @@name = []
  @@url = []
  @@name_and_email = []

  # Creation de la method initalize qui recupère le contenue des page et les stock dans c'est 2 tableaux

  def initialize
    annuaire = @@doc.css("a.lientxt") # Recupère le texte du lien soit le nom de la ville
  
    annuaire.map do |element| # Parcours annuaire qui contient le nom des ville
      @@name << { "city_name" => element.text } # Mais le nom des ville dans le tableaux name
      link = element["href"] # Recupère le lien du a 
      link[0] = "" # On remplace l'index 0 du lien par vide pour supprimer le point qui etait en trop
      @@url << { "url" => "http://annuaire-des-mairies.com" + link } # Mais les lien dans le tableau url
    end
    @@name # Return name
    @@url # Return url
  end

  # Création de la method qui recupere une email pour quond boucle dessus

  def get_townhall_email(url)
    doc = Nokogiri::HTML(open(url)) # On accède a l'url pour recuperé les email
    email = doc.xpath("/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]").text # Recupère l'email avec xpath
  end

  # Création de la method qui récupere le nom et les email et qui les stock dans un tableaux

  def get_name_and_email_townhall
    @@url.map.with_index do |url, index| # Parcour url
      email = get_townhall_email(url["url"]) # Mais l'email dans une variable
      @@name_and_email << { @@name[index]["city_name"] => email == "" ? "NO EMAIL" : email } # On test le cas ou la mairie n'a pas d'email. on remplace par "NO EMAIL" si la mairie n'a pas d'email et si elle as un email on le met dans le hash.
      break if index == 5
    end
    #save_as_JSON # Save les email dans un fichier JSON
    #save_as_csv # Save les email dans un fichier CSV
  end

  # Création de la method qui recupere le tableaux et l'ecrit dans une fichier JSON

  def save_as_JSON
    File.open("db/emails.json","w") do |save|
      save.write(@@name_and_email.to_json)
    end
  end

  # Création de la method qui recupere le tableaux et l'ecrit dans une fichier CSV

  def save_as_csv
    CSV.open("db/emails.csv", "wb") do |csv|
      csv << ["Ville","Email"]
      @@name_and_email.map do |hash|
        csv << hash.keys + hash.values
      end
    end
  end
end
