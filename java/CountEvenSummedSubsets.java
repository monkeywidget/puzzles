/** 
 * Given an array of integers,
 * 
 * - write a thing that counts the number of subsets of size 2 that are adjacent, that when added their sum is even
 * - Note: there could be duplicated values
*/
public class CountEvenSummedSubsets {

    public int solution(int[] A) {

        int countOfPairs = 0;

        List evens = new ArrayList(<int>);        
        List odds = new ArrayList(<int>);        

        for ( int first_index = 0; first_index < A.length ; first_index++ ) {
            
            for ( int second_index = first_index+1; 
                    second_index < A.length ; 
            
                    second_index++ ) {

                // don't count pairs of the same element
                if ( first_index == second_index) 
                    continue;                


                /* REQUIREMENT: The function should return −1 
                   if the number of such pairs exceeds 1,000,000,000. */
                if ( countOfPairs > 1000000000 )
                    return -1;

            
                if ( (A[first_index] + A[second_index]) %2 == 0 ){
                    countOfPairs++;
                }
            
            }
        }

        return countOfPairs;
    }

}


/**
 *  SOLUTION: it's actually a bit of a trick question : 
 * 
 *    since we never need to save the pairs or their sums,
 *    and the pairs we want are evens with evens, or odds with odds,
 * 
 *    it's actually only a matter of:
 *    - traverse the array once and count the number of even elements ( O(N) )
 *    - the number of odd elements is this number subtracted from N
 * 
 *    - plug in both these numbers into "combinations of N taken 2 at a time"
 *    - sum those two results
 * 
 */
