require 'spec_helper'
require 'route_map'


describe RouteMap do
  before do
    @route_map = RouteMap.new(5,6)
  end

  it "should create a grid from size in constructor" do
    expect(@route_map.valid_coords?(0,0)).to be_true
    expect(@route_map.valid_coords?(4,5)).to be_true
    expect(@route_map.valid_coords?(5,5)).to be_false
    expect(@route_map.valid_coords?(4,6)).to be_false
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

end

=begin

knows to not move a rover into an invalid square (could mock valid_coords?))
does not update a rover with new info when move fails for invalid coord

knows to not move a rover into a square holding another rover
does not update a rover with new info when move fails for square holding another rover

writes to the photographed map when rover moves
updates a rover with new info when moved
clears previous rover square when rover is moved

=end
