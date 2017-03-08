include <../configuration.scad>;
use <../base.scad>;
use <../pins.scad>;

//motor variables
dflat=.2;
shaft=5+slop;
shaft_offset = -2;
motor_rad = 33/2;
motor_mount_rad = 38/2;
m3_rad = 1.7;
m3_nut_rad = 3.5;

assembled();


module assembled(){
    %pegboard([12,12]);
    
    stair_inlet();
    
    translate([in*2,0,0]) fixed_stair();
}


module stair_inlet(){
    $fn=30;
    difference(){
        union(){
            inlet(height=2, width=3, length=2, outlet=INLET_HOLE, hanger_height=1, inset=0);
            
            //add a motor mount underneath the inlet
            hull(){
                translate([in,-in*1.5,in/2]) rotate([0,0,0]) rotate([0,90,0]) motorHoles(1, slot=5);
                translate([0,-in/2,in]) rotate([0,90,0]) cylinder(r=in/2, h=wall);
            }
        }
        
        #translate([in,-in*1.5,in/2]) rotate([0,0,0]) rotate([0,90,0]) motorHoles(0, slot=5);
    }
}

module fixed_stair(step_height = in, num_steps = 4){
    step_drop = .125*in;    //the slope per step
    step_length = in;
    step_width = ball_rad*2;
    
    difference(){
        union(){
            //hangers
            
            //stair steps
            for(i=[1:num_steps]) translate([step_length*i, 0, step_height*i]) difference(){
                //the step
                translate([0,-in/2-wall-wall,0]) cube([step_length, step_width, step_height]);
                
                //cut out a ball path
                #translate([0,-in/2,0]) hull(){
                    sphere(r=ball_rad + wall/2);
                }
            }
        }
    }
}

module cam_stair(haft=6, height=10, tolerance = .2, dflat=.25, $fn=30){
}
