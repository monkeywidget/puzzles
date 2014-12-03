import static org.apache.commons.math3.util.CombinatoricsUtils.binomialCoefficient;
    // http://commons.apache.org/proper/commons-math/apidocs/org/apache/commons/math3/util/CombinatoricsUtils.html#binomialCoefficient%28int,%20int%29

/** 
 * Given an array of integers,
 * 
 * - write a thing that counts the number of subsets of size 2, that when added their sum is even
 * - Note: there could be duplicated values
 * - REQUIREMENT: The function should return −1 if the number of such pairs exceeds 1,000,000,000.
 */
public class CountEvenSummedSubsets {

    /**
    *  Solution 1: brute force: sum every pair of elements, detect if even.  Runs in O(N^2)
    */
    public int naiveSolution(int[] A) {

        int countOfPairs = 0;

        List evens = new ArrayList(<int>);        
        List odds = new ArrayList(<int>);        

        for ( int first_index = 0; first_index < A.length ; first_index++ ) {

                // don't count pairs of the same element, so start after the first element
            for ( int second_index = first_index+1; 
                    second_index < A.length ; 
                    second_index++ ) {

                /* REQUIREMENT: The function should return −1 
                   if the number of such pairs exceeds 1,000,000,000. */
                if ( countOfPairs > 1000000000 ) { return -1; }

                if ( (A[first_index] + A[second_index]) %2 == 0 ) { countOfPairs++; }
            } // for every second element
        } // for every element

        return countOfPairs;
    }

    /**
     *  SOLUTION 2: it's actually a bit of a trick question : 
     * 
     *    since we never need to save the pairs or their sums,
     *    and the pairs we want are evens with evens, or odds with odds,
     * 
     *    it's actually only a matter of:
     *    - traverse the array once and count the number of even elements ( O(N) )
     *       - the number of odd elements is this number subtracted from N
     *    - plug in both these numbers into "combinations of N taken 2 at a time"
     *       - sum those two results
     * 
     *  Runs in O(N)
     */

    public int smarterSolution(int[] A) {

        int countOfEvens = 0;

        for ( int element : A ) {
            if ( A[element] %2 == 0 ) { countOfEvens++; }
        }

        // countOfOdds = A.length - countOfEvens;
        
        long total = binomialCoefficient(countOfEvens, 2) + binomialCoefficient(A.length - countOfEvens, 2);
        if (total > 1000000L) { return -1; }
        return (int) total;
    }

    
}
