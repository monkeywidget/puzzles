# 5-letter Coverage Words

## premise

We are trying to find every valid set of 5 words, such that:

- each word is in the Official Scrabble Dictionary
- each word is 5 letters
- the letters in all the words include 25 of the 26 letters of the English alphabet

We are generating a program which is a command-line script, or series of scripts, that will find and persist all such word combinations.

## guidelines

- the code is implemented in python 3
- follow the principles of `DRY`
- our deployment and task framework is `fabric`
- our test framework is `pytest`
- integers in datastructures are used either as indexes or binary bitmaps, but never both
- do not convert ingegers to strings unless printing to `stdout` or a file

## automation

- our deployment and task framework is `fabric`
- make targets / tasks for
  - running unit tests mentioned below
  - cleaning all data to start fresh
  - running all steps of the program serially
  - running each step of the program individually

## utility functions

For utility functions, please write:

- `log_function_start_end`
  - taking one boolean parameter `start` with a default value of True
  - prints to stdout
    - either `started at %H:%M:%S` if `start == True` or `ended at %H:%M:%S` otherwise
    - with the appropriate values in the time template populated to the current system time
  - This function will be called at the beginning and end of each `STEP` of our solution to show progress to the user. Each `STEP` is described below with a header beginning `## STEP`
- `print_progress_dot`
  - taking zero parameters
  - which prints a single dot, without a carriage return, to `stdout`
  - and does a `flush`
  - for use as a progress indicator
- `has_unique_words`
  - taking two parameters `(A, B)` which are sets
  - compares two sets of integers
  - and return `True` if none of the elements of both sets are repeated, or `False` otherwise
  - This is called by all methods named in the format `find_(\w+)_word_sets`
  - Write a unit test for this function
- `has_unique_letters`
  - taking two parameters `(A, B)` which are integers
  - the two integers are evaluated as binary bitmaps
  - The function returns `True` if `A^B == A|B` and returns `False` otherwise
  - Tnote: this will be called `O(N^4)` times so must be efficient
  - Write a unit test for this function
- `convert_to_bitmap`
  - takes one parameter `FOO` which is an array of letters
  - creates a binary bitmap where each bit represents the presence of a capital letter of the English alphabet in the string stored in `FOO`
    - For example: `0b00` represents `A`, `0b01` represents `B`, `0b10` represents `C`, and so on
    - For every letter in `FOO` set the corresponding bit to `1`
      - that is for `FOO` with `5` unique letters there should be `5` bits set to `1` and the remaining bits the default `0`
  - Raise a `TypeError` if any letter is out of range of the capital letters `A-Z`
  - Bit places of higher value than `2^25` remain set to the default `0`
  - return the completed bitmap as an integer value
  - Write a unit test for this function
- `is_coverage_word`
  - takes one parameter `FOO` which is a string
  - compares the length of `FOO` to the length of `FOO` when converted to a set
  - if the lengths are equal return `True`, return `False` otherwise
  - Write a unit test for this function

## data

Assume our initial data comes from a file named `sowpods.txt`

- the file contains every word in the Scrabble dictionary
- each on its own line
- all entries are in capital letters

## runtime data: data structures

we store several data structures which are accessible globally

- `word_pool` is an array
  - each element of the array is a 2-item tuple
    - containing the original loaded word, which is in all capitals
    - the bitmap for the word as described above, saved as a binary integer, created by `convert_to_bitmap` above
  - `word_pool` is populated in `build_word_lists`
- `anagrams` is a dictionary with integers as keys representing a specific letter bitmap
  - stored values are each a set of strings
  - `anagrams` is populated in `build_word_lists`
- `two_word_sets` is a dictionary with 2-element sets as keys representing the indexes of 2 member words
  - stored values are a bitmap saved as a binary integer representing the letters contained in the member words
  - `two_word_sets` is populated in `find_two_word_sets`
- `four_word_sets` is a dictionary with 4-element sets as keys representing the indexes of 4 member words
  - stored values are a bitmap saved as a binary integer representing the letters contained in the member words
  - `four_word_sets` is populated in `find_four_word_sets`
