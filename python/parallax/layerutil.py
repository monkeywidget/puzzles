import sys
import getopt


class LayerUtil :
    """
Usage: python layerutil.py x_distance -i <initial_coord>
Usage: python layerutil.py x_distance -f <final_coord>

x_distance : the total distance travlled by this object

Options:
    -i    specify the initial position (float)
    -f    specify the final position (float)


Calculates the displacement of layered artwork 
for keyframing multi-layer animation.

Command line specifies:
- the total distance travelled
- a known point at either the initial (-i) or final (-f) point in the sequence.

Given a [hardcoded] list of x-coordinates of the top foreground layer, 
one per keyframe,

outputs a grid of the lists of the x-coordinates for this layer
giving the displacement at the identical keyframes

EXAMPLE OUTPUT:

Initial X-diplacement:       -450.5
Total x-distance travelled:  10.0
Clip starts at timecode:     00:10:14:18

timecode        position
------------------------
00:10:14:18     -450.5
00:10:16:23     -450.5
00:10:16:24     -450.8
00:10:16:25     -455.0
...

"""

    known_distance = 0.0
    initial_coord = 0.0
    final_coord = 0.0

    def process_args(self, argv=None):

        if argv is None:
            argv = sys.argv
            
            if len(argv) < 2:
                print self.__doc__
                sys.exit(0)

            try:
                opts, args = getopt.getopt(argv[2:], "hi:f:")

            except getopt.error, msg:
                print msg
                print "for help use -h"
                sys.exit(2)

        # get the required layer level

        self.known_distance = float(argv[1])

        # process options
        for o, a in opts:
            if o == "-h":
                print self.__doc__
                sys.exit(0)
            elif o == "-i":
                known_coord = float(a)
                self.extrapolate_endpoints(known_coord,
                                           True,
                                           self.known_distance)
            elif o == "-f":
                known_coord = float(a)
                self.extrapolate_endpoints(known_coord,
                                           False,
                                           self.known_distance)


    # the last still keyframe is 2:05 into the clip
    clip_keyframe_timecode_s = 2
    clip_keyframe_timecode_f = 5

    # since the clip only is 04s 18f long...
    # 04:18 - 02:05 = ((4 - 2)s x 24 f/s) + (18f - 5f) 
    #               = 48f + 13f 
    #               = 61f

    keyframes_total = 61

    # frame 0:00 of the clip starts at this timecode
    clip_offset_timecode_m = 13
    clip_offset_timecode_s = 5
    clip_offset_timecode_f = 5

    FRAMES_PER_SECOND = 24

    # the layers are at set depths
    layer_depths = (0, 5, 25, 30, 44, 60, 120 )


    def convert_to_timecode ( self, playhead_timecode ) :
        """Given the number of frames into the clip,
           return a formatted string with the absolute timecode
        """
        frames = playhead_timecode + self.clip_offset_timecode_f
        frames_carry = frames / self.FRAMES_PER_SECOND    # how many whole seconds is this?
        frames = frames % self.FRAMES_PER_SECOND

        seconds = self.clip_offset_timecode_s + frames_carry
        seconds_carry = seconds / 60
        seconds = seconds % 60

        minutes = self.clip_offset_timecode_m + seconds_carry

        return "00:%02d:%02d:%02d" % ( minutes, seconds, frames )


    def extrapolate_endpoints(self, known_coord, known_initial_not_finalP, known_distance) :
        """Calculate the initial from the final
        """

        place = "initial" if known_initial_not_finalP else "final"
        # print "DEBUG: %s known value travelling %.2f pixels is %.2f" % ( place,
        #                                                                 known_distance,
        #                                                                 known_coord)

        if known_initial_not_finalP :
            self.initial_coord = known_coord
            self.final_coord = known_coord + known_distance
        else: 
            self.initial_coord = known_coord - known_distance
            self.final_coord = known_coord

        # print "DEBUG: endpoints are ( %.2f, %.2f )" % (self.initial_coord, self.final_coord)
        return


    def reference_values_distance(self) :
        return self.reference_x_values[-1] - self.reference_x_values[0]

    def parametric_xcoord_corresponding_to(self, reference_value):

        reference_delta = reference_value - self.reference_x_values[0]
        f = reference_delta * (self.known_distance / self.reference_values_distance() ) + self.initial_coord
        return f

    def print_timecode_and_coord_given_reference(self, index, reference_value) :
        """Given the reference value,
           print a single row with the timecode and the x-coordinate for this timecode
        """

        frames_into_clip = self.convert_to_timecode(index)
        x_coord = self.parametric_xcoord_corresponding_to(reference_value)

        print "\t%s\t%.1f" % (frames_into_clip, x_coord)

    def main(self, argv=None):
        self.process_args(argv)

        print "\n\tTimecode\tx-coord\n"

        # for each keyframe
        for index, reference_value in enumerate(self.reference_x_values) :
            # print the timecode and coordinate for this layer
            self.print_timecode_and_coord_given_reference (index, reference_value)
            if index % 6 == 5:
                print "\n"




    # a list of the x_values for the closest layer at each keyframe
    # this was calculated by focusing on a tuft of Joe's wig
    # and tracking it with Adobe After Effects

    # TEST COMMANDS:
    # python2.7 Documents/layerutil.py -754.6 -i 1208.9
    # python2.7 Documents/layerutil.py -754.6 -f 454.3

    # Note this uses AAE coordinate system, 1080p (0-1080 y)
        # which starts at 0 on the left, and goes to 1444 on the right

    reference_x_values = [  1208.9,    # 02:05
                            1208.3,
                            1207.7,
                            1207.0,
                            1206.0,
                            1204.5,
                            1203.0,
                            1201.6,    # 02:12
                            
                            1200.0,
                            1198.1,
                            1195.8,
                            1193.1,
                            1190.1,
                            1186.8,
                            1183.0,
                            1179.1,
                            1175.0,
                            1173.7,
                            1171.8,
                            1167.1,   # 03:00

                            1160.0,
                            1151.2,
                            1141.3,
                            1129.5,
                            1115.9,
                            1101.8,
                            1087.3,
                            1071.4,
                            1054.3,
                            1036.2,
                            1018.1,
                            1000.1,   # 03:!2

                            981.7,
                            963.1,
                            943.6,
                            923.4,
                            902.9,
                            883.4,
                            864.9,
                            846.6,
                            827.9,
                            808.2,
                            787.7,
                            767.2,   # 04:00
                            
                            746.9,
                            726.9,
                            706.7,
                            686.4,
                            664.9,
                            643.4,
                            623.6,
                            603.7,
                            584.2,
                            565.2,

                            547.2, # 549.9,   # 04:11 = 07:11
                            532.1, # 532.1,   # 04:12
                            517.4, # 513.9,   # 04:13
                            502.6, # 498.6,   # 04:14
                            488.8, # 483.7,   # 04:15
                            474.5, # 469.2,   # 04:16

                            460.5, # 455.8,   # 04:17
                            454.3  # 454.3    # 04:18
       ]

# reference: top layer deltaX = -765
# + Joe and Tim and Phil
# + glasses above
# + bar pulls near Tim
# + bar pulls near Joe

# reference: beam layer deltaX = -630
# + brick pillar
# + beam

# reference: harry layer deltaX = -440
# + Harry
# + pool table
# + beer chandelier
# + jukebox


# reference: BG wall layer deltaX = -300
# - BG: rear wall

if __name__ == "__main__":
    l = LayerUtil()
    l.main()
