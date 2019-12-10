# algorithm: 
# - reverses [0 1 2 3 4 5 6 7 8 9]
# - print array to stdout

# restrictions:
# - in any language (this is the python version)
# - do not use "reverse" library calls

# written for:
#  speed of implementation (in the interview)
#  speed of execution (traverse half array)

# analysis:
# - assumes len(array) is fast!
# - in the odd-numbered array case, the int division operation gives the previous element
#   ...so the "middle" element is left untouched (as desired).

# logic is easier to follow in the simple implementation
def simple():

    array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ]

    print array

    for x in range (0, len(array)/2):
        new_index = len(array) - 1 - x # for readability only
        move_me = array[x]

        array[x] = array[new_index]
        array[new_index] = move_me

    print array

#  XOR: Just as a crazy restriction: What if we have only the index as a variable??
#   three array writes, vs two for a more basic implementation (copy to a temp variable)
#   float to int conversion is spendy, as is div operation
#   triple XOR trick is not real pretty looking
def xor():

    array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ]

    print array

    # for extra credit: condense "array[?] = len(array) - 1 - x" e.g. as a lambda
    for x in range (0, len(array)/2):
        array[x]                  = array[x] ^ array[len(array) - 1 - x]
        array[len(array) - 1 - x] = array[x] ^ array[len(array) - 1 - x]
        array[x]                  = array[x] ^ array[len(array)-1-x]

    print array
    
def main():
    print "simple version:"
    simple()

    print "XOR version:"
    xor()
    
if __name__ == "__main__":
    main()
