require 'spec_helper'
require 'route_map'


describe RouteMap do
  before do
    @route_map = RouteMap.new(5,6)
  end

  it "should create a grid from size in constructor" do
    expect(@route_map.valid_coords?(0,0)).to be_true
    expect(@route_map.valid_coords?(5,6)).to be_true
    expect(@route_map.valid_coords?(6,6)).to be_false
    expect(@route_map.valid_coords?(5,7)).to be_false
  end

  # conceivably could do every permutation of the below (x and y)
  it "should reject invalid sizes in constructor" do
    expect{RouteMap.new(1,1)}.to_not raise_error
    expect{RouteMap.new(1,1.0)}.to raise_error
    expect{RouteMap.new(-1,1)}.to raise_error
    expect{RouteMap.new(0,1)}.to raise_error
    expect{RouteMap.new(1,0)}.to raise_error
    expect{RouteMap.new('g',1)}.to raise_error
  end

  # conceivably could do every permutation of the below (x and y)
  it "should validate coordinates" do
    expect(@route_map.valid_coords?(0,0)).to be_true
    expect(@route_map.valid_coords?(0,-1)).to be_false
    expect(@route_map.valid_coords?(0,0.0)).to be_false
    expect{@route_map.valid_coords?('g',0.0)}.to raise_error
  end

  it "should advise rovers to not move into an invalid square" do
    expect(@route_map.can_move_rover_into?([0,0])).to be_true
    expect(@route_map.can_move_rover_into?([-1,0])).to be_false
    expect(@route_map.can_move_rover_into?([6,0])).to be_false
  end

  it "should advise rovers to not move into an occupied square" do
    expect(@route_map.can_move_rover_into?([0,0])).to be_true

    rover = Rover.new(0,0,'N')
    @route_map.mark_rover_at(rover, [0,0])

    expect(@route_map.can_move_rover_into?([0,0])).to be_false
  end

  it "should not move a rover if the move cannot be completed" do
    rover = Rover.new(0,0,'N')
    @route_map.mark_rover_at(rover, [0,0])

    # there's a rover at (0,0)
    expect(@route_map.mark_rover_at(rover, [0,0])).to be_false
    expect(rover.x_location).to eql(0)
    expect(rover.y_location).to eql(0)
  end


  it "should record a rover's location" do
    rover = Rover.new(0,0,'N')
    @route_map.mark_rover_at(rover, [0,0])

    expect(@route_map.rover_grid[0][0]).to equal(rover)
  end

  it "should mark a rover's location when moved" do
    rover = Rover.new(0,0,'N')
    rover.travel_instructions='M'
    expect(@route_map.mark_rover_at(rover, [0,0])).to be_true
    expect(@route_map.rover_grid[0][0]).to equal(rover)
    rover.clock_tick

    expect(@route_map.mark_rover_at(rover, [0,1])).to be_true
    expect(@route_map.rover_grid[0][1]).to equal(rover)
  end

  it "should clear a rover's previous location when moved" do
    rover = Rover.new(0,0,'N')
    rover.travel_instructions='M'
    expect(@route_map.mark_rover_at(rover, [0,0])).to be_true
    expect(@route_map.rover_grid[0][1]).to be_nil

    expect(@route_map.mark_rover_at(rover, [0,1])).to be_true
    rover.clock_tick

    expect(@route_map.rover_grid[0][0]).to be_nil
  end


  it "should record which map coordinates have been explored" do
    rover = Rover.new(0,0,'N')
    rover.travel_instructions='M'
    expect(@route_map.photographed_grid[0][0]).to be_false
    expect(@route_map.mark_rover_at(rover, [0,0])).to be_true
    expect(@route_map.photographed_grid[0][0]).to be_true

    expect(@route_map.photographed_grid[0][1]).to be_false
    expect(@route_map.mark_rover_at(rover, [0,1])).to be_true
    rover.clock_tick

    expect(@route_map.photographed_grid[0][1]).to be_true
  end


end
