#!/usr/bin/env ruby

require 'telegram/bot'
require_relative 'commandes.rb'

token = '411259023:AAEQFbIyy9LKih4QW_Qjz-_5LcjP90-tZuo'
Telegram::Bot::Client.run(token) do |bot|
	bot.listen do |message|
		case message.text
		when "/start"
			bot.api.send_message(chat_id: message.chat.id, text: "Salut")
		when '/test'
			question = 'London is a capital of which country?'
			# See more: https://core.telegram.org/bots/api#replykeyboardmarkup
			answers =
				Telegram::Bot::Types::ReplyKeyboardMarkup
				.new(keyboard: [%w(A B), %w(C D)], one_time_keyboard: true)
			bot.api.send_message(chat_id: message.chat.id, text: question, reply_markup: answers)
		when '/insulte'
			bot.api.send_message(chat_id: message.chat.id, text: insulte)
		else
			bot.api.send_message(chat_id: message.chat.id, text: "Désolé, je ne connais pas cette commande")
		end
	end
end