- `five_word_sets` is a dictionary with 5-element sets as keys representing the indexes of 5 member words
  - stored values are a bitmap saved as a binary integer representing the letters contained in the member words
  - `five_word_sets` is populated in `find_five_word_sets`

## persistent data

- we will save the data structures listed above to local files
  - in a CSV format
  - named as the name of the global variable name with a `.csv` suffix
- the load and save operations for each structure are described below

### persistence methods for `word_pool`

- the method `load_word_pool` loads the value of `word_pool` from a file
  - `word_pool` is an array
  - iteratively read the file `word_pool.csv` one line at a time
  - split the line using `,` as a separator
  - each line in the file is added to an array element that is a 2-item tuple
  - the first item in the tuple is a string read from the first element in the line
  - the second item in the tuple is a bitmap stored as an integer, converted from the second element in the line read as a decimal integer
- the method `save_word_pool` persists the data in `word_pool` to a file
  - open a file for writing `word_pool.csv`
  - iterate through the array `word_pool` remembering the index `index` and also the value
    - the value stored at the index is a 2-tuple , a string `word` and an integer `bitmap`
    - write to the file the values of `index`, `word`, and `bitmap`, separated by commas, and a carriage return
  - close the file upon reaching the end
- write a test populating data for 5 elements of this data structure, saving it, loading it, and verifying the saved copy has the same data as the original

### persistence methods for `anagrams`

- the method `load_anagrams` loads the value of `anagrams` from a file
  - `anagrams` is a dictionary
  - iteratively read the file `anagrams.csv` one line at a time
  - for each line
    - save the list that is the line `split` using `,` as a separator
    - save the first element in the list as `bitmap`, and convert it to an integer
      - `bitmap` is a new key for `anagrams`
      - throw a KeyError if `bitmap` is already a key in `anagrams` and exit
    - save the remaining elements in the list as strings in a set
      - save this set as the value keyed by the new key `bitmap`
- the method `save_anagrams` persists the data in `anagrams` to a file
  - open a file for writing `anagrams.csv`
  - iterate through every key of the dictionary `anagrams`
    - the value stored at the key is a set of strings
    - write to the file the key, and all the strings in the set, each separated by commas, and a carriage return
  - close the file upon reaching the end
- write a test populating data for 5 elements of this data structure, saving it, loading it, and verifying the saved copy has the same data as the original

### persistence methods for `two_word_sets`

- the method `load_two_word_sets` loads the value of `two_word_sets` from a file
  - iteratively read the file `two_word_sets.csv` one line at a time
    - each line will look like `(%d %d), %d`
      - representing a CSV key and value
      - the key is a sorted 2-element set of integers
      - the value is an integer
    - for example one line might look like `(100 234), 2345325`
  - `two_word_sets` is a dictionary with 2-element sets as keys, storing binary integers as the values
  - for each line
    - save the list that is the line split using `,` as a separator
    - the first element will be a 2-element set like `(1 2)`
      - remove the parentheses and read the two values separated by a space and save them in a new set called `key`
    - save the second element as an integer, and save it as `bitmap`
    - save `bitmap` at `two_word_sets[key]`
- the method `save_two_word_sets` persists the data in `two_word_sets` to a file
  - open a file for writing `two_word_sets.csv`
  - iterate through every key of the dictionary `two_word_sets`
    - the key `key` is a 2-item set
    - the value stored at the `key` is an integer and is called `value`
    - write a line to the file formatted like `(%d %d), %d` populated with the two members of the set in `key` and `value`
  - close the file upon reaching the end
- write a test populating data for 5 elements of this data structure, saving it, loading it, and verifying the saved copy has the same data as the original

### persistence methods for `four_word_sets`

- the method `load_four_word_sets` loads the value of `four_word_sets` from a file
  - iteratively read the file `four_word_sets.csv` one line at a time
    - each line will look like `(%d %d %d %d), %d`
      - representing a CSV key and value
      - the key is a sorted 4-element set of integers
      - the value is an integer
    - for example one line might look like `(100 234 324 453), 2345325`
  - `four_word_sets` is a dictionary with 4-element sets as keys, storing binary integers as the values
  - for each line
    - save the list that is the line split using `,` as a separator
    - the first element will be a 4-element set like `(1 2 3 4)`
      - remove the parentheses and read the four values separated by a space and save them in a new set called `key`
    - save the second element as an integer, and save it as `bitmap`
    - save `bitmap` at `four_word_sets[key]`
