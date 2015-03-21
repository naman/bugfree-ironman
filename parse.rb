require 'sinatra'

get '/api' do

	require 'spreadsheet'
	require 'json'
	Spreadsheet.client_encoding = 'UTF-8'
	book = Spreadsheet.open 'state.xls'
	sheet1 = book.worksheet 0
	state = {}
	# 0-rank 1-name 2-type 3-population 4-% 5-males 6-females 7-literacy% 8-rural 9-urban 10-area-km^2 11-desity
	# male,female,literate,illiterate,rural,urban,km2/people
	sheet1.each do |row|
		# puts row[5]
		# puts row[6]
		# puts row[3]
		male = (row[5].to_f/row[3].to_f*100.0).round
		female = 100 - male
		l = (row[7]).round
		ul = 100 - l
		rural = (row[8].to_f/row[3].to_f*100.0).round
		urban = 100 -rural
		km = (row[10]/100.0).round
	  state[row[1]] = {male: male,female: female,literate: l,illiterate: ul,urban: urban,rural: rural,km: km}
	end
	state.to_json
end
require 'rubygems'

get '/' do
  html :index
end

def html(view)
  File.read(File.join('public', "#{view.to_s}.html"))
end