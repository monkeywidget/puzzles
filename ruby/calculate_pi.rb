## 
# calculate pi based on random sampling of coordinates:
# GIVEN the known area of the unit circle in quadrant I is PI/4
# AND a number of samples NUMSAMPLES
# - NUMSAMPLES times, pick a random location in the unit square (0.0,0.0) to (1.0,1.0)
# - tally the coordinates inside the unit circle centered at (0.0,0.0)
# - multiply this number by 4.0
# - divide this number by NUMSAMPLES to get an approximation of pi

NUMBER_OF_SAMPLES = 40000
PROGRESSOR_SAMPLE_PERIOD = 1000

##
# picks a random location in the unit square [0.0,0.0] to [1.0,1.0]
# returns true if the coordinates are distance 1.0 or less from [0.0,0.0]
# returns false otherwise
def random_coordinate_inside_unit_circle

  # Note: could be optimized into a global scope to avoid reallocation
  random = Random.new

  x_coord = random.rand(1.0)
  y_coord = random.rand(1.0)

  # the hypotenuese of a right triangle with a vertex on 0,0 and the unit circle will be 1.0
  # 1.0 squared is... 1.0
  # we will avoid doing a squareroot here

  (y_coord*y_coord) + (x_coord*x_coord) <= 1.0
end


##
#  print the progress bar if PROGRESSOR_SAMPLE_PERIOD more samples have occurred
def print_progress_bar_at i
    if (i%PROGRESSOR_SAMPLE_PERIOD == 0)
      print  '.'
      $stdout.flush
    end
end

##
# with user-friendly terminal output,
# poll  NUMBER_OF_SAMPLES times
# count the number of polls inside the unit circle
# derive PI from the total number of polls inside and outside the unit circle
# return the approximation
def approximate_pi
  puts "each dot is #{PROGRESSOR_SAMPLE_PERIOD} picks out of #{NUMBER_OF_SAMPLES} total samples"

  running_total_of_circle_hits = 0

  NUMBER_OF_SAMPLES.times do |i|
    running_total_of_circle_hits += 1 if random_coordinate_inside_unit_circle

    print_progress_bar_at i
  end

  puts '' # ends the progress bar

  (4.0 * running_total_of_circle_hits) / NUMBER_OF_SAMPLES
end



#############  START HERE

puts "With #{NUMBER_OF_SAMPLES} samples, the approximate value of pi is #{approximate_pi}"
