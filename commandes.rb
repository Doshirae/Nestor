require_relative "insultotron.rb"
require "httparty"

def random(*args)
    if args[1]
        max = args[1].to_i
        min = args[0].to_i
    elsif args[0]
        max = args[0].to_i
        min = 0
    else
        max = 1.to_f
        min = 0.to_f
    end
    rand(min..max)
end


def insulte(mode = nil)
    "#{Insulte.new(mode)}"
end


def strawpoll(name, *choices)
    if choices.empty?
        return "Mais enfin ! Quelle curieuse idée de faire un sondage sans le moindre choix... On se croirait en Russie"
    else
        choices = choices.join(' ').split(' | ')
        multi = false
        if choices[0] =~ /q\s.*/
            question = choices.shift[2..-1]
        elsif choices[0] =~ /qm\s.*/
            question = choices.shift[2..-1]
            multi = true
        end
        question ||= "Poll de #{name}"
        json = HTTParty.post("https://strawpoll.me/api/v2/polls", body: {title: "#{question}", options: choices, multi: multi}.to_json).body
        id = JSON.parse(json)["id"]
        return "Voici pour vous, mon cher\nhttps://strawpoll.me/#{id}"
    end
end

def doggo
    File.open("doggo.png", 'w') do |file|
        file.write HTTParty.get("https://www.randomdoggiegenerator.com/randomdoggie.php")
    end
end

def kitten
    File.open("kitten.png", 'w') do |file|
        file.write HTTParty.get("http://www.randomkittengenerator.com/cats/rotator.php")
    end
end

def xkcd(num=nil)
	if num =~ /\d+/ or num.nil? # soit un nombre soit rien du tout
		`curl -o xkcd.png $(curl https://xkcd.com/#{num}/ | grep "Image URL (for hotlinking/embedding):" | cut -d : -f 2-)`

		"https://xkcd.com/#{num}"
	else
		"Il me faut soit un entier, soit rien, très cher"
	end
end
