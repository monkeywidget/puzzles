import math

# algorithm: 
# - reverses [0 1 2 3 4 5 6 7 8 9]
# - print array to stdout

# restrictions:
# - in any language
# - do not use "reverse" library calls

# written for:
#  speed of implementation (in the interview)
#  speed of execution (traverse half array)
#  novelty ! uses only "x" as a scoped/temp variable in the for loop  :)
#  I picked python because it can easily be read in an IM window, 
#    and requires less memorized API (vs Java)

# cons:
#  three array writes, vs two for a more basic implementation (copy to a temp variable)
#  float to int conversion is spendy, as is div operation
#  triple XOR trick is not real pretty looking
#  assumes len(array) is fast

# possible extra credit (and fun?):
#  could condense "len(array) - 1 - x"
#  could condense "array[?] = len(array) - 1 - x"
# 
# optimise instead for brevity
# make into a one-liner

def main():

    array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

    for x in array:
        print "INPUT: a[" + str(x) + "] = " + str(array[x])


    for x in range (0, int(math.ceil(len(array)/2))):
        # print "evaluating " + str(x) + ", " + str(len(array) - 1 - x)
        array[x] = array[x] ^ array[len(array) - 1 - x]
        array[len(array) - 1 - x] = array[x] ^ array[len(array) - 1 - x]
        array[x] = array[x] ^ array[len(array)-1-x]

    for x in array:
        print "OUTPUT: a[" + str(x) + "] = " + str(array[x])


if __name__ == "__main__":
    main()


