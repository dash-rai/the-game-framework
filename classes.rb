
class Character

  attr_reader :health
  
  def initialize
    @items = []
    @health = 1
  end

  def list_items
    if @items.empty?
      puts "You aren't carrying anything."
      return
    end
    puts "You are currently carrying: "
    @items.each do |item|
      print '* '
      puts item.attributes['name']
    end
  end

  def pick_item(item_name)
    # check if character already has item
    @items.each do |item|
      if item.attributes['name'] == item_name
        puts "You already have the %s." % item_name
        return
      end
    end
    # if room has item, pick it up
    $current_room.items.each do |item|
      if item.attributes['name'] == item_name
        @items.push item
        puts "You picked up the %s" % item.attributes['name']
        $current_room.items.delete item
        return
      end
    end
    # item neither in room nor with you
    puts "The %s is not in the room" % item_name
  end

  def drop_item(item_name)
    @items.each do |item|
      if item.attributes['name'] == item_name
        $current_room.items.push item
        puts "You are no longer carrying the %s" % item.attributes['name']
        @items.delete(item)
        return
      end
    end
    puts "The %s is not with you" % item_name
  end
  
  def change_health(change) #negative change to cause damage
    if @health + change > 1
      @health = 1
    else
      @health += change
    end
  end

  def display_health
    puts "Health: %d%" % (@health * 100).to_i
  end

  
end


class Room
  attr_accessor :item,:paths,:description
  def initialize(description,paths)
    @description=description
    @paths=paths
  end

  def self.from_hash(hash)
    new(hash[:description],hash[:paths])
  end

  def move(direction)
    destination = $current_room.paths[direction] #A string from the json 
    if destination != nil #direction has been defined
      if $rooms.key? destination.to_sym #The string is a valid room
        $current_room=$rooms[destination.to_sym]
        print $current_room.description
      else
        puts destination
      end
    else
      puts "You can't go there."
    end
    
  end
end

