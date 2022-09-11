require 'singleton'

# Question: You are in a cookie factory.
# the factory makes 3 kinds of cookies.
# the boxes hold 6 cookies each.
# How many different boxes can you make?
# What are the contents of each?

if ARGV.size != 2
  puts "\nUSAGE: cookie_counter.rb NUMBER_FLAVORS BOX_SIZE"
  puts "\n\t EXAMPLE: % ruby cookie_counter.rb 3 6\n\n"
  exit 1
end

types_of_cookies = ARGV[0].to_i
box_size = ARGV[1].to_i

module Cookies
  class CookieBox
    attr_accessor :cookies

    def initialize
      # flavor default count of 0
      @cookies = Hash[Cookies::CookieUtils.instance.
                       all_flavors.collect { |item| [item, 0] } ]
    end

    # a custom clone imeplementation
    def self.copy_from(box)
      new_box = CookieBox.new

      new_box.cookies = box.cookies.dup
      new_box
    end

    def self.empty_box
      @@null_box ||= CookieBox.new
    end

    # @return String like "A=2,B=0,C=0"
    def key
      return @key if defined?(@key)

      new_key = []

      Cookies::CookieUtils.instance.
                       all_flavors.sort.each do |flavor|
        quantity = @cookies[flavor] || 0 # flavor default count of 0
        new_key << "#{flavor}=#{quantity}"
      end

      @key = new_key.join(',')
    end

    def add(flavor, quantity)
      @cookies[flavor] = @cookies[flavor] + quantity
    end

    # this is where we could extend to a new class
    # where we only have a given inventory of each cookie
    # @return Boolean true : we have an infinite number of every cookie
    def valid?
      true
    end

    # Note: does not render a \n
    def render_cookies
     @cookies.keys.sort.each do |flavor|
       count = @cookies[flavor]

       Cookies::CookieUtils.instance.
        render_cookies(flavor, count)
     end
    end
  end

  class CookieUtils
    include Singleton

    ANSI_COLORS = [ { name: 'red', ansi: 31 },
                    { name: 'green', ansi: 32 },
                    { name: 'yellow', ansi: 33 },
                    { name: 'blue', ansi: 34 },
                    { name: 'magenta', ansi: 35 },
                    { name: 'cyan', ansi: 36 } ]

    attr_reader :all_flavors
    attr_reader :flavor_color_map

    def initialize_flavors(number_cookie_flavors)
      @all_flavors = ('A'..'Z').to_a.slice(0..(number_cookie_flavors-1))
      @flavor_color_map = {}

      @all_flavors.each_with_index do |flavor_name, index|
        color_key = index % ANSI_COLORS.size
        @flavor_color_map[flavor_name] = ANSI_COLORS[color_key][:ansi]
      end
    end

    # renders a single flavor repeat_count times
    def render_cookies(flavor, repeat_count)
      repeat_count.times do |_|
        emit_ansi_color(flavor, @flavor_color_map[flavor])
      end
      $stdout.flush
    end

    def emit_ansi_color(text, color_code)
      $stdout.print "\e[#{color_code}m#{text}\e[0m"
    end
  end
end

# TODO: Method 1: recursive/iterative brute force
# start with a set of all flavors
# LOOP:
# flavor A: For count BOX_SIZE down to 0
#   prepend count of flavor A for all of:
#      recurse with all except flavor A, for the remaining cookie spaces
# remove flavor A from the set and iterate again
# END LOOP
module RecursiveCookies
  class RecursiveCookieComboCounter
    def initialize(number_cookie_flavors, box_size)
    end

    def render_combos
    end
  end
end

# start = Time.now
# RecursiveCookies::RecursiveCookieComboCounter.
#   new(types_of_cookies, box_size).render_combos
# stop = Time.now
# puts "The recursive solution took #{stop - start} seconds"

# Method 2: Dynamic brute force
# I wanted this to be faster than a recursive implementation,
# so I used a simple Dynamic Programming approach,
# caching smaller results to build up to the problem being asked
module DynamicCookies
  class DynamicCookieComboCounter
    def initialize(number_cookie_flavors, box_size)
      @box_size = box_size

      puts "\n\nHow many combinations of #{number_cookie_flavors} cookies " \
           "can fit in a #{@box_size} cookie box?"

      @utils = Cookies::CookieUtils.instance
      @utils.initialize_flavors(number_cookie_flavors)

      @box_combinations = Array.new(@box_size + 1) { Hash.new }
        # @box_combinations[N] has a Hash - all the combinations of size N
        # the key for each is like "A=2,B=0,C=0"
      @box_combinations[0] = { null_box.key => null_box }
    end

    def boxes_of_size(size)
      @box_combinations[size]
    end

    def null_box
      Cookies::CookieBox.empty_box
    end

    # assumes smaller box sizes have been rendered
    # @return Array of String - all the boxes of a given size
    def cache_all_boxes_sized(size)
      raise "cache_all_boxes_sized called with (#{size})" if size < 1
      smaller_boxes = boxes_of_size(size - 1)

      # for each flavor
      @utils.all_flavors.each do |flavor|
        # build a new box from each smaller box:
        smaller_boxes.each_value do |box|
          new_box = Cookies::CookieBox.copy_from(box) # clone and build from here
          new_box.add(flavor, 1)

          next unless new_box.valid? # if it makes an invalid, don't make it
          next unless boxes_of_size(size)[new_box.key].nil? # ignore if already cached

          boxes_of_size(size)[new_box.key] = new_box
        end
      end
    end

    # builds a cache of all combinations, smallest to largest
    def render_combos
      # build the cache of all combos
      (1..@box_size).each { |size| cache_all_boxes_sized(size) }

      puts "\nThere are #{@box_combinations[@box_size].size} combinations:\n\n"

      # print the combos
      @box_combinations[@box_size].values.each_with_index do |box,index|
        box.render_cookies
        puts ""
      end
    end
  end
