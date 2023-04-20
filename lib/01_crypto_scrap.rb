require 'nokogiri'
require 'watir'
require 'selenium-webdriver'
require 'webdrivers'

def database
  #1. Configuration de la page web pour qu'elle s'affiche entière (car elle utilise de la pagination) --------------
  #1.1 On ouvre le site via watir
  browser = Watir::Browser.new :chrome, headless:true #headless permet de ne pas ouvrir le navigateur
  browser.goto('https://coinmarketcap.com/all/views/all/')

  #1.2 On scroll 16 fois en bas de la page doucement en appuyant sur espace régulièrement
  16.times do 
    browser.send_keys(:space)
    sleep 0.1
  end

  #1.3 Lien avec Nokogiri
  page = Nokogiri::HTML.parse(browser.html)

  #2. On extrait les données ciblées -------------------------------------------------------------------------------

  nodes_crypto_symbols = page.xpath('//tbody/tr[@class = "cmc-table-row"]/td[@class = "cmc-table__cell cmc-table__cell--sortable cmc-table__cell--left cmc-table__cell--hide-sm cmc-table__cell--sort-by__symbol"]/div[@class = ""]')
  nodes_crypto_prices = page.xpath('//tbody/tr[@class = "cmc-table-row"]/td[@class = "cmc-table__cell cmc-table__cell--sortable cmc-table__cell--right cmc-table__cell--sort-by__price"]/div[@class = "sc-cadad039-0 clgqXO"]/a/span')

  browser.close #fermeture browser

  array_crypto_symbols = nodes_crypto_symbols.map{|i|i.text} #on récupère seulement le texte du node
  array_crypto_prices = nodes_crypto_prices.map{|i|i.text} 

  array_crypto_prices.map!{|price|(price.delete",$").to_f} #on supprime le symbole $ et on passe en float

  #3. On crée un hash à partir des array -----------------------------------------------------------------
  
  array_crypto = array_crypto_symbols.zip(array_crypto_prices).map {|name, value| {name => value }}
  return array_crypto
end 

puts database