class Rover

  # this is the model - movements are in the controller

  attr_reader :x_location
  attr_reader :y_location
  attr_reader :facing_direction

  def initialize (x_start, y_start, face_start)

    raise ArgumentError, 'coordinates must be integers' unless x_start.integer? and y_start.integer?
    raise ArgumentError, 'coordinates must be non-negative' unless (x_start > -1) and (y_start > -1)
    raise ArgumentError, 'direction must be one of N S E W' unless ['N', 'S', 'E', 'W'].include?(face_start)

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
  end

end