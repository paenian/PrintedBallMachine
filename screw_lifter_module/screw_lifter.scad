include <../configuration.scad>;
use <../base.scad>;
use <../clank_drop/clank_drop.scad>;
use <../screw_drop/bowl_drop.scad>;
use <../ball_return/ball_return.scad>;

part = 103;

screw_rad = ball_rad*1.5+wall*2;
screw_pitch = ball_rad*2+wall*3;
screw_offset = -wall-screw_rad-.9;
screw_offset = -in*1.5;
screw_length = 5.5;
screw_inset = ball_rad*1.5;

//oriented out for printing
if(part == 0)
    screw_inlet();
if(part == 1)
    screw_segment_2(length=screw_length, starts=2, top=PEG, inset = screw_inset);
if(part == 2)
    screw_segment_2(length=screw_length, starts=1, top=PEG, inset = screw_inset);
if(part == 3)
    rotate([-90,0,0]) bowl_drop(inlet_length=5, height = 2-.125, rad=2.5, height_scale=.55*in, lower=11.3);
if(part == 4)
    rotate([-90,0,0]) offset_slope_module(size = [3,-.4]);
if(part == 5)
    rotate([0,90,0]) rear_ball_return_inlet();
if(part == 6)
    rotate([0,-90,0]) rear_ball_return_outlet();


if(part == 7)
    screw_inlet_2(height = 5, width = in*5.45, screw_rad = 19, num_guides = 4);

if(part == 71){
    %screw_inlet_2(height = 5, width = in*5.45, screw_rad = 19, num_guides = 4);
    
    translate([0,0,5*(screw_pitch+5)]) screw_inlet_2_extender(height = 5, width = in*5.45, screw_rad = 19, num_guides = 4);
}

if(part == 72){
    %screw_inlet_2(height = 5, width = in*5.45, screw_rad = 19, num_guides = 4);
    
    translate([0,0,5*(screw_pitch+5)]) screw_inlet_2_top(height = 5, screw_rad = 19, num_guides = 4);
}

if(part == 8)
    screw_segment_inset(length=5, starts=2, top=PEG, bot=PEG, screw_rad = 19);
if(part == 88)
    screw_segment_peg(length=5, starts=2, top=PEG, bot=PEG, screw_rad = 19);
if(part == 9) {
    difference(){
        union(){
            screw_segment_inset(length=5, starts=2, top=PEG, bot=MOTOR, screw_rad = 19);
    
            //rough in the motor screw to see if they line up
            *translate([0,0,5.1*(screw_pitch+5)]) screw_segment_inset(length=5, starts=2, top=PEG, bot=PEG, screw_rad = 19);
        }
        *translate([200,0,0]) cube([400,400,400], center=true);
    }
}
if(part == 77)
    screw_inlet_2(height = screw_length, width = in*7.5, screw_rad = 19, legs=true);

if(part == 777)
    fountain_leg(height = 70, width = in*7);

if(part == 7777)
    fountain_guide_extension(height = 70, width = in*7);

if(part == 100){
    two_inch_fountain();
}

if(part == 101)
    two_inch_screw();

if(part == 102)
    two_inch_screw_plug();

if(part == 103)
    two_inch_screw_base();

if(part == 110)
    two_inch_screw_assembled();

if(part==10){
    assembled();
}

angle = 0;

//tops for the lift screws
ROUND = 2;
NONE = 0;
PEG = 1;
MOTOR = 3;

module assembled(){
    //draw in the pegboard & rear ball return
    basic_panel();
    
    //first lifter
    translate([0,0,peg_sep*4]) screw_inlet();
    //translate([peg_sep*2,screw_offset,peg_sep*4]) rotate([0,angle,90]) translate([0,0,0]) screw_segment(length=screw_length, starts=1, top=ROUND);
    
    translate([peg_sep*3,0,peg_sep*6]) bowl_drop(inlet_length=3, height = 2-.125, rad=2.5, height_scale=.55*in, lower=11.3);
    
    translate([peg_sep*3,0,peg_sep*5]) inlet(length=3, width=3, outlet=CENTER);
    
    //second lifter
    translate([peg_sep*6,0,peg_sep*4]) screw_inlet();
    //translate([peg_sep*5,screw_offset,peg_sep*7]) rotate([0,angle,90]) translate([0,0,0]) screw_segment(length=screw_length, starts=2, top=ROUND);
    
    translate([peg_sep*9,0,peg_sep*7]) clank_drop(width=3, length=3, height = 2.0);
    
    //bowl drop
    //translate([peg_sep*7,0,peg_sep*8]) bowl_drop(inlet_length=6, height = 2-.125, rad=2.5, height_scale=.55*in, lower=11.3);
    
    //catch the ball out of the spinner
    //translate([peg_sep*9, 0, peg_sep*4]) offset_slope_module(size = [2,-.4]);
}

module slide_motor_mount(angle_inset = 20, max_angle = 75, motor_width = 20){
    
    zip_width = 3;
    zip_length = 5;
    
    sweep_angle = max_angle + 5;
    rad = angle_inset + motor_width+zip_width*4;
    
    difference(){
        //body
        intersection(){
            rotate([90,0,0]) cylinder(r=rad, h=wall);
            translate([-50,0,-50]) cube([100,100,100], center=true);
            rotate([0,90-sweep_angle,0]) translate([-50,0,-50]) cube([100,100,100], center=true);
        }
        
        //slots for zip ties to attach the motor
        for(i=[5:360/100:max_angle-zip_width]) rotate([0,-i,0])  {
            translate([-angle_inset,0,0]) cube([zip_width, wall*3, zip_length], center=true);
            translate([-angle_inset-motor_width-zip_width,0,0]) cube([zip_width, wall*3, zip_length], center=true);
        }
    }
}

/* this is a second inlet attempt, trying to get it to jam
 * less by going in straight.  Intended for a taller lifter.
 */
module screw_direct_inlet(height = in*5, length=peg_sep*6, width=peg_sep*3){
    %screw_segment_2(length=screw_length, starts=1, top=PEG, inset = screw_inset);
    
