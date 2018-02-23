#!/bin/sh

#lifter unique parts
openscad -o sl_inlet.stl -D part=1 stair_lifter.scad &
openscad -o sl_stairs.stl -D part=2 stair_lifter.scad &
openscad -o sl_cam.stl -D part=3 stair_lifter.scad &

openscad -o fully_assembled.stl -D part=10 stair_lifter.scad &
