
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pry'


def get_townhall_email(townhall_url)

page = Nokogiri::HTML(open(townhall_url))		#on met l'url en tant que variable afin d'éviter un message d'erreur avec la constante PAGE_URL

email_town = page.css('table.table:nth-child(1) > tbody:nth-child(3) > tr:nth-child(4) > td:nth-child(2)').text #on sélecte en utilisant css
return email_town

end




PAGE_URL = "http://annuaire-des-mairies.com/val-d-oise.html"


def get_townhall_urls

	url_storage = []								#crée un array vide où entreproser les url des villes que l'on scrappe

	page = Nokogiri::HTML(open(PAGE_URL))			#va chercher la page que l'on veut scrapper

	url = page.css(".Style20 a")					#select la donnée que l'on veut scrapper sur la page

	url.each do |link|								#itère sur le dataobject node afin d'ajouter les attributs href à l'array vide créé plus tôt

		url_storage << link['href']

	end


return url_storage

end




def get_all_email 

	all_email = []

	all_url = []

	all_url = get_townhall_urls							#array with strings

	all_url = all_url.map { |e| e.delete_prefix(".") }


	all_url.each do |url | 

			url = "http://annuaire-des-mairies.com" + url

			all_email << get_townhall_email(url)
	end

	return all_email

end

puts get_all_email