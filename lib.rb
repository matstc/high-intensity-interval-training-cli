require_relative './config'

def play file
	fork {`nohup #{AUDIO_PLAYER} --volume 50 #{file} 2> /dev/null 1> /dev/null`}
end

def communicate text
	path = '/tmp/hiit-temp-file.txt'
	File.open(path, 'w') {|f| f.puts text.split('(').first}
	fork {`nohup espeak -v en-sc -s 140 -f #{path} 2> /dev/null 1> /dev/null`}
end

def parse line
	match = line.match(/\A([^(]*)(.*)\Z/)
	main = match.captures[0].strip
	details = match.captures[1]&.strip&.gsub(/\(|\)/, '')

	[main, details.length > 0 ? details : nil]
end
