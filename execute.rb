def execute(instruction)

  if instruction.token == :say
    puts instruction.value
  elsif instruction.token == :take
    $runner.pick_item(instruction.value)
  elsif instruction.token == :drop
    $runner.pick_item(instruction.value)
  elsif instruction.token == :go
    $current_room.move(instruction.value)
  end
  
end
