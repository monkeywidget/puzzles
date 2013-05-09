# 1. removes duplicates chars from a string, 
#   maintaining the order in the final string
#   of the first occurrence of the character
#
# input = 'anadsfasdfads'
# output = 'andsf'

# 2. removes duplicates chars from a string, 
#   maintaining the order in the final string
#   of the LAST occurrence of the character
#
# input = 'anadsfasdfads'
# output = 'nfads'



require 'set'

# passed a string
def eliminateDuplicatesWithoutPreservingOrder (sourceString)
  return Set.new(sourceString.split(//)).to_a.sort.join.to_s
end

# passed a string
def eliminateDuplicatesAndPreserveOrderForFirst (sourceString)

  first_hash = Hash.new

  # O(n)
  sourceString.split(//).each_with_index do |single_char,index|
    # add to hash
    if not first_hash.has_key?(single_char)
      # if not there yet, record the first index
      first_hash[single_char] = index
    end 
  end

  second_hash = Hash.new

  # O(n)
  first_hash.keys.each  do | this_key |
    # for all the keys, hash by value in a new hash

    # print "DEBUG: first hash: key=#{this_key} , value=#{first_hash[this_key]}\n"
    # first_hash[this_key] = first_hash['a'] = 0
    second_hash[first_hash[this_key]] = this_key
    # second_hash[0] = 'a'
  end
  
  output = ""

  # output the new hash by keys (the original initial index of the char)
  second_hash.keys.sort.each do | this_key |
    # print "DEBUG: second hash: key=#{this_key} , value=#{second_hash[this_key]}\n"
    output << second_hash[this_key]
  end

  return output

end





finalString = eliminateDuplicatesWithoutPreservingOrder("anadsfasdfads")
print "UNORDERED: \"#{finalString}\"\n"
finalString = eliminateDuplicatesAndPreserveOrderForFirst("anadsfasdfads")
print "ORDERED: \"#{finalString}\"\n"

