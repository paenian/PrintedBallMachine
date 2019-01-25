include <../configuration.scad>;
use <../base.scad>;
use <easy_print_bearing.scad>;
use <bearing.scad>;

//chain variables
width = in-1;
length = in;
hook_width = wall;
core = width-wall-wall-1;
shaft=3;
thickness = wall;
groove_rad = 2;

idler_shaft=4;

jut = 11;


$fn=60;

stab_rad=4; //radius of stabilizer triangle

//this is the face of the driving gear - it should be related to the length a bit better.
face = in-shaft*2-1;

//render everything
part=2;

//parts for laser cutting
if(part == 0)
    link(ball_grabber=true);
if(part == 1)
    link(ball_grabber=false);
if(part == 2)
    drive_gear();
if(part == 3)
    idler_gear2();
if(part == 4)
    cl_inlet();
if(part == 5)
    cl_outlet();
if(part == 6){
    link(ball_grabber=true);
    translate([length,0,0]) link(ball_grabber=false);
    translate([length,0,0]) translate([length,0,0]) rotate([0,angle,0]) link(ball_grabber=false);
}

if(part == 11){
    link_loop();
}

clearance_rad = 53;
angle = 60;
if(part==10){
    
    
    //todo: place these correctly
    cl_inlet();
    
    //drive gear
    translate([in*2.5,in*1.5,in*1.5]) rotate([90,0,0]) {
        translate([length/2,0,-in*3-thickness-.5]) rotate([90,0,0]) drive_gear();
        rotate([0,0,0]) link_loop();
    }
    
    cl_outlet();
}

module link_loop(){
    //do a full loop of links
    link(ball_grabber=false);
    translate([length,0,0]) rotate([0,angle,0]) link(ball_grabber=true);
    translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) link(ball_grabber=false);
    translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) link(ball_grabber=true);
    translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) link(ball_grabber=false);
    translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) link(ball_grabber=true);
}

module drive_gear(facets = 6, thick=in-4.5){
    translate([0,clearance_rad+wall,0]) difference(){
        union(){
            cylinder(r=face, h=thick, center=true, $fn=facets);
            
            //alignment groove
            hull() for(i=[0:60:359]) rotate([0,0,i]) {
                translate([0,face*cos(180/facets),0]) rotate([0,90,0]) cylinder(r=groove_rad-slop/2, h=face-thickness, center=true, $fn=6);
            }
        
            //clearance for the balls
            %cylinder(r=32, h=2, center=true);

            //clearance for the arms - ball loading
            %cylinder(r=clearance_rad, h=1, center=true);
            
            //extra bump for the motor
            translate([0,0,motor_bump/2]) cylinder(r=motor_shaft, h=thick+motor_bump, center=true);
            
            
        }
        
        //d shaft
        translate([0,0,-in/2-.1]) d_slot(shaft=motor_shaft, height=60, dflat=motor_dflat, double_d=true, round_inset = in-10, round_height = 4.25);
    }
}

module idler_gear2(){
    bearing();
}

module idler_gear(facets=6){
    outer_rad = face*cos(180/facets)-1.25;
    inner_rad = idler_shaft-1;
    height = in/2;
    num_rollers = 8;
    translate([0,clearance_rad+wall,0]) difference(){
        union(){
            difference(){
                union(){
                    cylinder(r=face, h=height, center=true, $fn=facets);
                    case(width=height,out_rad1=outer_rad,out_rad2=outer_rad,in_rad=inner_rad);
                    
                    //alignment groove
                    hull() for(i=[0:60:359]) rotate([0,0,i]) {
                        translate([0,face*cos(180/facets),0]) rotate([0,90,0]) cylinder(r=groove_rad-slop/2, h=face-thickness, center=true, $fn=6);
                        }
                }
                
                //the bearing race
                ring(width=height,out_rad1=outer_rad,out_rad2=outer_rad,in_rad=inner_rad);
            }
            
            //bearing rollers
            for(n=[1:num_rollers]){
               rotate([0,0,(n*(360/num_rollers))]) roller(width=height,out_rad1=outer_rad,out_rad2=outer_rad,in_rad=inner_rad);
            }
            
            
        
            //clearance for the balls
            %cylinder(r=32, h=2, center=true);

            //clearance for the arms - ball loading
            %cylinder(r=clearance_rad, h=1, center=true);
        }
        
        //shaft
        cylinder(r1=idler_shaft+1, r2=idler_shaft+1, h=in+1, center=true, $fn=6);
    }
}

