include <../configuration.scad>;
use <../base.scad>;
use <torricelli_trumpet.scad>;

peg_sep = 25.4;

dflat=.2;

%pegboard([12,12]);

part = 10;

if(part == 0)
    rotate([-90,0,0]) bowl_drop(inlet_length=5, height = 2-.125, rad=2.5, height_scale=.55*in, lower=11.3);

if(part == 1)
    rotate([-90,0,0]) bowl_drop(inlet_length=6, height = 2-.125, rad=3.5, height_scale=.55*in-.191*in, lower=11.3+4.8);

if(part == 2)
    rotate([0,270,0]) bowl_drop_inlet(length=5);

if(part == 3)
    rotate([0,270,0]) bowl_drop_outlet(extend=3);

if(part == 4)
    rotate([0,270,0]) shallow_bowl_drop(inlet_length=6, height = 2-.125, rad=3.5, height_scale=.55*in-.191*in, lower=11.3+4.8);

if(part == 10){
    //this requres a special collector.
    translate([peg_sep*7,0,peg_sep*4]) shallow_bowl_drop(inlet_length=5, height = 2-.125, rad=2.5);
    
    translate([0,0,peg_sep*4]) bowl_drop_inlet(length=6);
    
    translate([peg_sep*9,0,peg_sep*2]) bowl_drop_outlet(extend=3);
}

//inlet ramp - get some speed
module bowl_drop_inlet(length=4){
    slope_module(size = [length, -.5], width=3, inlet = NORMAL);
}

//catch the ball, and pass it on
module bowl_drop_outlet(extend=3){
    extra = 4;
    angle = -6;
    difference(){
        union(){
            translate([0,0,-peg_sep*2]) slope_module(size = [2, -.5], width=1, inlet = NORMAL);
            
            //reach out for the ball
            translate([peg_sep/2,-peg_sep+extra,peg_sep/2+wall]) rotate([0,0,-90]) track_trough(length=(extend-.5)*in+extra, angle=angle);
            
            //catcher
            translate([peg_sep*.5,-peg_sep*.5,peg_sep*.5+wall+ball_rad*.5]) rotate([angle-1,0,0]) translate([0,-peg_sep*extend,0]) sphere(r=ball_rad*2.5);
        }
        
        //open the catcher up
        translate([peg_sep*.5,-peg_sep*.5,peg_sep*.5+wall]) rotate([angle-1,0,0]) translate([0,-peg_sep*extend,ball_rad*3]) cube([ball_rad*6, ball_rad*6, ball_rad*6], center=true);
        hull(){
            translate([peg_sep*.5,-peg_sep*.5,peg_sep*.5+wall]) rotate([angle-1,0,0]) translate([0,-peg_sep*extend,0]) sphere(r=ball_rad+wall);
            translate([peg_sep*.5,-peg_sep*.5,peg_sep*.5+wall]) rotate([angle-1,0,0]) translate([0,-peg_sep*extend,0]) rotate([6,0,0]) translate([0,0,ball_rad*1.333]) sphere(r=ball_rad*2.5);
        }
        
        //hollow the track
        translate([peg_sep/2,-peg_sep+extra+.5,peg_sep/2+wall]) rotate([0,0,-90]) track_hollow(length=(extend-.5)*in+extra+1, angle=angle);
        
        //slope the ball in
        hull(){
            translate([peg_sep*.5,-peg_sep*.5,peg_sep*.5+wall]) sphere(r=ball_rad+wall);
             translate([peg_sep*.5,-peg_sep*.5,peg_sep*.5+wall]) rotate([angle-1,0,0]) translate([0,-peg_sep*extend,0]) sphere(r=ball_rad+wall);
        }
    }
}

module shallow_bowl_drop(inlet_length=2, inlet_width=3, height = 2.5, rad = 1.5){
    
    sphere_rad = rad*in;
    sphere_scale = height/rad*in;
    
    
    translate([0,0,in])
    difference(){
        union(){
            inlet(height=1, length=inlet_length, width=inlet_width, hanger_height=1, outlet=NONE);
            intersection(){
                translate([sphere_rad,-sphere_rad,0]) scale([1,1,1]) sphere(r=sphere_rad);
            }
        }
    }
}

module bowl_drop(inlet_length=2, inlet_width=3, height = 2.5, rad = 1.5, height_scale = in, lower = -.2){ 
    
    //height_scale = in*3/4;
    //lower = 6.24;
    
    translate([0,0,in])
    difference(){
        union(){
            inlet(height=1, length=inlet_length, width=inlet_width, hanger_height=1, outlet=NONE);
        
        
            //rim
            difference(){
                union(){
                    translate([in*rad,-in*rad,0]) cylinder(r=in*rad, h = in/2);
                    //translate([in*rad,-in*rad,0]) cylinder(r=in*rad, h = in/2);
                }
                
                translate([0,-in*inlet_width,0]) cube([in*rad, in*inlet_width, in]);
            }
            
            //trumpet
            translate([in*rad,-in*rad,in+wall*2-1-lower]) rotate([0,90,0]) horn(.2, 11.25, [height_scale, in*rad, in*rad]);
            
        }
        
        //inner cone
        translate([in*rad,-in*rad,in+wall*2-.9-lower]) rotate([0,90,0]) horn(.2, 11.25, [height_scale, in*rad-wall*2, in*rad-wall*3]);
        
        //rim hollow
        translate([in*rad,-in*rad,wall*2-.8]) cylinder(r=in*rad-wall, h = in*2);
        
        //let the marbles out
        #translate([in*rad,-in*rad,-in]) 
        cylinder(r=track_rad, h=height*8*in, center=true);
        
        //cut the base
        translate([0,0,-200-height*in]) cube([400,400,400], center=true);
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