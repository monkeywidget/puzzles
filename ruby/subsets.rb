=begin
  Level 3

  ----------------------------------------

  Congratulations.  You have reached the final level.

  For the final task, you must find all subsets of an array
  where the largest number is the sum of the remaining numbers.
  For example, for an input of:

  (1, 2, 3, 4, 6)

  the subsets would be

  1 + 2 = 3
  1 + 3 = 4
  2 + 4 = 6
  1 + 2 + 3 = 6

  Here is the list of numbers you should run your code on.
  The password is the number of subsets.  In the above case the
  answer would be 4.
=end

require 'set'

# returns an array of Sets
# each is a subset of the given array
# creating all subsets takes O(N 2^N)
def allSubsets ( bigListOfElements )

  print "DEBUG: big list: " + bigListOfElements.to_a.sort.to_s + "\n"

  master_list_of_elements = bigListOfElements.to_a.sort

  # subsets = Set.new
  number_of_matching_subsets = 0

  # given the list, with size N
  # we know there are 2^N subsets
  # So: if we were to count to 2^N in binary
  # each binary number would be a map of which elements will be in each subset

  # so to simulate this, 
  # for all the numbers from 0 to 2^N -1
    # set a counter to the number and a binary_number_index to 0
    # while the counter is nonzero
      # the binary_number_index is the index of the master set
      # if the counter % 2 == 0 then include the element at binary_number_index
      # increment the binary counter index
      # set the counter to counter / 2

  subset_total = (2**master_list_of_elements.size) - 1
  print "DEBUG: there will be " + (subset_total+1).to_s + " subsets\n"

  # for all the numbers from 0 to 2^N -1
  for subset_number in 0..subset_total
    # print "DEBUG: subset number " + subset_number.to_s + "\n"
    # set a counter to the number and a binary_number_index to 0
    counter = subset_number
    element_index = 0   # the binary_number_index is the index of the master set

    new_subset = Set.new

    while counter > 0 do
    # while the counter is nonzero

      # if the counter % 2 == 0 then include the element at binary_number_index
      if (counter.divmod(2)[1] == 1) then
        new_subset.add(master_list_of_elements[element_index])
      end

      # increment the binary counter index
      element_index += 1

      # set the counter to counter / 2
      counter = counter / 2
    end

    # print "\tSUBSET: " + new_subset.to_a.sort.to_s + "\n"
    # subsets.add(new_subset)
    # You can only really keep all the subsets for small values of N

    if setValid?(new_subset)
      print "\t" + new_subset.sort.to_a.to_s + " has this property\n"
      number_of_matching_subsets += 1
    end
    
  end 

  print "\n\nThere were " + number_of_matching_subsets.to_s + " such subsets\n\n"
  # return subsets
end


  # SECOND UNUSED, MORE INTUITIVE METHOD: similar to a knapsack algorithm:
  # build up sets from small sets.  
  # The problem is all the searching through Sets though... 
  #   ...and also accounting for all the data structures
  #
  # until the size of the sets is the size of the master set
    # for each of the subsets of this size
      # run through the elements of the master set that are not already in this subset
        # make a new subset that is this subset with the new element added


# test for the property requested above:
def setValid? ( setOfElements )
  if setOfElements.size < 2
    return false
  end

  # print "DEBUG: subset " + setOfElements.to_a.sort.to_s + "\n"

  biggestElement = setOfElements.to_a.sort[-1]
  remainingElements = setOfElements.to_a.sort[0..-2]

  #print "DEBUG: remaining subset " + remainingElements.to_s + "\n"

  sum = 0
  remainingElements.each do |a|
    sum += a
  end

  return sum == biggestElement
end

# USED IF THERE ARE A SMALL NUMBER OF SUBSETS
# ...because you'd have to keep all the subsets in memory!
#
# def printValidatedSubsets ( arrayOfElements )
#  allSubsets(arrayOfElements).each do |subset|
#    if setValid?(subset)
#      print "\t" + subset.sort.to_a.to_s + " has this property\n"
#    end
#  end
#end

# for testing:
#numbers = Set.new [1, 2, 3, 4, 6]

# for the puzzle:
numbers = Set.new [3, 4, 9, 14, 15, 
                   19, 28, 37, 47, 50, 
                   54, 56, 59, 61, 70, 
                   73, 78, 81, 92, 95, 
                   97, 99]
# DEBUG: there will be 4194304 subsets
# There were 179 such subsets