    screw_ball_rad = ball_rad+1;
    inlet_angle = 17;
    
    difference(){
        union(){
            //tray for ball ingress
            difference(){
                translate([0,0,peg_sep*.75]) cube([length, width, peg_sep*1.5], center=true);
                
                //slope all the balls into the scre
                translate([0,0,peg_sep*1.333]) for(i=[0:1]) mirror([i,0,0]) hull(){
                    rotate([0,90+5,0]) cylinder(r=screw_ball_rad, h=length/2-wall);
                    for(j=[0,1]) mirror([0,j,0]) translate([0,width/2-wall-screw_ball_rad,wall]) {
                        rotate([0,90+inlet_angle/2,0]) cylinder(r=screw_ball_rad, h=length/2-wall);
                        translate([0,0,peg_sep]) rotate([0,90+inlet_angle/2,0]) cylinder(r=screw_ball_rad, h=length/2-wall);
                    }
                }
            }
            
            //vertical ball guide
            hull() {
                for(i=[0:1]) mirror([i,0,0]) translate([screw_rad+screw_ball_rad-screw_inset,0,0])
                    cylinder(r=screw_ball_rad+wall, h=height, $fn=8);
                cylinder(r=screw_rad+wall, h=height);
            }
        }
        
        //motor mount
        translate([0,0,0]) rotate([0,0,180]) motor_holes();
        
        //ball inlet holes
        for(i=[0:1]) mirror([i,0,0]) translate([0,0,screw_ball_rad]) {
            rotate([0,90-inlet_angle,0]) cylinder(r=screw_ball_rad, h=length/2-wall);
        }
        
        //hole for the screw
        translate([0,0,-.1]) cylinder(r=screw_rad+.25, h=200);
        
        //vertical ball path
        for(i=[0:1]) mirror([i,0,0]) translate([screw_rad+screw_ball_rad-screw_inset,0,wall+screw_ball_rad])
            cylinder(r=screw_ball_rad, h = in*20);
        
        //windows into the ball/srew path
        for(j=[43:29:height-20]) translate([0,0,j])
            scale([1.25,1,1]) rotate([90,0,0]) cylinder(r=13, h = in*5, $fn=4,center=true);
    }
}

//this is the lift module :-)
module screw_inlet(){
    motor_width = 20;
    open_angle=0;
    
    drop = .25*in/2;
    back_drop = .25*in/4;
    
    difference(){
        union(){
            inlet(length=3, inset=0, outlet=NONE, hanger_height=4);
            
            //strengthen the hangers
            difference(){
                union(){
                    hanger(solid=1, hole=[1,5], drop = in*4, rot=-33);
                    hanger(solid=1, hole=[3,5], drop = in*4, rot=33);
                }
                hanger(solid=-1, hole=[1,5]);
                hanger(solid=-1, hole=[3,5]);
            }
            
            
            //motor hangs under the inlet, with an adustable angle centered on the hole in the floor.
            %translate([peg_sep*2,screw_offset,0]) rotate([0,-90+angle,0]) rotate([0,90,0]) rotate([0,0,-90]) translate([0,0,-21]) motor_holes();
            

            
            //guide track
           translate([in*2,in/2+screw_offset,0]) for(i=[0,1]) mirror([i,0,0]) rotate([0,0,open_angle]) translate([screw_rad+ball_rad+wall*1.5,0,0]) rotate([0,-90,0]) track(rise = 0, run = in*(4.25+i*.125));
            
            //balls
            *translate([in*3-ball_rad-wall,screw_offset,in*3+10]) sphere(r=ball_rad);
           
           //new floor, for better guides
           hull(){
               mirror([0,1,0]) cube([in*3, in*3, in*.5]);
               mirror([0,1,0]) translate([in*2,0,0]) cube([in, in*3, in/2+in*.5]);
           }
           
           //top exit track
           //rear
           translate([peg_sep*3,in/2+screw_offset+in,in*4-back_drop*4]) mirror([1,0,0]) track(rise=back_drop*2, run=in*2, solid=1, end_angle=90);
           translate([peg_sep*1,-in/2+screw_offset+1,in*4-back_drop]) mirror([0,0,0]) rotate([0,0,90]) track(rise=-back_drop, run=in, solid=1, end_angle=0);
           
           //front
           translate([peg_sep*2,in/2+screw_offset-.75,in*4-back_drop*2]) mirror([1,1,0]) track(rise=-back_drop*2, run=in*2, solid=1, end_angle=90);
           
           //exit supports
           translate([in*1.25,in/2+screw_offset+in*.15,in*3.5]) scale([1,1.3,1]) {
               //track(rise = -in/4, run = in*3);
               hull(){
                   translate([in*1.333+in/2-5, -track_rad-wall, track_rad/2-1]) cube([track_rad/2, track_rad*5, track_rad], center=true);
                   translate([in*.75, -track_rad-wall, -track_rad*1.5]) cube([in*1.5, track_rad*2, track_rad], center=true);
               }
           }
        }
        
        //rear exit hole
        translate([peg_sep*1,-in/2+screw_offset+1,in*4-back_drop]) mirror([0,0,0]) rotate([0,0,90]) track(rise=-back_drop, run=in, solid=1, end_angle=0, solid=-1);
        //front exit hole
        translate([peg_sep*2,in/2+screw_offset-.75,in*4-back_drop*2]) mirror([1,1,0]) track(rise=-back_drop*2, run=in*2, solid=1, end_angle=90, solid=-1);
        
        //guide track hollow
        translate([in*2,screw_offset,wall*4]) hull() for(i=[0,1]) mirror([i,0,0]) rotate([0,0,open_angle]) translate([screw_rad-1.5,0,0]) scale([1,.9,1]) {
               //track(rise = 0, run = in*4.5, solid=-1);
               cylinder(r=ball_rad+wall, h=in*4.5);
           }
               
           //cube cut
           translate([100+in*3,0,100]) cube([200,200,300], center=true);
           
           //extra hanger holes to avoid hitting ball returns etc.
            for(i=[1:3])
                for(j=[2:5])
                    hanger(solid = -1, hole=[i,j], drop = 0);
        
        
        //ball entry to the guides
        translate([in*2,screw_offset,ball_rad+wall*2]) for(i=[0,1]) rotate([0,0,i*180]) translate([-screw_rad,0,0]) {
            hull(){
                sphere(r=ball_rad+wall);
                translate([screw_rad,-in*3-screw_offset+ball_rad+wall*2,wall*2]) sphere(r=ball_rad+wall);
                //this added guy is an attempt to stop screw jams.
                translate([screw_rad,-in*3-screw_offset+ball_rad+wall*2,wall*2+ball_rad*2]) sphere(r=ball_rad+wall);
                translate([0,0,wall*2+ball_rad]) sphere(r=ball_rad+wall/2);
            }
        }
        
        //ball paths
        translate([in*2,screw_offset,ball_rad+wall*2]) for(i=[0,1]) mirror([0,i,0]) {
            hull(){
                translate([0,-in*3-screw_offset+ball_rad+wall*2,wall*2]) sphere(r=ball_rad+wall);
                
                translate([-in*1.5,-in*3-screw_offset+ball_rad+wall*2,wall*3]) sphere(r=ball_rad+wall);
                //translate([in*.5,-in*3-screw_offset+ball_rad+wall*2,wall*3]) sphere(r=ball_rad+wall);
            }
            
            hull(){
                translate([-in*1.5,-in*3-screw_offset+ball_rad+wall*2,wall*3]) sphere(r=ball_rad+wall);
                translate([-in*1.5,0,wall*3.5]) sphere(r=ball_rad+wall);
            }  
        }
        
        //motor mount
        translate([in*2,screw_offset,0]) rotate([0,0,180]) motor_holes();
        
                
        // hole for the screw
        translate([in*2,screw_offset, 0]) hull() {
            translate([0,0,-peg_sep/2]) cylinder(r=screw_rad+.25, h=200);
            *rotate([0,30,0]) translate([0,0,-peg_sep]) cylinder(r=screw_rad+1, h=100);
            *rotate([0,60,0]) translate([0,0,-peg_sep]) cylinder(r=screw_rad+1, h=100);
        }
        
        //rough in the screw
        %translate([in*2,-in*1.5,0]) screw_segment_2(length=screw_length, starts=2, top=ROUND);
        
        //marbles in the chute
        %translate([in*1.45, -in*1.5, in*1.75]) sphere(r=ball_rad);
        
        //testing: cut the whole thing in half
        //translate([0,-in*1.5-100,100]) cube([200,200,300], center=true);
    }
}

