#!/usr/bin/ruby
require 'rubygems'
require 'json'
require_relative 'classes'

objects_json = File.open(File.expand_path('~/the-game-framework/JSON/objects'),'r')
objects_data = JSON.parse(objects_json.read.gsub!("\n",""))
rooms_json = File.open(File.expand_path('~/the-game-framework/JSON/rooms'),'r')
rooms_data = JSON.parse(rooms_json.read.gsub!("\n","").gsub!("\t",""))
objects_json.close
rooms_json.close

$rooms={}

objects_data["rooms"].each do |room_id|
  if rooms_data.key?(room_id)
    $rooms[room_id] = Room.from_hash(rooms_data[room_id])
  else
   abort "#{room_id} not defined"
  end
end

