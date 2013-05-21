class RouteMap

=begin

The map has no negative coordinates
All coordinates are integers and start at 0

=end

  # @rover_grid is an array of arrays, each cell holding references to Rovers or nil

  # RFE: @rover_locations is a hash of all the rovers
  # RFE: track which angles have been photographed

  def initialize ( x_size, y_size )

    raise ArgumentError.new("Map size arguments must be positive integers") unless (
      x_size.integer? and y_size.integer? and
      x_size > 0 and y_size > 0
    )

    @rover_grid = Array.new(x_size) { Array.new(y_size) }
    @photographed_grid = Array.new(x_size) { Array.new(y_size) }
  end

  def valid_coords?(x_coord, y_coord)
    return false unless x_coord.integer? and x_coord > -1
    return false unless x_coord < @rover_grid.length

    return false unless y_coord.integer? and y_coord > -1
    return false unless y_coord < @rover_grid[x_coord].length
    true
  end

  def can_move_rover_into?(x_coord, y_coord)
    return false unless valid_coords?(x_coord, y_coord)

    @rover_grid[x_coord][y_coord].nil?      # avoid collisions!
  end


  def mark_rover_at(rover, x_coord, y_coord)
    return false unless can_move_rover_into?(x_coord, y_coord)

    @rover_grid[rover.x_coord][rover.y_coord] = nil
    @rover_grid[x_coord][y_coord]= rover

    # mark the new grid square photographed
    @photographed_grid[x_coord][y_coord] = true

    true
  end


end

