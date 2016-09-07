__author__ = 'monkeywidget'
class QuickSortDemo :

    my_list = []

    def __init__(self, newlist):
        self.my_list = newlist
        print "UNSORTED LIST (N=%s): %s" % (len(self.my_list),
                                            self.my_list )
    def printable_my_array(self):
        return "%s" % self.my_list

    # the main sort called from outside
    def sort(self):
        self.quicksort(0, len(self.my_list)-1)
        return

    # in-place partition algorithm:
    # left is the index of the leftmost element of the array
    # right is the index of the rightmost element of the array (inclusive)
    # number of elements in subarray = right-left+1
    # RETURNS the index of where the
    def partition (self, left_edge_index, right_edge_index, pivotIndex) :
        print "PARTITION: %s sorts %s" % (self.my_list[pivotIndex],self.my_list[left_edge_index:right_edge_index])
        print "\t\tsubstring (%s, %s, %s)" % (left_edge_index,right_edge_index,self.my_list)

        pivotValue = self.my_list[pivotIndex]

        # move the pivot safely to the end for now
        self.my_list[pivotIndex], self.my_list[right_edge_index] = \
                self.my_list[right_edge_index], self.my_list[pivotIndex]

        # our placeholders
        left_index = left_edge_index
        right_index = right_edge_index

        while (left_index < right_index) :
            # move the ends of the range we are looking at closer together

            # while the values below left_index are less than pivot, move left_index up
            while self.my_list[left_index] <= pivotValue and left_index <= right_edge_index:
                left_index += 1

            # while the values above right_index are greater than pivot, move right_index down
            while self.my_list[right_index] > pivotValue and right_index >= left_edge_index:
                right_index -= 1

            # should we swap these two?
            if left_index < right_index:
                self.my_list[left_index], self.my_list[right_index] =\
                    self.my_list[right_index], self.my_list[left_index]

        middle_index = right_index                                          # renaming for ease of reading the code

        self.my_list[middle_index], self.my_list[right_edge_index] =\
            self.my_list[right_edge_index], self.my_list[middle_index]      # retrieve the pivot from the end

        print "%s is now sorted around %s" % (self.my_list, pivotValue)

        return middle_index                                                 # return where the pivot ended up

    def quicksort(self, left_index, right_index):
        if left_index >= right_index:
            return

        print "sorting list %s" % self.my_list[left_index:right_index]

        pivotIndex = self.get_pivot_index_for(left_index, right_index)

        # Get lists of bigger and smaller items and final position of pivot
        pivotNewIndex = self.partition(left_index, right_index, pivotIndex)

        print "sorted around %s : %s" % (self.my_list[pivotNewIndex], \
                                            self.my_list[left_index:right_index] )

    # Recursively sort elements smaller than the pivot
        self.quicksort(left_index, pivotNewIndex -  1)

        # Recursively sort elements at least as big as the pivot
        self.quicksort(pivotNewIndex + 1, right_index)

    # TODO: get the index of the median of the first, last, and middle elements
    #       to avoid the "already sorted" worst case
    def get_pivot_index_for (self, left_index, right_index):
        print "DEBUG: pivot for list %s is %s" % (self.my_list[left_index:right_index], self.my_list[left_index])
        return left_index
        # pivot_list = [list[0], list[-1], list[ len(list)/2]]
        # pivot_list.sort()



if __name__ == "__main__":

    list = [ 12, 43, 5, 26, 18, 23, 64, 2, 7 ]

    qs = QuickSortDemo(list)

    qs.sort()

    print "SORTED LIST: %s" % qs.printable_my_array()

