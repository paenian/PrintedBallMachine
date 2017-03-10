include <../configuration.scad>;
use <../base.scad>;
use <../pins.scad>;

plinko_slope(in_width=4, out_width = 3, length = 4);


module plinko_slope(printable = true, in_width = 3, out_width=3, length = 4, drop = .5){
    side_wall = ball_rad;
    peg_rad = 2;
    peg_height = ball_rad-wall;
    peg_base_rad = (printable)?peg_rad*3:peg_rad;
    difference(){
        union(){
            inlet(outlet = INLET_SLOT, width = in_width);
            
            //the plate
            hull(){
                //top
                translate([in,-in_width*in, 0]) cube([wall, in_width*in, wall+side_wall]);
                
                //bottom
                translate([length*in,-out_width*in, -drop*in]) cube([wall, out_width*in, wall+side_wall]);
            }
        }
        
        //hollow out the plate, leaving the pegs behind
        difference(){
            hull(){
                //top
                translate([in-.1,-in_width*in+wall, wall]) cube([wall, in_width*in-wall*2, wall+side_wall]);
                //bottom
                translate([length*in+.1,-out_width*in+wall, -drop*in+wall]) cube([wall, out_width*in-wall*2, wall+side_wall]);
            }
            
            //the pegs
            for(i=[0:3]){
                translate([in*1.5, ])
            }
       }
    }
}