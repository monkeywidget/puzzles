require 'spec_helper'
require 'rover'

describe Rover do
  before do
    @rover = Rover.new(1,1,'N')
  end

  it "should reject a new Rover with invalid coordinates" do
    Hash.new.should == {}
  end

=begin

validates initial fields

loads and validates a route plan

tells its current position and face direction

calculates their next position given current position and different movement arguments


=end



end