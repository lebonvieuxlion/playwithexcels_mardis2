
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pry'
require 'json'
require 'google_drive'
require 'csv'



class Scrapper



#OBTENIR L'EMAIL SUR LA PAGE D'UNE VILLE


	def get_townhall_email(townhall_url)

	page = Nokogiri::HTML(open(townhall_url))		#on met l'url en tant que variable afin d'éviter un message d'erreur avec la constante PAGE_URL

	email_town = page.css('table.table:nth-child(1) > tbody:nth-child(3) > tr:nth-child(4) > td:nth-child(2)').text #on sélecte en utilisant css
	return email_town

	end





#CONSTANTE ET METHODE POUR SCRAPPER LES URLS DES PAGES DE CHAQUE VILLE


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




#OBTENIR TOUS LES NOMS DE VILLE

	def get_townhall_name

		name_storage = []								#crée un array vide où entreproser les noms des villes que l'on scrappe

		page = Nokogiri::HTML(open(PAGE_URL))			#va chercher la page que l'on veut scrapper

		 town_name = page.css(".Style20 a")				#select la donnée que l'on veut scrapper sur la page

		town_name.each do |link|						#itère sur le dataobject node afin d'ajouter le texte des balises <a> à l'array name_storage

			name_storage << link.text

		end


	return name_storage

	end





#OBTENIR TOUS LES EMAILS DE TOUTES LES MAIRIES

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




#AFFICHER LE SCRAPPING DANS UN ARRAY REMPLI DE HASH OU CHAQUE HASH REPRESENTE UNE VILLE

	def perform
																

		array_keys = get_townhall_name							#création d'un array où l'on entreprose les noms de villes

		array_values = get_all_email 							#création d'un array où l'on entrepose les mails de mairie

		array_of_hash = []  									#création d'un hash où seront entreprosés nos différents hash

		array_keys.length.times do |i|							#grâce à cette boucle j'entrepose en me servant de l'index j'associe les noms de villes
																# au mails correspondants pour ensuite les mettre dans un hash
			town_hash = {array_keys[i] => array_values[i]}

			array_of_hash << town_hash							#je mets ensuite chaque hash dans l'array accueillant tous les hahs

		end

		return array_of_hash

	end



#ENREGISTRER LE RESULTAT DU SCRAPPING EN JSON


	def save_as_JSON

		temporary_hash = perform

		File.open("../playwithexcels_mardis2/db/emails.json", "w") do |f|
		f.write(temporary_hash.to_json)

		end

	end





#ENREGISTRER LE RESULTAT DU SCRAPPING EN SPREADSHEETS

	def save_as_spreadsheets


		session = GoogleDrive::Session.from_config("config.json")										#permet de se brancher à l'api grâce à un fichier config.json qui contient l'ID
																										#et la clef secrète donnée par Google



		ws = session.spreadsheet_by_key("1oppW3bqvyrhxFnI679q8xeM1AcMthMScBS-yyjIgm-A").worksheets[0] 	#on va chercher la clef de la spreadsheet grâce à la clef
																										#contenue dans l'URL. Enfin on va chercher la première feuille
																										#du fichier spreadsheet 


       array = perform																					#on récupère le array de hashs


       	i = 1

		array.each do |hash|

			hash.each do|town, email|

				ws[i, 1] = town

				ws [i, 2] = email

				i += 1

			end

			ws.save

		end


		puts "Tu peux vérifier le résultat à cette URL : https://docs.google.com/spreadsheets/d/1oppW3bqvyrhxFnI679q8xeM1AcMthMScBS-yyjIgm-A/edit#gid=0"
																										
	end



#ENREGISTRER LE RESULTAT DU SCRAPPING EN CSV

	def save_as_CSV

		array = perform										#on récupère le array de hash

		CSV.open("db/emails.csv", "wb") do |csv|			#on crée un fichier csv avec des droits particuliers sur lequel on itère

			array.each do |hash|
				csv << [hash.keys, hash.values]             #on rentre sur la même ligne la clef et la valeur de chaque hash
			end

		end


	end



end
