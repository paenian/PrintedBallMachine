include <../configuration.scad>;
use <../base.scad>;
use <bearing.scad>;
use <../screw_drop/screw_drop.scad>;
use <../screw_drop/bowl_drop.scad>;
use <../ball_return/ball_return.scad>;

peg_sep = 25.4;

gear_rad = in*3.9;
hole_rad = 8;

lift_rad = in*3;
num_balls = 17;

part = 10;

//laid out for printing
if(part == 0)
    rotate([270,0,0]) bearing_inlet();
if(part == 1)
    bearing();
if(part == 2)
    bearing(bearing=false, drive_gear=true);
if(part == 3)
    rotate([270,0,0]) bearing_outlet();
if(part == 4)
    rotate([270,0,0]) screw_drop(inlet_length=2, width=2, height = 2.45);
if(part == 9)
    bearing_fingergaurd();


if(part==10){
    assembled();
}

//assembled unit, 12x12, for sale.  Includes all parts except mounting pegs.
//This module requires 14 pegs, at least 6 of which are the insert type.
module assembled(){
    //draw in the pegboard & rear ball return
    basic_panel();
    
    //frilly outlet
    translate([in*8,0,peg_sep*7]) screw_drop(inlet_length=2, width=2, height = 2.45);
    
    //bearing lifter
    translate([0,0,in*3]) bearing_inlet();
    translate([in*4.5,-in*1-1-ball_rad*2-wall,in*7]) rotate([90,0,0]) mirror([0,0,1]) rotate([0,0,30]) bearing();
    translate([in*4.5,-in*1-1-ball_rad*2-wall,in*7+1]) rotate([90,0,0]) bearing_fingergaurd();
    translate([0,0,in*3]) bearing_outlet();
    
    //also need feet, pegs, and handle.
}

module bearing_fingergaurd(){
    
    //%render() translate([0,0,-ball_rad*2-wall/2-1]) bearing();
    
    finger_rad = 65;
    num_rings = 5;
    
    difference(){
        union(){
            cylinder(r=finger_rad, h=wall);
            translate([0,0,wall]) scale([1,1,wall/finger_rad]) sphere(r=finger_rad);
        }
        
        translate([0,0,-.1]){
            //screwhole
            cylinder(r=m3_rad+slop, h=wall*3);
            translate([0,0,wall]) cylinder(r=m3_cap_rad+slop, h=wall*3);
            
            //sector rings
            sector_ring(in_rad = m3_cap_rad+slop+wall*1.25, out_rad = finger_rad*(1/num_rings), spokes = 5);
            sector_ring(in_rad = finger_rad*(1/num_rings)+wall, out_rad = finger_rad*(2/num_rings), spokes = 7);
            sector_ring(in_rad = finger_rad*(2/num_rings)+wall, out_rad = finger_rad*(3/num_rings), spokes = 11);
            sector_ring(in_rad = finger_rad*(3/num_rings)+wall, out_rad = finger_rad*(4/num_rings), spokes = 13);
            sector_ring(in_rad = finger_rad*(4/num_rings)+wall, out_rad = finger_rad-wall, spokes = 17);
        }
    }
}

module sector_ring(in_rad = 5, out_rad = 25, spokes = 5, height = 10){
    slope = 2;
    difference(){
        //donut
        difference(){
            cylinder(r1=out_rad, r2=out_rad+slope, h=height);
            translate([0,0,-.5]) cylinder(r1=in_rad, r2=in_rad-slope, h=height+1);
        }
        
        //spokes
        for(i=[rands(1,360/spokes,1)[0]:360/spokes:361]) rotate([0,0,i]) {
            translate([0,125,-1]) hull(){
                cube([wall, 250,.1], center=true);
                translate([0,0,height+2]) cube([.1, 250,.1], center=true);
            }
        }
    }
}

