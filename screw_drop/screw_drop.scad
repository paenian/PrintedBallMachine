include <../configuration.scad>;
use <../base.scad>;

peg_sep = 25.4;

dflat=.2;

%pegboard([10,10]);

//uncomment for printing
//!rotate([-90,0,0])
screw_drop(height = 2.55);
translate([peg_sep*3,0,-peg_sep*4])  reverse_module();

!translate([0,0,peg_sep*4]) screw_drop(inlet_length=2, height = 1.45);
translate([peg_sep*4,0,peg_sep])  reverse_module();

//inlet ramp
module screw_drop(inlet_length=1, exit=1, height = 2.5, width=3){
    
    turns = floor(height);
    segments = turns*4+1+((exit==-1)?3:2);
    
    echo(turns);
    echo(segments);
    drop = (height*in)/segments;
    
    
    
    translate([0,0,in])
    difference(){
        union(){
            inlet(height=1, width=width, length=inlet_length, hanger_height=1);
        
            //prevents excess speed on the ball in
            translate([(inlet_length-1)*in,-wall,0]) hull(){
                //big corner
                #translate([-wall*3,0,0]) cube([wall*3,wall,wall]);
                
                //bottom
                #translate([0,-in/2,0]) cube([wall/2,in/2,wall]);
                
                //side
                cube([wall/2,wall,in]);
            }
        
        
            //inlet screw down
            translate([peg_sep*inlet_length,0,0]){
                track(rise=-drop*2, run=2*in, solid=1, end_angle=90);
            
                for(i=[0:turns-1]) translate([-peg_sep*2,0,-drop-drop*4*i]) {
                    spiral(drop=drop, turns=4);
                }
                
                //translate([-peg_sep*2,0,-drop*5]) spiral(drop=drop, turns=4);
            
                //exit right
                if(exit == 1){
                    difference(){
                        translate([peg_sep*1+.5,-peg_sep+1,-drop*(turns*4+1+1)]) mirror([1,1,0]) track(rise=-drop, run=in, solid=1, end_angle=90);
                        translate([peg_sep*4+50-1,0,0]) cube([100,100,200], center=true);
                    }
                }
                
                //exit left
                if(exit == -1){
                    difference(){
                        translate([peg_sep*0+.5-10,-peg_sep+.1-peg_sep,-drop*(turns*4+1+2+1)]) mirror([0,1,0]) track(rise=drop*2, run=in*2+10, solid=1, end_angle=90);
                        translate([peg_sep*0-50+1,0,0]) cube([100,200,200], center=true);
                    }
                }
                
                //exit drop
                if(exit == 0){
                    
                }
            }
            hanger(solid=1, hole=[2+inlet_length,2], drop=in*(1.1+turns), rot=0);
        }
        
        hanger(solid=-1, hole=[2+inlet_length,2], drop=in*(1.1+turns));
        
        //the back isn't quite flat
        translate([peg_sep*2,100,0]) cube([200,200,200], center=true);
    }
}

module spiral(drop = .25*in, turns=4){
    //spiral!
        if(turns >= 1)
            translate([peg_sep*3-.3,-peg_sep*2+.1,-drop*2]) mirror([0,1,0]) track(rise=drop, run=in+.2, solid=1, end_angle=90);
        if(turns >= 2) 
            translate([peg_sep*2+.1,-peg_sep+.1+.5,-drop*3]) mirror([1,1,0]) track(rise=drop, run=in+.2, solid=1, end_angle=90);
        if(turns >= 3)
            translate([peg_sep*3+.5,.1,-drop*4]) mirror([1,0,0]) track(rise=drop, run=in+.2, solid=1, end_angle=90);
        if(turns >= 4)
            translate([peg_sep*3-.2,.1,-drop*4]) mirror([0,0,0]) track(rise=-drop, run=in+.2, solid=1, end_angle=90);
}

//outlet ramp
module bearing_outlet(){
	$fn=30;

	motor_rad = 33/2;
	motor_mount_rad = 38/2;
	m3_rad = 1.7;
    
    support_step=8;
    
