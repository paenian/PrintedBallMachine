openscad bearing_lifter.scad -D part=0 -o bl_inlet.stl &
openscad bearing_lifter.scad -D part=1 -o bl_lift_gear.stl &
openscad bearing_lifter.scad -D part=2 -o bl_drive_gear.stl &
openscad bearing_lifter.scad -D part=3 -o bl_outlet.stl &
openscad bearing_lifter.scad -D part=4 -o bl_spiral.stl &
openscad bearing_lifter.scad -D part=9 -o bl_guard.stl &

openscad ../ball_return/ball_return.scad -D part=0 -o breturn_inlet.stl &
openscad ../ball_return/ball_return.scad -D part=3 -o breturn_outlet.stl &
openscad ../ball_return/ball_return.scad -D part=4 -o breturn_peg_2*.stl &

openscad ../peg.scad -D part=0 -o peg_1x_3*.stl &
openscad ../peg.scad -D part=1 -o peg_2x_4*.stl &
openscad ../peg.scad -D part=2 -o peg_3x_4*.stl &
#openscad ../peg.scad -D part=7 -o insert_peg_0*.stl &
#openscad ../peg.scad -D part=50 -o bottom_peg_0*.stl &

openscad ../peg.scad -D part=4 -o stand_left.stl &
openscad ../peg.scad -D part=5 -o stand_right.stl &

openscad ../handle.scad -D part=0 -o handle.stl &
#openscad ../handle.scad -D part=1 -o handle_mount_2*Opt.stl &

openscad bearing_lifter.scad -D part=10 -o fully_assembled.stl &
