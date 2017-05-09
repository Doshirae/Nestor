#!/usr/bin/env ruby
class Insulte
	attr_reader :insulte, :mode
	def initialize(mode)
		case mode
		when nil
			createDefault
		when "fort"
			createDefault
			@insulte = @insulte.upcase
		when "kaaris"
			createKaaris
		when "martine"
			createMartine
		when "haddock"
			createHaddock
		end
	end

	def createDefault
		@insulte = "Espece d#{Insulte.animal} #{Insulte.adjectif} #{Insulte.lieu}"
	end

	def createKaaris
		@insulte = "P#{"U"*rand(10..100)}T#{"E"*rand(3..20)}#{"U"*rand(10..100)}H"
	end

	def createMartine
		salope = "SALO"
		rand(25..100).times do |_|# (so it makes a cup :D
			salope += (rand(0..1) %2 == 0) ? "o" : "O"
		end
		salope += "PE"
		@insulte = "#{salope}"
	end

	def createHaddock
		@insulte = "#{Insulte.insultesHaddock}"
	end

	def to_s
		@insulte
	end

	# animal ==>
	def self.animal
		animaux = [ "e Vegeta", "e renard", "e poulpe", "e caribou", "'ornythorinque", "e papier toilette", "e zombie necrophage", "e velocipede", "e castor", "e mamouth a poil ras", "e mamouth", "'huitre", "e joueur de LoL", "e sale tchoin", "e VACA DE LA SOLIDAD", "'enorme bachibouzouk", "'ectoplasme", "e marin d'eau douce", "e va-nu-pieds" 
		]
		return animaux[rand(animaux.size)]
	end
	# <==

	# adjectif ==>
	def self.adjectif
		adjs = [ "moustachu", "barbu", "roux", "psychopathe", "reconditione", "chauve", "shoote à l'Ibuprofene®", "nucléairement con", "mangeur de mamouths", "manchot", "pyroclastique", "associal", "incapable"
		]
		return adjs[rand(adjs.size)]
	end
	# <==

	# lieu ==>
	def self.lieu
		lieus = [ "des iles", "venant de mars", "des galapagos", "australien", "de ta soeur", "sumerien", "grec", "de l'espace", "du Zimbabwe", "italien", "des antilles", "numeriquement a la ramasse", "DE LA MADRE MIA AYAYAYA", "DEL FUEGO DE PAPEL"
		]
		return lieus[rand(lieus.size)]
	end
	# <==

	# insultesHaddock ==>
	def self.insultesHaddock
		jsp = [ "Bachi-bouzouk", "Va-nu-pieds", "Marin d'eau douce", "Ectoplasme", "Flibustier", "Bougre de faux jetons à la sauce tartare", "Coloquinte à la graisse de hérisson", "Cyrano à quatre pattes", "Zouave interplanétaire", "Ectoplasme à roulettes", "Bougre d’extrait de cornichon", "Jus de poubelle", "Espèce de porc-épic mal embouché", "Patagon de zoulous", "Loup-garou à la graisse de renoncule", "Amiral de bateau-lavoir", "Bayadère de carnaval", "Bougres d’extrait de crétins des Alpes", "Espèce de chouette mal empaillée", "Macchabée d'eau de vaisselle", "Astronaute d'eau douce", "Bulldozer à réaction", "Simili-martien à la graisse de cabestan", "Concentré de moules à gaufres", "Espèce de mitrailleur à bavette", "Tchouck-tchouck-nougat", "Garde-côtes à la mie de pain", "Papou des Carpates", "Sombre oryctérope", "Traîne-potence"
		]
		return jsp[rand(jsp.size)]
	end
	# <==
end

if __FILE__ == $0
	insulte = Insulte.new ARGV[0]
	puts insulte.insulte
	puts insulte.mode 
end

# vim:foldmethod=marker:foldmarker=\=\=>,<\=\=:foldlevel=0