end

start = Time.now
DynamicCookies::DynamicCookieComboCounter.new(types_of_cookies, box_size).render_combos
stop = Time.now
puts "The dynamic solution took #{stop - start} seconds"

# development Notes
# examples use 3 flavors
# approach 1: start from a 1 element String and grow it by 1 char each time
#
# with 1 element: we make each one - [A, B, C]
# with 2 elements:
# - we prepend to the previous: A[A, B, C], B[A, B, C], C[A, B, C]
# - and then sort? AA AB AC,
#                  BA, BB, BC has BA, which is the same as AB
# so we would sort N^m times? that seems bad!
# the prepend/append is what is messing this up, because we have to keep it sorted.
#
# approach 2: count the number of each flavor:
# still a hash but we concat the quantities to make a String key
# with 1 element: we make each one - [A, B, C] is A1B0C0 A0B1C0 A0B0C1
# with 2 elements:
# - we add to the previous:
#   A[A1B0C0 A0B1C0 A0B0C1] = A2B0C0 A1B1C0 A1B0C1
#   B[A1B0C0 A0B1C0 A0B0C1] = A1B1C0 A0B2C0 A0B1C1
#   C[A1B0C0 A0B1C0 A0B0C1] = A1B0C1 A0B1C1 A0B0C2
# when making the combination
# - we can see which ones are already stored
# - if there are other restrictions (max cookies for a flavor inventory)
#    we can see which ones are illegal
#
# I had tried to stick with simple types (Hash) but there were too many cases
# where I was converting between the key and the Hash contents.
# it's better to have it more OOP and make a CookieBox class
#
# I had issues where I didn't want to make a Module level variable,
# and I needed to share a sort of global variable for the flavors list
# and color maps, so I'm making a Singleton "Utils" class.
# I may as well put the ANSI methods in there too

# Method 3: Efficiency
# The efficient solution to this relates to: combinations n choose k,
# alternately "index Pascal's Triangle"
module MathCookies
  class CombinationsCalculator
    def initialize(number_cookie_flavors, box_size)
      # TODO: TBI
    end

    def factorial(n)
      (1..n.to_i).reduce(1, :*)
    end

    def combinations(n, k)
      n = n.to_i
      k = k.to_i
      factorial(n) / (factorial(k) * factorial(n-k))
    end
  end
end

# start = Time.now
# MathCookies::CombinationsCalculator.new(types_of_cookies, box_size).render_combos
# stop = Time.now
# puts "The math solution took #{stop - start} seconds"



# Brute force: every combination:

# A, B, C

# AAAAAA

# AAAAAB
# AAAAAC

# AAAABB
# AAAABC
# AAAACC

# 2 elements with 2 types: there are 3 combinations
# BB
# BC
# CC

# 3 elements with 2 types = previous x2 - duplicates = (3 x 2) - duplicates = 6 - 2 = 4
# (BB BC CC)(B, C) = BBB BBC BCC + BBC BCC CCC = BBB BBC BCC CCC

# 4 elements with 2 types = previous x2 - duplicates = 4x2 - 3 = 8 - 3 = 5
# (BBB BBC BCC CCC)(B,C) = BBBB BBBC BBCC BCCC + BBBC BBCC BCCC CCCC =  
# BBBB BBBC BBCC BCCC CCCC 

# 5 elements with 2 types = previous x2 - duplicates = 5x2 - 4 = 10 - 4 = 6
# (BBBB BBBC BBCC BCCC CCCC)(B,C) = 
# BBBBB BBBBC BBBCC BBCCC BCCCC + BBBBC BBBCC BBCCC BCCCC CCCCC  =
# BBBBB BBBBC BBBCC BBCCC BCCCC CCCCC

# 6 elements with 2 types = (6 x 2) - 5 = 12 -5 = 7 

# now we go backwards:

# 6 elements with 2 types = 0 of element A = 7
# 5 elements with 2 types = 1 of element A = 6
# 4 elements with 2 types = 2 of element A = 5
# 3 elements with 2 types = 3 of element A = 4
# 2 elements with 2 types = 4 of element A = 3
# 1 element with 2 types =  5 of element A = 2
# 0 elements with 2 types =  6 of element A = 1

# so the answer is 7 + 6 + 5 + 4 + 3 + 2 + 1 = summation of 7
# we have a formula for that: n(n+1)/2 where n = 7, 7x8/2 = 28
# but how do we get this for n total things with m categories?
# that is 
# f(n,m) = ?