- the method `save_four_word_sets` persists the data in `four_word_sets` to a file
  - open a file for writing `four_word_sets.csv`
  - iterate through every key of the dictionary `four_word_sets`
    - the key `key` is a 4-item set
    - the value stored at the `key` is an integer and is called `value`
    - write a line to the file formatted like `(%d %d %d %d), %d` populated with the four members of the set in `key` and `value`
  - close the file upon reaching the end
- write a test populating data for 5 elements of this data structure, saving it, loading it, and verifying the saved copy has the same data as the original

### persistence methods for `five_word_sets`

- the method `load_five_word_sets` loads the value of `five_word_sets` from a file
  - iteratively read the file `five_word_sets.csv` one line at a time
    - each line will look like `(%d %d %d %d %d), %d`
      - representing a CSV key and value
      - the key is a sorted 5-element set of integers
      - the value is an integer
    - for example one line might look like `(100 234 324 453 4543), 2345325`
  - `five_word_sets` is a dictionary with 5-element sets as keys, storing binary integers as the values
  - for each line
    - save the list that is the line split using `,` as a separator
    - the first element will be a 4-element set like `(1 2 3 4 5)`
      - remove the parentheses and read the four values separated by a space and save them in a new set called `key`
    - save the second element as an integer, and save it as `bitmap`
    - save `bitmap` at `five_word_sets[key]`
- the method `save_five_word_sets` persists the data in `five_word_sets` to a file
  - open a file for writing `five_word_sets.csv`
  - iterate through every key of the dictionary `five_word_sets`
    - the key `key` is a 5-item set
    - the value stored at the `key` is an integer and is called `value`
    - write a line to the file formatted like `(%d %d %d %d %d), %d` populated with the five members of the set in `key` and `value`
  - close the file upon reaching the end
- write a test populating data for 5 elements of this data structure, saving it, loading it, and verifying the saved copy has the same data as the original

## STEP `build_word_lists` - create `word_pool` and `anagrams`

- before running `build_word_lists`
  - the file `sowpods.txt` is locally available
- after running `build_word_lists`
  - the data structure `word_pool` is fully populated
  - the data structure `anagrams` is fully populated

### Outline for `build_word_lists`

- if there's already locally saved files `word_pool.csv` and `anagrams.csv`
  - call `load_word_pool`
  - call `load_anagrams`
  - return
- iteratively read the file `sowpods.txt` one line at a time
  - skip empty lines
  - the line is a string we call `word_entry`
  - continue to the next iteration if `word_entry` is not exactly 5 letters long
  - set an array `letters` to `word_entry` split into individual characters
  - continue to the next iteration unless `is_coverage_word(letters)` returns `True`
  - save a variable `bitmap` which is the value of `convert_to_bitmap(letters)`
  - if `anagrams` has a key `bitmap` already
    - add `word_entry` to the set that is stored at `anagrams[bitmap]`
    - continue to the next iteration
  - make a 2-item tuple `word_data`
    - the first item is `word_entry`
    - the second item is `bitmap`
  - add `word_data` to the `word_pool` array
  - add to `anagrams[bitmap]` a new set containing only `word_entry`
- call save_word_pool
- call save_anagrams

## STEP `find_two_word_sets` - create `two_word_sets`

- before running `find_two_word_sets`
  - the data structure `word_pool` is fully populated
  - the data structure `anagrams` is fully populated
- after running `find_two_word_sets`
  - the data structure `two_word_sets` is fully populated

### Outline for `find_two_word_sets`

- if there's already a locally saved file `two_word_sets.csv`
  - call `load_two_word_sets`
  - return
