openscad rotary_pump_lifter.scad -D part=0 -o rpl_inlet.stl &
openscad rotary_pump_lifter.scad -D part=1 -o rpl_outlet.stl &
openscad rotary_pump_lifter.scad -D part=2 -o rpl_tube.stl &

openscad ../ball_return/ball_return.scad -D part=0 -o breturn_inlet.stl &
openscad ../ball_return/ball_return.scad -D part=3 -o breturn_outlet.stl &
openscad ../ball_return/ball_return.scad -D part=4 -o breturn_peg.stl &

openscad ../peg.scad -D part=0 -o peg_1x.stl &
openscad ../peg.scad -D part=1 -o peg_2x.stl &
openscad ../peg.scad -D part=2 -o peg_3x.stl &
openscad ../peg.scad -D part=7 -o insert_peg.stl &

openscad ../peg.scad -D part=4 -o stand.stl &

openscad ../handle.scad -D part=0 -o handle.stl &
openscad ../handle.scad -D part=1 -o handle_mount.stl &
