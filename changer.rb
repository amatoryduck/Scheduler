# Alexander Scott

require 'csv'

puts "Starting..."

# Create array to put all new data
arr = Array.new()

# tsv file to write to
out = File.open("out.txt", 'w')

# Open csv file from HyperCaster and read line by line
File.open("./x_list.csv", "r") do |f|

	f.each_line do |line|
		
		# Capture vital metadata from csv
		if line =~ /^".*?",\s*([0-9]{4}-[0-9]{2}-[0-9]{2})\s*,\s*([0-9]{2}:[0-9]{2})\s*,.*?,\s*([0-9]+)\s*,".*?",(.*?) && (.*?),.*?,.*$/
			
			# Assign variables to captured data
			date = $1
			start = $2
			duration = $3
			episode = $4
			series = $5
			
			# Change date data to match website
			date = date.split('-')
			if date[1].length == 2
				date[1] = date[1][1]
			end
			puts date[1]
			date = date[1] + '/' + date[2] + '/' + date[0]

			# Change start time data to match website
			start = start.split(':')
			if start[0].to_i < 10 
				start[0] = start[0][1,1]
			end
			start = "" + start[0] + ":" + start[1] + ":00"

			# Change duration time data to match website
			duration = "0:" + duration + ":00"

			# Change episode name data to match website
			if episode[0] == "\"" 
				episode = episode[1,episode.length - 1]
			end

			# Change series name data to match website
			if series[series.length - 1] == "\""
				series = series[0, series.length - 2]
			end

			# Create array to input into csv
			newLine = [date, start, duration, episode, series]
			arr.push(newLine)
		end
	end
end

# Open csv and write each line of the array to the csv
CSV.open("schedule.csv", "w") do |csv| 

	count = 1
	count2 = 1
	for i in arr
		for j in i
			out.write(j)
			
			# Make sure there is no tab at the end of the line
			if count2 != i.length
				out.write("\t")
			end	
			count2 = count2 + 1
		end

		# Write CRLF line terminators
		if count != arr.length
			out.write("\r\n")
		end

		count2 = 1
		count = count + 1
	end

	arr.each { |x| csv << x }
end
