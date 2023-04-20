require 'http'
require 'nokogiri'
require 'open-uri'

def database_url #Méthode qui permet d'avoir accès aux URL des pages de chaque mairie

  #1. Extraction de la base url de toutes les mairies du Val d'Oise --------------------------------------------------

  base_web_directory = "https://www.annuaire-des-mairies.com/val-d-oise.html"
  base_url_municipalities = "http://www.annuaire-des-mairies.com"
  docs_array_directory = Nokogiri::HTML(URI.open(base_web_directory)) 

  node_link_municipalities = docs_array_directory.xpath('//a[@class = "lientxt"]/@href')

  #2. Reconstruction des URL des pages de chaque mairies -------------------------------------------------------------

  array_link_municipalities = node_link_municipalities.map{|link|link.to_s.sub(/\./,'')} #on enlève le point avec le bout d'url
  array_link_municipalities.map!{|link|base_url_municipalities+link} #on reconstruit toute l'url de la page de chaque mairie
  return array_link_municipalities #on retourne une array avec les urls des pages des mairies
end 


def name_email_municipalities (list_url) #Méthode d'extraire les infos de chaque mairie (sur sa page)
  #1. Choix des pages ciblées ----------------------------------------------------------------------------------------

  docs_array_municipalities = list_url.map { |link| Nokogiri::HTML(URI.open(link)) } 

  #2. Extraction des noms et emails ----------------------------------------------------------------------------------
  array_name_municipalities = []
  array_email_municipalities = []

  docs_array_municipalities.each do |doc| 
    array_name_municipalities << doc.xpath('//div[@class = "jumbotron text-center"]/h1/small')
    array_email_municipalities << doc.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]')
  end 

  array_name_municipalities = array_name_municipalities.flatten
  array_email_municipalities = array_email_municipalities.flatten

  array_name_municipalities.map!{|name|name.to_s[18..(name.to_s.length-9)]} #on garde seulement le nom de la mairie
  array_email_municipalities.map!{|email|email.to_s[4..(email.to_s.length-6)]} #on garde seulement le nom de la mairie
  
  #3. Création d'une array de hashs avec toutes les informations -----------------------------------------------------
  array_info = array_name_municipalities.zip(array_email_municipalities).map {|name, email| {name => email }}
  return array_info

end 

puts name_email_municipalities(database_url)