# Récuperation des gem

require 'nokogiri'
require 'open-uri'

# Création de la class ScrapTownhall :
# Variables : contient une variable doc qui accède a l'url et 3 varibles qui contienne des tableau
# Method : Contient une method initialize qui recupère les nom est les url, une method qui recupere une email (pour pouvoir boucler sur cette method ) et une method qui recupere le nom des ville et les email tous sa lier dans un hash

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

      if email == "" # On test le cas ou la mairie n'a pas d'email
        @@name_and_email << { @@name[index]["city_name"] => "NO EMAIL" } # on remplace par no email si la mairie n'a pas d'email
      else 
        @@name_and_email << { @@name[index]["city_name"] => email } # Sinon on mais l'email dans le tableau
      end
    end
    @@name_and_email # Return le tableaux avec les nom et les email
  end
end
