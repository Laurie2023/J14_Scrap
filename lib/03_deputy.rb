require 'http'
require 'nokogiri'
require 'open-uri'

def database_url 

  #1. Préparation des liens de toutes les pages de l'annuaire --------------------------------------------------------

  base_web_directory = "https://www.voxpublic.org/spip.php?page=annuaire&cat=deputes&lang=fr#pagination_deputes"
  base_url_directory = "https://www.voxpublic.org/spip.php?page=annuaire&cat=deputes&lang=fr&debut_deputes="
  base_url_municipalities = "http://www.annuaire-des-mairies.com"
  number_subpages_directory = 58

  urls_array_directory = []
  urls_array_directory << base_web_directory

  (1...number_subpages_directory).each do |number|
    urls_array_directory << "#{base_url_directory}#{number*10}#pagination_deputes"
  end 

  docs_array_directory = urls_array_directory.map { |url| Nokogiri::HTML(URI.open(url)) } 

  #2. Extraction des informations ------------------------------------------------------------------------------------

  array_email_deputies = []
  array_name_deputies = []
  array_first_name_deputies = []
  array_last_name_deputies = []
  
  docs_array_directory.each do |doc| 
    array_email_deputies << doc.xpath('//a[contains(@href, "@assemblee-nationale.fr")]').map(&:text)
    array_name_deputies << doc.xpath('//h2[@class = "titre_normal"]')
  end 

  array_email_deputies = array_email_deputies.flatten
  array_name_deputies = array_name_deputies.flatten

  #3. Mise en forme des informations et création d'une array de hash -------------------------------------------------
  
  array_email_deputies.map!{|email|email.to_s.strip}
  array_name_deputies.map!{|name|name.to_s[25..(name.to_s.length-6)]}

  array_name_deputies.map!{|name|name.split}
    
  array_name_deputies.each do |array|
    array_first_name_deputies << array[0]
    array_last_name_deputies << array[1..array.length].join(" ")
  end 

  array_info = array_first_name_deputies.zip(array_last_name_deputies,array_email_deputies)
  array_final = []
  array_info.each do |item|
    hash = {
      "first name:" => item[0],
      "last name :" => item[1],
      "email :" => item[2]
    }
  array_final << hash
  end 

  return array_final
end 

puts database_url