//this is a mockup so I could size it quickly :-)
module gear_mockup(){
    translate([in*4.5,0,in*4]) rotate([90,0,0]){
        //the giant bearing
        %translate([0,0,in+1]) cylinder(r=gear_rad, h=in/2);
        for(i=[0:360/10:360]){
            %rotate([0,0,i]) translate([0,lift_rad,in+1]) hull(){
                sphere(r=ball_rad+wall);
                translate([0,0,in/2]) sphere(r=ball_rad+wall);
            }
        }
    }
}

//inlet ramp
module bearing_inlet(){
    slot = 8;
    
    motor_mount_height = 6.5;
    motor_mount_lift = motor_mount_height-1.1-wall;
    gear_inset = in+5.5;
    
    translate([0,0,in])
    difference(){
    union(){
            translate([0,0,0]) inlet(height=1, length=1, width=3, hanger_height=4);
            
            //inlet ramp
            translate([peg_sep,0,0]) track(rise=-.25*in, run=4*in, solid=1, end_angle=90, end_scale=[1.25,1,1]);
            intersection(){ //to cut off the front
                translate([peg_sep*1.25+4*in,-in+.3,-.25*in]) rotate([0,0,-90]) scale([1,1.25,1]) track(rise=-.25*in, run=4*in, solid=1, end_angle=90, end_scale=[1.25,1,1]);
                translate([0,-gear_inset+100,0]) cube([400,200,200], center=true);
            }
            
            //bearing mount
            translate([in*4.5,0,in*3]) rotate([90,0,0]){
                translate([0,-10,0]) scale([2.7,2,1]) cylinder(r1=10, r2=9.5, h = gear_inset, $fn=6);
                translate([0,0,in-1]) cylinder(r1=hole_rad-slop*2, r2=hole_rad-slop*4, h = in*3/4+4, $fn=6);
            }
            
            //motor mount
            //new motor mount - right angled beastie
           translate([in/2, -in, in*2+6]) rotate([90,0,0])  rotate([0,0,90]){
            
              %translate([0,0,1+ball_rad*2+wall/2+2]) rotate([0,0,8]) rotate([180,0,0]) bearing(bearing=false, drive_gear=true);
              translate([0,0,motor_mount_lift]) hull() rotate([0,0,-90]) motorHoles(1, motor_bump = motor_mount_height, slot=slot, support=true);
           }
                  
            scale([1,1.75,1]) hanger(solid=1, hole=[5,4], drop=in*3, rot=0);
            hanger(solid=1, hole=[4,4], drop=in*3.1, rot =0);
            hanger(solid=1, hole=[6,4], drop=in*3.75, rot = 37);
           
            //hanger(solid=1, hole=[0,4], drop=in*3.5, rot =-20);
            scale([1,1.75,1]) hanger(solid=1, hole=[2,5], drop=in*3.6, rot = 10);
            
        }
        
        translate([in*4.5,0,in*3]) rotate([90,0,0]){
                translate([0,0,in*1.5+.1]) cylinder(r=1.45, r2=1.6, h = in*1.25, $fn=30, center=true);
            }
            
                        //new motor mount - right angled beastie
           translate([in/2, -in, in*2+6]) rotate([90,0,0])  rotate([0,0,90]){
              translate([0,0,motor_mount_lift]) rotate([0,0,-90]) motorHoles(0, motor_bump = motor_mount_height, slot=slot);
           }
        
        hanger(solid=-1, hole=[5,4], drop=in*2);
        hanger(solid=-1, hole=[4,4], drop=in*2, rot =-20);
        hanger(solid=-1, hole=[6,4], drop=in*1, rot = 20);
           
        //hanger(solid=-1, hole=[1,2], drop=in*6.5);
           
        //hanger(solid=-1, hole=[0,5], drop=in*3.5, rot =-20);
        hanger(solid=-1, hole=[2,5], drop=in*3.9, rot = 0);
    }
}



//outlet ramp
module bearing_outlet(){
	$fn=30;

	motor_rad = 33/2;
	motor_mount_rad = 38/2;
	m3_rad = 1.7;
    gear_inset = in+5.5;
    
