require 'spec_helper'
require 'rover'

describe Rover do
  before do
    @rover = Rover.new(1,2,'N')
  end

  it "should allow a new Rover with valid coordinates and direction" do
    Rover.new(1,1,'N').should_not raise_error
  end

  it "should reject a new Rover with invalid negative coordinates" do
    Rover.new(1,-1,'N').should raise_error
  end

  it "should reject a new Rover with invalid non-integer coordinates" do
    Rover.new(1,1.0,'N').should raise_error
  end

  it "should reject a new Rover with invalid direction" do
    Rover.new(1,1,'g').should raise_error
  end


  it "should return the current coordinates" do
    @rover.x_location.should be 1
    @rover.y_location.should be 2
  end

  it "should return the current direction it's facing'" do
    @rover.facing_direction.should eql 'N'
  end


=begin

validates initial fields

loads and validates a route plan

tells its current position and face direction

calculates their next position given current position and different movement arguments


=end



end