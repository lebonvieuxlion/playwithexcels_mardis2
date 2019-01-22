require_relative '../app/scrapper'

require 'pry'



class Index


	def initialize			

		save_choices

	end



#DEFINITION DES CHOIX QUE L'UTILISAREUR VA AVOIR EN EXECUTANT LE FICHIER APP.RB

	def offer_choices_to_user

		puts "Salut ptit chef. Tu veux scrapper des emaisl de mairies comme un fou ? Fais un choix pour définir comment tu vas entreposer tes données :"
		puts "Choisis 1 pour JSON "
		puts "Choisis 2 pour Spreadsheets"
		puts "Choisis 3 pour CSV"
		print ">"

		 @@choice = gets.to_i

		return @@choice

	end


#DEFINITION DES CONSEQUENCES POUR LES CHOIX FAIT PAR L'UTILISATEUR AVEC LA METHODE offer_choices_to_user


	def save_choices


		case offer_choices_to_user			#on exécute la méthode offer_choices_to_user et pour chaque output on appelle la classe correspondante

		when @@choice = 1
			Scrapper.new.save_as_JSON

		when @@choice = 2
			Scrapper.new.save_as_spreadsheets

		when @@choice = 3
			Scrapper.new.save_as_CSV

		end
	end


end

