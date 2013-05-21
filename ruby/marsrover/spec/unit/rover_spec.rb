require 'spec_helper'
require 'rover'

describe Rover do
  before do
    @rover = Rover.new(1,2,'N')
  end

  it "should allow a new Rover with valid coordinates and direction" do
    expect{Rover.new(1,1,'N')}.to_not raise_exception
  end
  it "should reject a new Rover with invalid negative coordinates" do
    expect{Rover.new(1,-1,'N')}.to raise_exception
  end

  it "should reject a new Rover with invalid non-integer coordinates" do
    expect{Rover.new(1,1.0,'N')}.to raise_exception
  end

  it "should reject a new Rover with invalid direction" do
    expect{Rover.new(1,1,'g')}.to raise_exception
  end

  it "should return the current coordinates" do
    @rover.x_location.should be 1
    @rover.y_location.should be 2
  end

  it "should return the current direction it's facing'" do
    @rover.facing_direction.should eql 'N'
  end

  it "should load in a route plan" do
    test_route = 'LMLMLMLMM'
    @rover.travel_instructions=(test_route)
    expect(@rover.travel_instructions).to eql(test_route)
  end

  it "should not load in an invalid route plan" do
    test_route = 'LMF'
    expect{@rover.travel_instructions=(test_route)}.to raise_error
    expect(@rover.travel_instructions).to be_nil
  end

  it "should recognize an invalid route plan" do
    expect{@rover.travel_instructions=('a')}.to raise_error
    expect{@rover.travel_instructions=('LMRa')}.to raise_error
    expect{@rover.travel_instructions=('   LMR')}.to raise_error
  end

  it "should execute a single right turn on a clock cycle" do
    @rover = Rover.new(1,2,'N')
    @rover.travel_instructions=('RRRR')
    @rover.clock_tick
    expect(@rover.facing_direction).to eql('E')
    @rover.clock_tick
    expect(@rover.facing_direction).to eql('S')
    @rover.clock_tick
    expect(@rover.facing_direction).to eql('W')
    @rover.clock_tick
    expect(@rover.facing_direction).to eql('N')
  end

  it "should execute a single left turn on a clock cycle" do
    @rover = Rover.new(1,2,'N')
    @rover.travel_instructions=('LLLL')
    @rover.clock_tick
    expect(@rover.facing_direction).to eql('W')
    @rover.clock_tick
    expect(@rover.facing_direction).to eql('S')
    @rover.clock_tick
    expect(@rover.facing_direction).to eql('E')
    @rover.clock_tick
    expect(@rover.facing_direction).to eql('N')
  end

  it "should turn without changing position" do
    @rover = Rover.new(1,2,'N')
    @rover.travel_instructions=('LR')

    @rover.clock_tick
    expect(@rover.facing_direction).to eql('W')
    expect(@rover.x_location).to eql(1)
    expect(@rover.y_location).to eql(2)

    @rover.clock_tick
    expect(@rover.facing_direction).to eql('N')
    expect(@rover.x_location).to eql(1)
    expect(@rover.y_location).to eql(2)
  end

  it "should execute a single move on a clock cycle and not turn" do
    @rover = Rover.new(1,2,'N')
    @rover.travel_instructions=('M')

    @rover.clock_tick
    expect(@rover.facing_direction).to eql('N')
    expect(@rover.x_location).to eql(1)
    expect(@rover.y_location).to eql(3)
  end

  it "should know its first desired move" do
    @rover.travel_instructions=('LMR')
    expect(@rover.will_travel_next_tick?).to be_false

    @rover.travel_instructions=('MR')
    expect(@rover.will_travel_next_tick?).to be_true
  end

  it "should know its next desired move" do
    @rover.travel_instructions=('LMR')
    expect(@rover.will_travel_next_tick?).to be_false
    @rover.clock_tick
    expect(@rover.will_travel_next_tick?).to be_true
  end

  # it "should know its next desired position on a move" do
  # end

  it "should know its next desired position on a turn" do
    @rover.travel_instructions=('LRM')

    new_x, new_y = @rover.wants_next_position
    # doesn't move (rover starting position set in "before")
    expect(new_x).to eql(1)
    expect(new_y).to eql(2)

    new_x, new_y = @rover.wants_next_position
    # doesn't move (rover starting position set in "before")
    expect(new_x).to eql(1)
    expect(new_y).to eql(2)
  end

  it "should execute its next move on a clock tick" do
    @rover.travel_instructions=('MLR')
    @rover.clock_tick

    # moves as predicted (rover starting position set in "before")
    expect(@rover.x_location).to eql(1)
    expect(@rover.y_location).to eql(3)
    expect(@rover.facing_direction).to eql('N')   # started at 'N'
  end

  it "should execute its next turn on a clock tick" do
    @rover.travel_instructions=('LRM')
    @rover.clock_tick

    # doesn't move (rover starting position set in "before")
    expect(@rover.x_location).to eql(1)
    expect(@rover.y_location).to eql(2)
    expect(@rover.facing_direction).to eql('W')   # started at 'N'
  end

  it "should execute its next move as predicted" do
    @rover.travel_instructions=('MLR')
    new_x, new_y = @rover.wants_next_position
    will_be_facing = @rover.facing_direction

    @rover.clock_tick

    # moves as predicted (rover starting position set in "before")
    expect(@rover.x_location).to eql(new_x)
    expect(@rover.y_location).to eql(new_y)
    expect(@rover.facing_direction).to eql(will_be_facing)   # started at 'N'
  end

  it "should execute its next turn as predicted" do
    @rover.travel_instructions=('LRM')
    new_x, new_y = @rover.wants_next_position

    @rover.clock_tick

    # moves as predicted (rover starting position set in "before")
    expect(@rover.x_location).to eql(new_x)
    expect(@rover.y_location).to eql(new_y)
    expect(@rover.facing_direction).to eql('W')   # started at 'N'
  end

  # story for cardinal_direction_to_my
  it "should know how to rotate clockwise" do
    @rover.travel_instructions=('RRRR')
    expect(@rover.facing_direction).to eql('N')   # started at 'N'
    @rover.clock_tick
    expect(@rover.facing_direction).to eql('E')
    @rover.clock_tick
    expect(@rover.facing_direction).to eql('S')
    @rover.clock_tick
    expect(@rover.facing_direction).to eql('W')
    @rover.clock_tick
    expect(@rover.facing_direction).to eql('N')
  end

  # story for cardinal_direction_to_my
  it "should know how to rotate counter-clockwise" do
    @rover.travel_instructions=('LLLL')
    expect(@rover.facing_direction).to eql('N')   # started at 'N'
    @rover.clock_tick
    expect(@rover.facing_direction).to eql('W')
    @rover.clock_tick
    expect(@rover.facing_direction).to eql('S')
    @rover.clock_tick
    expect(@rover.facing_direction).to eql('E')
    @rover.clock_tick
    expect(@rover.facing_direction).to eql('N')
  end

  # TODO: shorten test, break into cases
  # story for basic direction movement
  it "should know movement in the cardinal directions" do
    @rover.travel_instructions=('MLMLMLM')
    expect(@rover.facing_direction).to eql('N')   # started at 'N'
    expect(@rover.x_location).to eql(1)
    expect(@rover.y_location).to eql(2)

    @rover.clock_tick
    expect(@rover.facing_direction).to eql('N')   # moved N
    expect(@rover.x_location).to eql(1)
    expect(@rover.y_location).to eql(3)

    @rover.clock_tick
    expect(@rover.facing_direction).to eql('W')   # turned L
    expect(@rover.x_location).to eql(1)
    expect(@rover.y_location).to eql(3)

    @rover.clock_tick
    expect(@rover.facing_direction).to eql('W')   # moved W
    expect(@rover.x_location).to eql(0)
    expect(@rover.y_location).to eql(3)

    @rover.clock_tick
    expect(@rover.facing_direction).to eql('S')   # turned L
    expect(@rover.x_location).to eql(0)
    expect(@rover.y_location).to eql(3)

    @rover.clock_tick
    expect(@rover.facing_direction).to eql('S')   # moved S
    expect(@rover.x_location).to eql(0)
    expect(@rover.y_location).to eql(2)

    @rover.clock_tick
    expect(@rover.facing_direction).to eql('E')   # turned L
    expect(@rover.x_location).to eql(0)
    expect(@rover.y_location).to eql(2)

    @rover.clock_tick
    expect(@rover.facing_direction).to eql('E')   # moved E
    expect(@rover.x_location).to eql(1)
    expect(@rover.y_location).to eql(2)

  end

end