    motor_bump=3.5;
    
    support_step=8;
    
    translate([0,0,in])
    difference(){
        union(){
            //outlet ramp
            #translate([in*8.1,0,in*4.6]) mirror([i,0,0]) track(rise=.5*in, run=4.1*in, solid=1, end_angle=90, end_scale=[1.25,1,1]);
            
            intersection(){ //to cut off the front
                translate([peg_sep*1.25+3.745*in,-in+.9,5.1*in]) rotate([0,0,-90]) scale([1,1.25,1]) track(rise=.125*in, run=4*in, solid=1, end_angle=90, end_scale=[1.25,1,1]);
                translate([0,-gear_inset+100,0]) cube([400,200,400], center=true);
            }
            
            //hangers
            hanger(solid=1, hole=[5,7], drop=in, rot=-20);
            hanger(solid=1, hole=[8,7], drop=in*1.5, rot=0);
            
            //this prevents the balls from rolling out prematurely
            translate([in*4.5,0,in*3]) {
                for(i=[2:8]) hull() {
                    rotate([0,37-i*support_step,0]) translate([lift_rad-in*3/16,0,0]) rotate([90,0,0]) cylinder(r1=1+(i)/4, r2=2+(i)/2, h=gear_inset);
                    rotate([0,37-(i+1)*support_step,0]) translate([lift_rad-in*3/16,0,0]) rotate([90,0,0]) cylinder(r1=1+(i+1)/4, r2=2+(i+1)/2, h=gear_inset);
                }
                //first ramp up
                hull(){
                    rotate([0,37-2*support_step,0]) translate([lift_rad-in*3/16,0,0]) rotate([90,0,0]) cylinder(r1=1+(1+1)/4, r2=2+(1+1)/2, h=gear_inset);
                    rotate([0,37-(1)*support_step,0]) translate([lift_rad-in*3/16,0,0]) rotate([90,0,0]) cylinder(r1=1+(0+1)/4, r2=2+(0+1)/2, h=gear_inset*.8);
                }
                //last along the track
                translate([0,-in+1,0]) for(i=[9:13]) hull() {
                    rotate([0,37-i*support_step,0]) translate([lift_rad-in*3/16-i*2+18,0,0]) rotate([90,0,0]) cylinder(r1=1+(-i+17)/4, r2=8, h=gear_inset-in+1);
                    rotate([0,37-(i+1)*support_step,0]) translate([lift_rad-in*3/16-i*2+16,0,0]) rotate([90,0,0]) cylinder(r1=1+(-i+16)/4, r2=8, h=gear_inset-in+1);
                }
                
            }
        }
        
        hanger(solid=-1, hole=[5,7], drop=in-1);
        hanger(solid=-1, hole=[8,7], drop=in*1.5);
        
        //cut off the next track
        #translate([in*8+100-1,0,in*4.4]) cube([200,200,200], center=true);
    }
}

module d_slot(shaft=6, height=10, tolerance = .2, dflat=.25, double_d=false, round_inset=3, round_height=5, round_rad=3.25/2){
    translate([0,0,-.1]){
       difference(){ 
           cylinder(r=shaft/2+tolerance, h=height+.01);
           translate([-shaft/2,shaft/2-dflat,0]) cube([shaft, shaft, height+.01]);
           if(double_d==true){
               mirror([0,1,0]) translate([-shaft/2,shaft/2-dflat,0]) cube([shaft, shaft, height+.01]);
           }
           
           //this is the rounded inset, for securing the gear
           difference(){
               cylinder(r=shaft/2+tolerance*2, h=round_inset+round_height);
               
               //now the screwhole
               translate([0,0,-.1]) cylinder(r=round_rad*2, h=round_inset+.15);
               translate([0,0,round_inset]) cylinder(r1=round_rad*2, r2=round_rad, h=round_rad+.1);
               translate([0,0,round_inset+round_rad]) cylinder(r=round_rad, h=height);
           }
       }
    }
}

