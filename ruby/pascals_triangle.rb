#!/usr/bin/env ruby

class PascalsTriangle
  def factorial(n)
    raise "cannot make a factorial of #{n}" if n < 0
    (1..n.to_i).reduce(1, :*)
  end

  # optimizes n! / r! = n * (n-1) * (n-2) * ... * (r-1)
  def factorial_without(n, r)
    raise "#{r} is greater than #{n}" if r > n
    return n if r == n

    ((r+1)..n).reduce(1, :*)
  end

  # The formula is n! / (r! * (n-r)!)
  def combinations(n, r)
    # optimize!
    return 1 if n == r || r == 0
    return n if r == 1

    factorial_without(n, r) / factorial(n-r)
  end
end

unless ARGV.size == 2
  puts "USAGE: pascals_triangle row element"
  exit 1
end

row, coefficient = ARGV

puts PascalsTriangle.new.combinations(row.to_i, coefficient.to_i)

############# Tests
#
# triangle = PascalsTriangle.new
#
# puts "testing factorial: "
# (1..6).each { |i| puts "#{i}! = #{triangle.factorial(i)}" }
#
# puts "should be 1: #{triangle.combinations(5,0)}"
# puts "should be 5: #{triangle.combinations(5,1)}"
# puts "should be 10: #{triangle.combinations(5,2)}"
# puts "should be 10: #{triangle.combinations(5,3)}"
# puts "should be 5: #{triangle.combinations(5,4)}"
# puts "should be 1: #{triangle.combinations(5,5)}"
