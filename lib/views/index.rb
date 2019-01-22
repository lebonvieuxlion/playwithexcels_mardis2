require_relative '../app/scrapper'

require 'pry'

class Index

	def initialize

		offer_choices_to_user

	end

	def offer_choices_to_user

		puts "Salut ptit chef. Tu veux scrapper des emaisl de mairies comme un fou ? Fais un choix pour définir comment tu vas entreposer tes données :"
		puts "Choisis 1 pour JSON "
		puts "Choisis 2 pour Spreadsheets"
		puts "Choisis 3 pour CSV"
		print ">"

		 @@choice = gets.to_i

		return puts @@choice

	end


	def save_choices

		case 

		when @@choice = 1
			Scrapper.new
		else
			puts "fail"
		end
	end

end

Binding.pry