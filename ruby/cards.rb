# Make a deck of cards, pick out 4 random cards

puts 'in multiple lines, easier to read:'

suits = %w(♢ ♧ ♡ ♤)

# did this in order, just on principle!
# alternatives might be to group A with face cards,
#   or to have all values in a single array
ordinals = %w(A).push((2..10).to_a).push(%w(J Q K)).flatten

card_deck = suits.map { |suit| ordinals.map {|ordinal| "#{ordinal}#{suit}" } }.flatten

hand_of_four = card_deck.shuffle[0..3] # slice of the first 4 elements

# output to stdout
hand_of_four.each { |i| puts i }

############
puts 'in a single line!!!' # stunts!
# NOTE: we are creating the ordinals array suits.length times (not efficient)

%w(♢ ♧ ♡ ♤).map { |suit| %w(A).push((2..10).to_a).push(%w(J Q K)).flatten.map {|ordinal| "#{ordinal}#{suit}" } }.flatten.shuffle[0..3].each { |i| puts i }

puts 'in a single line!!!' # variant method calls: concat, sample vs shuffle/array

['A'].concat((2..10).to_a.map{ |i| i.to_s }).concat(%w(J Q K)).map { |number| %w(♢ ♧ ♡ ♤).map { |suit| "#{number}#{suit}" } }.flatten.sample(4).each { |i| puts i }
require 'benchmark'

############
puts 'parameterized / testable:'

# this would be a constant or an instance variable if object oriented
def suits
  %w(♢ ♧ ♡ ♤)
end

# this would be a constant or an instance variable if object oriented
def ordinals
  %w(A).push((2..10).to_a).push(%w(J Q K)).flatten
end

# this would be in "initialize" if object oriented
def make_deck
  suits.map { |suit| ordinals.map {|ordinal| "#{ordinal}#{suit}" } }.flatten
end

def print_deck(deck)
  puts "\tthe hand of #{deck.length} cards:"
  deck.each { |i| puts i }
end

def deal(num_cards)
  puts "\tshuffling and dealing #{num_cards} cards..."
  make_deck.shuffle[0..(num_cards-1)]
end

print_deck(deal(4))


#####
# I'm wondering which of the one-liners is faster...

def foo_one_line
  %w(♢ ♧ ♡ ♤).map { |suit| %w(A).push((2..10).to_a).push(%w(J Q K)).flatten.map {|ordinal| "#{ordinal}#{suit}" } }.flatten.shuffle[0..3]
end

def bar_one_line
  ['A'].concat((2..10).to_a.map{ |i| i.to_s }).concat(%w(J Q K)).map { |number| %w(♢ ♧ ♡ ♤).map { |suit| "#{number}#{suit}" } }.flatten.sample(4)
end

require 'benchmark'

foo_time = Benchmark.measure { 100.times { foo_one_line } }
puts "push and shuffle: #{foo_time.real}"

bar_time = Benchmark.measure { 100.times { bar_one_line } }
puts "concat and sample: #{bar_time.real}"
