# Q1. remove dupe chars from a string,
#   maintaining the order in the final string
#   of the first occurrence of the character
#
# input = 'anadsfasdfads'
# output = 'andsf'

# Q2. remove dupe chars from a string,
#   maintaining the order in the final string
#   of the LAST occurrence of the character
#
# input = 'anadsfasdfads'
# output = 'nfads'

require 'set'

def without_dupes_unordered(sourceString)
  Set.new(sourceString.split(//)).to_a.sort.join.to_s
end

# Notes:
# - each of these operations is O(n)
# - this is similar but not exactly how ruby's uniq works
# - has a invert and sort at the end
def without_dupes_ordered(sourceString)
  first_hash = {}

  sourceString.split(//).each_with_index do |single_char, index|
    first_hash[single_char] = index unless first_hash.key?(single_char)
  end

  first_hash = first_hash.invert
  first_hash.keys.sort.map { |key| first_hash[key] }.join
end

# abstracts the Hash into a Set
def without_dupes_ordered_with_set(sourceString)
  output = []
  occurences = Set.new

  sourceString.split(//).each do |single_char|
    unless occurences.include?(single_char)
      output << single_char
      occurences.add(single_char)
    end
  end

  output.join
end

def without_dupes_last_ordered(sourceString)
  without_dupes_ordered(sourceString.reverse).reverse
end

# More explicitly:
# def without_dupes_last_ordered(sourceString)
#   last_occurrences = {}
#   sourceString.split(//).each_with_index { |char,index| last_occurrences[char] = index }
#   last_occurrences = last_occurrences.invert
#   last_occurrences.keys.sort.reverse.map { |key| last_occurrences[key] }.reverse.join
# end

def test_functions(test_string)
  puts "#{test_string}:"
  puts "\tUNORDERED: #{without_dupes_unordered(test_string)}"

  puts "\tORDERED BY FIRST: #{without_dupes_ordered(test_string)}"
  puts "\t   implented with Set: #{without_dupes_ordered_with_set(test_string)}"

  puts "\t   ruby uniq: #{test_string.split('').uniq.join}"

  puts "\tORDERED BY LAST: #{without_dupes_last_ordered(test_string)}"
end

test_functions 'anadsfasdfads'
test_functions 'floccinaucinihilipilification'
