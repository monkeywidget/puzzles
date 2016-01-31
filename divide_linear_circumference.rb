# Q: I measured a cylinder with a string, and it was 50 cm around.
# I want to drill holes for 8 equidistant wheels centered 2cm from the bottom.  Where do I drill?
#
# This isn't really a programming question, it's an analysis question.
# There are two tricks to this question that I can see:
#
# 1) For the calculation, the fact that it is a circle is not especially relevant, 
#    except that the line formed by the holes is a cycle
#    So, no PI is necessary!
# 2) The question doesn't mention if the wheels are on axles (a QA/architecture question).
#    If so, the axles would all run into each other!

TOTAL_CIRCLE = 50.0
NUMBER_OF_SEGMENTS = 8

puts "Dividing a circle of circumference {TOTAL_CIRCLE} cm into #{NUMBER_OF_SEGMENTS} segments:"

segment_length = TOTAL_CIRCLE / NUMBER_OF_SEGMENTS
puts "\nThe length of each segment is #{segment_length} cm"
puts "\nSo the segment endpoints lie at measurements:\n\n"

total_traversed = 0.0

NUMBER_OF_SEGMENTS.times do |i|
	puts "\tSegment #{i +1} begins at\t#{total_traversed} cm"
	total_traversed += segment_length
end

puts "\tSegment #{NUMBER_OF_SEGMENTS} ends at\t#{TOTAL_CIRCLE} cm"

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
	Segment 8 ends at	50.0 cm
=end
