class Insulte
	def initialize()
		@insulte = "Espèce d#{animal} #{adjectif} #{lieu}"
	end

	def dire
		return @insulte
	end

	def animal
		animaux = [
			"e Végéta",
			"UNDEFINED",
			"e renard",
			"e poulpe",
			"e caribou",
			"e chouette",
			"'ornythorinque",
			"e papier toilette",
			"e zombie nécrophage",
			"e vélocipède",
			"e castor",
			"e mamouth a poil ras",
			"e mamouth",
			"'huitre",
			"e joueur de LoL"
		]
		return animaux[rand(animaux.size)]
	end

	def adjectif
		adjs = [
			"moustachu",
			"barbu",
			"roux",
			"psychopathe",
			"reconditioné",
			"chauve",
			"shooté à l'Ibuprofene®",
			"nucléairement con",
			"mangeur de mamouths",
			"manchot",
			"pyroclastique",
			"associal"
		]
		return adjs[rand(adjs.size)]
	end

	def lieu
		lieus = [
			"des iles",
			"venant de mars",
			"des galapagos",
			"australien",
			"de ta soeur",
			"sumérien",
			"grec",
			"de l'espace",
			"du Zimbabwe",
			"italien",
			"des antilles",
			"numériquement à la ramasse"
		]
		return lieus[rand(lieus.size)]
	end

end
