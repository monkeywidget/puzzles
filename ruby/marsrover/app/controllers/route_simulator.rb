class RouteSimulator

  def run_one_rover_instruction (rover)

    # update map only if the rover is moving (vs turning)
    if rover.will_travel_next_tick?
      raise ArgumentError.new("Rover would collide on next step!") unless @map.can_move_rover_into?(rover.wants_next_position)
      raise ArgumentError.new("Can't move rover from (#{rover.x_location},#{rover.y_location})") unless @map.mark_rover_at(rover, rover.wants_next_position)
    end

    # update rover
    rover.clock_tick
  end

  def run_rover_instructions (rover)
    rover.travel_instructions.split.size.times do
      run_one_rover_instruction(rover)
    end
  end

  def run_all_rover_instructions
    @rovers.each do |rover|
      run_rover_instructions (rover)
    end
  end

  def initialize
=begin
    file = File.new("ROVER_INPUT", "r")
    while (line = file.gets)
      print "DEBUG: FILE: #{line}"
    end
    file.close
=end

  end

  def init_map ( x_size, y_size )
    @map = RouteMap.new(x_size,y_size)
  end

  def add_rover (x_initial, y_initial, facing, instructions)
    rover = Rover.new (x_initial,y_initial,facing)
    rover.travel_instructions=(instructions)
    @rovers << rover
    @map.mark_rover_at(rover, [x_initial,y_initial])
  end

end
=begin

# RFE: revert if rover fails to move for some reason

clock tick for rover

update rover position
    rover.x_coord = x_coord
    rover.y_coord = y_coord


=end