//this is the lift module :-)
module screw_inlet_2(height = screw_length, length = in*5, width = in*5.4, legs=false, num_guides = 3){
    motor_width = 20;
    open_angle=0;
    
    pitch = screw_pitch+5;
    height = screw_length*pitch;
    
    drop = .25*in/2;
    back_drop = .25*in/4;
    
    motor_dimple_h = 6;
    motor_dimple_r = 6.5;
    motor_shaft_offset = 7;
    
    
    guide_rad = 8;
    
    screw_offset = length/2-screw_rad-wall;
    
    difference(){
        union(){
            if(legs == false){
                translate([screw_offset,0,0]) difference(){  //box
                    intersection(){
                        translate([0,0,(in*1.5)/2]) cube([length, width, in*1.5], center=true);
                        translate([0,0,motor_dimple_h+wall+in/4]) cylinder(r=in*3.333+wall, h=in*4, center=true, $fn=90);
                    }
                
                    //slope in towards the screw
                    intersection(){
                        hull(){
                            translate([-screw_offset,0,motor_dimple_h+wall+in/2]) cylinder(r=in*3.333, h=in*2, $fn=90);
                            translate([-screw_offset,0,0]) translate([0,0,motor_dimple_h+wall]) cylinder(r=screw_rad, h=height+10); //this lets the marbles into the screw, too
                            translate([in*3,0,motor_dimple_h+wall+in*1.5]) cube([in, in*5, in], center=true);
                        }
                        translate([0,0,in]) cube([length-wall*2, width-wall*2, in*2], center=true);
                        translate([0,0,motor_dimple_h]) cylinder(r=in*3.333, h=in*2, $fn=90);
                    }
                }
            }else{
                difference(){  //circle
                    union(){
                        cylinder(r1=width/2-in, r2=width/2, h=in*1.5, $fn=90);
                        rotate_extrude($fn=90){
                            translate([width/2-wall/2,in*1.5]) circle(r=wall/2);
                        }
                    }
                
                    //slope in towards the screw
                    intersection(){
                        scale([1,1,height/width+.1]) translate([0,0,width+motor_dimple_h+3]) sphere(r=width, $fn=180);
                        
                        translate([0,0,.1]) cylinder(r1=width/2-in-wall, r2=width/2-wall, h=in*1.5, $fn=90);
                    }
                }
            }
            
            //screw guides
            if(legs == true){
                for(i=[0:360/num_guides:359]) rotate([0,0,i]) {
                    hull(){
                        translate([screw_rad+guide_rad*1.5,0,0]) scale([2,.75,1]) cylinder(r=guide_rad, h=height-in/2, $fn=4);
                        translate([screw_rad+guide_rad*1,0,height-guide_rad/2]) scale([2,.75,1]) sphere(r=guide_rad/2);
                    }
                }
            }else{
                //widen the bases to restrict marble entry
                *for(i=[45:360/num_guides:359]) rotate([0,0,i]) {
                    hull(){
                        translate([screw_rad+guide_rad*.5,0,0]) scale([2,.75,1]) cylinder(r=guide_rad*1.2, h=in, $fn=4);
                        translate([screw_rad+guide_rad*1.5,0,0]) scale([2,.75,1]) cylinder(r=guide_rad, h=in*3, $fn=4);
                        
                        %rotate([0,0,45]) translate([screw_rad,0,in]) sphere(r=ball_rad+1);
                    }
                }
                for(i=[0,1]) mirror([0,i,0]) rotate([0,0,45]) translate([screw_rad+guide_rad*1.5,0,0]) scale([2,.75,1]) cylinder(r=guide_rad, h=height, $fn=4);
                
                hull() for(i=[0,1]) mirror([0,i,0]) rotate([0,0,135]) translate([screw_rad+guide_rad*1.5,0,0]) scale([2,.75,1]) cylinder(r=guide_rad, h=height, $fn=4);
            }
        }
        
        //attach bottom to the pegboard
        if(legs == false){
            //side holes for the pegboard
            for(j=[-peg_sep,0,peg_sep]) for(i=[0,1]) mirror([0,i,0]) translate([screw_offset-length/2+peg_sep/2+j,width/2,peg_sep/2]) {
                rotate([90,0,0]) cylinder(r=m5_rad, h=in, center=true);
                hull(){
                    translate([0,-wall,0]) rotate([90,0,0]) rotate([0,0,45]) cylinder(r=m5_sq_nut_rad, h=m5_nut_height, $fn=4);
                    translate([0,-wall,in]) rotate([90,0,0]) rotate([0,0,45]) cylinder(r=m5_sq_nut_rad+1, h=m5_nut_height+1, $fn=4);
                }
            }
            
            //this is the actual board
            translate([screw_offset-length/2-peg_sep/2,0,0]) cube([in*3/4, width+.1, in*50], center=true);
            
            //bolt the screw guides to the board
            translate([screw_offset-length/2-peg_sep/2,0,0])
            for(i=[1:1:height/(in*1.333)]) mirror([0,i%2,0]) translate([0,screw_rad/2,i*in*1.333]) {
                rotate([0,90,0]) rotate([0,0,-90]) cap_cylinder(r=3, h=in/2);
                translate([in/2-.1,0,0]) rotate([0,90,0]) cylinder(r1=3, r2=6, h=3.05);
                translate([in/2+3-.1,0,0]) rotate([0,90,0]) rotate([0,0,-90]) cap_cylinder(r=6, h=10);
            }
        }
        
        //some sloped marble entries
        if(legs == false){
            for(i=[0:360/num_guides:359*((num_guides-1)/num_guides)]) rotate([0,0,i-90-10]) {
                hull(){
                    translate([screw_rad-2,0,ball_rad+1+motor_dimple_h]) sphere(r=ball_rad+1);
                    translate([screw_rad*3,0,ball_rad+2+motor_dimple_h+1+in/3.5]) sphere(r=ball_rad+1);
                }
            }
        }
        
        //motor mount
        rotate([0,0,180]) gear_motor();
        
        //screw inset
        translate([0,0,motor_dimple_h-.1]) cylinder(r=screw_rad+.333, h=height+10, $fn=72);
        
        //rough in the screw
        %rotate([0,0,0]) render() translate([0,0,motor_dimple_h]) screw_segment_inset(length=screw_length, starts=2, top=PEG, bot=PEG, screw_rad = screw_rad, step = 36);
        
        //make some leg mounting holes
        if(legs == true){
            for(i=[0:360/num_guides:359]) rotate([0,0,i]) {
                translate([width/2-in*1.5,0,-2]) scale([2,.75,1]) cylinder(r1=guide_rad+.5, r2=guide_rad+.25, h=in/2, $fn=4);
            }
        }
    }
}

