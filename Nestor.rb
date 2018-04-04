#!/usr/bin/env ruby

require 'bundler/setup'
Bundler.require(:default)

require_relative 'config.rb'
require_relative 'insultotron.rb'
require_relative 'dd.rb'
require_relative 'commandes.rb'
$DOSHI = 164258114068021248

# This statement creates a bot with the specified token and application ID. After this line, you can add events to the
# created bot, and eventually run it.
bot = Discordrb::Commands::CommandBot.new token: configatron.token, client_id: 261161348124114945, prefix: '!'

# invite ==>
bot.command(:invite, chain_usable: false) do |event|
	# This simply sends the bot's invite URL, without any specific permissions,
	# to the channel.
	event.bot.invite_url
end
# <==

# random ==>
bot.command(:random, min_args: 0, max_args: 2, description: 'Generates a random number between 0 and 1, 0 and max or min and max.', usage: 'random [min/max] [max]') do |_event, min, max|
	random(min, max)
end
# <==

# ping ==>
bot.command :ping do |event|
	# The `respond` method returns a `Message` object, which is stored in a variable `m`. The `edit` method is then called
	# to edit the message with the time difference between when the event was received and after the message was sent.
	m = event.respond('Pong!')
	m.edit "Pong! `#{(Time.now - event.timestamp).round(2)}s`"
end
# <==

# dtc ==>
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

# pokemon ==>
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

# xkcd ==>
bot.command(:xkcd, description: "Renvoie une page XKCD")  do |event, num|
	# "https://xkcd.com/#{num}" page = Nokogiri::HTML(open("https://xkcd.com/#{num}"))
	# TODO : Recuperer l'image sur le site, et l'upload sur le chat
		url = xkcd(num)
		event.respond url
		event.channel.send_file File.new('xkcd.png')
		`rm xkcd.png`
end
# <==

bot.command(:dl) do |event, uri|
	require "net/http"
	if idx = uri =~ /jpe?g|png|gif$/
		ext = uri[idx..-1]
		response = Net::HTTP.get_response(URI(uri))
		if response.code == 200
			open("img.#{ext}", 'w+') { |f| f.write(response.body) }
			event.channel.send_file File.new("img.#{ext}")
			`rm img.#{ext}`
		else
			"Cette image n'existe pas. Erreur 404, bolosse."
		end
	else
		"Je ne peux pas poster un fichier qui ne soit pas une image, enfin !"
	end
end

# insulte ==>
bot.command(:insulte, description: "Renvoie une insulte générée")  do |event, action|
	if action == "add"
		lol
	else
		insulte(action)
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

# strawpoll ==>
bot.command(:strawpoll, description: "Créer un strawpoll", usage: "!strawpoll [q[m] <question>] | choix1 | choix2 | choix3 | ...\nq <question> → la question devient <question> (aucune question si le champ n'est pas là)\nqm <question> → question devient <question> et active le choix multiple des réponses")  do |event, *choices|
	strawpoll(event.user.name, choices)
end
# <==

# doggo ==>
bot.command(:doggo) do |event|
	doggo()
	event.channel.send_file File.new('doggo.png')
	`rm doggo.png`
end
# <==

# kitten ==>
bot.command(:kitten) do |event|
	kitten()
	event.channel.send_file File.new('kitten.png')
	`rm kitten.png`
end
# <==

# exit ==>
bot.command(:exit, help_available: false) do |event|
	# This is a check that only allows a user with a specific ID to execute this command. Otherwise, everyone would be
	# able to shut your bot down whenever they wanted.
	break unless event.user.id == $DOSHI # Replace number with your ID

	bot.send_message(event.channel.id, 'À bientôt j\'espère')
	exit
end
# <==

# eval ==>
bot.command(:eval, help_available: false) do |event, *code|
	break unless event.channel.server.id == $DOSHI # Replace number with your ID
	begin
		eval code.join(' ')
	rescue
		"Il semblerait qu'une erreur soit apparue, très cher"
	end
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
	sleep(2)
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
	event.send_temp "Oui monsieur, bien monsieur, je pars me flageller monsieur", 5
end

bot.message(containing: /C'est une bonne situation ça,? scribe \?/) do |event|
	event.respond "Vous savez, moi je ne crois pas qu’il y ait de bonne ou de mauvaise situation."
	sleep 1.5
	event.respond "Moi, si je devais résumer ma vie aujourd’hui avec vous, je dirais que c’est d’abord des rencontres."
	sleep 3
	event.respond "Des gens qui m’ont tendu la main, peut-être à un moment où je ne pouvais pas, où j’étais seul chez moi."
	sleep 2
	event.respond "Et c’est assez curieux de se dire que les hasards, les rencontres forgent une destinée…"
	sleep 1.5
	event.respond "Parce que quand on a le goût de la chose, quand on a le goût de la chose bien faite, le beau geste, parfois on ne trouve pas l’interlocuteur en face je dirais, le miroir qui vous aide à avancer."
	sleep 4
	event.respond "Alors ça n’est pas mon cas, comme je disais là, puisque moi au contraire, j’ai pu : et je dis merci à la vie, je lui dis merci, je chante la vie, je danse la vie… je ne suis qu’amour !"
	sleep 4
	event.respond "Et finalement, quand beaucoup de gens aujourd’hui me disent « Mais comment fais-tu pour avoir cette humanité ? », et bien je leur réponds très simplement, je leur dis que c’est ce goût de l’amour ce goût donc qui m’a poussé aujourd’hui à entreprendre une construction mécanique, mais demain qui sait ? Peut-être simplement à me mettre au service de la communauté, à faire le don, le don de soi…"
end
# <==

bot.run
