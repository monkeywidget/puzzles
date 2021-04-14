#!/usr/bin/env ruby

# https://en.wikipedia.org/wiki/Square_root
# https://en.wikipedia.org/wiki/Methods_of_computing_square_roots
# This is based on the Babylonian Method
class BabylonianSquareRoot
  # http://www.tofla.iconbar.com/tofla/arm/arm02/index.htm
  # https://en.wikipedia.org/wiki/Division_algorithm
  # TODO: implement this in simpler operations
  def quotient(dividend, divisor)
    dividend / divisor
  end

  def half_of(number)
    quotient(number, 2)
  end

  def split_difference(dividend, divisor)
    half_of(divisor + quotient(dividend, divisor))
  end

  # Inspired by:
  # https://www.educba.com/square-root-in-java/
  def square_root(value)
    num = half_of(value)
    half = split_difference(value, num)

    while (num - half) != 0 do
      num = half
      half = split_difference(value, num)
    end

    half
  end
end

# https://en.wikipedia.org/wiki/Methods_of_computing_square_roots
class BinarySquareRoot
    def square_root(value)
#    int32_t isqrt(int32_t num) {
#        assert(("sqrt input should be non-negative", num > 0));
#        int32_t res = 0;
#        int32_t bit = 1 << 30; // The second-to-top bit is set.
#                               // Same as ((unsigned) INT32_MAX + 1) / 2.
#
#        // "bit" starts at the highest power of four <= the argument.
#        while (bit > num)
#            bit >>= 2;
#
#        while (bit != 0) {
#            if (num >= res + bit) {
#                num -= res + bit;
#                res = (res >> 1) + bit;
#            } else
#                res >>= 1;
#            bit >>= 2;
#        }
#        return res;
#    }
    end
end
  
# https://www.tutorialspoint.com/compile_assembly_online.php

unless ARGV.size == 1
    puts 'USAGE: squareroot OPERAND'
    exit 1
end

operand = ARGV[0].to_f

babylon = BabylonianSquareRoot.new
puts "Babylonian Square root of #{operand} = #{babylon.square_root(operand)}"

binary = BinarySquareRoot.new
puts "Binary Square root of #{operand} = #{binary.square_root(operand)}"

