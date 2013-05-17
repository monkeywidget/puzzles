# Build a number from a string one character at a time
# account for sign and a decimal point
# the number may be an integer or may be a float!
# "Fail fast" is ok (throws exception on a non number)

# "14"
# "-45"
# "+514"

# "15.5" <=> 155 * 10 ^ (-1)
# "


# r = r * 10 + c



def number_builder( number_as_string )

    number_array = number_as_string.each_char.to_a

    pos_flag = true
    had_sign = false

    # handle the sign
    case number_array.first
    when '-'
        pos_flag = false
        had_sign = true
        number_array.shift
    when '+'
        had_sign = true
        number_array.shift
    end

    total = 0    
    decimal_position = -1

    number_array.each_with_index do |character,index|
    
        # record this position if decimal
        if character.eql?('.')
            decimal_position = index
        else
            # don't validate the number        
            total = total*10 + character.to_i
        end
    end
    
    ( total  = 0 - total ) if not pos_flag

    # account for decimal point placement
    
    if (decimal_position != -1)
        # Example:  15.5
        #           0123   (length 4, decimal_position = 2)

        # Example:  19.26
        #           01234   (length 5, decimal_position = 2)

        # Example:  -23.26
        #           012345   (length 6, decimal_position = 3)


        power = number_array.length - decimal_position -1

        total = total * 10**(0-power)

    end

    return total.to_f

end

# test code:


print "14 gives #{number_builder("14")}\n"
print "-45 gives #{number_builder("-45")}\n"
print "+514 gives #{number_builder("+514")}\n"
print "15.5 gives #{number_builder("15.5")}\n"
print "19.26 gives #{number_builder("19.26")}\n"
print "-23.26 gives #{number_builder("-23.26")}\n"

=begin
OUTPUT

14 gives 14.0
-45 gives -45.0
+514 gives 514.0
DEBUG: power 61 :  1, 155 
DEBUG: total 63 :  31/2 
15.5 gives 15.5
DEBUG: power 61 :  2, 1926 
DEBUG: total 63 :  963/50 
19.26 gives 19.26
DEBUG: power 61 :  2, -2326 
DEBUG: total 63 :  -1163/50 
-23.26 gives -23.26

=end

