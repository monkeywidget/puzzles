# Luhn check
# http://en.wikipedia.org/wiki/Luhn_algorithm
#
# 4893
# 1. Process from right to left: 3 9 8 4
# 2. Double value of every 2nd digit, starting at offset 1: 3 18 8 8
# 3. Split into single digits: 3 1 8 8 8
# 4. Sum 28
# 5. Sum mods with 10 == 0 (pass)

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



def print_luhn (number)
  if luhn?(number) 
    puts "%d passed the luhn check" % number
  else
    puts "%d failed the luhn check" % number
  end  
end


test_numbers = [ "4893", "4895", "489" ]
# 4893 fail
# 4895 pass
# 489  pass

test_numbers.each do |number|
  print_luhn(number)
end

