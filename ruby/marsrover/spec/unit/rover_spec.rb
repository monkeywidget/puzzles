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


=begin

calculates its next position given current position and different movement arguments

=end



end