module screw_inlet_2_top(height = 5, width = in*5.45+peg_thick*2, length = in*4, screw_rad = 19, num_guides = 4){
        
    pitch = screw_pitch+5;
    height = screw_length*pitch;
    
    guide_rad = 8;
    
    screw_offset = length/2-screw_rad-wall;
    
    extend_inset = 7;
    
    overhang = (width-in*5.45)/2-peg_thick;
    
    difference(){
        union(){
            //box
            translate([screw_offset-wall,overhang,-extend_inset]) difference(){            
                intersection(){
                    translate([0,0,(in*1.5)/2]) cube([length, width, in*1.5], center=true);
                    translate([0,0,6+wall+in/4]) cylinder(r=in*3.33+wall, h=in*4, center=true, $fn=90);
                }
                
                intersection(){
                    intersection(){
                        translate([0,0,(in*1.5)/2+wall]) cube([length-wall*2, width-wall*2, in*1.5], center=true);
                        translate([0,0,6+wall+in/4+wall]) cylinder(r=in*3.33, h=in*4, center=true, $fn=90);
                    }
                    
                    hull(){
                        //ball exit
                        translate([-length/2+wall+ball_rad+wall/2,width/2-wall/2,ball_rad+wall/2+wall]) sphere(r=ball_rad+wall/2);
                        
                        //opposite board corner
                        translate([-length/2+wall+ball_rad+wall/2,-width/2+wall/2,ball_rad+wall/2+wall*6]) sphere(r=ball_rad+wall/2);
                        
                        //kiddy corner
                        translate([length/2-wall,-width/2+wall/2,ball_rad+wall/2+wall*4]) sphere(r=ball_rad+wall/2);
                        
                        //opposite board corner
                        translate([length/2-wall,width/2-wall/2,ball_rad+wall/2+wall*2]) sphere(r=ball_rad+wall/2);
                        translate([0,0,in*4]) cube([length, width, in*1.5], center=true);
                    }
                }
            }
            
            //descent slope from marblering
            translate([0,0,-extend_inset]) scale([1,1,1]) difference(){
                hull(){
                    cylinder(r=screw_rad+ball_rad/2, h=extend_inset+wall*6, $fn=18);
                    cylinder(r=screw_rad+guide_rad*3+wall*2, h=extend_inset+wall, $fn=36);
                }
                
                //cylinder(r=screw_rad+guide_rad*3-wall, h=extend_inset*2+.1, center=true);
            }
        }
        
        //hollow the inset out
        for(i=[0,1]) mirror([0,i,0]) rotate([0,0,45]) translate([screw_rad+guide_rad*1.5,0,-extend_inset-.1]) scale([2,.75,1]){
            cylinder(r=guide_rad+.3, h=extend_inset*5, $fn=4);
        }
        
        difference(){
            hull() for(i=[0,1]) mirror([0,i,0]) rotate([0,0,135]) translate([screw_rad+guide_rad*1.5,0,-extend_inset-.1]) scale([2,.75,1]) cylinder(r=guide_rad+.3, h=extend_inset*9, $fn=4);
            translate([screw_offset-length/2-peg_sep/2,0,0]) cube([in*3/4, width+.1, in*50], center=true);
        }
        
        //ball exit
        translate([screw_offset-wall,overhang,-extend_inset]) hull(){
            translate([-length/2+wall+ball_rad+wall,width/2-wall,ball_rad+wall/2+wall]) sphere(r=ball_rad+wall/2+1);
            translate([-length/2+wall+ball_rad+peg_sep,width/2-wall,ball_rad+wall/2+wall]) sphere(r=ball_rad+wall/2+1);
            translate([-length/2+wall+ball_rad+wall,width/2+in/2,ball_rad+wall/2+wall]) sphere(r=ball_rad+wall/2+2);
        }
        
        //the screw
        translate([0,0,-.1-extend_inset]) cylinder(r=screw_rad+.333, h=height+10, $fn=72);
        
        //balls
        for(i=[30:90:290]) rotate([0,0,180+45+i]) translate([screw_rad-ball_rad/2,0,-extend_inset-1]) difference(){
            hull(){
                cylinder(r=ball_rad+1, h=extend_inset*5);
            }
        }
        
        //screw into the board top
        for(i=[0,1]) mirror([0,i,0]) translate([screw_offset-length/2-peg_sep/2,13,-extend_inset-.1]) {
            cylinder(r=3, h=in);
            translate([0,0,wall]) cylinder(r1=3, r2=6, h=3.05);
            translate([0,0,wall+3]) cylinder(r=6, h=in);
        }
        
        //this is the actual board
        %translate([screw_offset-length/2-peg_sep/2,0,0]) cube([in*3/4, in*5.45+.1, in*50], center=true);
    }
}

