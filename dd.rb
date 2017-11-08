#!/usr/bin/env ruby

# Calcul le temps estimé avant de récup une dd, pour pas foirer le coche de la serenité.
# Une dd à de la fatigue, un objectif à attendre pour la jauge, le niveau courant de la jauge et un coefficient d'apprentissage
# Les items ont une résistance et une efficacité (600 et 30 pour les enclos publics)
# La fréquence temporaire calculée à l'arrache des enclos publics = 2 frottement / min

		# Coefficients d'apprentissage des dd ==>
		$coefDD = {
			"rousse" => 1,
			"amande" => 1,
			"indigo" => 0.8,
			"ebene" => 0.8,
			"orchidee" => 0.6,
			"pourpre" => 0.6,
			"ivoire" => 0.6,
			"turquoise" => 0.6,
			"emeraude" => 0.4,
			"prune" => 0.4,
			"doree" => 0.2,
			"amanderousse" => 0.8,
			"amandedoree" => 0.8,
			"doreerousse" => 0.8,
			"amandeorchidee" => 0.6,
			"orchideerousse" => 0.6,
			"doreeorchidee" => 0.6,
			"indigoorchidee" => 0.6,
			"ebeneorchidee" => 0.6,
			"amandepourpre" => 0.6,
			"pourprerousse" => 0.6,
			"doreepourpre" => 0.6,
			"indigopourpre" => 0.6,
			"ebenepourpre" => 0.6,
			"orchideepourpre" => 0.6,
			"amandeturquoise" => 0.4,
			"turquoiserousse" => 0.4,
			"doreeturquoise" => 0.4,
			"indigoturquoise" => 0.4,
			"ebeneturquoise" => 0.4,
			"turquoiseorchidee" => 0.4,
			"turquoisepourpre" => 0.4,
			"ivoireturquoise" => 0.4,
			"amandeivoire" => 0.4,
			"ivoirerousse" => 0.4,
			"doreeivoire" => 0.4,
			"indigoivoire" => 0.4,
			"ebeneivoire" => 0.4,
			"ivoireorchidee" => 0.4,
			"ivoirepourpre" => 0.4,
			"amandeemeraude" => 0.2,
			"emerauderousse" => 0.2,
			"doreeemeraude" => 0.2,
			"emeraudeindigo" => 0.2,
			"ebeneemeraude" => 0.2,
			"emeraudeorchidee" => 0.2,
			"emeraudepourpre" => 0.2,
			"emeraudeivoire" => 0.2,
			"emeraudeturquoise" => 0.2,
			"pruneamande" => 0.2,
			"prunerousse" => 0.2,
			"prunedoree" => 0.2,
			"pruneindigo" => 0.2,
			"pruneebene" => 0.2,
			"pruneorchidee" => 0.2,
			"prunepourpre" => 0.2,
			"pruneivoire" => 0.2,
			"pruneturquoise" => 0.2,
			"pruneemeraude" => 0.2
		}
		# <==

class Dragodinde
	attr_accessor :nivCourantJauge, :coefLearn, :bonusFatigue

	def initialize(couleur, fatigue, nivCourantJauge)
		@nivCourantJauge = nivCourantJauge.to_i
		@coefLearn = $coefDD[couleur]
		@bonusFatigue = case fatigue.to_i
						when 0..160 then 100/100
						when 161..170 then 115/100
						when 171..180 then 130/100
						when 181..190 then 150/100
						when 191..200 then 150/100
						when 201..210 then 180/100
						when 211..220 then 210/100
						when 221..230 then 250/100
						when 231..239 then 300/100
						when 240 then 0
						end
	end

	def bonus(resistanceObjet)
		return (0.01 * resistanceObjet * @coefLearn * @bonusFatigue)
	end

end

class Objet
	attr_accessor :resistance, :efficacite

	def initialize(resistance=600, efficacite=30)
		@resistance = resistance
		@efficacite = efficacite
	end
end

class Main
	attr_accessor :drago, :objet, :frequence

	def initialize(drago, objet, frequence=2)
		@drago = drago
		@objet = objet
		@frequence = frequence
	end

	def temps(jaugeVoulue)
		bonusParFrottement = @objet.efficacite + @drago.bonus(objet.resistance)
		bonusParMinute = bonusParFrottement * @frequence
		differenceNiveaux = (@drago.nivCourantJauge - jaugeVoulue.to_i).abs
		tempsMinute = (differenceNiveaux / bonusParMinute).round
		tempsSeconde = tempsMinute*60

		mtn = Time.new
		mtn.min = "0#{mtn.min}".to_i if mtn.min < 10
		pret = mtn + tempsSeconde
		pret.min = "0#{pret.min}".to_i if pret.min < 10

		return "Il est actuellement #{mtn.hour}h#{mtn.min} et la dragodinde sera prete vers #{pret.hour}h#{pret.min}"
	end
end

# Main ---------------------------------------------------------------------------------------------------

if __FILE__ == $0 
	if ARGV[0] == 'help'
		puts "Usage : ./dd.rb [couleur dd] [fatigue] [niveau jauge courant] [niveau jauge voulu]"
	else
		couleur = ARGV[0]
		fatigue = ARGV[1].to_i
		jaugeCourante = ARGV[2].to_i
		jaugeVoulue = ARGV[3].to_i

		objet = Objet.new
		drago = Dragodinde.new(couleur, fatigue, jaugeCourante)
		main = Main.new(drago, objet)

		puts main.temps(jaugeVoulue)
	end
end

# vim:foldmethod=marker:foldmarker=\=\=>,<\=\=:foldlevel=0
