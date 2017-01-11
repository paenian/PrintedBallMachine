//this is some Marbulous track pieces - using glass marbles, but they are the same size.
//The reason we use ball bearings is cuz they're MUCH rounder than glass marbles.
//That, and steel has a super satisfying thunk to it.


//todo: gonna skip the rotary lifter... turn the multi-foot into a screw lifter instead.
//Current plan is several parts:
//1. triple inlet + motor mount
//2. screw - extendable
//3. top adapter - goes over the lifter, as a finger-guard + starts the ball guide
//4. extension - tube to guide the balls up farther
//5. exit - basically a mirror of the inlet, so there's three outputs.


include <../configuration.scad>;
use <../base.scad>;

//variables for the Marbulous connector
tube_height = 1.375*in;
tube_rad = 1.1*in/2;
tube_wall = .1*in;
connector_rad = .935*in/2;
connector_insert_rad = .935*in/2;

connector_height = .25*in;

tube_inlet_height = 1*in;

//single length
track_sep = 3*in+31/32*in;    //3" and 15/16ths plus
track_rad = ball_rad+.1*in;
track_wall = tube_wall;


//these are for the lifter
lift_wheel_rad = 1*in;
lift_wheel_thickness = 5;


part = 2;

$fn=90;

//laid out for printing
if(part == 0)
    rotary_inlet();
if(part == 1)
    rotary_outlet();
if(part == 2)
    marbulous_tube(height = 1);
if(part == 3)
    marbulous_slope();
if(part == 4)
    marbulous_multifoot();

if(part==10){
    assembled();
}

//assembled unit, 12x12, for sale.  Includes all parts except mounting pegs.
//This module requires 14 pegs, at least 6 of which are the insert type.
module assembled(inlet = 1, outlet = 1){
    %pegboard([12,12]);
    
    //inlet
    
    //stack some tubes
    
    //outlet
    
    //loop?
    
    //ball recirculator
    translate([in*12,0,in*5]) rear_ball_return_inlet();
    translate([0,0,in*4]) rear_ball_return_outlet();
    
    //next section
    %translate([in*12,0,in*1]) inlet();
}

module lift_wheel(slots = 2){
    difference(){
        //the core of the wheel
        cylinder(r=lift_wheel_rad, h=ball_rad, center=true);
        
        //slot for marble snagging
        for(i=[0:360/slots:359]) rotate([0,0,i]) hull(){
            #translate([lift_wheel_rad-ball_rad-wall/2,0,0]) sphere(r=ball_rad+wall/2);
            translate([lift_wheel_rad,0,0]) sphere(r=ball_rad + wall);
        }
        
        //attach it to the motor
        
        //torus cut around, for better marble guidance
        rotate_extrude(){
            translate([lift_wheel_rad+ball_rad,0,0]) circle(r=ball_rad);
        }
    }
}

module rotary_inlet(){
        difference(){
        union(){
            //endpoints
            marbulous_tube(height = 1, outlet=true);
            translate([track_sep,0,0]) marbulous_tube(height = 2);
            
            //track
            marbulous_track(solid = 1);
            
            //the lift wheel
            translate([track_sep-lift_wheel_rad+ball_rad+wall/2, 0, lift_wheel_rad+connector_height]) rotate([90,0,0])
            %lift_wheel();
        }
        
        //ball path
        marbulous_track(solid = -1);
  
        //slope the top of the ball path so it looks nice
        hull(){
            translate([0,0,tube_inlet_height]) sphere(r=track_rad-1);
            translate([0,0,tube_inlet_height]) scale([1,1,track_rad/(connector_insert_rad+1)]) sphere(r=connector_insert_rad);
        }
        
        //tube hollow
        //translate([track_sep,0,-.1]) cylinder(r=connector_insert_rad, h=tube_height*.75);
    }
}

module marbulous_slope(){
    //lower connectors
    translate([0,0,-tube_height-.25]) %marbulous_tube(height = 1);
    translate([track_sep,0,-tube_height-.25]) %marbulous_tube(height = 1);
    
