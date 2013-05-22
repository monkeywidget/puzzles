class RouteMap

=begin

The map has no negative coordinates
All coordinates are integers and start at 0

=end
  attr_reader :rover_grid
  # @rover_grid is an array of arrays, each cell holding references to Rovers or nil

  attr_reader :photographed_grid
  # @photographed_grid is an array of arrays, each cell holding "true" if the square has been photographed
  # RFE: track which angles have been photographed

  def initialize ( x_greatest, y_greatest )

    raise ArgumentError.new("Map size arguments must be positive integers") unless (
      x_greatest.integer? and y_greatest.integer? and
        x_greatest > 0 and y_greatest > 0
    )

    @rover_grid = Array.new(x_greatest+1) { Array.new(y_greatest+1) }
    @photographed_grid = Array.new(x_greatest+1) { Array.new(y_greatest+1) }
  end

  def valid_coords?(x_coord, y_coord)
    return false unless x_coord.integer? and x_coord > -1
    return false unless x_coord < @rover_grid.length

    return false unless y_coord.integer? and y_coord > -1
    return false unless y_coord < @rover_grid[x_coord].length
    true
  end

  def can_move_rover_into?(xy_coords)
    x_coord, y_coord = xy_coords
    return false unless valid_coords?(x_coord, y_coord)

    @rover_grid[x_coord][y_coord].nil?      # avoid collisions!
  end

  # called BEFORE the rover is updated
  # doesn't distinguish between this and other rovers,
  #   i.e. a rover asking to move to the square it is already in will be denied
  def mark_rover_at(rover, xy_coords)
    return false unless can_move_rover_into?(xy_coords)
    x_coord, y_coord = xy_coords

    @rover_grid[rover.x_location][rover.y_location] = nil
    @rover_grid[x_coord][y_coord]= rover

    # mark the new grid square photographed
    @photographed_grid[x_coord][y_coord] = true
    true
  end


end

