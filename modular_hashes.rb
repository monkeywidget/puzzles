# Problem: Given an input string,
# - how many substrings are there...
# - which are contiguous
# - which have no duplicate letters?
#
# There's a n^2 way to do this, but I wanted to simulate a ElasticSearch-like system
# - where we can index the substrings
# - where we can run searches against them without consulting their data
#
# What I chose to do here was use a hash which uses prime multiplication and division to detect duplicates
# - modern hardware makes these operations much faster
# - the number of tests is small, because it's the length of the alphabet
# - the index enables a faster search for other use cases as well:
#     - e.g. which substrings have an 'a' and 'b'?

require 'singleton'

# optimized for case-less Latin letters as used in English (26 letters)
# - to expand to more, change:
#     - first_primes
#     - first_squares
#     - alpha_table
# - optimize: order the table by expected letter frequency in the domain
#
# optimized for looking for duplicates only
# - "2 or more" of the same element
# - to expand to more, change:
#     - _calculate_hash
#     - has_duplicates?
#     - first_squares
module ModularSubstring
  class Utils
    include Singleton
    # courtesy of https://prime-numbers.info/list/first-26-primes
    FIRST_PRIMES = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101]

    def first_primes
      FIRST_PRIMES
    end

    def first_squares
      @first_squares ||= first_primes.map { |a| a*a }
    end

    # maps (lower case) letters to numbers
    def alpha_table
      @alpha_table ||= _init_alpha_table
    end

    def _init_alpha_table
      @alpha_table = {}
      (('a'..'z').zip(1..26)).each { |x| @alpha_table[x[0]] = x[1] }

      @alpha_table
    end

    def letter_key(letter)
      first_primes[alpha_table[letter.downcase]]
    end

    # generate a list of all contiguous substrings
    # Not necessarily unique! we could add that
    def substrings(str)
      output = []
      (0...str.length).each do |i|
        (i...str.length).each do |j|
          output << str[i..j]
        end
      end
      output
    end
  end

  class Substring
    attr_reader :text

    def initialize(text)
      raise 'substring must be non-nil' if text.nil?
      @text = text
    end

    # the idea is this is a fingerprint for the substring
    # in a real Big Data or Map Reduce implementation this makes the substring indexable
    # possibly with the above application this could be a single table with 26 rows
    def hash
      @hash ||= _calculate_hash
    end

    # multiply all the letter keys together
    # use up to 2 of the same letter (because we want to detect duplicates)
    def _calculate_hash
      seen_letters = {}

      total = 1
      # we are going to abuse ruby's Bignum here
      # - this is potentially around 100 ^ (2x 26) = 10^104
      # - 100 because thw 26th prime is 101, so its square is around 10^4
      # - if you had 2 of every letter in the alphabet, this has is around 10^104
      # - 64 bit architectures represent up to (2^64)-1 which is under 10^20

      # Things we could do here, at the linear O(n) pass
      # - calculate whether this has a duplicate here, but we want to do this with math instead!
      @text.split('').each do |letter|
        if seen_letters.key?(letter)
          seen_letters[letter] += 1
        else
          seen_letters[letter] = 1
        end

        # only count up to 2, because we are looking for "duplicates"
        total *= ModularSubstring::Utils.instance.letter_key(letter) if seen_letters[letter] < 3
      end

      total
    end

    # detect any squares
    # this would be an indexing function
    # runs in constant time (the table of squares is 26 long)
    # in a "large" implementation this function might be centralized,
    #   (or at least not stored directly with the leaf data)
    def has_duplicates?
      count = 0

      ModularSubstring::Utils.instance.first_squares.each do |square|
        count += 1

        if hash % square == 0
          puts "\t\tfound a duplicate in #{@text} after #{count} tests"
          return true
        end
      end

      false
    end
  end

  class Hasher
    def initialize(master_text)
      @master_string = master_text
      puts "hello world! we'll examine the word '#{@master_string}'"
    end

    def simple_tests
      puts "\nSIMPLE TESTS"
      puts "the letter key for 'a' is #{ModularSubstring::Utils.instance.letter_key('a')}"
    end

    def hash_tests
      puts "\nHASH TESTS"
      substring = Substring.new('banana')
      puts "'#{substring.text}' has a hash of #{substring.hash}"


      if substring.has_duplicates?
        puts "'#{substring.text}' has duplicates"
      else
        puts "'#{substring.text}' has no duplicates"
      end
    end

    def substrings_tests
      puts "\nSUBSTRING TESTS"
      @substrings = ModularSubstring::Utils.instance.substrings(@master_string)
      # puts "all substrings of '#{@master_string}':"
      # @substrings.each do |substring|
      #   puts "\t#{substring}"
      # end
      puts "there are #{@substrings.size} continuous substrings"
      puts "\tof those, #{@substrings.uniq.size} are unique"

      # convert to instances of our struct
      @substrings = @substrings.uniq.map { |text| Substring.new(text) }
      @substrings = @substrings.reject { |substring| substring.has_duplicates? }
      puts "\tof those, #{@substrings.size} are without duplicates"
    end
  end
end

ms_hasher = ModularSubstring::Hasher.new('Possessions')

ms_hasher.simple_tests
ms_hasher.hash_tests
ms_hasher.substrings_tests

# Sample output:
#
# hello world! we'll examine the word 'Possessions'
#
# SIMPLE TESTS
# the letter key for 'a' is 3
#
# HASH TESTS
# 'banana' has a hash of 99405
#                 found a duplicate in banana after 2 tests
# 'banana' has duplicates
#
# SUBSTRING TESTS
# there are 66 continuous substrings
#         of those, 60 are unique
#                 found a duplicate in Poss after 20 tests
#                 found a duplicate in Posse after 20 tests
#                 found a duplicate in Posses after 20 tests
#                 found a duplicate in Possess after 20 tests
#                 found a duplicate in Possessi after 20 tests
#                 found a duplicate in Possessio after 16 tests
#                 found a duplicate in Possession after 16 tests
#                 found a duplicate in Possessions after 16 tests
#                 found a duplicate in oss after 20 tests
#                 found a duplicate in osse after 20 tests
#                 found a duplicate in osses after 20 tests
#                 found a duplicate in ossess after 20 tests
#                 found a duplicate in ossessi after 20 tests
#                 found a duplicate in ossessio after 16 tests
#                 found a duplicate in ossession after 16 tests
#                 found a duplicate in ossessions after 16 tests
#                 found a duplicate in ss after 20 tests
#                 found a duplicate in sse after 20 tests
#                 found a duplicate in sses after 20 tests
#                 found a duplicate in ssess after 20 tests
#                 found a duplicate in ssessi after 20 tests
#                 found a duplicate in ssessio after 20 tests
#                 found a duplicate in ssession after 20 tests
#                 found a duplicate in ssessions after 20 tests
#                 found a duplicate in ses after 20 tests
#                 found a duplicate in sess after 20 tests
#                 found a duplicate in sessi after 20 tests
#                 found a duplicate in sessio after 20 tests
#                 found a duplicate in session after 20 tests
#                 found a duplicate in sessions after 20 tests
#                 found a duplicate in ess after 20 tests
#                 found a duplicate in essi after 20 tests
#                 found a duplicate in essio after 20 tests
#                 found a duplicate in ession after 20 tests
#                 found a duplicate in essions after 20 tests
#                 found a duplicate in ssi after 20 tests
#                 found a duplicate in ssio after 20 tests
#                 found a duplicate in ssion after 20 tests
#                 found a duplicate in ssions after 20 tests
#                 found a duplicate in sions after 20 tests
#         of those, 20 are without duplicates
