include <configuration.scad>
use <base.scad>

hole_rad = 6.5/2;
hole_sep = 25.4;

hanging_hole_rad = 3*in/16;

%cube([in,in,in], center=true);

%cube([in*1.5,in*1.5,in/2], center=true);

width = 4.75;
height = 3.125;
handle_thick = in*.5;

part = 1;

%translate([-in*1.5,in*.5,0]) handle();

if(part == 0)
    translate([0,0,handle_thick/2]) handle();

if(part == 1)
    mirror([1,0,0]) rotate([90,0,0]) handle_mount();

if(part == 2)
    rotate([90,0,0]) handle_mount();

if(part == 10)
    assembled();

module assembled(){
    translate([0,0,handle_thick/2]) handle();
    
    translate([in*1.5,-in*.5,-in*.75]) rotate([90,0,0]) handle_mount();
}

//this is a double-peg-mounted cylinder to attach the handle to.
module handle_mount(){
    taper = in/32;
    
    height = rear_gap - .25*in;  //the gap should be rear_gap.  The handle protrudes 1/4" behind the pegboard, but the handle mount is mounted by pegboard hooks - so it's 1"-1/4", with the wall provided by the pegs.
    
    inset = 1;
    
    difference(){
        union(){
            //hangers
            translate([in/2*0,wall,in]) hull() {
                hanger(solid=1, hole=[1,1], drop = in*1);
                hanger(solid=1, hole=[0,1], drop = in*2);
            }
            
            //mounting plate
            difference(){
                hull(){
                    translate([-in/2, 0, in/2]) rotate([-90,0,0]) cylinder(r=in/3, h=height);
                    translate([in/2, 0, in/2]) rotate([-90,0,0]) cylinder(r=in/3, h=height);
                    translate([-in/2, 0, -in*1.5]) rotate([-90,0,0]) cylinder(r=in/3, h=height);
                }
                //clearance for the screw holding the handle in
                translate([-in/2, -1, -in*1.5]) rotate([-90,0,0]) cylinder(r=in/4, h=height+2);
            }
            
            % rotate([-90,0,0]) cylinder(r=in, h=height);
            
            //handle hanger
            for(i=[-1,1]) translate([in*.5*i,0,in*.5]) {
                //rests on here
                rotate([-90,0,0]) cylinder(r1=hanging_hole_rad - slop, r2=hanging_hole_rad - slop-taper, h=height+handle_thick-inset);
                translate([0,height+handle_thick-inset,0]) sphere(r=hanging_hole_rad - slop-taper);
                translate([0,height+handle_thick-inset,0]) rotate([-45,0,0]) cylinder(r1=hanging_hole_rad - slop-taper, r2=hanging_hole_rad - slop-taper*2, h=in*.25);
                translate([0,height+handle_thick-inset,0]) rotate([-45,0,0]) translate([0,0,in*.25]) sphere(r=hanging_hole_rad - slop-taper*2);
            }
        }
        
        translate([in/2*0,wall,in]) {
            hanger(solid=-1, hole=[1,1]);
            hanger(solid=-1, hole=[0,1]);
        }
    }
}

module handle(){
    min_rad = in/8;
    
    thick = handle_thick - min_rad*2;
    
    difference(){
        minkowski(){
            difference(){
                hull(){
                    cube([width*in, (height-.5)*in, thick], center=true);
                    translate([0,-.5*in,0]) cube([.125*in, (height-.5)*in, thick], center=true);
                }
                
                //hanging holes - these are used to mount it to the pegboard, too.
                for(i=[-2,2]) translate([i*in,-1*in,0]) cylinder(r=hanging_hole_rad+min_rad, h=200, center=true);
                
                //step up the middle holes
                for(i=[-1:1]) translate([i*in,-1*in-((1-abs(i))*in/4),0]) cylinder(r=hanging_hole_rad+min_rad, h=200, center=true);
                
                
                hull(){
                    translate([.55*in,.5*in,0]) rotate([0,0,45/2]) cylinder(r=(height-.6)*in/2, h=200, center=true, $fn=8);
                    translate([-.55*in,.5*in,0]) rotate([0,0,45/2]) cylinder(r=(height-.6)*in/2, h=200, center=true, $fn=8);
                }
            }
            sphere(r=min_rad, $fn=8);
        }
        
        translate([0,(height-1)/2*in,1/2*in]) cube([6*in, 1*in, 1*in], center=true);
        
        //pegboard holes
        for(i=[-2:1:2]) translate([i*in,1*in,0]) cylinder(r=hole_rad, h=200, center=true);
    }
}