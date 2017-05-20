require 'nokogiri'
require 'open-uri'
# [Pokemon]
# [evo1 --[moyen d'obtention]-> evo 2 ---> mega evo
# [types] [talents] 

# [pv]
# [atk]
# [defense]
# [SpAtk]
# [SpDef]
# [Spd]

# [Resistances/faiblesses]]

page = Nokogiri::HTML(open('BulbizarreEntier.html'))
# name = Bulbizarre
# évolutions
evo1 = page.css("table > tr:has(th:contains('évolution')) + tr td").text
moyen_evo1 = page.css("table tr:has(th:contains('évolution')) + tr + tr td").text.split('').grep(/[A-Za-z0-9 ]+/).join
evo2 = page.css("table > tr:has(th:contains('évolution')) + tr + tr + tr td").text
moyen_evo2 = page.css("table tr:has(th:contains('évolution')) + tr + tr + tr + tr td").text.split('').grep(/[A-Za-z0-9 ]+/).join
evo3 = page.css("table > tr:has(th:contains('évolution')) + tr + tr + tr + tr + tr td").text

# types :
typesHTML = page.css('table tr th:contains("Types") + td a') # just got to figure out how to extract the title
types = typesHTML.filter("title")

# talents : 
talents = page.css("table tr th:contains('Talents') + td a").text.split(/(?=[A-Z])/)
talents[-2] += " (#{talents[-1]})"
talents.pop

# Stats
# pv, atk, def, spAtk, spDef, vitesse
