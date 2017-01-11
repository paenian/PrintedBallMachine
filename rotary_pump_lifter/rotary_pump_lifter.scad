include <../configuration.scad>;
use <../base.scad>;
use <../screw_drop/screw_drop.scad>;
use <../screw_drop/bowl_drop.scad>;
use <../ball_return/ball_return.scad>;

peg_sep = 25.4;

gear_rad = in*3.9;
hole_rad = 8;

lift_rad = in*3;
num_balls = 17;

part = 9;

//next section
%translate([in*12,0,in*1]) inlet();
%translate([in*12,0,in*4]) inlet();

//laid out for printing
if(part == 0)
    rotate([270,0,0]) rotary_inlet();
if(part == 1)
    rotary_outlet();
if(part == 2)
    rotary_tube(height = 4);

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
}


//inlet ramp
module bearing_inlet(){
    translate([0,0,in])
    difference(){
    union(){
            translate([0,0,0]) inlet(height=1, length=1, width=3, hanger_height=4);
            
            //inlet ramp
            translate([peg_sep,0,0]) track(rise=-.25*in, run=4*in, solid=1, end_angle=90, end_scale=[1.33,1,1]);
            
            //bearing mount
            translate([in*4.5,0,in*3]) rotate([90,0,0]){
                translate([0,-10,0]) scale([2.7,2,1]) cylinder(r1=10, r2=9.5, h = in+1, $fn=6);
                translate([0,0,in-1]) cylinder(r1=hole_rad-slop*2, r2=hole_rad-slop*4, h = in*3/4-1, $fn=6);
            }
            
            //motot mount
            //new motor mount - right angled beastie
           translate([in/2, -in, in*2+6]) rotate([90,0,0])  rotate([0,0,90]){
            
              %translate([0,0,1+ball_rad*2+wall/2+2]) rotate([0,0,8]) rotate([180,0,0]) bearing(bearing=false, drive_gear=true);
              translate([0,0,-.1]) hull() rotate([0,0,-90]) motorHoles(1, slot=5);
           }
                  
            hanger(solid=1, hole=[5,4], drop=in*3.4, rot=5);
            hanger(solid=1, hole=[4,4], drop=in*3.5, rot =-15);
            hanger(solid=1, hole=[6,4], drop=in*3.7, rot = 25);
           
            //hanger(solid=1, hole=[0,4], drop=in*3.5, rot =-20);
            hanger(solid=1, hole=[2,5], drop=in*3.5, rot = 11);
            
        }
        
        translate([in*4.5,0,in*3]) rotate([90,0,0]){
                translate([0,0,in*1.5+.1]) cylinder(r=1.45, r2=1.6, h = in*1.25, $fn=30, center=true);
            }
            
                        //new motor mount - right angled beastie
           translate([in/2, -in, in*2+6]) rotate([90,0,0])  rotate([0,0,90]){
              rotate([0,0,-90]) motorHoles(0, slot=5);
           }
        
        hanger(solid=-1, hole=[5,4], drop=in*6.5);
        hanger(solid=-1, hole=[4,4], drop=in*3.5, rot =-20);
        hanger(solid=-1, hole=[6,4], drop=in*3.5, rot = 20);
           
        //hanger(solid=-1, hole=[1,2], drop=in*6.5);
           
        //hanger(solid=-1, hole=[0,5], drop=in*3.5, rot =-20);
        hanger(solid=-1, hole=[2,5], drop=in*3.5, rot = 20);
    }
}



//outlet ramp
module bearing_outlet(){
	$fn=30;

	motor_rad = 33/2;
	motor_mount_rad = 38/2;
	m3_rad = 1.7;
    
    motor_bump=3.5;
    
    support_step=8;
    
    translate([0,0,in])
    difference(){
        union(){
            //outlet ramp
            translate([in*8,0,in*4.5]) mirror([i,0,0]) track(rise=.75*in-2, run=4*in, solid=1, end_angle=90, end_scale=[1.33,1,1]);
            
            //hangers
            hanger(solid=1, hole=[5,7], drop=in, rot=-20);
            hanger(solid=1, hole=[8,6], drop=in*.5, rot=-10);
            
            //this prevents the balls from rolling out prematurely
            translate([in*4.5,0,in*3]) {
                for(i=[2:8]) hull() {
                    rotate([0,35-i*support_step,0]) translate([lift_rad-in*3/16,0,0]) rotate([90,0,0]) cylinder(r1=1+(i)/4, r2=2+(i)/2, h=in);
                    rotate([0,35-(i+1)*support_step,0]) translate([lift_rad-in*3/16,0,0]) rotate([90,0,0]) cylinder(r1=1+(i+1)/4, r2=2+(i+1)/2, h=in);
                }
                hull(){
                    rotate([0,35-2*support_step,0]) translate([lift_rad-in*3/16,0,0]) rotate([90,0,0]) cylinder(r1=1+(1)/4, r2=2+(1)/2, h=in);
                    rotate([0,35-(1)*support_step,0]) translate([lift_rad-in*3/16,0,0]) rotate([90,0,0]) cylinder(r1=1+(0+1)/4, r2=2+(0+1)/2, h=in*.8);
                }
            }
        }
        
        *translate([in*6.5, -in+2-motor_bump, in*6.8+2.5]) rotate([90,0,0])  rotate([0,0,0]){
            //bearing(bearing=false, drive_gear=true);
            rotate([0,0,-90]) motorHoles(0, slot=2);
        }
        
        hanger(solid=-1, hole=[5,7]);
        hanger(solid=-1, hole=[8,6]);
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
                    translate([0,0,motor_bump/2]) cylinder(r=motor_shaft, h=T+motor_bump, center=true);
                }
            
                //d shaft
                translate([0,0,-30]) d_slot(shaft=motor_shaft, height=60, dflat=motor_dflat);
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
