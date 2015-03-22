require 'sinatra'

require 'spreadsheet'
require 'json'
# set :static_cache_control, [:public, {:max_age => 300}]
get '/api' do
	content_type :json
	Spreadsheet.client_encoding = 'UTF-8'
	book = Spreadsheet.open 'state.xls'
	sheet1 = book.worksheet 0
	state = {}
	# 0-name 1-population 2-% 3-males 4-females 5-literacy% 6-rural 7-urban 8-area-km^2 9-desity
	# 10-child labour %,11- utilization of govt health services,12- child marriage girls, 13- child marriage boys,
	# %age - 14 - total toilet 15 - rural toilet 16 - urban toilet 
	# 17 unemployment rural /100, 18- unemployment urban/100
	# religion absolute 19 - hindu, 20 - muslim, 21-christian 22- others
	# male,female,literate,illiterate,rural,urban, child_labour, health_services, total_toilet, urban_toilet, rural_toilet
	# urban_unemployed, rural_unemployed , child_marriage_girl, child_marriage_boy, hindu, muslim, christian, others
	row0 = sheet1.row(0)
	cmg = []
	cmb = []
	hs = []
	ru = []
	uu = []
	childl_def = row0[10]
	sheet1.each do |row|
		male = (row[3].to_f/row[1].to_f*100.0).round
		female = 100 - male
		l = (row[5]).round
		ul = 100 - l
		rural = (row[6].to_f/row[1].to_f*100.0).round
		urban = 100 -rural

		hindu = (row[19].to_f/row[1].to_f*100.0).round
		muslim = (row[20].to_f/row[1].to_f*100.0).round
		christian = (row[21].to_f/row[1].to_f*100.0).round
		others = 100 - hindu - muslim - christian

		#stage 2
		#child labour calcs
		if row[10].nil?
			childl = childl_def
		else
			childl = row[10]
		end
		if childl <= 1.7
			childl = 1
		elsif childl <= 2.6
			childl = 2
		else
			childl = 3
		end

		total_toilet = row[14].round
		urban_toilet = row[16].round
		rural_toilet = row[15].round

		# id = sheet1.count
		state[row[0]] = {male: male,female: female,literate: l,illiterate: ul,urban: urban,rural: rural,child_labour: childl,
			total_toilet: total_toilet,urban_toilet: urban_toilet,rural_toilet: rural_toilet,hindu: hindu, muslim: muslim, christian: christian,others: others}

		#accumulate next three parameters
		if row[11]
			heal = row[11]
			hs << heal
			state[row[0]][:health] = heal
		end
		if row[12]
			cgirl = row[12]
			cmg << cgirl
			state[row[0]][:child_marriage_girl] = (cgirl*0.15).ceil
		end
		if row[13]
			cboy = row[13]
			cmb << cboy
			state[row[0]][:child_marriage_boy] = (cboy*0.15).ceil
		end

		#employment
		if row[17]
			rural_unemployed = row[17]
			ru << rural_unemployed
			state[row[0]][:rural_unemployed] = rural_unemployed
		end
		if row[18]
			urban_unemployed = row[18]
			uu << urban_unemployed
			state[row[0]][:urban_unemployed] = urban_unemployed
		end
	end
	state[row0[0]][:rural_unemployed] = ru.sum/ru.size.to_f.round
	state[row0[0]][:urban_unemployed] = uu.sum/uu.size.to_f.round
	state[row0[0]][:health] = hs.sum/hs.size.to_f.round
	state[row0[0]][:child_marriage_boy] = (cmb.sum*0.15/cmb.size.to_f).ceil
	state[row0[0]][:child_marriage_girl] = (cmg.sum*0.15/cmg.size.to_f).ceil
	sheet1.each do |row|

		#Time to refill those parameters for empty with average
		if not row[11]
			state[row[0]][:health] = state[row0[0]][:health]
		end
		if not row[12]
			state[row[0]][:child_marriage_girl] = state[row0[0]][:child_marriage_girl]
		end
		if not row[13]
			state[row[0]][:child_marriage_boy] =  state[row0[0]][:child_marriage_boy]
		end
		if not row[17]
			state[row[0]][:rural_unemployed] = state[row0[0]][:rural_unemployed]
		end
		if not row[18]
			state[row[0]][:urban_unemployed] =  state[row0[0]][:urban_unemployed]
		end
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