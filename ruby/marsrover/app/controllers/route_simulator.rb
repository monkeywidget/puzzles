require 'route_map'
require 'rover'

class RouteSimulator

  attr_reader :map
  attr_reader :rovers   # an array

  # RFE: move parse logic into its own class

=begin
  simple state machine:

      :reading_map -> :reading_rover_init
      :reading_rover_init -> :reading_rover_instructions
      :reading_rover_instructions -> :reading_rover_init
=end

  # calls init_map and add_rover
  def parse_input (input_string)
    lines = input_string.split(/\n/)

    state = :reading_map

    rover_x_start = 0
    rover_y_start = 0
    rover_facing_start = 0

    lines.each do |line|
      # drop empty lines
      next unless /(\w)+/ =~ line

      case state
        when :reading_map
          match = /^\s*(\d+)\s+(\d+)\s*$/.match(line)
          raise ArgumentError.new("Invalid map data >>#{line}<<") unless match

          x_size = $1.to_i
          y_size = $2.to_i

          init_map(x_size,y_size)

          state = :reading_rover_init

        when :reading_rover_init
          match = /^\s*(\d+)\s+(\d+)\s+([NSWE])\s*$/.match(line)
          # match = line.match /^\s*(\d+)\s+(\d+)\s+([NSWE])\s*$/
          raise ArgumentError.new("Invalid rover init >>#{line}<<") unless match

          rover_x_start = $1.to_i
          rover_y_start = $2.to_i
          rover_facing_start = $3

          state = :reading_rover_instructions
        when :reading_rover_instructions
          match = /^\s*([LRM]+)\s*$/.match(line)
          raise ArgumentError.new("Invalid rover init >>#{line}<<") unless match

          rover_instructions = $1

          add_rover(rover_x_start,rover_y_start,rover_facing_start,rover_instructions)

          state = :reading_rover_init
      end
    end

  end



  # RFE: revert if rover fails to move for some reason
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
    init_rovers
  end

  def init_rovers
    @rovers = Array.new
  end

  def init_map ( x_size, y_size )
    @map = RouteMap.new(x_size,y_size)
  end

  def add_rover (x_initial, y_initial, facing, instructions)
    rover = Rover.new(x_initial,y_initial,facing)
    rover.travel_instructions=(instructions)
    @rovers << rover
    @map.mark_rover_at(rover, [x_initial,y_initial])
  end

  def report_final_rover_positions
    output = ""
    rovers.each do |rover|
      output << "#{rover.x_location} #{rover.y_location} #{rover.facing_direction}\n\n"
    end

    output
  end

  def run_simulation
    run_all_rover_instructions
    print "FINAL: #{report_final_rover_positions}\n\n"
  end

end
