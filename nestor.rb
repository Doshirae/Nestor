#!/usr/bin/env ruby 

require 'rubygems'
require 'discordrb'
require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'configatron'
require_relative 'config.rb'
require_relative 'insultotron.rb'
require_relative 'dd.rb'

# This statement creates a bot with the specified token and application ID. After this line, you can add events to the
# created bot, and eventually run it.
bot = Discordrb::Commands::CommandBot.new token: configatron.token, client_id: 261161348124114945, prefix: '!'

# Commandes invite ==>
bot.command(:invite, chain_usable: false) do |event|
	# This simply sends the bot's invite URL, without any specific permissions,
	# to the channel.
	event.bot.invite_url
end
# <==

# Commande random ==>
bot.command(:random, min_args: 0, max_args: 2, description: 'Generates a random number between 0 and 1, 0 and max or min and max.', usage: 'random [min/max] [max]') do |_event, min, max|
	# The `if` statement returns one of multiple different things based on the condition. Its return value
	# is then returned from the block and sent to the channel
	if max
		rand(min.to_i..max.to_i)
	elsif min
		rand(0..min.to_i)
	else
		rand
	end
end
# <==

# Commande ping ==>
bot.command :ping do |event|
	# The `respond` method returns a `Message` object, which is stored in a variable `m`. The `edit` method is then called
	# to edit the message with the time difference between when the event was received and after the message was sent.
	m = event.respond('Pong!')
	m.edit "Pong! `#{(Time.now - event.timestamp).round(2)}s`"
end
# <==

# Commande dtc ==>
bot.command(:dtc, description: "Renvoie une quote avec un certain numéro, ou une au hasard", usage: 'dtc [numéro_quote]')  do |event, num_quote|
	if num_quote
		# File.open("latestQuote.txt", 'r') do |file,latestQuote| 
		# 	latestQuote = file.gets
		# end
		# if num_quote <= latestQuote
		"http://danstonchat.com/#{num_quote}.html"
		# else
		# 	"La quote existe pas fdp"
		# end
	else
		mechanize = Mechanize.new
		page = mechanize.get('http://danstonchat.com/latest.html')
		link = page.link_with(:href => /danstonchat\.com\/[0-9]+\.html$/)
		latestQuote = link.click
		url = latestQuote.uri.to_s.split('') #  transform the url into a string, and then into an array
		latestQuoteNumber = url.grep(/\d+/).join.to_i # grep digits into that array (\d means [0-9]), join it into a string, and make that an integer
		File.open("latestQuote.txt", 'w') {|file| file.write(latestQuoteNumber) }
		random = rand(1..latestQuoteNumber)
		"http://danstonchat.com/#{random}.html"
	end
end
# <==

# Commandes pokemon ==>
bot.command(:pokelink, description: "Renvoie une page poképedia")  do |event, *args|
	nom_pokemon = args.join('%20')
	event.respond "http://www.pokepedia.fr/#{nom_pokemon}"
end


bot.command(:poke, description: "Renvoie le nom, les évolutions, et les talents d'un pokemon")  do |event, *args|
	nom_pokemon = args.join('%20')
	page = Nokogiri::HTML(open("http://www.pokepedia.fr/#{nom_pokemon}"))
	name = args.join(' ')
	# évolutions
	evo1 = page.css("table > tr:has(th:contains('évolution')) + tr td").text
	moyen_evo1 = page.css("table tr:has(th:contains('évolution')) + tr + tr td").text.split('').grep(/[A-Za-z0-9 ]+/).join
	evo2 = page.css("table > tr:has(th:contains('évolution')) + tr + tr + tr td").text
	moyen_evo2 = page.css("table tr:has(th:contains('évolution')) + tr + tr + tr + tr td").text.split('').grep(/[A-Za-z0-9 ]+/).join
	evo3 = page.css("table > tr:has(th:contains('évolution')) + tr + tr + tr + tr + tr td").text

	# types :
	# typesHTML = page.css('table tr th:contains("Types") + td a') # just got to figure out how to extract the title
	# types = typesHTML.filter("title")

	# talents : 
	talents = page.css("table tr th:contains('Talents') + td a").text.split(/(?=[A-Z])/)
	talents[-2] += " (#{talents[-1]})"
	talents.pop

	event << "Nom : #{name.capitalize}"
	if not evo1.empty?
		event << "Stade 1 : #{evo1}"
		if not evo2.empty?
			event << "Moyen d'évolution : #{moyen_evo1}"
			event << "Stade 2 : #{evo2}"
			if not evo3.empty?
				event << "Moyen d'évolution : #{moyen_evo2}"
				event << "Stade 3 : #{evo3}"
			end
		end
	end
	# event << "Type(s) : #{types}"
	event << "Talents :"
	talents.each do |talent|
		event << "#{talent}"
	end
	event << ""
