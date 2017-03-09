include <../configuration.scad>;
use <../base.scad>;
use <../pins.scad>;
use <../screw_drop/screw_drop.scad>;

//motor variables
dflat=.2;
shaft=5+slop;
shaft_offset = -2;
motor_rad = 33/2;
motor_mount_rad = 38/2;
m3_rad = 1.7;
m3_nut_rad = 3.5;

assembled();


//stair variables
stair_length = 7*in;
num_steps = 5;
step_drop = .125*in;    //the slope per step
step_length = stair_length/num_steps;
step_width = in-wall;
step_height = in*1.5;
    

module assembled(){
    %pegboard([12,12]);
    //previous bit
    %translate([-in*5,0,in*7]) slope_module();
    //next bit
    %translate([in*12,0,in*7]) slope_module();
    //handle
    %translate([in*6.5,0,in*12]) cube([in*4, in, in], center=true);
    
    #translate([0,0,in*7]) screw_drop(inlet_length = 2, height = 1.5);
    
    translate([in*4,0,in*5]) {
        stair_inlet();
    
        translate([in*1,0,in*1.5-step_height]) fixed_stair();
        
        
    
        //%translate([in*1+step_length/2,-step_width*2,in*1.5-step_height]) mirror([0,1,0]) fixed_stair();
    
        //translate([in*7,0,in*1]) slope_module();
    }
}


module stair_inlet(){
    $fn=30;
    difference(){
        union(){
            inlet(height=2, width=3, length=1, outlet=INLET_HOLE, hanger_height=3, inset=0);
        }
    }
}

//need a rail with a tolerance, so we can inset it.
module rail(){
    
}

module stair_step(solid = 1, entrance = 0, exit = 0){
    if(solid == 1){
        //the step
        translate([0,-step_width,0]) cube([step_length, step_width, step_height]);
        
        //Rails to guide the sliding parts
    }
    
    if(solid == -1){
        //ball path in
        translate([0,-in/2,step_height]) hull(){
            if(entrance == 1){
                translate([ball_rad-in,0,step_drop]) sphere(r=ball_rad + wall);
            }else{
                translate([ball_rad, -in, step_drop]) sphere(r=ball_rad + wall);
            }
            
            translate([ball_rad,0,0]) sphere(r=ball_rad + wall);
        }
        
        //cut out a ball path forward on each step
        translate([0,-in/2,step_height]) hull(){
            translate([ball_rad,0,0]) sphere(r=ball_rad + wall);
            translate([step_length-ball_rad,0,-step_drop]) sphere(r=ball_rad + wall);
        }
        
        //and a ball path sideways
        translate([0,-in/2,step_height]) hull(){
            translate([step_length-ball_rad,0,-step_drop]) sphere(r=ball_rad + wall);
            if(exit == 1){
                translate([step_length-ball_rad+in,0,-step_drop*2]) sphere(r=ball_rad + wall);
            }else{
                translate([step_length-ball_rad,-in,-step_drop*2]) sphere(r=ball_rad + wall);
            }
        }
    }
}

module motor_mount(solid = 1){
    if(solid == 1){
        //motor mount
        hull(){
            translate([num_steps*step_length/2, -in, -in/2]) rotate([90,0,0])  rotate([0,0,90]){            
                %translate([0,0,1+ball_rad*2+wall/2+2]) rotate([0,0,8]) rotate([180,0,0]) bearing(bearing=false, drive_gear=true);
                translate([0,0,-.1]) hull() rotate([0,0,-90]) motorHoles(1, slot=5);
            }
            #translate([num_steps*step_length/2,-wall/2,step_height*2]) cube([in*2,wall,in], center=true);
        }
    }else{
        translate([num_steps*step_length/2, -in, -in/2]) rotate([90,0,0])  rotate([0,0,90]){
            #translate([0,0,-.1]) rotate([0,0,-90]) motorHoles(0, slot=5);
        }
    }
}

module fixed_stair(step_height = in){
    difference(){
        union(){
            for(i=[0:num_steps-1]){
                //stair steps
                translate([step_length*i, 0, step_height*i]) stair_step(solid = 1);
                
                echo(floor((step_length*i)/in));
                //stair hangers
                hanger(hole=[ceil((step_length*i)/in),num_steps+1], solid=1, drop=in*(num_steps-i));
                
                hanger(hole=[ceil((step_length*i)/in),num_steps+1], solid=1, drop=in*(num_steps-i), rot=-45);
            }
            
            motor_mount(solid = 1);
        }
        
        for(i=[0:num_steps-1]){
            //stair step cutouts
            translate([step_length*i, 0, step_height*i]) stair_step(solid = -1, entrance = i+1, exit = i-num_steps+2);
            
            //stair hangers
            hanger(hole=[ceil((step_length*i)/in),num_steps+1], solid=-1, drop=in*(num_steps-i));
        }
        
        motor_mount(solid = -1);
        
        //chop the very end off
        translate([num_steps*step_length+50-1, 0, num_steps*step_height]) cube([100,100,100], center=true);
    }
}

module cam_stair(haft=6, height=10, tolerance = .2, dflat=.25, $fn=30){
}