module guide_moon(){
    hull(){
        translate([inlet_width/2*in, wall*2.5, in*1.5]) cylinder(r=clearance_rad, h=in, center=true);
        translate([inlet_width/2*in, wall*2.5, in*1.5]) cylinder(r=clearance_rad+wall*4, h=.1, center=true);
    }
}

module cl_inlet(){
    inlet_width = 6;
    %translate([inlet_width/2*in,0,in*1.5]) drive_gear();
    
    hanger_h = 3*in;
    
    difference(){
        union(){
            //tray
            render() intersection(){
                rotate([-90,0,0]) inlet(length=inlet_width, outlet=NONE, hanger_height=1, hanger_vert=true);
                rotate([-90,0,0]) translate([inlet_width*in,0,0]) mirror([1,0,0]) inlet(length=inlet_width, outlet=NONE, hanger_height=1);
            }
            
            //flat floor - will cut into it later, to slope the marbles in.
            cube([inlet_width*in,wall*4,in*3]);
            
            //guide moon, and blocker
            intersection(){
                guide_moon(inlet_width=inlet_width);
                cube([inlet_width*in,in*2,in*3]);
            }
            
            //motor mount
            translate([inlet_width/2*in,clearance_rad+wall,in]) hull(){
                motorHoles(1, support=true);
                for(i=[0,1]) mirror([i,0,0]) translate([inlet_width/2*in*.75,-clearance_rad+wall,-in]) cylinder(r=wall, h=wall*2);
            }
        }
        
        //hangers
        for(i=[1:inlet_width]){
            rotate([-90,0,0]) hanger(solid = -1, hole=[i,2]);
        }
        
        //guide hollow
        translate([inlet_width/2*in, clearance_rad+wall, in*1.5]) hull(){
            cylinder(r=clearance_rad, h=in+.1, center=true);
            cylinder(r=clearance_rad+wall, h=.1, center=true);
        }
        
        //motor mount
        translate([inlet_width/2*in,clearance_rad+wall,in]) motorHoles(0, motor_bump = 10);
        
        //bed slope
        difference(){
            hull(){
                translate([inlet_width/2*in, clearance_rad+wall, in*1.5]) cylinder(r=clearance_rad, h=in, center=true);
                translate([wall,wall*4,wall]) cube([inlet_width*in-wall*2,.1,in*3-wall*2]);
            }
            //guide moon, and blocker
            render() guide_moon(inlet_width=inlet_width);
        }
    }
}

module cl_outlet(){
    %rotate([90,0,0]) idler_gear();
    %translate([0,0,in*3.3]) rotate([0,30,0]) link_loop();
    
    difference(){
        union(){
            //ball grabbing wings - slide inbetween the ball hook and the link hooks.
            
            //slide - to get the marbles out.  Should just be a straight shot, with the ball wings attached.
            
            //idler gear mount - and put the idler gear on it properly
            
            //hooks - hold up the thingamajig
            
            //main body - make sure all the bits hold together
        }
    }
}

module link(ball_grabber=true){
    core_shorten = shaft*3;
    
