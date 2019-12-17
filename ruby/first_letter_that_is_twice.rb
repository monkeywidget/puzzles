# Problem statement:
# Given a string,
# print the first letter that appears which appears twice in the entire string
def first_twice_letter(source_string)
  seen_before = []

  source_string.downcase.split('').each do |letter|
    if seen_before.include?(letter)
      puts "First duplicate letter in >>#{source_string}<<: #{letter}"
      return
    else
      seen_before << letter
    end
  end

  puts "there were no letters appearing twice in >>#{source_string}<<"
end

# more ruby-like (regex) but a bit verbose for the sake of concise code in this exercise
# However note it technically does something slightly different from the previous!
def first_twice_letter_regex(source_string)
  match = /(.).*\1/.match(source_string)
  puts match.nil? ? "no matching letters in >>#{source_string}<<" : "First matching letter in >>#{source_string}<<: #{match[1]}"
end

# Problem statement:
# Given a string,
# find the first letter that appears which appears _exactly_ twice (not more) in the entire string
# Note we cannot use Regex because it's too greedy: /(.).*\1/.match('Mississippi') would return the match for 'i'
# Clarifying requirement: the "first letter" is the letter for which the second occurrence is earliest

class LetterLog
  attr_reader :letter
  attr_reader :incidences
  attr_reader :index_of_second_incidence

  def initialize(l)
    @letter = l
    @incidences = 1
    @index_of_second_incidence = -1
  end

  def increment(index)
    @incidences = @incidences + 1
    @index_of_second_incidence = index if happened_twice?
  end

  def happened_twice?
    @incidences == 2
  end
end

def incidence_hash_for(source_string)
  appearance_records = {}

  source_string.downcase.split('').each_with_index do |letter, index|
    if appearance_records.key?(letter)
      appearance_records[letter].increment(index)
    else
      appearance_records[letter] = LetterLog.new(letter)
    end
  end

  appearance_records
end

def first_exactly_twice_letter(source_string)
  appearance_records = incidence_hash_for source_string

  letters_happened_twice = appearance_records.values.keep_if(&:happened_twice?)

  if letters_happened_twice.empty?
    puts "No letters occurred twice in >>#{source_string}<<"
    return
  end

  first_twice = letters_happened_twice.sort_by!(&:index_of_second_incidence).first.letter

  puts "The first letter occurring twice in >>#{source_string}<< is #{first_twice}"
end

# Note: originally I implemented this without a class, and it looked much uglier,
# mostly because it required remembering what the fields were:
#
# appearance_records = {} # Hash, key = letter, value = [count, 2nd occurrence seen at index]
#
# source_string.downcase.split('').each_with_index do |letter, index|
#   if appearance_records.key?(letter)
#   if appearance_records[letter][0] == 1
#     appearance_records[letter][0] = 2
#     appearance_records[letter][1] = index
#   else
#     appearance_records[letter][0] = appearance_records[letter][0] + 1
#   end
# else
#   appearance_records[letter] = [1, -1]
# end


def test_with(source_string)
  first_twice_letter(source_string)
  first_twice_letter_regex(source_string)
  first_exactly_twice_letter(source_string)
  puts "\n"
end

test_with('sesquipedalian')
test_with('string')
test_with('foo')
test_with('balloon')
test_with('subdermatoglyphic')
test_with('Mississippi')