    difference(){
        union(){
            //endpoints
            marbulous_tube(height = 1, outlet=true);
            translate([track_sep,0,0]) marbulous_tube();
            
            //track
            marbulous_track(solid = 1);
        }
        
        //ball path
        marbulous_track(solid = -1);
  
        //slope the top of the ball path so it looks nice
        hull(){
            translate([0,0,tube_inlet_height]) sphere(r=track_rad-1);
            translate([0,0,tube_inlet_height]) scale([1,1,track_rad/(connector_insert_rad+1)]) sphere(r=connector_insert_rad);
        }
        
        //tube hollow
        translate([track_sep,0,-.1]) cylinder(r=connector_insert_rad, h=tube_height*.75);
    }
}

module marbulous_multifoot(){
    //lower connectors
    translate([0,0,-tube_height-.25]) %marbulous_tube(height = 1);
    translate([track_sep,0,-tube_height-.25]) %marbulous_tube(height = 1);
    %cube([200,200,.1], center=true);
    
    //this sort of thing would work for 4 or more points, but this math only handles 3.
    feet = 3;
    rad = ((track_sep/2)/(sqrt(3)))*2;
    
    difference(){
        union(){
            //inlets
            for(i = [1:feet]){
                rotate([0,0,i*(360/feet)]) translate([-rad,0,0]) marbulous_tube(height = 1, outlet=true);
                
                //this is to ensure that the inlets are perfectly aligned.
                %render() rotate([0,0,i*(360/feet)]) translate([-rad,0,0]) rotate([0,0,30]) marbulous_slope();
            }
            
            //track
            for(i = [1:feet]){
                rotate([0,0,i*(360/feet)]) translate([-rad,0,0]) marbulous_track(solid = 1, outlet=track_rad+track_wall/2);
            }
        }
        
        //ball path
        for(i = [1:feet]){
            rotate([0,0,i*(360/feet)]) translate([-rad,0,0]) 
            hull(){
                marbulous_track(solid = -1, outlet=track_rad+track_wall/2);
                translate([0,0,track_rad]) marbulous_track(solid = -1, outlet=track_rad+track_wall/2);
            }
        }
  
        //slope the top of the ball path so it looks nice
        for(i = [1:feet]){
            rotate([0,0,i*(360/feet)]) translate([-rad,0,0])
            hull(){
                translate([0,0,tube_inlet_height]) sphere(r=track_rad-1);
                translate([0,0,tube_inlet_height]) scale([1,1,track_rad/(connector_insert_rad+1)]) sphere(r=connector_insert_rad);
            }
        }
        
        //tube hollow
        *translate([track_sep,0,-.1]) cylinder(r=connector_insert_rad, h=tube_height*.75);
        
        //cut off the bottom flat
        translate([0,0,-200]) cube([400,400,400], center=true);
    }
}

module marbulous_track(solid = 1, inlet = tube_inlet_height, outlet = connector_height+track_rad){
    
    rise = inlet - outlet;
    
    //calculate the angle
    slope = rise / track_sep;
    
    if(solid >= 0){
        difference(){
            hull(){
                translate([0,0,inlet]) sphere(r=track_rad+track_wall);
                //spine below track, for easier printing
                translate([0,0,inlet-track_rad]) cube([track_rad,.1*in,track_rad], center=true);
            
                translate([track_sep,0,outlet]) sphere(r=track_rad+track_wall);
                translate([track_sep,0,outlet-track_rad]) cube([track_rad,.1*in,track_rad], center=true);
            }
            
             //flat cut the ends inside the tubes
            translate([0,0,inlet]) cylinder(r=tube_rad-.1, h=50);
            translate([track_sep,0,outlet]) cylinder(r=tube_rad-.1, h=50);
            
            difference(){
                //cut off the track top
                hull(){
                    translate([0,0,inlet+track_rad*3/2]) cube([.1, track_rad*3, track_rad*3], center=true);
                    translate([track_sep,0,outlet+track_rad*3/2]) cube([.1, track_rad*3, track_rad*3], center=true);
                }
                
                //round the corners of the slope top
                for(i=[0:1]) mirror([0,i,0]) hull(){
                    translate([0,track_rad+track_wall/2,inlet]) sphere(r=track_wall/2);
                    translate([track_sep,track_rad+track_wall/2,outlet]) sphere(r=track_wall/2);
                }
            }
        }
    }
    
