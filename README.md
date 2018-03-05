The PrintedBallMachine!

Herein are some tips for working with the printed ball machine - making your own modules, first, and later making your own parts.

# Rough Idea
The PBM is a marble machine that utilized pegboard for its vertical structure.  In order to make modular units, the pegboard is cut into 12" sections, with defined inlet and exit for linking together.  The machines are standardized on 5/8" steel ball bearings, because steel is satisfying.  This is the same size as the common glass marble, however there is much more variation in marbles than there are in ball bearings.

The Printed Ball Machine is designed in [OpenSCAD](http://www.openscad.org/), the programmer's solid modeler.

# Common Parts
* Pegboard - 1" holes, 1/4" thick.  This is the 'heavy duty' pegboard, usually just brown hardboard.  Thinner stuff works, but not as well.  Generally sold in 2 foot by 4 foot sections - for modules, cut to 12" square.  Available at Home Depot/Lowes type stores - and they'll cut it if you ask nicely.
  * [home depot](https://www.homedepot.com/p/Triton-1-4-in-x-1-8-in-Heavy-Duty-Brown-Pegboard-Wall-Organizer-Set-of-4-TPB-4BR/205196091)
* 5/8" Steel Ball Bearings - I get mine from McMaster Carr, but anything'll work.
* Pololu plastic gear motors - I standardized on this motor because it fits nicely in a 1" space, has a right-angle drive and decent torque, plus runs off 5v easily.
  * [Pololu Plastic Gearmotor](https://www.pololu.com/product/1120)
  * You can get less-geared versions for faster motors, too.
* USB Charger and Cables
  * The motors are nominally 6v, but run fine (a little slower) at 5v - so we cut up old or cheap USB cables to power them.
  * You can also buy USB splitters, to minimize the number of chargers needed - two motors per amp is safe, in practice 4 seems to work fine.
  * M3x12mm flat-head screws - two to hold each motor on, no tapping :-)
  * #3 by 3/8" flat wood screws - used to hold parts onto the motor, fits perfectly into its D-shaft, no tapping.
  * 12" x 3/8" wooden dowels - to make a single-module with ball recirculation.

# Getting Started
To get started, you need a pegboard, a motor or two, and a 3D printer. To make life easier, we've broken the parts into modules - 12"x12" units that can be linked together.  A module is not complete; it requires the addition of feet and a ball return option - either wooden dowels to recirculate around the back, straight peg clamps to attach it to another adjacent module, 180 degree ball returns to mate it to a second module behind it or 90 degree ball returns to turn it into a square.

I think the best unit is actually two modules back-to-back - these can be recirculated simply, and joined by removing the recirculators and lining them up.  There are three ready modules:

[Stair Lifter Module](stair_lifter_module)

[Bearing Lifter Module](bearing_lifter_module)

[Screw Lifter Module](screw_lifter_module)


