class Rover

  attr_reader :x_location
  attr_reader :y_location
  attr_reader :facing_direction

  def initialize (x_start, y_start, face_start)

    raise ArgumentError, "coordinates (#{x_start},#{y_start}) must be integers" unless x_start.integer? and y_start.integer?
    raise ArgumentError, "coordinates (#{x_start},#{y_start}) must be non-negative" unless (x_start > -1) and (y_start > -1)
    raise ArgumentError, "direction \'#{face_start}\' must be one of N S E W" unless ['N', 'S', 'E', 'W'].include?(face_start)

    @x_location = x_start
    @y_location = y_start
    @facing_direction = face_start

    @current_instruction = 0    # index of travel_instructions
  end

  # travel_instructions are an array of cardinal directions
  def travel_instructions
    @travel_instructions
  end

  def travel_instructions=(new_instructions)
    # validate:
    new_instructions.split(//).each do | instruction |
      raise ArgumentError.new("#{instruction}: All instructions must be in L R M") unless ['L', 'R', 'M'].include? instruction
    end
    @travel_instructions = new_instructions
    @current_instruction = 0   # reset the index
  end


  def will_travel_next_tick?
    return @travel_instructions[@current_instruction].eql?('M')
  end

  # returns x,y
  def coordinates_to_the(direction)
    case direction
      when 'N'
        return @x_location, @y_location+1
      when 'S'
        return @x_location, @y_location-1
      when 'E'
        return @x_location+1, @y_location
      when 'W'
        return @x_location-1, @y_location
    end
    raise new ArgumentError("cardinal direction #{direction} is not in [N S E W]")
  end

  def cardinal_direction_to_my(left_or_right)
    case left_or_right
      when 'L'
        case @facing_direction
          when 'N'
            return 'W'
          when 'W'
            return 'S'
          when 'S'
            return 'E'
          when 'E'
            return 'N'
        end
      when 'R'
        case @facing_direction
          when 'N'
            return 'E'
          when 'E'
            return 'S'
          when 'S'
            return 'W'
          when 'W'
            return 'N'
        end
    end
    raise ArgumentError.new("turn direction #{left_or_right} is not in [L R]")
  end


  def wants_next_position
    case @travel_instructions[@current_instruction]
      when 'L', 'R'                         # TURN
        return @x_location, @y_location
      else                                  # MOVE
        coordinates_to_the(@facing_direction)
    end
  end

  # must be run after updating the map!
  def clock_tick
    instruction = @travel_instructions[@current_instruction]
    case instruction
      when 'L', 'R'
        @facing_direction = cardinal_direction_to_my(instruction)
      when 'M'
        @x_location, @y_location = coordinates_to_the(@facing_direction)
      else
        raise ArgumentError.new("illegal instruction #{@travel_instructions[@current_instruction]} at index #{@current_instruction}")
    end
    @current_instruction += 1
  end

=begin

  # used only when debugging
  def announce_debug
    print "DEBUG: I'm a Rover \n\tat (#{@x_location},#{@y_location})\n"
    print "\tfacing #{@facing_direction}\n\tand my next instruction is '#{@travel_instructions[@current_instruction]}'\n"
  end
=end
end