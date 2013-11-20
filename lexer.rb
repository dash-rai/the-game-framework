# go into the house
# drop item



Pair = Struct.new(:token, :value)

$verb_list = {
  :go => [:N, :E, :S, :W, :NE, :SE, :SW, :NW, :U, :D],
  :enter => [:house], # review having this around
  :take => [:lantern], #don't forget those pesky commas
  :look => [:around, :lantern] # look around, look at lantern. Remember the "at" will be removed
}

$prepositions_list = ["the", "at", "on", "under", "above", "in", "with", "to"]
$adjectives_list = ["brown", "brass"]

def understand(input_string)
  input_string = input_string.strip.downcase.gsub(/[^a-z0-9\s]/, '')

  case input_string
    # EMPTY
  when ""
    return Pair.new(:gibberish, :empty)
    #GREETINGS
  when "hello", "hi", "hey", "greetings"
    return Pair.new(:say, :"Hello! Welcome to The Adventure!")
    # if input_string == "exit"
    #   return Pair.new(:say, :"You can't go that way")
    # end
    #DIRECTION SHORTCUTS
  when "north", "n"
    return Pair.new(:go, :N)
  when "east", "e"
    return Pair.new(:go, :E)
  when "south", "s"
    return Pair.new(:go, :S)
  when "west", "w"
    return Pair.new(:go, :W)
  when "up", "u"
    return Pair.new(:go, :U)
  when "down", "d"
    return Pair.new(:go, :D)
  when "northeast", "north-east", "ne" 
    return Pair.new(:go, :NE)
  when "southeast", "south-east", "se"
    return Pair.new(:go, :SE)
  when "southwest", "south-west", "sw"
    return Pair.new(:go, :SW)
  when "northwest", "north-west", "nw"
    return Pair.new(:go, :NW)
  when "look", "l"
    return Pair.new(:look, :around)
    # ACTION SHORTCUTS
  when "take"
    return Pair.new(:take, :all)
  when "drop"
    return Pair.new(:drop, :all)
  end
  #GET VERB AND NOUN
  token, value = get_verb_noun(input_string.split(' '))

  # :gibberish token values:
  # :goWHERE
  # :takeWHAT
  # :throwAT?
  # :breakWITH?
  # if verb, but noun == nil, say verb what?
  #I DIDN'T UNDERSTAND THAT!

  # possible returns:
  # did not find verb, did not find noun :gibberish, "Could not understand that"
  # verb, no noun :NoNoun, :verb
  # no verb, noun :NoVerb, :noun
  # verb, noun :verb, :noun

  
  if token == :gibberish
    return Pair.new(token, value) # There doesn't appear to be a NOUN? in that sentence
  end
  #RETURN token, value
  if $verb_list.include?(token) && $verb_list[token].include?(value)
    return Pair.new(token, value)
  else # probably don't ever need this
    return Pair.new(:gibberish, value)
  end
  
end

def get_verb_noun(input)

  verb = nil
  input = remove_preps_adjs(input)

  if input.first == "go" || input.first == "head" || input.first == "walk"
    verb = :go
  elsif input.first == "enter"
    verb = :enter
  elsif input.first == "take"
    verb = :take
  elsif input.first == "pick"
    input.delete("up") #takes care of things like "pick upX" or "pick X up"
    verb = :take
  elsif input.first == "look"
    verb = :look
  end
  
  if verb
    noun = input[1...input.length]
    symbol = symbolisize(noun)
    if symbol
      return verb, symbol
    else
      return :gibberish, "I don't know how to do that to a %s." % noun.join(' ')
    end
  end
  #MULTI NOUN COMMANDS:
  #THROW
  if input.first == "throw"
    if !input.include? "at"
      return :gibberish, :throwAT #in execute() say "What do you want me to throw noun at?
    end
    noun = input[1..input.index("at")], input[(input.index("at") + 1)...input.length]
    if noun[0] == nil
      return :gibberish, :throwWHAT?
    end
    if noun[1] == nil
      return :gibberish, :throwAT?
    end
    verb = :throw
  end
  
  #BREAK
  if input.first == "break"
    if !input.include? "with"
      ;      return :gibberish, :breakWITH?
    end
    noun = input[1..input.index("at")], input[(input.index("at") + 1)...input.length]
    if noun[0] == nil
      return :gibberish, :breakWHAT?
    end
    if noun[1] == nil
      return :gibberish, :breakWITH?
    end
    verb = :break
  end

  # #TIE
  # if input.first == "tie"
  #   if !input.include? "with"
  # return verb, [symbolisize(noun[0]), symbolisize(noun[1])]
  # #tie rope onto railing
  # #tie sack with rope


  #perhaps do an all-else-fail return here

end
def symbolisize(noun)
  noun = noun.join
  if noun == "north" || noun == "n"
    return :N
  end
  if noun == "east" || noun == "e"
    return :E
  end
  if noun == "south" || noun == "s"
    return :S
  end
  if noun == "west" || noun == "w"
    return :W
  end
  if noun == "northeast" || noun == "north-east" || noun == "ne"
    return :NE
  end
  if noun == "southeast" || noun == "south-east" || noun == "se"
    return :SE
  end
  if noun == "southwest" || noun == "south-west" || noun == "sw"
    return :SW
  end
  if noun == "northwest" || noun == "north-west" || noun == "nw"
    return :NW
  end
  if noun == "up" || noun == "u" || noun == "upstairs"
    return :U
  end
  if noun == "down" || noun == "d" || noun == "downstairs"
    return :D
  end
  #things
  if noun == "lantern"
    return :lantern
  end
  if noun == "around"
    return :around
  end
  return nil
end

def remove_preps_adjs(input)
  $prepositions_list.each do |prep|
    input.delete(prep)
  end
  return input
end





