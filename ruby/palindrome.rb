# FYI:  
# http://ruby-doc.org/core-2.0/String.html

=begin
  Embedded in this block of text is the password for level 2.
  The password is the longest substring that is the same in reverse.

  As an example, if the input was "I like racecars that go fast"
  the password would be "racecar".
=end

pal = "Never a foot too far, even."
class String

  def letters_only
    return self.downcase.scan(/\w/)
  end

  def palindrome?
    letters = self.letters_only
    letters == letters.reverse
  end

  def palindromeFromXtoY?(from, to)
    # print "\tDEBUG: testing \"" + self[from,to-from+1] + "\"\n"
    return self[from,to-from+1].palindrome?
  end

  def search_for_palindrome(from, to)

    if self[from,to-from+1].letters_only.length < 2    # a palindrome is at least 2 letters
      return
    elsif !palindromeFromXtoY?(from, to)
      return
    else

      if ( to - from >= 4 )
        print "DEBUG: found \"" + self[from,to-from+1] + "\"\n"
      end

      if ( (from > 1) and ( to < self.length ) )
        search_for_palindrome(from-1, to+1)
      end

    end  
  end

end


search_text1 = "I like racecars that go fast";
#                      6       
# search_text1.palindromeFromXtoY?(6,13) => true

if search_text1.palindromeFromXtoY?(7,13) 
  print "yo!\n"
else
  print "nope.\n"
end

# "ranynar" is the longest
search_text2 = "FourscoreandsevenyearsagoourfaathersbroughtforthonthiscontainentanewnationconceivedinzLibertyanddedicatedtothepropositionthatallmenarecreatedequalNowweareengagedinagreahtcivilwartestingwhetherthatnaptionoranynartionsoconceivedandsodedicatedcanlongendureWeareqmetonagreatbattlefiemldoftzhatwarWehavecometodedicpateaportionofthatfieldasafinalrestingplaceforthosewhoheregavetheirlivesthatthatnationmightliveItisaltogetherfangandproperthatweshoulddothisButinalargersensewecannotdedicatewecannotconsecratewecannothallowthisgroundThebravelmenlivinganddeadwhostruggledherehaveconsecrateditfaraboveourpoorponwertoaddordetractTgheworldadswfilllittlenotlenorlongrememberwhatwesayherebutitcanneverforgetwhattheydidhereItisforusthelivingrathertobededicatedheretotheulnfinishedworkwhichtheywhofoughtherehavethusfarsonoblyadvancedItisratherforustobeherededicatedtothegreattdafskremainingbeforeusthatfromthesehonoreddeadwetakeincreaseddevotiontothatcauseforwhichtheygavethelastpfullmeasureofdevotionthatweherehighlyresolvethatthesedeadshallnothavediedinvainthatthisnationunsderGodshallhaveanewbirthoffreedomandthatgovernmentofthepeoplebythepeopleforthepeopleshallnotperishfromtheearth"

my_string = search_text2;

for str_index in 0..my_string.length
  my_string.search_for_palindrome( str_index, str_index+1 )   # even number of elements
  my_string.search_for_palindrome( str_index-1, str_index+1 ) # odd number of elements
end




# LOCAL_PALINDROME_EVEN_SEARCH: if this and next indices form a 2-letter palindrome
  # print it out
  # recurse on the larger string forwards and backwards

# LOCAL_PALINDROME_ODD_SEARCH: if the previous and next indices form a 3-letter palindrome
  # print it out
  # recurse on the larger string forwards and backwards
