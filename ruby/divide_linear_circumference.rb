# Q: I measured a cylinder with a string, and it was 50 cm around.
# I want to drill holes for 8 equidistant wheels centered 2cm from the bottom.
# Where do I drill?

# This is one of those "I want to see how you think" interview questions,
# which many studies have shown do not predict job performance.

# In fact, if someone asks you a question like this, consider walking away from the interview.
# Why? First let's answer the problem:

# A: This isn't really a programming question, it's an analysis question.
# There are several (!) tricks to this question that I can see:
#
# 1) For the calculation, the fact that it is a circle is not especially relevant,
#    except that the line formed by the holes is a cycle
#    So, no PI is necessary! Just divide the circumference by 8.
# 2) The question doesn't mention if the wheels are on axles (a QA/architecture question).
#    If so, the axles would all run into each other! So let's assume they have no axles.
#    That's what inexperienced developers would do! Assume the best!
# 3) the other trick is: the string may be meant to be a hint.
#    - 8 is a power of 2
#    - so you can find the points to drill by folding the string in half 3 times,
#    - then marking everywhere the string is folded
#    - Wrap this around the cylinder and drill on the marks.  But where??
#    We discover this string is not going to make your job especially easier,
#    because the way the question is phrased, someone must have a metric ruler
#    somewhere at least 50cm long, and you have to measure 2cm up anyway!

# Now I have more questions. Did the interviewer mess up the question?
# Are you not allowed to use a ruler? Is this a poorly phrased metaphor for something?
# Is it an ill-remembered puzzle from Encyclopedia Brown?? What is the deal?
# Maybe we have to let it go.

# So now that we have an answer,
# why this question may be unintentionally revealing something about the asker:

# The whole thing is sort of stupid and reeks of an ego boost for the interviewer...
# and at that, an interviewer who doesn't ever actually build anything physical.
# The fabrication methodology is ridiculous and contrived,
# if it were really about putting wheels on a cylinder, which of course it is not.
#
# But worse, it may be an indicator of an anti-pattern of the team's engineers, rederiving
# basic libraries from scratch, when they could have just used a common implementation
# and then immediately started work on the product.
#
# Like "implement quicksort! Our thing is different!"
# No. Don't implement Quicksort. Everyone has done that already.
# The part of your thing that is different is not going to helped by rewriting Quicksort.

# Sooooo...
# Want to see some code?? Sure!

TOTAL_CIRCLE = 50.0
NUMBER_OF_SEGMENTS = 8

puts "\n\nDividing a circle of circumference #{TOTAL_CIRCLE} cm " \
     "into #{NUMBER_OF_SEGMENTS} segments:"

segment_length = TOTAL_CIRCLE / NUMBER_OF_SEGMENTS
puts "\nThe length of each segment is #{segment_length} cm"
puts "\nSo the segment endpoints lie at measurements:\n\n"

NUMBER_OF_SEGMENTS.times { |i| puts "\tSegment #{i +1} begins at\t#{segment_length * i} cm" }

puts "\n\tSegment #{NUMBER_OF_SEGMENTS} ends at\t#{TOTAL_CIRCLE} cm,"
puts "\t which is the same point as 0 cm"

puts "\n\n"


=begin
sample output:

Dividing a circle of circumference 50.0 cm into 8 segments:

The length of each segment is 6.25 cm

So the segment endpoints lie at measurements:

	Segment 1 begins at	0.0 cm
	Segment 2 begins at	6.25 cm
	Segment 3 begins at	12.5 cm
	Segment 4 begins at	18.75 cm
	Segment 5 begins at	25.0 cm
	Segment 6 begins at	31.25 cm
	Segment 7 begins at	37.5 cm
	Segment 8 begins at	43.75 cm

	Segment 8 ends at	50.0 cm,
	 which is the same point as 0 cm

=end
