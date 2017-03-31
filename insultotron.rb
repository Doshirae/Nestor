class Insulte
	def initialize()
		@insulte = "Espece d#{animal} #{adjectif} #{lieu}"
	end

	def dire
		return @insulte
	end

	def animal
		animaux = [
			"e Vegeta",
			"e renard",
			"e poulpe",
			"e caribou",
			"'ornythorinque",
			"e papier toilette",
			"e zombie necrophage",
			"e velocipede",
			"e castor",
			"e mamouth a poil ras",
			"e mamouth",
			"'huitre",
			"e joueur de LoL",
			"e sale tchoin",
			"e VACA DE LA SOLIDAD",
			"'enorme bachibouzouk",
			"'ectoplasme",
			"e marin d'eau douce",
			"e va-nu-pieds"

		]
		return animaux[rand(animaux.size)]
	end

	def adjectif
		adjs = [
			"moustachu",
			"barbu",
			"roux",
			"psychopathe",
			"reconditione",
			"chauve",
			"shoote à l'Ibuprofene®",
			"nucléairement con",
			"mangeur de mamouths",
			"manchot",
			"pyroclastique",
			"associal",
			"incapable"
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
			"sumerien",
			"grec",
			"de l'espace",
			"du Zimbabwe",
			"italien",
			"des antilles",
			"numeriquement a la ramasse",
			"DE LA MADRE MIA AYAYAYA",
			"DEL FUEGO DE PAPEL"
		]
		return lieus[rand(lieus.size)]
	end
end