module screw_inlet_2_extender(height = screw_length, length = in*5, width = in*5.45, screw_rad = 19, num_guides = 4){
    
    pitch = screw_pitch+5;
    height = screw_length*pitch;
    
    guide_rad = 8;
    
    screw_offset = length/2-screw_rad-wall;
    
    extend_inset = 15;
    
    difference(){
        union(){
            //this is just the lifter part, identically
            for(i=[0,1]) mirror([0,i,0]) rotate([0,0,45]) translate([screw_rad+guide_rad*1.5,0,0]) scale([2,.75,1]) cylinder(r=guide_rad, h=height, $fn=4);
                
            hull() for(i=[0,1]) mirror([0,i,0]) rotate([0,0,135]) translate([screw_rad+guide_rad*1.5,0,0]) scale([2,.75,1]) cylinder(r=guide_rad, h=height, $fn=4);
        
            //add a connector-type part for the outer guides
            difference(){
                for(i=[0,1]) mirror([0,i,0]) rotate([0,0,45]) translate([screw_rad+guide_rad*1.5,0,-extend_inset]) scale([2,.75,1]) difference(){
                    hull(){
                        cylinder(r=guide_rad+wall, h=extend_inset+2, $fn=4);
                        cylinder(r=guide_rad, h=extend_inset+7, $fn=4);
                    }
                }
                cylinder(r=screw_rad+ball_rad/2, h=height*3, center=true);
            }
            
            translate([11,0,-extend_inset/2+wall]) scale([1,1,1]) difference(){
                hull(){
                    cylinder(r=screw_rad+guide_rad*3+wall, h=extend_inset+wall*2, center=true, $fn=18);
                    cylinder(r=screw_rad+guide_rad*3+wall*2, h=extend_inset, center=true, $fn=36);
                }
                
                cylinder(r=screw_rad+guide_rad*3-wall, h=extend_inset*2, center=true);
            }
        }
        
        //hollow the inset out
        for(i=[0,1]) mirror([0,i,0]) rotate([0,0,45]) translate([screw_rad+guide_rad*1.5,0,-extend_inset-.1]) scale([2,.75,1]){
            cylinder(r=guide_rad+.222, h=extend_inset+.1, $fn=4);
        }
        
        hull() for(i=[0,1]) mirror([0,i,0]) rotate([0,0,135]) translate([screw_rad+guide_rad*1.5,0,-extend_inset-.1]) scale([2,.75,1]) cylinder(r=guide_rad+.222, h=extend_inset+.1, $fn=4);
        
        //the screw
        translate([0,0,-.1]) cylinder(r=screw_rad+.333, h=height+10, $fn=72);
        
        //this is the actual board
        translate([screw_offset-length/2-peg_sep/2,0,0]) cube([in*3/4, width+.1, in*50], center=true);
        
        //screwholes
        translate([screw_offset-length/2-peg_sep/2,0,0])
        for(i=[1:1:height/(in*1.8)]) mirror([0,(i+1)%2,0]) translate([0,screw_rad/3,i*in*1.7]) {
            rotate([0,90,0]) rotate([0,0,-90]) cap_cylinder(r=3, h=in/2);
            translate([in/2-.1,0,0]) rotate([0,90,0]) cylinder(r1=3, r2=6, h=3.05);
            translate([in/2+3-.1,0,0]) rotate([0,90,0]) rotate([0,0,-90]) cap_cylinder(r=6, h=10);
        }
    }
}

module fountain_leg(height = 70, width = in*5.4){
    guide_rad = 8;
    union(){
        //leg body
        difference(){
            rotate([0,0,45])
            translate([width/2-in*1.5,0,0]) scale([2,.75,1]) minkowski(){
                cylinder(r1=guide_rad+wall*2, r2=guide_rad+wall, h=height+in/4, $fn=4);
                sphere(r=1, $fn=6);
            }
            translate([0,0,height]) hull() screw_inlet_2(height = screw_length, width = in*7+.25, screw_rad = 19, legs=true);
        }
        
