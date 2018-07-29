#!/usr/bin/env ruby
#
#
# This script reads the workout activities from the file WORKOUT_FILE (defaults
# to `workout.txt`). Each line of this file consists in the name of the activity
# and optional details or variations in parentheses (not read aloud).
#
# You can configure options in the file `config.rb`.
#
# Make sure you have `mpv` and `espeak` installed.
#
# Usage:
#
#     ./workout.rb

require_relative './config'
require_relative './lib'

workout = File.open(WORKOUT_FILE).readlines.map(&:chomp).select {|a| !a.start_with?('#')}.sample(NUMBER_OF_ACTIVITIES)

puts "————————————————————————————————————————————————————————"
puts workout.map.with_index {|activity, index| "#{index + 1} – #{activity}"}.join("\n")
puts
puts "#{WORK} seconds of work"
puts "#{REST} seconds of rest"
puts "————————————————————————————————————————————————————————"
puts
total_seconds = (WORK * workout.length) + (REST * (workout.length - 1))

puts "The workout will last #{sprintf("%.2f", total_seconds/60.to_f)} minutes"
puts

workout.each.with_index do |activity, index|

	play "./bliss.ogg" if index > 0

	main, details = parse(activity)
	puts "Get ready for #{main.upcase} #{details ? "(#{details})" : ""}"
	communicate "Get ready for #{activity}"

	sleep REST - 3
	beep 3, print_dot: false

	play "./system-ready.ogg"
	communicate "GO!", print:true, newline:false

	(WORK - 3).times {print "."; sleep 1}
	beep 3

	puts "DONE"
end

play "./harmonics.ogg"
puts "All done! Congratulations."
