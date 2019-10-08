#!/bin/sh

#this file compiles many of the useful parts into their own directory
#for mixing and matching.

#handle
openscad -o parts/handle.stl -D part=0 handle.scad &
openscad -o parts/double_handle.stl -D part=4 handle.scad &

#stand
openscad -o parts/stand.stl -D part=0 pushpeg.scad &
openscad -o parts/double_stand.stl -D part=20 pushpeg.scad &

#pushpegs
openscad -o parts/peg_tpu.stl -D part=1 pushpeg.scad &
openscad -o parts/peg_tpu_handle.stl -D part=11 pushpeg.scad &
openscad -o parts/peg_tpu_double_handle.stl -D part=121 pushpeg.scad &
openscad -o parts/peg_petg.stl -D part=2 pushpeg.scad &
openscad -o parts/peg_petg_handle.stl -D part=12 pushpeg.scad 

#pegs
openscad -o parts/peg_1l.stl -D part=0 peg.scad &
openscad -o parts/peg_2l.stl -D part=1 peg.scad &
openscad -o parts/peg_3l.stl -D part=2 peg.scad &
openscad -o parts/peg_stand.stl -D part=4 peg.scad &
openscad -o parts/peg_stand_m.stl -D part=5 peg.scad &

#ball return around the back
openscad -o parts/ball_return_inlet_2.stl -D part=0 ball_return/ball_return.scad &
openscad -o parts/ball_return_inlet_3.stl -D part=2 ball_return/ball_return.scad &
openscad -o parts/ball_return_outlet.stl -D part=3 ball_return/ball_return.scad &
openscad -o parts/ball_return_joint.stl -D part=5 ball_return/ball_return.scad &

#connector returns
openscad -o parts/ball_return_180.stl -D part=1 ball_return/ball_return.scad &
openscad -o parts/ball_return_90.stl -D part=6 ball_return/ball_return.scad &

#link two modules together
openscad -o parts/straight_link.stl -D part=7 ball_return/ball_return.scad 

##########################
##Standard Track Pieces!##
##########################
#inlets - mainly to use in other 3d programs
openscad -o tracks/inlet_1.stl -D part=0 base.scad &
openscad -o tracks/inlet_2.stl -D part=1 base.scad &
openscad -o tracks/inlet_3.stl -D part=2 base.scad &

#simple straight slope
openscad -o tracks/simple_slope_3.stl -D part=3 base.scad &
openscad -o tracks/simple_slope_4.stl -D part=4 base.scad &
openscad -o tracks/simple_slope_5.stl -D part=5 base.scad &
openscad -o tracks/simple_slope_6.stl -D part=6 base.scad 

#offset slope
openscad -o tracks/offset_slope_4.stl -D part=7 base.scad &
openscad -o tracks/offset_slope_5.stl -D part=8 base.scad &
openscad -o tracks/offset_slope_6.stl -D part=9 base.scad &

#wide slope
openscad -o tracks/wide_slope_4.stl -D part=10 base.scad &
openscad -o tracks/wide_slope_5.stl -D part=11 base.scad &
openscad -o tracks/wide_slope_6.stl -D part=12 base.scad

