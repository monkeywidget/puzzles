class Rover

  attr_reader :x_location
  attr_reader :y_location
  attr_reader :facing_direction

  def initialize (x_start, y_start, face_start)

    # validate initial values

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
    # TODO: validate
    @travel_instructions = new_instructions
  end

  # note that this does not validate vs the RouteMap !
  # def execute_next_instruction

  # end

=begin

=end
end