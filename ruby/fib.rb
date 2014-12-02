=begin
Find the first prime fibonacci number larger than a given minimum.
Examples: given 10, the answer is 13

Note: do not count duplicated divisors. e.g. the number 12 we consider the sum of the prime divisors to be 2 + 3 = 5.

=end

require 'set'
# Fib bigger than 227,000
  # = 317811
# prime fib bigger than this:

# calculate the first 1000 fibonacci numbers
# for each one print it to the file
# make a note if it is prime

def prime_divisors(factor_me)
  squareroot = Math.sqrt(factor_me).ceil
      # print "\tDEBUG: limit is \"" + squareroot.to_s + "\"\n"

  factors= Set.new

  number_to_factor = factor_me

  for factor_candidate in 2..squareroot
    # if factor_candidate % number_to_factor == 0
    if number_to_factor.divmod(factor_candidate)[1] == 0
      #print "\tDEBUG: \"" + factor_candidate.to_s + 
      #  "\" is a factor of \"" + number_to_factor.to_s + "\"\n"

      factors.add(factor_candidate)
      number_to_factor = number_to_factor / factor_candidate
    end
  end

  if factors.size == 0
    print "\t\t" + factor_me.to_s + " is prime!\n"
  end

  return factors

end

# TEST CODE:
#factor_mes = [ 6, 44, 12, 18, 28, 227000 ]

#factor_mes.each do |factorizable|
#   print "the prime divisors for " + factorizable.to_s + 
#      " are [" + prime_divisors(factorizable).to_a.sort.to_s + "]\n"
# end

parent_fib = 1
grandparent_fib = 1

while parent_fib < 10000000
  new_fib = parent_fib + grandparent_fib
  # print "Fibonacci: " + new_fib.to_s + "\n"

  divisors = prime_divisors(new_fib)
  if divisors.size > 0           # don't print this for primes
  	print "the prime divisors for " + new_fib.to_s + 
          " are [" 
  		divisors.to_a.sort.each do |element_as_string|
			print " " + element_as_string.to_s
  		end
  	print " ]\n"
  end

  grandparent_fib = parent_fib
  parent_fib = new_fib
end

# 514229
# TEST QUESTION: [2, 3, 5, 61, 281]
# Sum of those is 352

print "TEST QUESTION: " + prime_divisors(514229+1).to_a.sort.to_s + "\n"

sum = 0
prime_divisors(514229+1).to_a.sort.each { |a| sum += a }

#
print "Sum of those is " + sum.to_s + "\n"
