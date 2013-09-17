# Luhn check
# http://en.wikipedia.org/wiki/Luhn_algorithm
#
# 4893
# 1. Process from right to left: 3 9 8 4
# 2. Double value of every 2nd digit, starting at offset 1: 3 18 8 8
# 3. Split into single digits: 3 1 8 8 8
# 4. Sum 28
# 5. Sum mods with 10 == 0 (pass)


# 3. Split into single digits: 3 1 8 8 8
def value_of_summed_digits_of_this_less_than_100_number( number )

  raise ArgumentError "number must be two digits" unless number < 100

  sum = 0

  if number >= 10
    sum = number / 10 
  end
  
  sum += number % 10

  sum
end

# to prevent using exponents - extend array size to expected size of params
@powersof10 = [1, 10, 100, 1000, 10000, 100000];

def extract_nth_digit_from(n, number)
  return (number / @powersof10[n]) % 10
end


# optimized from below implementation which used strings
def luhn? (number)

  max_power = number.to_s.length - 1

  sum = 0

  # 1. Process from right to left: 3 9 8 4
  (0 .. max_power).each do |current_power|

    this_digit = extract_nth_digit_from(current_power, number)

    # 4. Sum digits

    if current_power % 2 != 0
      # 2. Double value of every 2nd digit, starting at offset 1: 3 18 8 8
      sum += value_of_summed_digits_of_this_less_than_100_number(this_digit *= 2)
    else
      sum += value_of_summed_digits_of_this_less_than_100_number(this_digit)
    end

  end


  # 5. Sum mods with 10 == 0 (pass)

  sum % 10 == 0
  
end



def print_luhn (number)
  if luhn?(number) 
    puts "\t\t%d passed the luhn check" % number
  else
    puts "\t\t%d failed the luhn check" % number
  end  
end


test_numbers = [ 4893, 4895, 489 ]
# 4893 fail
# 4895 pass
# 489  pass

test_numbers.each do |number|
  print_luhn(number)
end



=begin
# first pass: storing as string
# TODO: use only integers, condense both loops into one

def luhn? (number)

  # puts "DEBUG: luhn test on %d" % number

  numbers = number.split('').reverse

  # 1. Process from right to left: 3 9 8 4
  numbers.each_with_index do | number, index |

    # 2. Double value of every 2nd digit, starting at offset 1: 3 18 8 8

    if index % 2 != 0 
      # puts "\tDEBUG: before doubling on index %d is %d" % [index, numbers[index]]

      doubled_value = numbers[index].to_i * 2
      numbers[index] = doubled_value.to_s

      #puts "\tDEBUG: after doubling on index %d is %d" % [index, numbers[index]]
    end
  end

  sum = 0

  numbers.each do |number|
  # 4. Sum 28

    # 3. Split into single digits: 3 1 8 8 8
    if number.to_i > 10
      sum += number.to_i % 10
      sum += number.to_i / 10
    else
      sum += number.to_i
    end
  end

  # 5. Sum mods with 10 == 0 (pass)

  sum % 10 == 0
  
end
=end