    //this is just the marble clearance
    if(solid <= 0){
            hull(){
                translate([0,0,inlet]) sphere(r=track_rad);
                translate([0,0,inlet+track_rad]) cube([track_rad,track_rad/4,track_rad], center=true);
            
                translate([track_sep,0,outlet]) sphere(r=track_rad);
                translate([track_sep,0,outlet+track_rad]) cube([track_rad,track_rad/4,track_rad], center=true);
            }
            
            //make the top square
            hull(){
                translate([0,0,inlet+track_rad]) cube([track_rad,track_rad,track_rad*2], center=true);
            
                translate([track_sep,0,outlet+track_rad]) cube([track_rad,track_rad,track_rad*3], center=true);
            }
           
            //and chamfer the top edges
            translate([0,0,tube_height+connector_height]) rotate([0,90,0]) cylinder(r=in*.33, h=track_sep, $fn=4);
    }
    
}


module marbulous_tube_hollow(height = 1, outlet=false){
    cylinder(r=connector_insert_rad, h=height-connector_height+.1);
}

module marbulous_tube(height = 1, outlet=false){
    height = height * tube_height;
    
    difference(){
        union(){
            //tube
            cylinder(r=tube_rad, h=height+.01);
            
            //connector
            translate([0,0,height]) intersection(){
                union(){
                    cylinder(r1=connector_rad, r2=connector_rad - slop, h=connector_height-1);
                    
                    //rounded top
                    translate([0,0,connector_height-1]) rotate_extrude(convexity = 10){
                        translate([connector_rad - slop - tube_wall/2, 0, 0])
                        circle(r = tube_wall/2);
                    }
                }
                cylinder(r=connector_rad+.666, h=connector_height, $fn=8);
            }
        }
        
        //chamfer the base for better insertion
        translate([0,0,-.1]) cylinder(r1=connector_insert_rad+slop*2, r2=connector_insert_rad, h=slop*4+.1, $fn=16);
        
        //tube hollow
        difference(){
            translate([0,0,-.1]) cylinder(r=connector_insert_rad, h=height-connector_height+.1);
            
            if(outlet == true){
                //the base of the track
                marbulous_track(solid = 1);
                
                //marble gooser - to make sure they don't jam up
                //translate([-connector_insert_rad-1,0,tube_inlet_height-track_rad-1]) rotate([90,0,0]) cylinder(r=11, h=wall/2, center=true, $fn=4);
                //don't think it's needed with the slope.
                
                //slope the base for printing
                hull(){
                    translate([0,0,tube_inlet_height]) intersection(){
                        sphere(r=connector_insert_rad+.1);
                        translate([0,0,-50]) cube([100,100,100], center=true);
                    }
                    translate([connector_rad+in*.1,0,connector_height]) cylinder(r=in*.1, h=1);
                }
            }
        }
        
        //exit hole
        if(outlet == true){
            marbulous_track(solid = -1);
            
            //slope the top so it looks nice
            hull(){
                translate([0,0,tube_inlet_height]) sphere(r=track_rad-1);
                translate([0,0,tube_inlet_height]) scale([1,1,track_rad/(connector_insert_rad+1)]) sphere(r=connector_insert_rad);
            }
        }
        
        translate([0,0,height-connector_height-.05]) cylinder(r1=connector_insert_rad, r2=connector_rad-tube_wall, h=connector_height);
        
        
        //connector hollow - top
        translate([0,0,height-.1]) 
                cylinder(r=connector_rad-tube_wall, h=connector_height+.2);
        
        //connector hollow - bottom
        translate([0,0,-.1]) 
                cylinder(r=connector_insert_rad, h=connector_height+.2);
    }
    
}