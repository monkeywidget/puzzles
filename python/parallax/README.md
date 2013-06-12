Parallax Utility
================

April 16, 2012

I was editing some video on a project that was in Final Cut Pro.
I had to rotoscope something so it looked like there were several layers moving, synchronized to the camera movement, at different depths from the camera!

Final Cut Pro at the time didn't have any way to key movement to a given element on a layer.  But Adobe After Effects did!  Unfortunately I couldn'tt export the project to AAE.

So what I did was, I took a render of the raw footage, imported just that into AAE, and ran the movement tracker.  I wrote down the coordinates for the reference object.

Next I wrote this utility to calculate the movement for every frame for a given layer, based on the parametric movement of the reference layer.

I hand-entered those displacements for the movement on the layers in FCP, one frame at a time.

The results can be seen in the pan of the bar in the short film "The Templetons: We All Scream For Ice Cream."


