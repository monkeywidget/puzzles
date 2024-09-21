# problem statement

the original problem is:

- using the words from the Scrabble dictionary
- find 5 words that are each 5 letters long that use 25 of the 26 letters in the English alphabet

The context of this is finding "coverage words" for the Wordle puzzle.

Given the size of the search space I wanted something a little more: find ALL of the sets of 5 words.

## Problem origin

I was inspired to do this by a youtube video

- a mathemetician (not a computer scientist!) was challenged to find 5 words spanning 25 letters of the English alphabet
- he did it sort of clumsily
- then a bunch of commenters, likely with CS degrees, swooped in and solved it "better"

response video:

<https://www.youtube.com/watch?v=c33AZBnRHks>

We can see this is a variation of a "clique cover" problem, with a restriction the cliques are each 5 vertices and there are only 5 of them.

The specific problem has been attempted many times before:

- <https://stackoverflow.com/questions/71011062/find-5-letter-words-with-25-distinct-characters>

however I'm going to only read implementation ideas (including the response video) AFTER I get tired of iterating on my design

## Implementation Experiment

as an experiment I have been using chat tools to come up with the initial framework
such that it respects my design choices

### prompt 2024-09-01

Attempting to tightly control the implementation of the code, and also implement the improvements from the previous iteration. It would be nice to have some unit tests in here (for example for the comparision function and a check on a generated `CSV` to run as regression tests) but that should be a different prompt.

At this point writing the prompt is taking longer than writing the actual code.

Previous prompts below:

### prompt 2024-08-31

    I'm going to take a new approach. I have a file called "sowpods.txt" which has a list of all valid words in all capitals. 

    write a python3 program that dos the following, with each bullet point being broken up into at least 1 function. The principle of DRY must be respected. At the beginning and end of each of the functions that is a bullet point, emit to stdout a log saying the function has started or finished, with the current timestamp in miliseconds

    - read the file. The name of the file is hardcoded and is local to the python script. Discard all words that are not 5 letters long. retain the resulting list in a data structure
    - add an index to the rows in the data structure, a 26 bit integer which is a bitmap representing which letters are present in the word. permanently discard any words which have fewer than 5 bits set to 1. Save the resulting structure in a file called "1-word.csv"
    - find all 2-word combinations with 10 bits set to 1 and save them in a new structure. Save the resulting structure in a file called "2-words.csv"
    - find all 4-word combinations with 20 bits set to 1 and save them in a new structure. Save the resulting structure in a file called "4-words.csv"
    - find all 5-word combinations with 25 bits set to 1 and save them in a new structure. Save the resulting structure in a file called "5-words.csv"

The next few prompts were me trying to get better interface working

    we need a progress meter. add a function that prints a single dot with no carriage returns. print a dot every 100 words or rows or combinations iterated

    set the dot to only run every 10k iterations for that step

    - set the dot to print every 1k iteration of 4-word
    - change the encoding of the index - it must be a integer, not a string
    - use bitwise operators to compare words or count bits

    change the time output to print a human readable format like the example: "1m32.34s" which represents one minute and 32.34 seconds to 2 digits of accuracy

    save the start time of the program and print out the total elapsed time at the end

At this point it became clear the LLM was not only failing to understand the premise of the algorithm (Knapsack algorithm) but also the memory of the prompt was starting to degrade, probably because of the number of interactions in the chat.

- the code was doing brute force for every step, and not leveraging earlier results, therefore not doing knapsack algorithm.
  - to address this I tried to get it to directly read in the previous results
- the CSV output for anything after the first one was wrong. Why? the utility method was just printing out the values, and was not handling tuples or arrays for the first element

    retain the results from the 1-word structure, the 2-word structure, and the 4-word structure.

    When deriving the 2-word structure use the data already present in the 1-word structure. Retain in the 2-word structure the 2 words and the integer bitmask of their combination. write this to the CSV file

    When deriving the 4-word structure use the data already present in the 2-word structure. Retain in the 4-word structure the 4 words and the integer bitmask of their combination. write this to the CSV file

    When deriving the 5-word structure use the data already present in the 4-word structure. Retain in the 5-word structure the 5 words and the integer bitmask of their combination. write this to the CSV file

- this all turns out to be too little, too late, and I need to start fresh again:
- the LLM generated comparison function is very bad: it's counting 1's
  - it's converting the integer to a binary representation as a string, which is already terrible
  - and then counts the number of 1's
  - each interation has a expected number of 1's - this was an error I introduced early in the design
- the first two steps should be done in the same pass:
  - read in the file, and for each word
    - discard if not exactly 5 letters which are all unique
    - generate a bitmask representing the 5 letters
    - save in a data structure: array
      - each element is a 2-element array: the original word, the bitmask saved as a binary integer
      - the reason for the array is
        - we only access by iterating through all the indexes, or directly by index when looking it up
        - we only check the word again when we output the answer

Comparision function example:

    # Check if the combined mask has the desired number of bits set to 1
        if bin(combined_mask).count('1') == bit_count:

additionally there are basic flaws in the original instructions:

- the comparison function is actually much simpler than I initially specified:
  - if we are sure the two bitmasks are nonzero and already have the desired number of 1's, it's just A AND B == 0
  - if we are NOT sure, it's X OR B == X XOR B
- there's no reason to retain the actual words in the tuples (in memory or the CSV file)
  - they instead should be reduced to indexes referencing the initial table
- there's another possible optimization here: words that are anagrams
  - words with the same bitmask can be removed and put in another "anagrams" structure
  - the structure would be a dictionary keyed to the bitmask storing a set of matching indexes
  - on completion then we would have to check if a given combination included a word with anagrams, and then multiply / permute by all the anagrams
    - that means we would have to either have to save whether a word had anagrams in every single word (adds to space for optimizing time), or check for the presence of the bitmask in the anagram table - since that's a single access that seems better
  - this definitely saves space. I think it saves time, because there are a bunch of anagrams.
    - the cost is: now we have to look up the bitmask in the anagram table. That should be cheap because it's a dict
    - the savings is: now we reduced the comparisions etc in at least 2 loops because we do the cost once in the original 1-word list, and we use it 3 more times (making the 2-word, 4-word, and 5-word lists), each of which use an O(n^2) loop
- to make this easier to test and run we should make each step runnable as a separate command, so it's saving to a CSV or a sqlite3, checking for the file's existence and reading it in

## earlier attempts

### SQL (ML-written logic only)

    assume we have a distributed database with every valid word in it and the booleans already populated, implementing a sparse array

    write a query which detects only rows (representing words) with 5 unique letters

    use that query to group rows into groups of 2 with no collisions in the booleans
    use that query to group rows into groups of 4 with no collisions in the booleans
    use that query to group rows into groups of 5 with no collisions in the booleans

ChatGPT came up with a solution where each letter was its own column, and compared every possible combination. After some massaging it started using JOIN

### ElastcSearch

    write a elasticsearch query that finds groups of 5 words, each with 5 letters, such that the 5 words contain 25 of the 26 letters of the english alphabet. Assume ElasticSearch already has a dictionary with all valid 5-letter words

The issue with this approach is it got bogged down with ES notion of tokens, and stemming, and started getting complicated too early in the process