        //leg peg
        rotate([0,0,45])
        translate([width/2-in*1.5,0,0]) translate([0,0,height-3]) scale([2,.75,1]) cylinder(r1=guide_rad, r2=guide_rad, h=in/2, $fn=4);
    }
}

module gear_motor(screws = true){
    motor_dimple_h = 6;
    motor_dimple_r = 6.5;
    
    motor_shaft_r = 3.5;
    motor_shaft_h = 20;
    
    motor_shaft_offset = 7;
    
    gear_r = 37/2;
    gear_h = 22;
    motor_r = 35/2;
    motor_h = 31;
    
    num_screws = 6;
    screw_ring_r = 31/2;
    screw_r = 1.875;
    screw_h = 2.9;
    screw_cap_r = 3.25;
    screw_cap_h = 12;
    
    
    translate([-motor_shaft_offset,0,0]) 
    union(){
        translate([0,0,-gear_h]) cylinder(r=gear_r, h=gear_h);
        translate([0,0,-gear_h-motor_h]) cylinder(r=motor_r, h=motor_h+.1);
        translate([motor_shaft_offset,0,-.1]) {
            cylinder(r=motor_dimple_r, h=motor_dimple_h+.1);
            cylinder(r=motor_shaft_r, h=motor_shaft_h+.1);
        }
        
        if(screws == true){
            for(i=[0:360/num_screws:359]) rotate([0,0,i]){
                translate([0,screw_ring_r,-.1]) cylinder(r=screw_r, h=screw_h+screw_cap_h);
                translate([0,screw_ring_r,screw_h-.1]) cylinder(r=screw_cap_r, h=screw_h+screw_cap_h);
            }
        }
    }
}

module two_inch_screw_assembled(){
    thrust_inner_rad = 25/2;
    thrust_flange_rad = 38/2;
    thrust_rad = 52/2;
    thrust_flat_rad = 42/2;
    thrust_thick = 17;
    
    rod_rad = 15/2+.25;
    bearing_rad = 35/2+.25;
    bearing_thick = 11.75;
    screw_rad = in*2.5+.75; //large clearance on the screw
    
    base_rad = in*5.25;
    base_height = in*1.75;
    screw_ring = 10;
    
    wall = 4;
    
    difference(){
        union(){
            render() two_inch_screw_base();
            render() translate([0,0,wall+bearing_thick-wall-.5]) two_inch_screw_plug();
            render() translate([0,0,wall+bearing_thick+wall+1]) two_inch_screw();
        }
    
        //cut in half for a test view
        translate([500,0,0]) cube([1000,1000,1000], center=true);
    }
}

//this attaches the bottom screw to the base, inside of a thust bearing.
module two_inch_screw_plug(){
    thrust_inner_rad = 25/2;
    thrust_fange_rad = 38/2;
    rod_rad = 15/2+.25;
    bearing_rad = 35/2+.25;
    bearing_thick = 11.75;
    
    
    difference(){
        union(){
            cylinder(r=thrust_inner_rad-.4, h=10.1);
            translate([0,0,10]) cylinder(r=bearing_rad-.5, h=bearing_thick/2-1+.1);
            translate([0,0,10+bearing_thick/2-1]) cylinder(r=bearing_rad-.5, h=bearing_thick, $fn=6);
        }
        
        cylinder(r=rod_rad+2, h=100);
    }
}

module rod_hole(height = 100){
    rod_rad = 15/2;
    rod_wall = 2.6+.2;
    
    union(){
        difference(){
            union(){
                cylinder(r=rod_rad+.3, h=height);
            }
            translate([0,0,-.1]) cylinder(r1=rod_rad-rod_wall, r2=rod_rad-rod_wall*1.5, h=height+1);
        }
        translate([rod_rad-rod_wall-m5_rad+.25,0,0]) {
            translate([0,0,-wall/2+.3]) cylinder(r=m5_rad, h=height);
            rotate([180,0,0]) translate([0,0,wall/2]) cylinder(r=m5_cap_rad, h=height*2);
        }
    }
}

//a nice base for the screw to sit in. Edge is flat so we can add more bowl to it.
module two_inch_screw_base(){
    high_facets = 108;
    
    thrust_inner_rad = 25/2;
    thrust_flange_rad = 38/2;
    thrust_rad = 52/2;
    thrust_flat_rad = 42/2;
    thrust_thick = 17;
    
    rod_rad = 15/2+.25;
    bearing_rad = 35/2+.25;
    bearing_thick = 11.75;
    screw_rad = in*2.5+.75; //large clearance on the screw
    
    base_rad = in*5.25;
    base_height = in*1.75;
    screw_ring = 10;
    
    bearing_lift = .75;
    
    wall = 4;
    
    %translate([screw_rad+in,0,in*3]) sphere(r=in);
    
