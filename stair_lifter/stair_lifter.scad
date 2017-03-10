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
stair_length = 6*in;
num_steps = 4;
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
    
    translate([0,0,in*6]) offset_slope_module(inlet_length = 3, height = 1.5);
    
    translate([in*5,0,in*6]) {
        stair_inlet();
    
        moving_stair();
    
        //translate([in*7,0,in*1]) slope_module();
    }
}


module stair_inlet(){
    $fn=30;
    difference(){
        union(){
            inlet(height=2, width=3, length=1, outlet=INLET_HOLE, hanger_height=3, inset=0);
            translate([in*1,0,in*1.5-step_height]) fixed_stair();
        }
    }
}

//need a rail with a tolerance, so we can inset it.
module rail(solid = 1){
    rail_width = 6;
    rail_thick = 3;
    jut = 1;
    
    rad = (solid==1)?.5:.75;
    
    //a jut out bit to lower friction
    if(solid == 1) for(i=[step_length*.25, step_length*.75]){
        
        translate([i-rail_width/2,-step_width-jut,0])
        cube([rail_width,jut*2,step_height]);
    }
    
    //the rail itself - a triangle made of cylinders.
    if(solid == 1){
        for(i=[step_length*.25, step_length*.75]) translate([i,-step_width,0])
        hull(){
            cylinder(r=rad, h=step_height);
            for(i=[-rail_width/2, rail_width/2]) translate([i, -rail_thick,0]) cylinder(r=rad, h=step_height);
        }
    }
    
    if(solid == 0){
        for(i=[step_length*.25, step_length*.75]) translate([i,-step_width-jut-.1,0])
        hull(){
            cylinder(r=rad, h=step_height*3, center=true);
            for(i=[-rail_width/2, rail_width/2]) translate([i, rail_thick,0]) cylinder(r=rad, h=step_height*3, center=true);
        }
    }
}

module stair_step(solid = 1, entrance = 0, exit = 0, rail_solid = 1){
    rear = step_length*.25;
    front = step_length*.75;
    
    if(solid == 1){
        //the step
        translate([0,-step_width,0]) cube([step_length, step_width, step_height]);
        
        //Rails to guide the sliding parts
        if(rail_solid == 1) rail(rail_solid);
    }
    
    if(solid == -1){
        //ball path in
        translate([0,-in/2,step_height]) hull(){
            if(entrance == 1){
                translate([rear-in,0,step_drop]) sphere(r=ball_rad + wall);
            }else{
                translate([rear, -in, step_drop]) sphere(r=ball_rad + wall);
            }
            
            translate([rear,0,0]) sphere(r=ball_rad + wall);
        }
        
        //cut out a ball path forward on each step
        translate([0,-in/2,step_height]) hull(){
            translate([rear,0,0]) sphere(r=ball_rad + wall);
            translate([front,0,-step_drop]) sphere(r=ball_rad + wall);
        }
        
        //and a ball path sideways
        translate([0,-in/2,step_height]) hull(){
            translate([front,0,-step_drop]) sphere(r=ball_rad + wall);
            if(exit == 1){
                translate([front+in,0,-step_drop*2]) sphere(r=ball_rad + wall);
            }else{
                translate([front,-in,-step_drop*2]) sphere(r=ball_rad + wall);
            }
        }
        
        //cut out the rail
        if(rail_solid != 1) rail(rail_solid);
    }
}



module cam(){
    difference(){
        scale([1,cam_scale,1]) cylinder(r=cam_rad, h=ball_rad);
        
        //cut out the D shaft, and a screw fastener.
    }
}

module motor_mount(solid = 1){

    
    if(solid == 1){
        //motor mount
        hull(){
            translate([num_steps*step_length/2, -in, -in/2]) rotate([90,0,0])  rotate([0,0,90]){            
                %translate([0,0,2]) rotate([0,0,35]) scale([1,cam_scale,1]) cylinder(r=cam_rad, h=ball_rad);
                %translate([0,0,2]) rotate([0,0,35+90]) scale([1,cam_scale,1]) cylinder(r=cam_rad, h=ball_rad);
                %translate([0,0,2]) rotate([0,0,60]) scale([1,cam_scale,1]) cylinder(r=cam_rad, h=ball_rad);
                
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
    cam_rad = 45;
    cam_scale = .25;

module moving_stair(step_lift = in){
    //travel maximums
    top = 6;
    bottom = -32;
    
    bottom_extra = 12;
    
    translate([in-step_length/2,-step_width*2-1.1,bottom]) 
    difference(){
        union(){
            for(i=[1:num_steps-1]){
                //stair steps
                mirror([0,1,0]) translate([step_length*i, 0, step_lift*i]) stair_step(solid = 1, rail_solid=0);
            }
            
            //make a slope for pushing
            hull() for(i=[1:num_steps-1]){
                //stair steps
                mirror([0,1,0]) translate([step_length*i, -step_width, step_lift*i-bottom_extra]) cube([step_length*.666, step_width/2, bottom_extra+1]);
            }
        }
        
        for(i=[0:num_steps-1]){
            //stair step cutouts
            mirror([0,1,0]) translate([step_length*i, 0, step_lift*i]) stair_step(solid = -1, entrance = 0, exit = 0, rail_solid=0);
        }
    }
}

module fixed_stair(step_lift = in){
    difference(){
        union(){
            for(i=[0:num_steps-1]){
                //stair steps
                translate([step_length*i, 0, step_lift*i]) stair_step(solid = 1);
                
                echo(floor((step_length*i)/in));
                //stair hangers
                hanger(hole=[ceil((step_length*i)/in),num_steps+1], solid=1, drop=in*(num_steps-i));
                
                hanger(hole=[ceil((step_length*i)/in),num_steps+1], solid=1, drop=in*(num_steps-i), rot=-45);
            }
            
            motor_mount(solid = 1);
        }
        
        for(i=[0:num_steps-1]){
            //stair step cutouts
            translate([step_length*i, 0, step_lift*i]) stair_step(solid = -1, entrance = i+1, exit = i-num_steps+2);
            
            //stair hangers
            hanger(hole=[ceil((step_length*i)/in),num_steps+1], solid=-1, drop=in*(num_steps-i));
        }
        
        motor_mount(solid = -1);
        
        //chop the very end off
        translate([num_steps*step_length+50-1, 0, num_steps*step_lift]) cube([100,100,100], center=true);
    }
}