#!/usr/bin/ruby
require 'rubygems'
require 'json'
require_relative 'classes'
require_relative 'lexer'
require_relative 'execute'

objects_json = File.open(File.expand_path('JSON/objects'),'r')
objects_data = JSON.parse(objects_json.read.gsub!("\n","") , :symbolize_names => true)
rooms_json = File.open(File.expand_path('JSON/rooms'),'r')
rooms_data = JSON.parse(rooms_json.read.gsub!("\n","").gsub!("\t","") , :symbolize_names => true)
objects_json.close
rooms_json.close

$rooms={}

#handle multiple definitions of the same room
objects_data[:rooms].each do |room_id|
  room_id=room_id.to_sym
  if rooms_data.key?(room_id)
    $rooms[room_id] = Room.from_hash(rooms_data[room_id])
  else
   abort "#{room_id} not defined"
  end
end

$current_room=$rooms[:south_of_house]



prompt = '> '
puts '*' * 80
puts "Welcome!"
puts "Enter \"quit\" to exit game."
puts '*' * 80
puts $current_room.description
while true
  puts
  print prompt

  # A ctrl-d doesn't play well. Reports an error. Perhaps you could catch that and exit nicely.
  # Right now, the error handling below takes care of that, but doesn't look like the best way since
  # any error will go to this.
  input = STDIN.gets.chomp

  if input == "quit"
    break
  end
  
  instruction=understand(input)
  execute(instruction)

end

puts "Thank you for playing The Adventure."