module bearing(bearing=true, drive_gear=false){
    //set variables
    // bearing diameter of ring
    D=in*5.25;
    // thickness
    T=ball_rad*2+wall/2;
    // clearance
    tol=.25;
    number_of_planets=7;
    number_of_teeth_on_planets=11;
    approximate_number_of_teeth_on_sun=21;
    ring_outer_teeth = 71;
    // pressure angle
    P=45;//[30:60]
    // number of teeth to twist across
    nTwist=1;
    // width of hexagonal hole
    w=hole_rad*2;

    DR=0.5*1;// maximum depth ratio of teeth
    
    //derived variables
    m=round(number_of_planets);
    np=round(number_of_teeth_on_planets);
    ns1=approximate_number_of_teeth_on_sun;
    k1=round(2/m*(ns1+np));
    k= k1*m%2!=0 ? k1+1 : k1;
    ns=k*m/2-np; //actual number of teeth on the sun
    echo(ns);
    nr=ns+2*np; //number of teeth on the inside of the ring gear
    pitchD=0.9*D/(1+min(PI/(2*nr*tan(P)),PI*DR/nr));
    pitch=pitchD*PI/nr;
    //echo(pitch);
    helix_angle=atan(2*nTwist*pitch/T);
    //echo(helix_angle);
    phi=$t*360/m;
    
    //%translate([0,0,-50]) cylinder(r=gear_rad, h=50);
    
        if(drive_gear==true){
            //motor drive gear - just a planet with a motor attachment.
            translate([0,0,T/2]) difference(){
                union(){
                    //%cylinder(r=18, h=40);
                    herringbone(9,pitch,P,DR,tol,helix_angle,T);
                    //little bump on top
                    translate([0,0,motor_bump]) cylinder(r=motor_shaft, h=T+motor_bump, center=true);
                }
            
                //d shaft
                //translate([0,0,-30]) d_slot(shaft=motor_shaft, height=60, dflat=motor_dflat);
                
                d_height = T;
                round_inset = 10;
                round_height = 20-5.5-round_inset;
                round_rad = 3.25/2;
                translate([0,0,-T/2-.2]) d_slot(shaft=7.1, height=d_height+round_height+round_inset, dflat=.625, double_d=true, round_inset=round_inset, round_height=round_height, round_rad=round_rad);
            }
        }
    
    if(bearing==true)
    translate([0,0,T/2]){
        //ring gear
        difference(){
            mirror([0,1,0])
            herringbone(ring_outer_teeth,pitch,P,DR,tol,helix_angle,T);
            //inner ring
            herringbone(nr,pitch,P,DR,-tol,helix_angle,T+0.2);
            
            //ball holes
            for(i=[0:360/num_balls:359]) rotate([0,0,i]) translate([lift_rad,0,0]) hull(){
                translate([0,0,-wall/2]) sphere(r=ball_rad+wall/2);
                //translate([0,0,-T/2-.1]) cylinder(r=ball_rad, h=5);
                translate([-in/4,0,ball_rad+wall/2]) scale([1,1.1,1]) sphere(r=ball_rad+wall/2);
            }
        }
        

        
        //sun gear
        rotate([0,0,(np+1)*180/ns+phi*(ns+np)*2/ns])
        difference(){
            mirror([0,1,0])
                herringbone(ns,pitch,P,DR,tol,helix_angle,T);
            //cylinder(r=w/sqrt(3),h=T+1,center=true,$fn=6);
            translate([0,0,-T/2-.1]) cylinder(r1=hole_rad, r2=hole_rad-slop*2, h = in+1, $fn=6);
        }
        
        //planets
        for(i=[1:m])rotate([0,0,i*360/m+phi])translate([pitchD/2*(ns+np)/nr,0,0])
            rotate([0,0,i*ns/m*360/np-phi*(ns+np)/np-phi]){
                difference(){
                    herringbone(np,pitch,P,DR,tol,helix_angle,T);
                    
                    //slot to free the gears
                    cube([4,14,100], center=true);
                }
            }
        }
}
