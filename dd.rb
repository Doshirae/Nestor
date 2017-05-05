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
			"amande et rousse" => 0.8,
			"amande et doree" => 0.8,
			"doree et rousse" => 0.8,
			"amande et orchidee" => 0.6,
			"orchidee et rousse" => 0.6,
			"doree et orchidee" => 0.6,
			"indigo et orchidee" => 0.6,
			"ebene et orchidee" => 0.6,
			"amande et pourpre" => 0.6,
			"pourpre et rousse" => 0.6,
			"doree et pourpre" => 0.6,
			"indigo et pourpre" => 0.6,
			"ebene et pourpre" => 0.6,
			"orchidee et pourpre" => 0.6,
			"amande et turquoise" => 0.4,
			"turquoise et rousse" => 0.4,
			"doree et turquoise" => 0.4,
			"indigo et turquoise" => 0.4,
			"ebene et turquoise" => 0.4,
			"turquoise et orchidee" => 0.4,
			"turquoise et pourpre" => 0.4,
			"ivoire et turquoise" => 0.4,
			"amande et ivoire" => 0.4,
			"ivoire et rousse" => 0.4,
			"doree et ivoire" => 0.4,
			"indigo et ivoire" => 0.4,
			"ebene et ivoire" => 0.4,
			"ivoire et orchidee" => 0.4,
			"ivoire et pourpre" => 0.4,
			"amande et emeraude" => 0.2,
			"emeraude et rousse" => 0.2,
			"doree et emeraude" => 0.2,
			"emeraude et indigo" => 0.2,
			"ebene et emeraude" => 0.2,
			"emeraude et orchidee" => 0.2,
			"emeraude et pourpre" => 0.2,
			"emeraude et ivoire" => 0.2,
			"emeraude et turquoise" => 0.2,
			"prune et amande" => 0.2,
			"prune et rousse" => 0.2,
			"prune et doree" => 0.2,
			"prune et indigo" => 0.2,
			"prune et ebene" => 0.2,
			"prune et orchidee" => 0.2,
			"prune et pourpre" => 0.2,
			"prune et ivoire" => 0.2,
			"prune et turquoise" => 0.2,
			"prune et emeraude" => 0.2
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
		differenceNiveaux = (@drago.nivCourantJauge - jaugeVoulue).abs
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
