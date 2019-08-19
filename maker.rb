# Alexander Scott

require 'time'
require 'date'
require 'csv'

# This is a series class, that hase a name, which is a string
# A duration, which is the amount of 30-minute chunks it costs,
# And episodes, which is a list of episodes that it has.
class Series
	def initialize(name, duration, episodes)
		@name = name
		@duration = duration
		@episodes = episodes
	end

	def getName
		return @name
	end

	def getDur
		return @duration
	end

	def getEp
		return @episodes
	end
end

# This reads the shows.csv file in the current directory and 
# returns a list of series objects.
def readFile
	shows = Array.new()
	File.open('./shows.csv', 'r') do |f|
		f.each_line do |line|
			line = line[0..(line.length - 2)]
			line = line.split(',')
			tmpEp = Hash.new()

			i = 2
			while (i < line.length)
				tmpEp[line[i]] = line[i + 1]
				i = i + 2
			end
			
			tmpSeries = Series.new(line[0], line[1], tmpEp)
			shows.push(tmpSeries)
		end
	end
	return shows
end

def main
	puts "Loading Shows...."

	# Read the shows.csv files
	shows = readFile

	# Set for 24 30-minute chunks
	timeLeft = 24
	choice = Array.new()
	foo = Array.new()

	# While you have not reached 24 chunks.
	while (timeLeft > 0)
		j = 0

		# Output how many chunks you have left
		puts "You have: " + timeLeft.to_s + " '30' minute blocks left"

		# Print out all the series
		for i in shows
			print j.to_s + ") ... " + i.getName + " ... " + i.getDur + "\n"
			j = j + 1
		end

		puts "^^^ Please choose a series ^^^"

		# Get user input, chomp it, turn it to an integer, subtract
		# From total chunks, and add your choice to your schedule
		pick = gets
		pick = pick[0..(pick.length - 2)]
		pick = pick.to_i
		timeLeft = timeLeft - ((shows[pick]).getDur).to_i
		choice.push((shows[pick]))
		foo.push((shows[pick]))
	end

	# Push your choices again to make it a 24-hour schedule 
	# (48 chunks)
	foo.each do |x|
		choice.push(x)
	end

	choice.each do |name|
		#puts name.getName
	end

	# Get start and end dates to schedule,
	# Note: these dates are inclusive
	puts "Enter start date in form DD-MM-YYYY"
	start_date = gets
	start_date = Date.parse(start_date)
	puts "Enter end date in form DD-MM-YYYY"
	end_date = gets
	end_date = Date.parse(end_date)

	days = end_date - start_date
	curr = start_date

	# Creating the schedule file
	output = File.open('./maker.csv', 'w')
	# The HyperCaster needs this line, I don't know why
	output.puts('Output,Date,Time,Type,Source ID,Source Name,Offset,Duration,Output Name,Program Code,Episode Code,Program,Title,Episode,Description,OSD,OSD Path,OSD File,Include In Guide,Track Content Attributes,Program Number,Switch Command')

	series = Array.new()
	for i in choice
		series.push(i.getEp)
	end

	day = 0
	# For everyday you want to schedule
	for i in 0..days
		# This keeps track of what time the show should be scheduled at
		currTime = 0

		# Rip apart the date
		if curr.to_s =~ /^(\d{4})-(\d{2})-(\d{2})$/
			real = "" + $2 + "/" + $3 + "/" + $1 
		end

		# For each series you chose insert it into the schedule
		for j in choice
			# Get the episode name
			ep = ((j.getEp).keys)[i % (((j.getEp).keys).length)]
			
			# Get the actual time betweenm show and next chunk
			now = (currTime * 60 * 30) + ((j.getEp)[ep]).to_i
			later = (currTime + (j.getDur).to_i) * 60 * 30
			diff = later - now
			bet = diff
			if bet % 15 == 0
				bet = bet + 15
			end
			bet = (diff / 15).round * 15

			# Choose the correct PSA playlist based on time
			psa = ""
			x = 1
			if bet == 15
				psa = ":15 Minute"
				x = 230
			elsif bet == 30
				psa = ":30 Minute"
				x = 226
			elsif bet == 45
				psa = ":45 Minute"
				x = 3018
			elsif bet == 60
				psa = "1 Minute"
				x = 194
			elsif bet == 75
				psa = "1:15 Minute"
				x = 3021
			elsif bet == 90
				psa = "1:30 Minute"
				x = 197
			elsif bet == 105
				psa = "1:45 Minute"
				x = 3025
			elsif bet == 120
				psa = "2 Minutes"
				x = 200
			elsif bet == 135
				psa = "2:15 Minute"
				x = 3029
			elsif bet == 150
				psa = "2:30 Minutes"
				x = 204
			elsif bet == 165
				psa = "2:45 Minute"
				x = 3034
			elsif bet == 180
				psa = "3 Minutes"
				x = 209
			elsif bet == 195
				psa = "3:15 Minute"
				x = 3040
			elsif bet == 210
				psa = "3:30 Minute"
				x = 213
			elsif bet == 225
				psa = "3:45 Minute"
				x=213
			else
				psa = "4:00 Minute"
				x=213
			end

			# Write your episode
			output.puts("1,#{real},#{Time.at((currTime * 60 * 30)).utc.strftime("%H:%M:%S")},PLAYOUT,,#{((j.getEp).keys)[i % (((j.getEp).keys).length)]},0,#{(j.getEp)[ep]},Channel 1,,,,,,,FALSE,,,TRUE,TRUE,0,")
			# Write the appropriate PSA
			output.puts("1,#{real},#{Time.at((currTime * 60 * 30) + ((j.getEp)[ep]).to_i).utc.strftime("%H:%M:%S")},PLAYLIST,#{x},#{psa},0.0,#{bet},Channel 1,"","","",,"","",false,"","",true,true,0,")
			currTime = currTime + (j.getDur).to_i
		end
		
		curr = curr.next_day
	end

	output.close

end
main