    difference(){
        union(){
            difference(){
                cylinder(r1=base_rad-base_height, r2=base_rad, h=base_height);
                
                //todo:remove some chunks?
                *for(i=[60:360/3:359]) rotate([0,0,i]) {
                    hull(){
                        translate([thrust_rad+rod_rad+wall,0,-.1]) cylinder(r=rod_rad, h=thrust_thick);
                        translate([base_rad,0,-.1]) cylinder(r=base_rad/2, h=thrust_thick);
                    }
                }
            }
        }
        
        //slope inwards
        intersection(){
            translate([0,0,wall+thrust_thick]) cylinder(r1=base_rad-base_height/2, r2=base_rad-screw_ring, h=base_height-wall-thrust_thick+.1);
            //translate([0,0,base_height]) scale([1,1,(base_height-wall*2-thrust_thick)/(base_rad-screw_ring)]) sphere(r=base_rad-screw_ring, $fn=high_facets);
            translate([0,0,wall*1.5+thrust_thick]) cylinder(r1=screw_rad, r2=base_rad-screw_ring, h=base_height-wall-thrust_thick+.1);
        }
        
        
        //the screw inset
        translate([0,0,wall+thrust_thick-.5]) cylinder(r=screw_rad, h=base_height, $fn=high_facets);
        
        //screws to attach more rings
        for(i=[0:360/6:359]) rotate([0,0,i]) translate([base_rad-screw_ring*.75,0,base_height]) {
            translate([0,0,-wall+.3]) cylinder(r=m5_rad, h=base_height);
            rotate([180,0,0]) translate([0,0,wall]) cylinder(r=m5_nut_rad, h=base_height, $fn=6);
        }
        
        //thrust bearing hole
        translate([0,0,wall+bearing_lift]) 
        difference(){
            union(){
                cylinder(r=thrust_rad+.3, h=base_height, $fn=high_facets);
                translate([0,0,-wall/2]) cylinder(r=thrust_flat_rad-.25, h=base_height);
            }
            
            translate([0,0,-wall/2-.1]) cylinder(r=thrust_inner_rad-1, h=thrust_thick/2-1);
            translate([0,0,-wall/2-.1]) rotate_extrude(){
                translate([thrust_inner_rad-1,0,0]) circle(r=1.5, $fn=4);
            }
        }
        
        //rod holes
        translate([0,0,wall]){
            rod_hole();
            for(i=[0:360/3:359]) rotate([0,0,i]) translate([screw_rad+rod_rad+.5,0,0]) rod_hole();
        }
        
        //cut in half for a test view
        *translate([500,0,0]) cube([1000,1000,1000], center=true);
    }
}

module two_inch_screw(){
    joint = 15;
    pitch = in*3;
    rad = in*2.5;
    length = 3;
    
    rod_rad = 15/2+.25;
    bearing_rad = 35/2+.25;
    bearing_thick = 11.75;
    
    
    difference(){
        screw_segment_inset(length=length, starts=2, top=NONE, bot=NONE, screw_rad = rad, ball_rad = in, screw_pitch=pitch);
        
        //lock the next segment in
        for(j=[0,1]) for(i=[0,1]) mirror([0,i,0]) translate([0,bearing_rad+joint/2+1,j*pitch*length]) cube([joint+.4, joint+.4, joint+1], center=true);
    
        //rod/bearing support
        translate([0,0,-.5]) cylinder(r=bearing_rad, h=pitch*length+1, $fn=6);
        
        //bearing top and bottom
        translate([0,0,pitch*length/2])
        for(i=[0,1]) mirror([0,0,i]) translate([0,0,pitch*length/2]){
            cylinder(r=bearing_rad, h=bearing_thick, center=true);
            *hull(){
                cylinder(r=bearing_rad, h=bearing_thick*2, center=true, $fn=6);
                cylinder(r=rod_rad+1, h=bearing_thick*6, center=true);
            }
        }
        
        echo(pitch*3);
    }
}

//length is measured in revolutions!
//this is a differenced version, all around the marble.
module screw_segment_inset(length = 4, starts = 2, top = PEG, bot = PEG, screw_rad = 19, step = 18){
    pitch = screw_pitch;
    true_pitch = pitch*starts;
    
    screw_ball_rad = ball_rad+1;
    inset = ball_rad*1.6;
    echo("RAD");
    echo(screw_ball_rad);
    
    screw_inner_rad = (7.5+wall)/2;
    
    //#cylinder(r=screw_rad, h=50);
    
    peg_len = 20;
    
  
    %rotate([0,0,step*7]) translate([screw_rad+screw_ball_rad-inset, 0, step*7/360*true_pitch-(screw_ball_rad-ball_rad)]) sphere(r=ball_rad);
    %translate([0,screw_rad+ball_rad*3-inset,  in*1.75-2.5]) sphere(r=ball_rad);
    
    difference(){
        union(){        
            //main tube
            cylinder(r=screw_rad-.5, h=length*pitch, $fn=720/step);
            
            //handle the screw top
            if(top == PEG){
                //connect to the next screw along
                *translate([0,0,length*pitch-.1]) d_slot(shaft=9-slop*3, height=10-slop*2, dflat=.4+.4+slop*2, round_inset = 0, round_height = 0, double_d=true);
            }
            
            if(top == ROUND){
                //this is just flat for now
            }
        }
        
        //cut paths into the side - trying to make it bind less
        for(j=[1:starts]) rotate([0,0,j*(360/starts)]) translate([0,0,-pitch]) {
            for(i=[0:step:360*length-step-1]) {
                hull(){
                    rotate([0,0,i]) translate([screw_rad+screw_ball_rad-inset, 0, i/360*true_pitch]) sphere(r=screw_ball_rad);
                    rotate([0,0,i+step]) translate([screw_rad+screw_ball_rad-inset, 0, (i+step)/360*true_pitch]) sphere(r=screw_ball_rad);
                    
                    //expansion up and out
                    rotate([0,0,i]) translate([screw_rad+screw_ball_rad*4-inset, 0, screw_ball_rad*2+i/360*true_pitch]) sphere(r=screw_ball_rad);
                    rotate([0,0,i+step]) translate([screw_rad+screw_ball_rad*4-inset, 0, screw_ball_rad*2+(i+step)/360*true_pitch]) sphere(r=screw_ball_rad);
                }
            }
        }
        
        //d slot for the connection
        if(bot == MOTOR) {
            translate([0,0,-.1]) rotate([0,0,90]) d_slot(shaft=6.33, height=15, dflat=.4+.3, round_inset = 0, round_height = 0, double_d=false);
            translate([0,0,-.1]) rotate([0,0,90]) cylinder(r1=6.9/2, r2=6.7/2, h=3.5);
        }
        
        if(bot == PEG) {
            translate([0,0,-.1]) d_slot(shaft=9, height=peg_len/2, dflat=.4+.4, round_inset = 0, round_height = 0, double_d=true);
        }
        
        if(top == PEG) {
            translate([0,0,length*pitch-slop-peg_len/2]) d_slot(shaft=9, height=peg_len, dflat=.4+.4, round_inset = 0, round_height = 0, double_d=true);
        }
        
        //flatten the base
        translate([0,0,-50]) cube([50,50,100], center=true);
    }
}