- create `two_word_sets` as an empty dictionary
- iterate through `word_pool` retaining the current index in a variable `index_a` which starts at `0`
  - save the second element of the tuple at `index_a` in `word_pool` as `bitmap_a`
    - this should look like `bitmap_a = word_pool[index_a][1]`
  - iterate through `word_pool` retaining the current index in a variable `index_b`, which starts at `index_a + 1`
    - save the second element of the tuple at `index_b` in `word_pool` as `bitmap_b`
      - this should look like `bitmap_b = word_pool[index_b][1]`
    - if `has_unique_letters(bitmap_a, bitmap_b)` is `True`
      - save a new entry in `two_word_sets`
        - the key is the set `(index_a, index_b)`
        - the value is bitwise OR of `bitmap_a` and `bitmap_b`
- call `save_two_word_sets`

## STEP `find_four_word_sets` - create `four_word_sets`

- before running `find_four_word_sets`
  - the data structure `word_pool` is fully populated
  - the data structure `anagrams` is fully populated
  - the data structure `two_word_sets` is fully populated
- after running `find_four_word_sets`
  - the data structure `four_word_sets` is fully populated

### Outline for `find_four_word_sets`

- if there's already a locally saved file `four_word_sets.csv`
  - call `load_four_word_sets`
  - return
- create `four_word_sets` as an empty dictionary
- save a list of the keys of `two_word_sets` as `two_word_sets_keys`
- iterate through `two_word_sets_keys` retaining the current index in a variable `index_a` which starts at `0`
  - save `two_word_sets_keys[index_a]` as `key_a` which is a 2-element `set`
  - save `two_word_sets[key_a]` as `bitmap_a` which is an integer we will be interpreting as a binary bitmap
  - iterate through `two_word_sets_keys` retaining the current index in a variable `index_b`, which starts at `index_a + 1`
    - save `two_word_sets_keys[index_b]` as `key_b` which is a 2-element `set`
    - continue to the next iteration unless `has_unique_words(key_a, key_b)` is `True`
    - save `two_word_sets[key_b]` as `bitmap_b` which is an integer we will be interpreting as a binary bitmap
    - if `has_unique_letters(bitmap_a, bitmap_b)` is `True`
      - save a new entry in `four_word_sets`
        - the key is the `set` which is the sorted union of the two sets `index_a` and `index_b`
        - the value is bitwise `OR` of `bitmap_a` and `bitmap_b` which looks like `bitmap_a | bitmap_b`
- call `save_four_word_sets`

## STEP `find_five_word_sets` - create `five_word_sets`

- before running `find_five_word_sets`
  - the data structure `word_pool` is fully populated
  - the data structure `anagrams` is fully populated
  - the data structure `two_word_sets` is fully populated
  - the data structure `four_word_sets` is fully populated
- after running `find_five_word_sets`
  - the data structure `five_word_sets` is fully populated

### Outline for `find_five_word_sets`

- if there's already a locally saved file `five_word_sets.csv`
  - call `load_five_word_sets`
  - return
- create `five_word_sets` as an empty dictionary
- save a list of the keys of `four_word_sets` as `four_word_sets_keys`
- iterate through `word_pool` retaining the current index in a variable `index_a` which starts at `0`
  - save the second element of the tuple at `index_a` in `word_pool` as `bitmap_a`
    - this should look like `bitmap_a = word_pool[index_a][1]`
  - iterate through `four_word_sets_keys` retaining the current index in a variable `index_b` which starts at `0`
    - save the item as `four_words_key` which os a 4-element set used as a key in `four_word_sets`
    - continue to the next iteration if `four_words_key` contains `index_a`
      - the reason is, this would indicate the word is already in the set of 4
    - save `four_word_sets[four_words_key]` as `bitmap_b` which is an integer we will be interpreting as a binary bitmap
    - if `has_unique_letters(bitmap_a, bitmap_b)` is `True`
      - save a new entry in `five_word_sets`
        - the key is the `set` which is the sorted union of the set `index_b` and the element `index_a`
        - the value is bitwise `OR` of `bitmap_a` and `bitmap_b` which looks like `bitmap_a | bitmap_b`
- call `save_five_word_sets`

## STEP expand_anagrams to build the final list

- yet to be specified, leave empty for now
