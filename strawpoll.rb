require 'mechanize'
mechanize = Mechanize.new
page = mechanize.get('http://www.strawpoll.me/')
form =  page.forms[1]

form.fields.each do |f|
	puts f.name
end
