/* Make a deck of cards, pick out 4 random cards */
package main

// cribbed and streamlined from montanaflynn
// https://gist.githubusercontent.com/montanaflynn/4cc2779d2e353d7524a7bdce57869a75/raw/92391063667d82c22daa6e671663ee747765bdf7/poker.go

import (
	"fmt"
	"math/rand"
	"time"
)

// TODO: make object oriented (store not return value)
// New creates a deck of cards to be used
func MakeDeck() [52]string {

  var deck [52]string // an array because its data is very well defined
  i := 0 // array index to allow us to use array not slice during init

  // constants, broken out for readability only
  // note there is no constant array in Go
  const SUITS string = "♢♧♡♤"
  ordinals := [13]string {"A", "2", "3", "4", "5", "6", "7",
                          "8", "9", "10", "J", "Q", "K"}

  for _,v1 := range SUITS {
    for _,v2 := range ordinals {
      deck[i] = fmt.Sprintf("%s%c ", v2, v1)
      i++
    }
  }

  return deck
}

/* given a deck, pick out some cards and return their values */
func PickCards(deck [52]string, handSize int) []string {
	hand := make([]string, handSize)
	i := 0

	for i < len(hand) {
		r := rand.Intn(len(deck))

		// TODO: only add the card if we haven't already matched it
		hand[i] = deck[r]
		i++
	}

	return hand
}

func main() {
	// init
	rand.Seed(time.Now().UnixNano()) // Seed randomness
  deck := MakeDeck()

	// business logic
	hand := PickCards(deck, 4)

	// output
	for _,v := range hand {
		fmt.Println(v)
	}
}