module screw_segment_peg(){
    peg_len = 20;
    
    rotate([90,0,0])  d_slot(shaft=9-.5, height=peg_len-.2, dflat=.4+.4+.2, round_inset = 0, round_height = 0, double_d=true);
}

//length is measured in revolutions!
//this is a differenced version, all around the marble.
module screw_segment_2(length = 4, starts = 2, top = PEG, inset = 7){  
    pitch = screw_pitch;
    true_pitch = screw_pitch*starts;
    
    screw_ball_rad = ball_rad+1;
    echo("RAD");
    echo(screw_ball_rad);
    
    screw_inner_rad = (7.5+wall)/2;
    
    //#cylinder(r=screw_rad, h=50);
    
    step = 30; //out of 360
  
    %translate([-screw_rad-screw_ball_rad+inset, 0, true_pitch*1.5]) sphere(r=ball_rad);
    
    difference(){
        union(){        
            //main tube
            cylinder(r=screw_rad-.5, h=length*pitch);
            
            //handle the screw top
            if(top == PEG){
                //connect to the next screw along
                translate([0,0,length*pitch-.1]) d_slot(shaft=7.5-slop*3, height=10-slop*2, dflat=.4+.4+slop, double_d=true);
            }
            
            if(top == ROUND){
                //this is just flat for now
            }
        }
        
        //cut paths into the side - trying to make it bind less
        for(j=[1:starts]) rotate([0,0,j*(360/starts)]) translate([0,0,-pitch]) {
            for(i=[0:step:360*length-step-1+720]) 
                hull(){
                    rotate([0,0,i]) translate([screw_rad+screw_ball_rad-inset, 0, i/360*true_pitch]) sphere(r=screw_ball_rad);
                    rotate([0,0,i+step]) translate([screw_rad+screw_ball_rad-inset, 0, (i+step)/360*true_pitch]) sphere(r=screw_ball_rad);
            
                    //expansion
                    rotate([0,0,i]) translate([screw_rad+screw_ball_rad-inset+wall*2, 0, i/360*true_pitch]) sphere(r=screw_ball_rad+wall/2);
                    rotate([0,0,i+step]) translate([screw_rad+screw_ball_rad-inset+wall*2, 0, (i+step)/360*true_pitch]) sphere(r=screw_ball_rad+wall/2);
                    
                }
        }
        
        //d slot for the connection
        translate([0,0,-.1]) d_slot(shaft=7.5, height=10, dflat=.4+.4, double_d=true);
        
        //flatten the base
        translate([0,0,-50]) cube([50,50,100], center=true);
    }
}

//length is measured in revolutions!
module screw_segment(length = 4, starts = 2, top = PEG){  
    pitch = screw_pitch;
    true_pitch = screw_pitch*starts;
    
    screw_inner_rad = (7.5+wall)/2;
    difference(){
        union(){        
            //main tube
            cylinder(r=screw_inner_rad, h=length*pitch);
            
            //we'll need a screw, too...
            for(i=[1:starts]) rotate([0,0,i*(360/starts)]) translate([0,0,-pitch]) screw_threads(length = (length+1)*pitch, pitch = true_pitch);
            
            //handle the screw top
            if(top == PEG){
                //connect to the next screw along
                translate([0,0,length*pitch-.1]) d_slot(shaft=7.5-slop*3, height=10-slop*2, dflat=.4+.4+slop, double_d=true);
            }
            
            if(top == ROUND){
                //this is just flat for now
            }
        }
        
        //d slot for the connection
        translate([0,0,-.1]) d_slot(shaft=7.5, height=10, dflat=.4+.4, double_d=true);
        
        //flatten the base
        translate([0,0,-50]) cube([50,50,100], center=true);
    }
}

module screw_threads(length = 30, pitch = 5){
    facets = 30;
    
    inner_rad = 7;
    
    stretch = 1.1;
    
    intersection(){
        cylinder(r=screw_rad-slop, h=length);
        
        for(turn=[0:pitch:length]) translate([0,0,turn]) {
            //single ring
            for(i=[0:facets]) {
                hull(){
                    rotate([0,0,i*(360/facets)]) translate([inner_rad,0,i*pitch/facets]) scale([stretch,1,1]) rotate([90,0,0]) cylinder(r=screw_rad-slop-inner_rad, h=.1, center=true, $fn=3);
                    
                    rotate([0,0,(i+1)*360/facets]) translate([inner_rad,0,(i+1)*pitch/facets]) scale([stretch,1,1]) rotate([90,0,0]) cylinder(r=screw_rad-slop-inner_rad, h=.1, center=true, $fn=3);
                }
            }
        }
        
    }
}

module motor_holes(){
    translate([0,37/2-12+.1,-20.8/2-5]) cube([22.3+1,37+1,20.8+10], center=true);
    hull(){
        translate([0,37-12,-20.8/2]) rotate([-90,0,0]) cylinder(r=20.5/2, h=28);
        translate([0,37-12,-20.8/2-10]) rotate([-90,0,0]) cylinder(r=24/2, h=28);
    }
   translate([0,0,-1]){
       //center hole is overwritten by the sprocket hole, but it's good to have
       cylinder(r=5.2, h=25);
       
       //bump - straight up
       translate([0,12,0]) cylinder(r=2.6, h=3.1);
       
       //mounting holes
       for(j=[1,1]) mirror([0,0,j]) translate([0,0,(20.8-2)*j]) for(i=[0,1]) mirror([i,0,0]) mirror([0,0,1])  translate([17.5/2,20,0]) {
           cylinder(r=2.9/2, h=80, center=true, $fn=12);
           translate([0,0,22]) cylinder(r1=3.3/2, r2=3.1, h=1.5);
           translate([0,0,22+1.4]) cylinder(r=3.3, h=50);
       }
   }       
}