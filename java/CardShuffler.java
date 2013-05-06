// Write a program in Ruby (or the language of your choice) to shuffle a deck of cards
public class CardShuffler {

    List<String> SUITS = new ArrayList<String>("SPADES", "CLUB", "HEARTS", "DIAMONDS");
    List<String> VALUES = new ArrayList<String>("A", "1", "2" ...); 

    public class Card {
        // each Card has data :  String  ("4 spades")
        String label;
        
        public Card(String l) { 
            label = l;
        }
        
        private String getLabel() {
            return label;
        }
    }

    private List<Card> dealerDeck = new ArrayList<Card>();
    // dealer's deck =  Collection of Card objects
    
    // initially the dealer's deck is in order
    public CardShuffler() {
        for ( String suit : SUITS ) {
                for ( String value : VALUES ) {
                    dealerDeck.append(new Card(value + " of " + suit));
                }
        }
    }  // end constructor, makes dealer's deck


    public void shuffle() {

        deck = new ArrayList<Card>(52); 
        // deck = empty array of same size

        while ( dealerDeck.size() > 0 ) {
        // for Collection is not empty
        
            int randomIndex = java.util.Random.netxtInt() % dealerDeck.size();
                                // TODO: repalce mod op here

            // remove Collection item at index "index"
            Card chosenCard = dealerDeck.remove(randomIndex);

            // place on the deck
            deck.append(chosenCard);
        
            dealerDeck = deck;        
        }
    }
}