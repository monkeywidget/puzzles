#!/usr/bin/env ruby
# https://en.wikipedia.org/wiki/Monty_Hall_problem

class MontyHallSimulator

  attr_reader :switcher_total_wins
  attr_reader :stayer_total_wins
  attr_reader :chaosmonkey_total_wins
  attr_reader :random

  def initialize(num_games)
    @num_games = num_games.to_i
    put_greeting
    @printer = ProgressBarPrinter.new(1000)
    @random = Random.new
  end

  def put_greeting
    puts "Suppose you're on a game show, and you're given the choice of three doors: "
    puts "Behind one door is a car; behind the others, goats. [Assume: you want the car]"
    puts "- You pick a door, say No. 1"
    puts "- Then the host, who knows what's behind the doors, opens another door, "
    puts "  which has a goat.\n\n"
    puts "He then says to you, \"Do you want to pick your door or the other?\"\n\n"
    puts "Q: Is it to your advantage to switch your choice?\n\n"

    @switcher_total_wins = 0
    puts '- Switcher always switches'

    @stayer_total_wins = 0
    puts '- Stayer never switches'

    @chaosmonkey_total_wins = 0
    puts '- Chaosmonkey chooses at random between switching or not'

    puts "\nI'll run the simulation #{@num_games} times:\n\n"
  end

  # The players always initially choose Door 1
  def run_one_game
    # the car is actually in any of three doors:
    car_location = random.rand(1..3)

    revealed_goat_door = host_opens_door(car_location)
    other_choice = remaining_closed_door(revealed_goat_door)

    if (car_location == other_choice)
      @switcher_total_wins += 1
    end

    # Stayer will stay (Door 1)
    if (car_location == 1)
      @stayer_total_wins += 1
    end

    # Chaosmonkey will either stay (Door 1) or switch
    chaosmonkey_choice = (random.rand(0..1) == 0) ? other_choice : 1

    if (car_location == chaosmonkey_choice)
      @chaosmonkey_total_wins += 1
    end
  end

  # The host opens a door, either Door 2 or Door 3
  # @param [Integer] car_location which is 1, 2, or 3
  # @return [Integer] goat_door revealed by the host, which will be 2 or 3
  def host_opens_door(car_location)
    case car_location
    when 2
      3 # the only unpicked door with a goat
    when 3
      2 # the only unpicked door with a goat
    else
      random.rand(2..3)
    end
  end

  # @param [Integer] opened_door which is 2 or 3
  # @return [Integer] non_opened_door which is 3 or 2, respectively
  def remaining_closed_door(opened_door)
    return opened_door == 2 ? 3 : 2
  end

  # printer utility to print the percent of the wins to 4 decimal places
  # @param [Integer] wins out of @num_games
  # @return [Float] percentage of games won
  def percent_wins(wins)
     ((wins.to_f / @num_games.to_f) * 100).round(4)
  end

  def print_totals
    @num_games.times do
      run_one_game
      @printer.print_progress_bar
    end

    puts "\n\n"
    puts "The Switcher won the car #{percent_wins(switcher_total_wins)}% of the time"
    puts "The Stayer won the car #{percent_wins(stayer_total_wins)}% of the time"
    puts "The ChaosMonkey won the car #{percent_wins(chaosmonkey_total_wins)}% of the time"
    puts "\n\n"
  end

  class ProgressBarPrinter
    def initialize(how_often)
      @sample_period = how_often
      puts "I'll print a dot every #{how_often} tests:\n\n"

      @current_count = 0
    end

    #  print the progress bar every @sample_period times
    def print_progress_bar
      if @current_count % @sample_period == 0
        print  '.'
        $stdout.flush
      end

      @current_count += 1
    end
  end

end

MontyHallSimulator.new(ARGV[0]).print_totals
