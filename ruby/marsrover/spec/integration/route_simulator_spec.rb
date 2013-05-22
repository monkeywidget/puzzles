require 'spec_helper'
require 'route_simulator'


describe RouteSimulator do
  before do
    @route_simulator = RouteSimulator.new
    @route_simulator.init_map(5,5)
    @test_input = <<-eos
5 5

1 2 N

LMLMLMLMM

3 3 E

MMRMMRMRRM

eos

    @test_output = <<-eos
1 3 N

5 1 E

eos

  end

  it "should create a map" do
    expect(@route_simulator.map.rover_grid.size).to eql(6)
    expect(@route_simulator.map.rover_grid[2].size).to eql(6)
    expect(@route_simulator.map.photographed_grid.size).to eql(6)
    expect(@route_simulator.map.photographed_grid[2].size).to eql(6)
  end

  it "should have an initially-empty list of rovers" do
    expect(@route_simulator.rovers).to be_true  # i.e. "not nil"
    expect(@route_simulator.rovers.size).to eql(0)
  end

  it "should add rovers to a list of rovers" do
    instructions = 'LRM'
    @route_simulator.add_rover(0,0,'N',instructions)

    expect(@route_simulator.rovers.size).to eql(1)
    expect(@route_simulator.rovers.first.travel_instructions).to eql(instructions)
  end

  it "should add new rovers to the map" do
    expect(@route_simulator.map.rover_grid[0][0]).to be_nil

    instructions = 'LRM'
    @route_simulator.add_rover(0,0,'N',instructions)

    expect(@route_simulator.map.rover_grid[0][0]).to be_true
    expect(@route_simulator.map.rover_grid[0][0].travel_instructions).to eql(instructions)
  end

  it "should remember the order of the rovers" do
    instructions_01 = 'LRM'
    instructions_02 = 'MRR'
    @route_simulator.add_rover(0,0,'N',instructions_01)
    @route_simulator.add_rover(2,2,'W',instructions_02)

    expect(@route_simulator.rovers.size).to eql(2)
    expect(@route_simulator.rovers[0].travel_instructions).to eql(instructions_01)
    expect(@route_simulator.rovers[1].travel_instructions).to eql(instructions_02)
  end

  it "should be able to run a single rover's single instruction'" do
    instructions_01 = 'ML'
    @route_simulator.add_rover(0,0,'N',instructions_01)
    expect(@route_simulator.map.rover_grid[0][0]).to be_true

    @route_simulator.run_one_rover_instruction(@route_simulator.rovers[0])
    expect(@route_simulator.map.rover_grid[0][0]).to be_false
    expect(@route_simulator.map.rover_grid[0][1]).to be_true
  end

  it "should update a rover on a single move instruction'" do
    instructions_01 = 'ML'
    @route_simulator.add_rover(0,0,'N',instructions_01)
    expect(@route_simulator.rovers[0].x_location).to eql(0)
    expect(@route_simulator.rovers[0].y_location).to eql(0)

    @route_simulator.run_one_rover_instruction(@route_simulator.rovers[0])
    expect(@route_simulator.rovers[0].x_location).to eql(0)
    expect(@route_simulator.rovers[0].y_location).to eql(1)
    expect(@route_simulator.rovers[0].facing_direction).to eql('N')
  end

  it "should update a rover on a single turn instruction'" do
    instructions_01 = 'LM'
    @route_simulator.add_rover(0,0,'N',instructions_01)
    expect(@route_simulator.rovers[0].x_location).to eql(0)
    expect(@route_simulator.rovers[0].y_location).to eql(0)

    @route_simulator.run_one_rover_instruction(@route_simulator.rovers[0])
    expect(@route_simulator.rovers[0].x_location).to eql(0)
    expect(@route_simulator.rovers[0].y_location).to eql(0)
    expect(@route_simulator.rovers[0].facing_direction).to eql('W')
  end


  it "should update a rover on multiple instructions'" do
    instructions_01 = 'ML'
    @route_simulator.add_rover(0,0,'N',instructions_01)
    expect(@route_simulator.rovers[0].x_location).to eql(0)
    expect(@route_simulator.rovers[0].y_location).to eql(0)
    expect(@route_simulator.rovers[0].facing_direction).to eql('N')

    @route_simulator.run_rover_instructions(@route_simulator.rovers[0])
    expect(@route_simulator.rovers[0].x_location).to eql(0)
    expect(@route_simulator.rovers[0].y_location).to eql(1)
    expect(@route_simulator.rovers[0].facing_direction).to eql('W')
  end



  it "should not move a rover to an invalid location" do
    instructions_01 = 'ML'
    @route_simulator.add_rover(0,0,'S',instructions_01)

    # so this rover would move off the map!
    expect(@route_simulator.rovers[0].x_location).to eql(0)
    expect(@route_simulator.rovers[0].y_location).to eql(0)

    expect{@route_simulator.run_one_rover_instruction(@route_simulator.rovers[0])}.to raise_error

    expect(@route_simulator.rovers[0].x_location).to eql(0)
    expect(@route_simulator.rovers[0].y_location).to eql(0)
  end



  it "should parse a basic input" do
    @route_simulator.parse_input(@test_input)
  end


  it "should complain on unparseable input" do
    expect{@route_simulator.parse_input("5 5\nspleen")}.to raise_error
  end
  # TODO: this could be a lot more cases to test the input parsing


  it "should instantiate a map from a basic input" do
    @route_simulator.parse_input(@test_input)
    expect(@route_simulator.map.rover_grid.size).to eql(6)
    expect(@route_simulator.map.rover_grid[2].size).to eql(6)
    expect(@route_simulator.map.photographed_grid.size).to eql(6)
    expect(@route_simulator.map.photographed_grid[2].size).to eql(6)
  end

  it "should instantiate rovers from basic input" do
    @route_simulator.parse_input(@test_input)
    expect(@route_simulator.rovers[0].x_location).to eql(1)
    expect(@route_simulator.rovers[0].y_location).to eql(2)
    expect(@route_simulator.rovers[0].facing_direction).to eql('N')
    expect(@route_simulator.rovers[0].travel_instructions).to eql("LMLMLMLMM")

    expect(@route_simulator.rovers[1].x_location).to eql(3)
    expect(@route_simulator.rovers[1].y_location).to eql(3)
    expect(@route_simulator.rovers[1].facing_direction).to eql('E')
    expect(@route_simulator.rovers[1].travel_instructions).to eql("MMRMMRMRRM")
  end

  it "should report final rover positions" do
    @route_simulator.parse_input(@test_input)
    @route_simulator.run_all_rover_instructions
    expect(@route_simulator.report_final_rover_positions).to eql(@test_output)
  end

end
