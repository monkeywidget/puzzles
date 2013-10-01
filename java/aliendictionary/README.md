Alien Dictionary
================

Problem
-------

- Given a list of words in an alien language 
- sorted in alphabetical order in that alien alphabet
- return the letters in the alien alphabet in order

Example
-------

    public List<Character> generateAlphabet ( String[] dictionary ) {
	...
    }


Solution Stage one: build a rule graph
--------------------------------------

//pseudocode:

    List<Character> sortedAlphabet = new ArrayList<Character>();

    String previousWord = ""

    // doubly-linked tree:
    HashMap<Character, Set<Character>> alphabetOrderingGraphForSucceedingCharacters = new HashMap<Character, Set<Character>>();
    HashMap<Character, Set<Character>> alphabetOrderingGraphForPrecedingCharacters = new HashMap<Character, Set<Character>>();

    HashMap<Character, int> numberOfPrecedingLetters = new HashMap<Character, int>();

    // example: previousWord is "cab", currentWord is "cat"

    for (all the words in the dictionary list starting with the second one) {

        int common_index = index of the last letters in common with the previous word

	// example: the common letters are "ca"	

	thisLetter = currentWord.getCharacterAtIndex(common_index + 1)
	previousLetter = previousWord.getCharacterAtIndex(common_index + 1)

	// example: thisLetter is "t" and previousLetter is "b"

	addToAlphabetOrderingGraphIfNotAlreadyPresent(thisLetter);

	addXToListOfLettersThatMustBeAfterY( previousLetter, thisLetter );

	incrementNumberOfPrecedingLettersToLetter( previousLetter );

     }

Solution Stage two: verify the graph is a tree
----------------------------------------------

	// TO OPTIMISE: because we'll have to run this a lot to rebalance the tree (see below)

     private Node recalculateTreeRoot() {

     // output all the values of numberOfPrecedingLetters
	// TODO: possible a priority queue (heap) here?  Another hashmap for faster rebalancing?

     // verify there is one and only one letter with 0 preceding letters: this is the first letter

     // if this is not the case: 
      //there is no unique alphabetical ordering given this dictionary
      // throw an exception!
     }


Solution stage three: build the alphabet
----------------------------------------

     // starting at the tree root,
     
     nodePointer = root of tree;

     while there is still something in the tree  {  // there are elements in the hashmaps

	
	addLetterToSortedAlphabet(thisLetter);

	removeLetterNodeFromTree(thisLetter);

	removeOutgoingEdgesFromThisLetterToOtherLetters(thisLetter);

	nodePointer = recalculateTreeRoot();

     }

     // if you got here there are no nodes left and the alphabet is complete
     return sortedAlphabet;

