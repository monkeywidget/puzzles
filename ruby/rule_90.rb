# Rule 90:
#   rule 111 => 0
#   rule 110 => 1
#   rule 101 => 0
#   rule 100 => 1
#   rule 011 => 1
#   rule 010 => 0
#   rule 001 => 1
#   rule 000 => 0
class LinearCellularAutomaton
  RULE_NAME = 90
  CYCLE_DURATION = 0.1

  def initialize
    require 'io/console'
    @size = IO.console.winsize[1] # number of columns of the terminal

    @universe = Array.new(@size){ 0 }
    @universe[@size/2] = 1 # "acorn" or "Garden of Eden"

    print_rules
    print_universe # initial print
  end

  # table of rules, converted from the binary interpretation of the name
  # the current state of a single cell and its 2 neighbors determine the next state
  # therefore Rule 010 would dictate the next state of a live cell surrounded by 2 dead cells
  # By convention of these 1D CA, the rules count down from 7 ('111') to 0 ('000')
  def rules
    return @rules unless @rules.nil?

    # this initialization code runs only once
    @rules = {}
    7.downto(0).each do |rule_key|
      key = rule_key.to_s(2).rjust(3, '0') # convert to binary, pad left with 0
      @rules[key.to_sym] = RULE_NAME >> rule_key & 1 # just the one bit
    end

    @rules
  end

  # advances the universe one cycle and prints
  def next_step
    universe_next = Array.new(@size){0}

    universe_next.each_with_index do |cell, index|
      universe_next[index] = rule_on(index)
    end

    @universe = universe_next
    print_universe
  end

  # given the current state, what is the next step for @universe[index] ?
  def rule_on(index)
    case index
    when 0 # the left edge
      rules[@universe.slice(index,2).push(0).join.to_sym]
    when @size - 1 # the right edge
      rules[@universe.slice(index-1,2).unshift(0).join.to_sym]
    else
      rules[@universe.slice(index-1,3).join.to_sym] # use the neighbors
    end
  end

  def print_universe
    puts @universe.map{ |state| state.eql?(1) ? '*' : ' ' }.join
  end

  def print_rules
    puts "Rule #{RULE_NAME}:"
    rules.each_pair do |rule_key, rule_value|
      puts "\trule #{rule_key} => #{rule_value}"
    end
  end

  def age(cycles_to_run)
    cycles_to_run.times do
      next_step
      sleep CYCLE_DURATION
    end
  end
end

LinearCellularAutomaton.new.age(100)
