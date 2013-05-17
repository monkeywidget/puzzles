
=begin
Given the MM-DD-YYYY formatted date
      "10-02-2001"

We will call this a "palindrome date," 
   since without the separators this is 10022001

(1) Write a function that, 
given a specific date,
finds the closest valid date before the given date that is a palindrome date.
you may ignore leap years!

(2) Now write a function that, 
given a specific date,
finds the closest valid date AFTER the given date that is a palindrome date.
you may ignore leap years!

=end

require 'set'

class MmDdYyyyDate

  @@valid_months = ("01".."12").to_set
  @@valid_days = ("01".."31").to_set

  # the only years possible will have a final two digits 
  #   which are reverse valid months
  @@candidate_year_endings = []
  @@valid_months.to_a.sort.each do |month|
    @@candidate_year_endings << month.reverse
  end

  def MmDdYyyyDate.candidate_year_endings
    @@candidate_year_endings
  end
    
  # the only years possible will have an initial two digits 
  #   which are reverse valid days
  @@candidate_year_beginnings = []
  @@valid_days.to_a.sort.each do |day|
    @@candidate_year_beginnings << day.reverse
  end

  def MmDdYyyyDate.candidate_year_beginnings
      @@candidate_year_beginnings
  end


  def MmDdYyyyDate.numbers_of_days_in_month(m)
    case m
    when "02" then 28
    when "04", "06", "09", "11" then 30
    when "01", "03", "05", "07", "08", "10", "12" then 31
    else 0
    end
  end

  def MmDdYyyyDate.valid_months
    @@valid_months
  end

  def MmDdYyyyDate.valid_days
    @@valid_days
  end

  def valid?
    # verify all three fields are set
    return false if not defined? @month 
    return false if not defined? @day
    return false if not defined? @year

    # verify the year is positive integer
    #   ( to_i makes a string 0 if not parseable )
    return false if @year.to_i <= 0

    # verify all month and day are in the set of all valid values
    # verify the month/day combination is valid
    return valid_month_day_combination?
  end

  # verify all month and day are in the set of all valid values
  # verify the month/day combination is valid
  def valid_month_day_combination?
    return false if not @@valid_months.include?(@month)
    return false if not @@valid_days.include?(@day)
    return MmDdYyyyDate.numbers_of_days_in_month(@month) >= @day.to_i
  end

  def to_s
    return "#{@month}-#{@day}-#{@year}"
  end

  # expects a string of numbers and hyphens like "MM-DD-YYYY"
  def initialize (s)
    split_string = s.split("-")
    if split_string.size != 3
      print "ERROR: \"#{s}\" is not a valid MM-DD-YYYY date!\n"
      return
    end

    @month = split_string[0]
    @day = split_string[1]
    @year = split_string[2]
 
  end

  def month
    @month
  end

  def year
    @year
  end

  def day
    @day
  end

end # class MmDdYyyyDate


def palindrome_date_before ( starting_date )
  if not starting_date.valid?
    print "ERROR: \"#{starting_date}\" is not a valid date\n"
    return
  end

  # cut the year into the first two and last two digits
  starting_date_year_beginning = starting_date.year[0..1]
  starting_date_year_ending = starting_date.year[2..3]

  # print "DEBUG: starting from year #{starting_date_year_beginning}#{starting_date_year_ending}\n"

  # find the largest year before this one and count backwards
  
  MmDdYyyyDate.candidate_year_beginnings.sort.reverse.each do |year_string_start|

    next if year_string_start > starting_date_year_beginning

    MmDdYyyyDate.candidate_year_endings.sort.reverse.each do |year_string_ending|

      # check ending of year is before; if not skip to the next one
      next if starting_date.year < year_string_start + year_string_ending

      # for this year, construct the month and day

      this_date = "#{year_string_ending.reverse}-#{year_string_start.reverse}" + 
                                     "-#{year_string_start}#{year_string_ending}"
      this_mmddyyyy_date = MmDdYyyyDate.new(this_date)

      # if the year is this year, we have to check the month, then day is before now
      if starting_date.year == year_string_start + year_string_ending
        # check month is before this (if not, break from loop)
        next if year_string_ending.reverse > starting_date.month
        # if the month is this month and the day is not before this, break
        next if (year_string_ending.reverse == starting_date.month) and (year_string_start.reverse > starting_date.day)
      end

      # if the month/day is a valid combination then this is the result

      if this_mmddyyyy_date.valid?
        # print "#{this_mmddyyyy_date} is the next previous date\n\n"
        return this_mmddyyyy_date
      end

    end # for all year endings
  end # for all year beginnings

end # palindrome_date_before ( starting_date )



def palindrome_date_after ( starting_date )
  if not starting_date.valid?
    print "ERROR: \"#{starting_date}\" is not a valid date\n"
    return
  end

  # cut the year into the first two and last two digits
  starting_date_year_beginning = starting_date.year[0..1]
  starting_date_year_ending = starting_date.year[2..3]

end # palindrome_date_after ( starting_date )


# debug code!
# print "Hello World!\n\n"
date1 = MmDdYyyyDate.new("10-02-2001")
date2 = MmDdYyyyDate.new("10-02-spleen")

# print "Testing valid date: \"#{date1}\"\n"
# print "Testing invalid date: \"#{date2}\"\n"
# print "date1 is valid: \"#{date1.valid?}\"\n"
# print "date2 is valid: \"#{date2.valid?}\"\n"

# print "valid months: #{MmDdYyyyDate.valid_months.to_a}\n\n"
# print "valid days: #{MmDdYyyyDate.valid_days.to_a}\n\n"

# print "Feb has #{MmDdYyyyDate.numbers_of_days_in_month("02")} days\n"
# print "Aug has #{MmDdYyyyDate.numbers_of_days_in_month("08")} days\n"
# print "Fnord has #{MmDdYyyyDate.numbers_of_days_in_month("fnord")} days\n"

start_date = MmDdYyyyDate.new("10-01-2001")
print "The palindrome date previous to \"#{start_date}\" " + 
  "is \"#{palindrome_date_before(start_date)}\"\n\n"


# start_date = MmDdYyyyDate.new("10-01-2001")
# print "The palindrome date after \"#{start_date}\" " + 
#  "is \"#{palindrome_date_after(start_date)}\"\n"


