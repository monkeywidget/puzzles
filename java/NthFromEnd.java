/* Given a linked list, retrun the nth node from the last */

public class LinkedListTest {

    private ListNode listHead;

    private class ListNode {
        private int data;
        ListNode next;
        
        public ListNode() {
            data = 0;
            next = null;
        }

        public void setData (int d) {
            data = d;
        }
        public int getData(){
            return data;
        }
        
        /* etc */
    }
    
    /**
     * @returns the ListNode N elements from the end
     * @returns null if list is less than n elements long
    */
    public ListNode getNodeNthFromEnd( int n )  {

        // handle case of a 0-length LL
        if (listHead == null) return null;

        int windowSize = 1;  // because the head and tail begin at the same index

        ListNode tailOfQueue = listHead;
                /* moves along the linked list 
                 * n elements behind traversePointer
                 * points to eventually end - n
                 * and therefore the return value
                 */

        ListNode headOfQueue = listHead;
                /* moves along the linked list
                 * points to eventually the end
                 */

        /* EXAMPLE:
         
           given n = 2
        
                              0 1 2 3 4 5

           tailOfQueue              ^
           headOfQueue                ^

           windowSize = 2           

        */

        // slide the queue until it hits the end of the LL
        while ( headOfQueue.next != null ) {
            
            headOfQueue = headOfQueue.next;

            if ( windowSize == n ) {
                // the window = the queue length is maxed out now
                // therefore the tail moves as the head moves
                
                tailOfQueue = tailOfQueue.next;

            } else {
               // initially populate the queue 
               // by sliding the end and not the front
               
               windowSize++;
            }
        } // end while not at the end of the LL

        // if the window never got big enough
        // it means the LL wasn't longer than N
        if (windowSize < n) {
            return null;  
        }
        
        return tailOfQueue;
    }
    
}