import time
import itertools
import csv

def log_function_start_end(func):
    def wrapper(*args, **kwargs):
        start_time = time.time()
        print(f"{func.__name__} started at {format_time(start_time)}")
        result = func(*args, **kwargs)
        end_time = time.time()
        duration = end_time - start_time
        print(f"{func.__name__} finished at {format_time(end_time)} (Duration: {format_duration(duration)})")
        return result
    return wrapper

def format_time(epoch_time):
    return time.strftime("%H:%M:%S", time.localtime(epoch_time))

def format_duration(duration):
    minutes = int(duration // 60)
    seconds = duration % 60
    return f"{minutes}m{seconds:.2f}s" if minutes > 0 else f"{seconds:.2f}s"

def print_progress_dot(count, interval=100):
    if count % interval == 0:
        print(".", end='', flush=True)

@log_function_start_end
def read_file_and_filter_words():
    file_name = "sowpods.txt"
    words = []
    with open(file_name, 'r') as f:
        for i, word in enumerate(f.readlines()):
            word = word.strip()
            if len(word) == 5:
                words.append(word)
                print_progress_dot(i)
    print()  # New line after progress dots
    return words

@log_function_start_end
def create_index_and_filter_words(words):
    word_struct = []
    for i, word in enumerate(words):
        # Create a bitmask where each bit represents a letter
        letter_mask = sum([1 << (ord(char) - ord('A')) for char in set(word)])
        # Only keep words that have exactly 5 unique letters
        if bin(letter_mask).count('1') == 5:
            word_struct.append(([word], letter_mask))
        print_progress_dot(i)
    save_to_csv("1-word.csv", word_struct)
    print()  # New line after progress dots
    return word_struct

def save_to_csv(filename, data):
    with open(filename, 'w', newline='') as file:
        writer = csv.writer(file)
        for entry in data:
            words, bitmask = entry
            writer.writerow(words + [str(bitmask)])

@log_function_start_end
def find_combinations(prev_struct, combination_size, bit_count, output_file, progress_interval=100):
    valid_combinations = []
    total_combinations = itertools.combinations(prev_struct, combination_size // 2)
    for i, combination in enumerate(total_combinations):
        combined_mask = 0
        combined_words = []
        for word_tuple in combination:
            combined_mask |= word_tuple[1]  # Combine the bitmasks using bitwise OR
            combined_words.extend(word_tuple[0])
        # Check if the combined mask has the desired number of bits set to 1
        if bin(combined_mask).count('1') == bit_count:
            valid_combinations.append((combined_words, combined_mask))
        print_progress_dot(i, progress_interval)
    save_to_csv(output_file, valid_combinations)
    print()  # New line after progress dots
    return valid_combinations

@log_function_start_end
def main():
    program_start_time = time.time()

    words = read_file_and_filter_words()
    words_struct = create_index_and_filter_words(words)
    
    two_word_struct = find_combinations(words_struct, 2, 10, "2-words.csv", progress_interval=10000)  # Dot every 10k iterations
    four_word_struct = find_combinations(two_word_struct, 4, 20, "4-words.csv", progress_interval=1000)  # Dot every 1k iterations
    find_combinations(four_word_struct, 5, 25, "5-words.csv")  # Default dot interval
    
    total_duration = time.time() - program_start_time
    print(f"Total elapsed time: {format_duration(total_duration)}")

if __name__ == "__main__":
    main()