# printValidatedSubsets(numbers)

allSubsets(numbers)


=begin
DEBUG: there will be 4194304 subsets
	[4, 15, 19] has this property
	[4, 9, 15, 28] has this property
	[9, 19, 28] has this property
	[4, 14, 19, 37] has this property
	[3, 15, 19, 37] has this property
	[9, 28, 37] has this property
	[4, 9, 15, 19, 47] has this property
	[4, 15, 28, 47] has this property
	[19, 28, 47] has this property
	[3, 4, 9, 15, 19, 50] has this property
	[3, 4, 15, 28, 50] has this property
	[3, 19, 28, 50] has this property
	[4, 9, 37, 50] has this property
	[3, 47, 50] has this property
	[3, 9, 14, 28, 54] has this property
	[3, 4, 19, 28, 54] has this property
	[3, 14, 37, 54] has this property
	[3, 4, 47, 54] has this property
	[4, 50, 54] has this property
	[4, 9, 15, 28, 56] has this property
	[9, 19, 28, 56] has this property
	[4, 15, 37, 56] has this property
	[19, 37, 56] has this property
	[9, 47, 56] has this property
	[3, 4, 9, 15, 28, 59] has this property
	[3, 9, 19, 28, 59] has this property
	[3, 4, 15, 37, 59] has this property
	[3, 19, 37, 59] has this property
	[3, 9, 47, 59] has this property
	[9, 50, 59] has this property
	[3, 56, 59] has this property
	[4, 9, 14, 15, 19, 61] has this property
	[4, 14, 15, 28, 61] has this property
	[14, 19, 28, 61] has this property
	[9, 15, 37, 61] has this property
	[14, 47, 61] has this property
	[3, 4, 54, 61] has this property
	[4, 9, 14, 15, 28, 70] has this property
	[9, 14, 19, 28, 70] has this property
	[4, 14, 15, 37, 70] has this property
	[14, 19, 37, 70] has this property
	[9, 14, 47, 70] has this property
	[4, 19, 47, 70] has this property
	[3, 4, 9, 54, 70] has this property
	[14, 56, 70] has this property
	[9, 61, 70] has this property
	[3, 4, 9, 14, 15, 28, 73] has this property
	[3, 9, 14, 19, 28, 73] has this property
	[3, 4, 14, 15, 37, 73] has this property
	[3, 14, 19, 37, 73] has this property
	[3, 9, 14, 47, 73] has this property
	[3, 4, 19, 47, 73] has this property
	[9, 14, 50, 73] has this property
	[4, 19, 50, 73] has this property
	[4, 15, 54, 73] has this property
	[19, 54, 73] has this property
	[3, 14, 56, 73] has this property
	[14, 59, 73] has this property
	[3, 9, 61, 73] has this property
	[3, 70, 73] has this property
	[3, 4, 9, 15, 19, 28, 78] has this property
	[3, 9, 14, 15, 37, 78] has this property
	[3, 4, 15, 19, 37, 78] has this property
	[4, 9, 28, 37, 78] has this property
	[3, 4, 9, 15, 47, 78] has this property
	[3, 9, 19, 47, 78] has this property
	[3, 28, 47, 78] has this property
	[4, 9, 15, 50, 78] has this property
	[9, 19, 50, 78] has this property
	[28, 50, 78] has this property
	[9, 15, 54, 78] has this property
	[3, 4, 15, 56, 78] has this property
	[3, 19, 56, 78] has this property
	[4, 15, 59, 78] has this property
	[19, 59, 78] has this property
	[3, 14, 61, 78] has this property
	[3, 4, 9, 28, 37, 81] has this property
	[15, 19, 47, 81] has this property
	[3, 4, 9, 15, 50, 81] has this property
	[3, 9, 19, 50, 81] has this property
	[3, 28, 50, 81] has this property
	[4, 9, 14, 54, 81] has this property
	[3, 9, 15, 54, 81] has this property
	[3, 4, 15, 59, 81] has this property
	[3, 19, 59, 81] has this property
	[3, 78, 81] has this property
	[3, 4, 9, 14, 15, 19, 28, 92] has this property
	[3, 4, 14, 15, 19, 37, 92] has this property
	[4, 9, 14, 28, 37, 92] has this property
	[3, 9, 15, 28, 37, 92] has this property
	[3, 4, 9, 14, 15, 47, 92] has this property
	[3, 9, 14, 19, 47, 92] has this property
	[3, 14, 28, 47, 92] has this property
	[4, 9, 14, 15, 50, 92] has this property
	[9, 14, 19, 50, 92] has this property
	[14, 28, 50, 92] has this property
	[9, 14, 15, 54, 92] has this property
	[4, 15, 19, 54, 92] has this property
	[3, 4, 14, 15, 56, 92] has this property
	[3, 14, 19, 56, 92] has this property
	[4, 14, 15, 59, 92] has this property
	[14, 19, 59, 92] has this property
	[3, 4, 9, 15, 61, 92] has this property
	[3, 9, 19, 61, 92] has this property
	[3, 28, 61, 92] has this property
	[3, 4, 15, 70, 92] has this property
	[3, 19, 70, 92] has this property
	[4, 15, 73, 92] has this property
	[19, 73, 92] has this property
	[14, 78, 92] has this property
	[3, 4, 9, 14, 28, 37, 95] has this property
	[14, 15, 19, 47, 95] has this property
	[3, 4, 9, 14, 15, 50, 95] has this property
	[3, 9, 14, 19, 50, 95] has this property
	[3, 14, 28, 50, 95] has this property
	[3, 9, 14, 15, 54, 95] has this property
	[3, 4, 15, 19, 54, 95] has this property
	[4, 9, 28, 54, 95] has this property
	[4, 37, 54, 95] has this property
	[3, 4, 14, 15, 59, 95] has this property
	[3, 14, 19, 59, 95] has this property
	[15, 19, 61, 95] has this property
	[3, 4, 15, 73, 95] has this property
	[3, 19, 73, 95] has this property
	[3, 14, 78, 95] has this property
	[14, 81, 95] has this property
	[3, 92, 95] has this property
	[3, 9, 14, 15, 19, 37, 97] has this property
	[3, 14, 15, 28, 37, 97] has this property
	[4, 9, 19, 28, 37, 97] has this property
	[3, 4, 9, 15, 19, 47, 97] has this property
	[3, 4, 15, 28, 47, 97] has this property
	[3, 19, 28, 47, 97] has this property
	[4, 9, 37, 47, 97] has this property
	[4, 9, 15, 19, 50, 97] has this property
	[4, 15, 28, 50, 97] has this property
	[19, 28, 50, 97] has this property
	[47, 50, 97] has this property
	[9, 15, 19, 54, 97] has this property
	[15, 28, 54, 97] has this property
	[3, 9, 14, 15, 56, 97] has this property
	[3, 4, 15, 19, 56, 97] has this property
	[4, 9, 28, 56, 97] has this property
	[4, 37, 56, 97] has this property
	[9, 14, 15, 59, 97] has this property
	[4, 15, 19, 59, 97] has this property
	[3, 4, 14, 15, 61, 97] has this property
	[3, 14, 19, 61, 97] has this property
	[4, 9, 14, 70, 97] has this property
	[3, 9, 15, 70, 97] has this property
	[9, 15, 73, 97] has this property
	[4, 15, 78, 97] has this property
	[19, 78, 97] has this property
	[3, 4, 9, 81, 97] has this property
	[15, 19, 28, 37, 99] has this property
	[4, 14, 15, 19, 47, 99] has this property
	[9, 15, 28, 47, 99] has this property
	[15, 37, 47, 99] has this property
	[3, 4, 9, 14, 19, 50, 99] has this property
	[3, 4, 14, 28, 50, 99] has this property
	[3, 9, 37, 50, 99] has this property
	[3, 4, 9, 14, 15, 54, 99] has this property
	[3, 9, 14, 19, 54, 99] has this property
	[3, 14, 28, 54, 99] has this property
	[9, 15, 19, 56, 99] has this property
	[15, 28, 56, 99] has this property
	[3, 4, 14, 19, 59, 99] has this property
	[3, 9, 28, 59, 99] has this property
	[3, 37, 59, 99] has this property
	[9, 14, 15, 61, 99] has this property
	[4, 15, 19, 61, 99] has this property
	[14, 15, 70, 99] has this property
	[3, 9, 14, 73, 99] has this property
	[3, 4, 19, 73, 99] has this property
	[3, 4, 14, 78, 99] has this property
	[4, 14, 81, 99] has this property
	[3, 15, 81, 99] has this property
	[3, 4, 92, 99] has this property
	[4, 95, 99] has this property


There were 179 such subsets
=end
