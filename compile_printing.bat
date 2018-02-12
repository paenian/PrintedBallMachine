#!/bin/sh

#this file compiles many of the useful parts into their own directory
#for mixing and matching.

#handle
openscad -o parts/handle.stl -D part=0 handle.scad &

#stand
openscad -o parts/stand.stl -D part=0 pushpeg.scad &

#pegs
openscad -o parts/peg_tpu.stl -D part=1 pushpeg.scad &
openscad -o parts/peg_tpu_handle.stl -D part=11 pushpeg.scad &
openscad -o parts/peg_petg.stl -D part=2 pushpeg.scad &
openscad -o parts/peg_petg_handle.stl -D part=12 pushpeg.scad &


#ball return around the back
openscad -o parts/ball_return_inlet_2.stl -D part=0 ball_return/ball_return.scad &
openscad -o parts/ball_return_inlet_3.stl -D part=2 ball_return/ball_return.scad &
openscad -o parts/ball_return_outlet.stl -D part=3 ball_return/ball_return.scad &
openscad -o parts/ball_return_joint.stl -D part=5 ball_return/ball_return.scad &

#connector returns
openscad -o parts/ball_return_180.stl -D part=1 ball_return/ball_return.scad &
openscad -o parts/ball_return_90.stl -D part=6 ball_return/ball_return.scad &

