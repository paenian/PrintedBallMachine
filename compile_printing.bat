#!/bin/sh

#this file compiles many of the useful parts into their own directory
#for mixing and matching.

#handles
openscad -o parts/handle.stl -D part=0 handle.scad &
openscad -o parts/handle_leftmount.stl -D part=1 handle.scad &
openscad -o parts/handle_rightmount.stl -D part=2 handle.scad &

#stand
openscad -o parts/standleft.stl -D part=4 peg.scad &
openscad -o parts/standright.stl -D part=5 peg.scad &

#ball return
openscad -o ball_return/ballreturn_inlet_2.stl -D part=0 ball_return/ball_return.scad &
openscad -o ball_return/ballreturn_inlet_3.stl -D part=2 ball_return/ball_return.scad &
openscad -o ball_return/ball_return_outlet.stl -D part=1 ball_return/ball_return.scad &
openscad -o ball_return/ball_return_peg.stl -D part=4 ball_return/ball_return.scad &
openscad -o ball_return/ball_return_joint.stl -D part=5 ball_return/ball_return.scad &

#pegs
