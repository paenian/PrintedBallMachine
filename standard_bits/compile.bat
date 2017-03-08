openscad ../ball_return/ball_return.scad -D part=0 -o breturn_2inlet.stl &
openscad ../ball_return/ball_return.scad -D part=2 -o breturn_3inlet.stl &
openscad ../ball_return/ball_return.scad -D part=3 -o breturn_outlet.stl &
openscad ../ball_return/ball_return.scad -D part=4 -o breturn_peg.stl &
openscad ../ball_return/ball_return.scad -D part=5 -o breturn_joint.stl &

openscad ../peg.scad -D part=0 -o peg_1x.stl &
openscad ../peg.scad -D part=1 -o peg_2x.stl &
openscad ../peg.scad -D part=2 -o peg_3x.stl &
openscad ../peg.scad -D part=7 -o insert_peg.stl &
openscad ../peg.scad -D part=50 -o peg_lower_hook.stl &

openscad ../peg.scad -D part=4 -o stand.stl &
openscad ../peg.scad -D part=5 -o stand_mirror.stl &

openscad ../handle.scad -D part=0 -o handle.stl &
openscad ../handle.scad -D part=1 -o handle_mount.stl &
openscad ../handle.scad -D part=2 -o handle_mount_mirror.stl &