end
# <==

# Commande xkcd ==>
bot.command(:xkcd, description: "Renvoie une page XKCD")  do |event, *args|
	# "https://xkcd.com/#{num}" page = Nokogiri::HTML(open("https://xkcd.com/#{num}"))
	# TODO : Recuperer l'image sur le site, et l'upload sur le chat
	isInt = Integer(args[0]) rescue nil
	str = (args.size > 1) ? "Trop d'arguments, très cher" : (isInt) ? "https://xkcd.com/#{num}" : "Pas un entier"
	event.respond(str)
end
# <==

# insulte ==>
bot.command(:insulte, description: "Renvoie une insulte générée")  do |event, action|
	if action == "add"
		lol
	else
		mode = action
		event.respond("#{Insulte.new(mode)}")
	end
end
# <==

# dragodinde ==>
bot.command(:dd, min_args: 4, max_args: 4, description: "Donne l'heure de recup d'une dd", usage: "dd.rb [couleur dd] [fatigue] [niveau jauge courant] [niveau jauge voulu]")  do |event, couleur, fatigue, jaugeCourant, jaugeVoulue|# {{{# }}}# {{{# }}}
	drago = Dragodinde.new(couleur, fatigue, jaugeCourant)
	objet = Objet.new
	main = Main.new(drago, objet)
	event.respond("#{main.temps(jaugeVoulue)}")
end
# <==

# Réponses aux messages ==>
bot.message(containing: ['(╯°□°）╯︵ ┻━┻', '(ﾉಥ益ಥ）ﾉ﻿ ┻━┻', '(ノಠ益ಠ)ノ彡┻━┻']) do |event|
	event.respond '┬─┬ノ( º _ ºノ )'
end

bot.message(containing: /Aladin/i) do |event|
	event.respond "TOUT L'MONDE DIT LE PRINCE !"
end

bot.message(containing: /Mi+chel/i) do |event|
	event.respond "Oui, c'est moi"
	sleep(1)
	event.respond "Michel, forever"
	sleep(1)
	event.respond "Je suis le veilleur"
	sleep(1)
	event.respond "Votre ministère"
	sleep(1)
	event.respond "For you, forever"
	event.channel.send_file File.new("michel.png")
end

bot.message(content: /rt/i) do |event|
	event.respond "#{event.content}"
end

bot.message(containing: [/tg/i, /ta gueule/i]) do |event|
	event.respond "Oui monsieur, bien monsieur, je pars me flageller monsieur"
end
# <==

bot.command(:eval, help_available: false) do |event, *code|
	break unless event.channel.server.id == 169135745141964800 # Replace number with your ID

	begin
		eval code.join(' ')
	rescue
		"Il semblerait qu'une erreur soit apparue, très cher"
	end
end

# command taht mention
# bot.mention do |event|
# 	# The `pm` method is used to send a private message (also called a DM or direct message) to the user who sent the
# 	# initial message.
# 	event.user.pm('You have mentioned me!')
# end

bot.run
# vim:foldmethod=marker:foldmarker=\=\=>,<\=\=:foldlevel=0
