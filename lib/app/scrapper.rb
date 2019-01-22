require 'nokogiri'
require 'open-uri'

class ScrapTownhall
  @@doc = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))
  @@name = []
  @@url = []
  @@name_and_email = []

  def get_townhall_name
    annuaire = @@doc.css("a.lientxt")
  
    annuaire.map do |element|
      @@name << { "ville" => element.text }
    end
    @@name
  end

  def get_townhall_url
    annuaire = @@doc.css("a.lientxt")
  
    annuaire.map do |element|
      link = element["href"]
      link[0] = ""
      @@url << { "url" => "http://annuaire-des-mairies.com" + link }
    end
    @@url
  end

  def get_townhall_email(url)
    doc = Nokogiri::HTML(open(url))
    email = doc.xpath("/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]").text
  end

  def get_name_and_email_townhall
    @@url.map.with_index do |url, index|
      #puts url["url"]
      #puts @@name[index]["ville"]
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