    translate([length/2,0,-(shaft+thickness/2)]) 
    difference(){
        union(){
            //straight bit
            translate([-core_shorten/2+2,0,0]) cube([length-core_shorten-4,core,thickness], center=true);
            hull(){
                #translate([-core_shorten+shaft*1.5+4,0,0]) cube([length-core_shorten-shaft*3,core,thickness], center=true);
                #translate([length/2-core_shorten/2-3,0,0]) cube([core_shorten/2,width,thickness], center=true);
            }
            
            //hook interface rod
            translate([-length/2,0,shaft+thickness/2]) rotate([90,0,0]) difference(){
                union(){
                    cylinder(r=shaft, h=width, center=true);
                    hull(){
                        cylinder(r=shaft, h=core, center=true);
                        translate([shaft,-shaft,0]) cylinder(r=shaft, h=core, center=true);
                        translate([shaft*2,-shaft,0]) cylinder(r=shaft, h=core, center=true);
                    }
                }
                hull(){
                    translate([5,ball_rad-shaft,0]) sphere(ball_rad+.2);
                    translate([-5,ball_rad-shaft,0]) sphere(ball_rad+.2);
                }
            }
            
            
            //hooks
            translate([length/2,0,thickness/2]) difference(){
                translate([0,0,shaft]) rotate([90,0,0]) cylinder(r=shaft*3, h=width, center=true);
                //cut out the middle
                translate([0,0,0]) cube([length,width-hook_width*2, 20], center=true);
                translate([0,0,10]) cube([length,width-hook_width*2, 20], center=true);
                
                //room for the next link, and opening
                hull(){
                    translate([0,0,shaft])
                    rotate([90,0,0]) cylinder(r=shaft+slop, h=width+1, center=true);
                    translate([-shaft*4,0,shaft*3]) rotate([90,0,0]) cylinder(r=shaft*3, h=width+1, center=true);
                }
            }
            
            //ball grabber
            if(ball_grabber == true){
                translate([-shaft*2-1,0,jut]) difference(){
                    %translate([0,0,ball_rad+thickness]) sphere(r=ball_rad);
                    intersection(){
                        hull(){
                            translate([0,0,ball_rad-jut]) rotate([90,0,0]) cylinder(r=ball_rad+wall, h=ball_rad+wall, center=true);
                            translate([0,0,ball_rad+wall]) rotate([90,0,0]) cylinder(r=ball_rad+wall+jut/4, h=ball_rad+wall, center=true);
                        }
                        translate([shaft*2+1,0,-jut]) translate([length/2-core_shorten*1.5,0,0]) cube([core_shorten*3,core,thickness*50], center=true);
                        
                    }
                
                    //cutout
                    hull(){
                        translate([0,0,ball_rad+wall/2]) rotate([90,0,0]) sphere(r=ball_rad+slop);
                        translate([-15,0,ball_rad*2]) rotate([90,0,0]) sphere(r=ball_rad*2);
                        translate([-15,0,ball_rad*2-jut]) rotate([90,0,0]) sphere(r=ball_rad*2);
                    }
                }
            }
            
            //alignment groove beefinator
            *translate([0,0,-thickness/2]) rotate([0,90,0]) rotate([0,0,30])           
               cylinder(r=groove_rad+thickness, h=core, center=true, $fn=6);
        }
        
        //flatten the bottom
        translate([0,0,-25-thickness/2]) cube([50,50,50], center=true);
        
        //alignment groove
        translate([0,0,-thickness/2]) rotate([0,90,0]) rotate([0,0,30]) cylinder(r=groove_rad+slop/2, h=100, center=true, $fn=6);
    }
}

module bearing(bearing=true, drive_gear=false){
    //set variables
    // bearing diameter of ring
    D=33;
    // thickness
    T=in/2;
    // clearance
    tol=.125;
    number_of_planets=5;
    number_of_teeth_on_planets=6;
    approximate_number_of_teeth_on_sun=9;
    ring_outer_teeth = 71;
    // pressure angle
    P=45;//[30:60]
    // number of teeth to twist across
    nTwist=1;
    // width of hexagonal hole
    w=idler_shaft*2;
    hole_rad = idler_shaft;

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
    
    if(bearing==true)
    translate([0,0,T/2]){
        //ring gear
        difference(){
            union(){
                cylinder(r=face, h=T, center=true, $fn=6);
            
                //alignment groove
                hull() for(i=[0:60:359]) rotate([0,0,i]) {
                    translate([0,face*cos(180/6),0]) rotate([0,90,0]) cylinder(r=groove_rad-slop/2, h=face-thickness, center=true, $fn=6);
                }
        
                //clearance for the balls
                %cylinder(r=32, h=2, center=true);

                //clearance for the arms - ball loading
                %cylinder(r=clearance_rad, h=1, center=true);
            }
            
            //inner ring
            herringbone(nr,pitch,P,DR,-tol,helix_angle,T+0.2);
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
                    cube([1,3,100], center=true);
                }
            }
        }
}