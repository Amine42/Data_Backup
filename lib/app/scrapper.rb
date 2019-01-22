# Récuperation des gem

require 'nokogiri'
require 'open-uri'

# Création de la class ScrapTownhall :
# Variables : contient une variable doc qui accède a l'url et 3 varibles qui contienne des tableau
# Method : Contient une method qui recupère le nom des ville, une method qui recupère les url, une method qui recupére une email, une method qui recupere le nom de la ville et l'email

class ScrapTownhall
  @@doc = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))
  @@name = []
  @@url = []
  @@name_and_email = []

  def initialize
    annuaire = @@doc.css("a.lientxt")
  
    annuaire.map do |element|
      @@name << { "ville" => element.text }
    end
  
    annuaire = @@doc.css("a.lientxt")
  
    annuaire.map do |element|
      link = element["href"]
      link[0] = ""
      @@url << { "url" => "http://annuaire-des-mairies.com" + link }
    end
    @@name
    @@url
  end

  def get_townhall_email(url)
    doc = Nokogiri::HTML(open(url))
    email = doc.xpath("/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]").text
  end

  def get_name_and_email_townhall
    @@url.map.with_index do |url, index|
    
      email = get_townhall_email(url["url"])
      
      if email == ""
        @@name_and_email << { @@name[index]["ville"] => "NO EMAIL" }
      else
        @@name_and_email << { @@name[index]["ville"] => email }
      end
    end
    @@name_and_email
  end
end
