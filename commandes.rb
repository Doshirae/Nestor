require_relative "insultotron.rb"
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
