<<<<<<< HEAD
# Récuperation des gem

# require 'google_drive'
# require 'nokogiri'
# require 'open-uri'
# require 'json'
# require 'csv'

=======
>>>>>>> 96303305b6573e47f3759d24c8391048a3aa9735
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
    annuaire = @@doc.css("a.lientxt") # Recupère le texte du lien. ce texte corespond au nom de la ville
  
    annuaire.map do |element| # Parcours annuaire qui contient le nom des ville
      link = element["href"] # Recupère le lien du a (la valeur du Href)
      link[0] = "" # On remplace l'index 0 du lien par vide pour supprimer le point qui etait en trop
      @@name << { "city_name" => element.text } # Mais le nom des ville dans le tableaux name
      @@url << { "url" => "http://annuaire-des-mairies.com" + link } # Mais les lien dans le tableau url
    end
  end

  # Création de la method qui recupere une email pour quond boucle dessus

  def get_townhall_email(url)
    doc = Nokogiri::HTML(open(url)) # On accède a l'url pour recuperé les email
    doc.xpath("/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]").text # Recupère l'email avec xpath
  end

  # Création de la method qui récupere le nom et les email et qui les stock dans un tableaux

  def get_name_and_email_townhall
    @@url.map.with_index do |url, index| # Parcour url
      email = get_townhall_email(url["url"]) # Mais l'email dans une variable
      @@name_and_email << { @@name[index]["city_name"] => email == "" ? "NO EMAIL" : email } # On test le cas ou la mairie n'a pas d'email. on remplace par "NO EMAIL" si la mairie n'a pas d'email et si elle as un email on le met dans le hash.
      break if index == 5 # Bride le nombre de data a recuperer a 5
    end
    #save_as_JSON # Save les email dans un fichier JSON
    save_as_csv # Save les email dans un fichier CSV
    #save_as_spreadsheet
  end

  # Création de la method qui recupere le tableaux et l'ecrit dans une fichier JSON

  def save_as_JSON
    File.open("db/emails.json","w") do |save| # Ouvre le fichier JSON
      save.write(@@name_and_email.to_json) # Sauvegarde la tableau dans le fichier JSON
    end
  end

  # Création de la method qui recupere le tableaux et l'ecrit dans une fichier CSV

  def save_as_csv
    CSV.open("db/emails.csv", "wb") do |csv| # Ouvre le fichier csv
      csv << ["Ville","Email"] # Mais en entete ville , email
      @@name_and_email.map do |hash| # Parcour le tableaux pour recupéré les valeur
        csv << hash.keys + hash.values # mais les valeur de ville et de email dans le fichier csv
      end
    end
  end

  # Creation de la methode qui sauvegarde les donnees recuperer dans un spreadsheet grace a l'api

  def save_as_spreadsheet
    session = GoogleDrive::Session.from_config("../../config.json")
    spreadsheet = session.spreadsheet_by_name("testcreatefile").worksheets[0] # on dit a l'api que l'on souhaite modifier le spreadsheet qui porte X nom et la feuille numero 0 de ce meme spreadsheet
    @@name_and_email.map.with_index do |hash, index| # on parcour le tableau qui contion les nom et les emails de chasque ville
      name = hash.keys # je met la key du hash dans une variable, cette variable corespond au nom de la ville
      name = name[0] # je transforme ma variable en string (sans cette ligne cette variable est de type array)
      email = hash.values # je met la value du hash dans une variable, cette variable corespond a l'email de la ville
      email = email[0] # je transforme ma variable en string (sans cette ligne cette variable est de type array)
      spreadsheet[index + 1, 1] = name # le programme envoi le nom de la ville sur le spreadsheet
      spreadsheet[index + 1, 2] = email # le programme envoi l'email de la ville sur le spreadsheet
    end
    spreadsheet.save # le programme sauvegarde les modifications sur le spreadsheet qu'il a modifier
  end
end
