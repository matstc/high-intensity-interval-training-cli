#!/usr/bin/env ruby

WORK = 30
REST = 5
AUDIO_PLAYER = 'mpv'

def play file
	fork {`nohup #{AUDIO_PLAYER} #{file} 2> /dev/null 1> /dev/null`}
end

workout = File.open('workout.txt').readlines.map(&:chomp)

puts "#{WORK} seconds of work"
puts "#{REST} seconds of rest"
total_seconds = (WORK * workout.length) + (REST * (workout.length - 1))

puts "The workout will last #{sprintf("%.2f", total_seconds/60.to_f)} minutes"
puts

workout.each.with_index do |activity, index|
	puts "Get ready for #{activity}"

	if index > 0
		play "./bliss.ogg"
	end

	sleep REST
	puts "GO!"
	play "./system-ready.ogg"

	(WORK - 3).times {print "."; sleep 1}

	3.times do
		print "."
		play "./dialog-information.ogg"
		sleep 1
	end

	puts "DONE"
end

play "./harmonics.ogg"
puts "All done! Congratulations."
