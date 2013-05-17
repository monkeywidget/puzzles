# Build a number from a string one character at a time
# account for sign
# the number is an integer!
# "Fail fast" is ok (throws exception on a non number)

# "14"
# "-45"
# "+514"

# r = r * 10 + c

def number_builder( number_as_string )

    number_array = number_as_string.each_char.to_a

    pos_flag = true

    # handle the sign
    case number_array.first
    when '-'
        pos_flag = false
        number_array.shift
    when '+'
        number_array.shift
    end

    total = 0    

    number_array.each do |character|
        # don't validate the number        
        total = total*10 + character.to_i
    end
    
    ( total  = 0 - total ) if not pos_flag

    return total

end

# test code:

print "14 gives #{number_builder("14")}\n"
print "-45 gives #{number_builder("-45")}\n"
print "+514 gives #{number_builder("+514")}\n"

# "14"
# "-45"
# "+514"