    translate([0,0,in])
    difference(){
        union(){
            //outlet ramp
            translate([in*8,0,in*4.5])
            translate([peg_sep,0,0]) mirror([i,0,0]) track(rise=.75*in-2, run=5*in, solid=1, end_angle=90, end_scale=[1.33,1,1]);
            
            //prevents the balls from rolling out prematurely
            for(i=[1:8]){
                translate([in*4.5,0,in*3]) hull(){
                    rotate([0,35-i*support_step,0]) translate([lift_rad-in*3/16,0,0]) rotate([90,0,0]) cylinder(r1=1+(i)/4, r2=2+(i)/2, h=in);
                    rotate([0,35-(i+1)*support_step,0]) translate([lift_rad-in*3/16,0,0]) rotate([90,0,0]) cylinder(r1=1+(i+1)/4, r2=2+(i+1)/2, h=in);
                }
            }

				//motor mounting lugs
				translate([in*7, 0, in*6.5]) rotate([90,0,0]){
					difference(){
						union(){
							translate([-motor_mount_rad,0,0]) cylinder(r1=in/2, r2=m3_rad+wall, h=in-wall);

							//the right mount is curvy
							for(i=[-15:5:15]) translate([-motor_mount_rad,0,0]) rotate([0,0,i]) translate([motor_mount_rad*2,0,0]) hull(){
								cylinder(r1=in/2, r2=m3_rad+wall, h=in-wall);
							}
						}
						translate([-motor_mount_rad,0,in/2]) cylinder(r=m3_rad, h=in+wall);
						translate([-motor_mount_rad,0,-.2]) cylinder(r=m3_rad, h=in/2);
						translate([-motor_mount_rad,0,in/2-3.2]) cylinder(r=7/2, h=3, $fn=6);
						
						//the right mount is curvy
						for(i=[-15:1:15]) translate([-motor_mount_rad,0,-.1]) rotate([0,0,i]) translate([motor_mount_rad*2,0,0]) {
							translate([0,0,in/2]) cylinder(r=m3_rad, h=in+wall);
							translate([0,0,-.2]) cylinder(r=m3_rad, h=in/2);
							translate([0,0,in/2-3.2]) cylinder(r=7/2, h=3, $fn=6);
						}
						
						//motor clearance
						*translate([-motor_mount_rad,0,0]) rotate_extrude(){
							translate([motor_mount_rad,0,-.1]) square([motor_rad*2, in*2], center=true);
						}

						//motor clearance
						for(i=[-30:15:90]) translate([-motor_mount_rad,0,-.1]) rotate([0,0,i]) translate([motor_mount_rad,0,0]) hull(){
							cylinder(r=motor_rad, h=in*2);
							//translate([50,0,0]) cylinder(r=motor_rad, h=in*2);
						}
					}
        		}

            hanger(solid=1, hole=[6,7], drop=in);
            hanger(solid=1, hole=[9,7], drop=in*1.5);
        }
        hanger(solid=-1, hole=[6,7], drop=in);
        hanger(solid=-1, hole=[9,7], drop=in*1.5);
    }
}

module bearing(bearing=true, drive_gear=false){
    //set variables
    // bearing diameter of ring
    D=in*5.25;
    // thickness
    T=ball_rad*2+wall;
    // clearance
    tol=.4;
    number_of_planets=5;
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
    
    %translate([0,0,-50]) cylinder(r=gear_rad, h=50);
    
    translate([0,0,T/2]){
        //ring gear
        difference(){
            mirror([0,1,0])
            herringbone(ring_outer_teeth,pitch,P,DR,tol,helix_angle,T);
            //inner ring
            herringbone(nr,pitch,P,DR,-tol,helix_angle,T+0.2);
            
            //ball holes
            for(i=[0:360/num_balls:359]) rotate([0,0,i]) translate([lift_rad,0,0]) hull(){
                translate([0,0,-wall/2]) sphere(r=ball_rad+wall);
                //translate([0,0,-T/2-.1]) cylinder(r=ball_rad, h=5);
                translate([-in/4,0,ball_rad+wall/2]) sphere(r=ball_rad+wall/2);
            }
        }
        
        //motor drive gear - just a planet with a motor attachment.
        *translate([100+2,0,0]) difference(){
            union(){
                //%cylinder(r=18, h=40);
                herringbone(17,pitch,P,DR,tol,helix_angle,T);
            }
            
            //d shaft
            d_slot(shaft=shaft, height=20, dflat=dflat);
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
                herringbone(np,pitch,P,DR,tol,helix_angle,T);
            }
        }
        
        
}

module d_slot(shaft=6, height=10, tolerance = .2, dflat=.25, $fn=30){
    translate([0,0,-.1]){
       difference(){ 
           cylinder(r1=shaft/2+tolerance, r2=shaft/2+tolerance/2, h=height+.01);
           translate([-shaft/2,shaft/2-dflat,0]) cube([shaft, shaft, height+.01]);
           translate([-shaft/2,-shaft/2-shaft+dflat,0]) cube([shaft, shaft, height+.01]);
       }
    }
}

//next section
%translate([in*9,0,in]) inlet(height=5);