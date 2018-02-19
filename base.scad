include<configuration.scad>
use <pins.scad>

//%translate([0,0,-in*4]) pegboard([12,12]);

//simple slope!
//rotate([-90,0,0])
*translate([in*10,0,-in*4]) 
mirror([1,0,0])
offset_slope_module(offset=2);
*translate([in*5,0,-in*1]) 
slope_module();

*inlet_switch();
*switch();


!wide_slope_module(size = [4, -.2], width=3);


default_panel();

//this module angles to the other side, acts as a brake to slow down long runs.
//rotate([-90,0,0])
union(){
    %translate([0,0,-in*4]) pegboard([12,12]);
    slope_module(size=[5,-1.5]);
}

inlet(height=2, width=2, length=1, outlet=INLET_HOLE, hanger_height=1);//, inset=0);


*translate([in*10,0,-in*2]) 
rotate([-90,0,0])
reverse_module();

*intersection(){
    rotate([-90,0,0]) inlet(length=4, outlet=NONE);
    rotate([-90,0,0]) translate([in*4,0,0]) mirror([1,0,0]) inlet(length=4);
}

//the size is the X and Y number of holes in the peg board.
//This is meant to be used as a visual reference when designing your module.
module pegboard(size = [12,6]){
    difference(){
        cube([size[0]*in, peg_thick, size[1]*in]);
        
        translate([-.5*in,0,-.5*in]) 
        for(i=[1:size[0]])
            for(j=[1:size[1]])
                translate([i*peg_sep, 0, j*peg_sep]) rotate([90,0,0]) cylinder(r=peg_rad, h=in, center=true);
    }
}

module default_panel(){
    union(){
        pegboard(size = [12,12]);
        translate([-peg_sep*4,0, peg_sep*4]) slope_module(size = [3,-.5]);
        translate([peg_sep*12,0,peg_sep*5]) slope_module();
    }
}

//A sample module which uses the inlet to roll balls down a chute.
module slope_module(size = [4, -.5], width=3, inlet = NORMAL){
    difference(){
        union(){
            if(inlet == NORMAL){
                inlet(height=3, width=width);
            }
            if(inlet == REVERSE){
                translate([peg_sep,0,0]) mirror([1,0,0]) inlet(height=3, width=width, outlet = REVERSE);
            }
            
            translate([in,0,in*2]) track(rise=(size[1]*1.1)*in, run=(size[0]*1.1)*in, solid=1, end_angle=0);
            hanger(solid=1, hole=[floor(size[0])+1,3], drop = -size[1]*in);
        }
        //hole in the inlet
        *translate([in,0,in*2]) track(rise=size[1], run=size[0], solid=-1, hanger=0, extra_len=in-wall*1.5);

		  //cut the end flat
		  translate([50+in*size[0]+in-1,0,in*2]) cube([100,100,100], center=true);
        
         hanger(solid=-1, hole=[floor(size[0])+1,3], drop = in/2);
    }
}

//A sample module which uses the inlet to roll balls down a wide, rolly chute
module wide_slope_module(size = [4, -.5], width=3){
    height = 3;
    difference(){
        union(){
            inlet(height=height, width=width);
            //beefy bottom for more slopey
            translate([0,-in*width,in*2]) cube([in,in*width,in*.55]);
            
            %translate([in*1.45, -in/2, in*2.5]) sphere(r=ball_rad+wall/2);
            
            //flapper to kick it downslope
            intersection(){
                translate([in+ball_rad*2+wall*2.5, -in*1.25, in*2]) rotate([0,0,5]) cube([wall, in*1.25, in]);
                hull() translate([in,0,in*2]) scale([1,width,1]) track(rise=(size[1]*1.1)*in, run=(size[0]*1.1)*in, solid=1, end_angle=0);
            }   
            
            translate([in,0,in*2]) scale([1,width,1]) track(rise=(size[1]*1.1)*in, run=(size[0]*1.1)*in, solid=1, end_angle=0);
            
            hanger(solid=1, hole=[floor(size[0])+1,3], drop = -size[1]*in+in);
            hanger(solid=1, hole=[1,4], drop = -size[1]*in+in*2);
        }
        //inlet exit
        hull(){
            translate([in/2, -in/2, (height-.2)*in]) sphere(r=ball_rad+wall/2);
            translate([in*1.5, -in/2, (height-.3)*in]) sphere(r=ball_rad+wall/2);
        }
        
        hull(){
            translate([in/2, -in/2, (height-.2)*in]) sphere(r=ball_rad+wall/2);
            translate([in/2, -width*in+in/2, (height-.1)*in]) sphere(r=ball_rad+wall/2);
        }

          //cut the end flat
          translate([100+in*size[0]+in-1,0,in*2]) cube([200,200,200], center=true);
        
         //hanger(solid=-1, hole=[floor(size[0])+1,3], drop = in/2);
        
        for(i=[2:1:4]){
            hanger(solid=-1, hole=[floor(size[0])+1,i], drop = -size[1]*in+in);
            hanger(solid=-1, hole=[1,i], drop = -size[1]*in+in*2);
        }
    }
}

//A sample module which uses the inlet to roll balls down a chute.
module offset_slope_module(size = [4, -.5], offset=1){
    inset = wall;
    z_out = offset*in*2;
    
    
    difference(){
        union(){
            inlet(height=3, length=1);
            
            translate([in-inset,0,in*2])  difference(){
                track(rise=(size[1]*2)*in, run=(size[0]*2)*in, z_out=z_out, solid=1, end_angle=0);
                //flatten the front
                translate([-25+inset,-25,0]) cube([50,50,50], center=true);
            }
            hanger(solid=1, hole=[floor(size[0])+1,3], drop = in*.75);
            
            //lower end support
            hull(){
                translate([(floor(size[0])+.5)*in,0,in*2.5-in*.75]) rotate([90,0,0]) rotate([0,0,22.5]) cylinder(r=wall*2, h=in*1.5, $fn=8);
                translate([(floor(size[0])+.5)*in,0,in*2.5-in*.55]) rotate([90,0,0]) rotate([0,0,22.5]) cylinder(r=wall*2, h=in*1.5, $fn=8);
            }
            
        }
        
        translate([in-inset,0,in*2]) difference(){
            track(rise=(size[1]*2)*in, run=(size[0]*2)*in, z_out=z_out, solid=-1, end_angle=0);
            //flatten the front
            translate([0,-25,track_rad+wall]) cube([50,50,50], center=true);
        }

		 //cut the end flat
		 translate([50+in*size[0]+in-1,0,in*2]) cube([100,200,200], center=true);
        
         hanger(solid=-1, hole=[floor(size[0])+1,3], drop = in*.75);
    }
}

//a module to turn the marbles around.
module reverse_module(size = [4, -.5]){
    difference(){
        union(){
            inlet(height=3, hanger_height=1);
            
            translate([0,0,in*2]){
                translate([in,0,0]) track(rise=(size[1]*.5)*in, run=(size[0]*1)*in, solid=1, end_angle=90);
                difference(){
                    translate([-.25*in,-in*2,size[1]*in]) mirror([0,1,0]) track(rise=(size[1]*-.5)*in, run=(size[0]+1.25)*in, solid=1, end_angle=90);
                    //gotta cut the end flat
                    translate([-49,0,in*2]) cube([100,200,100], center=true);
                }
            }
            
            //support
            translate([peg_sep/2,-peg_sep,peg_sep*1.5]) cube([peg_sep-2,wall/2,peg_sep], center=true);
            
            hanger(solid=1, hole=[size[0],4], drop = in*1.33);
        }
        //hole in the inlet
        //translate([in,0,in*2]) track(rise=size[1], run=size[0], solid=-1, hanger=0, extra_len=in-wall*1.5);

		  //cut the end flat
		  translate([50+in*size[0]+in,0,in*2]) cube([100,100,100], center=true);
        
        hanger(solid=-1, hole=[size[0],4], drop = in*1.33);
    }
}

/* The inlet module.
 * ABSOLUTELY REQUIRED: two (2) scalloped entry points, centered 1" and 2" from the hook.  The height and radius are not to deviate.
 *
 * Variables:
 * height: Given in units of pegboard; raises or lowers your inlet, for convenience.  Must be a whole number.
 *
 * width: MINIMUM 2, I think max 3 by convention... not set in stone.
 * ***TODO: this parameter does not yet affect the width of the inlet.
 *
 * length: Given in units of pegboard; 1 or more.  Each extra unit adds its own hanger, if applicable.
 *
 * outlet: how the ball gets out; options are INLET_HOLE, INLET_SLOT, and INLET_NONE.  Hole is a single exit point; slot opens the entire side, and none does nothing.  All three still move the balls to the pegboard/outlet corner, however.
 * 
 * hanger_height: Given in units of pegboard, how tall your hanger should be.  Set to 0 for no hanger.
 * board_inset: How far into the pegboard the inlet should jut - used for the ball return.  Does not affect the inlet holes, but does effect the outlet.
 */
module inlet(height = 1, width = 3, length = 1, hanger_height=1, lift=5, outlet=INLET_HOLE, inset = inlet_x-ball_rad*2-wall*2, board_inset = 0){
    //slope = .25*in;
    
    side_supports = length-1;
    
    inlet_x = inlet_x*length;
    inlet_y = inlet_y/2*width;
    
    lift_angle = atan(lift/inlet_x);
    drop_top = 4.6;
    
    %translate([in,-in/2,(height-.5)*in]) translate([0,0,0]) sphere(r=ball_rad);
    
    translate([0,-inlet_y+board_inset,height*in-inlet_z])
    difference(){
        union() {
            hull(){
                cube([inlet_x,inlet_y,.1]);
                translate([0,0,inlet_z-drop_top]) rotate([0,-lift_angle,0]) cube([inlet_x+inset,inlet_y,.1]);
                translate([inlet_x-wall,inlet_y-wall,inlet_z+lift]) cube([wall,wall,.1]);
                //%translate([0,0,inlet_z-.1]) cube([inlet_x,inlet_y,.1]);
            }
            for(i=[0:length-1]){
                translate([i*inlet_x/length,inlet_y,-in+inlet_z]) difference(){
                    hanger(solid=1, hole=[1,1+hanger_height], drop = (hanger_height)*in);
                    hanger(solid=-1, hole=[1,1+hanger_height], drop =(hanger_height)*in);
                }
            }
        }
        
        //hollow center
        difference(){
            hull(){
                intersection(){
                    //ball divot
                    if(outlet == REVERSE){
                        hull(){
                            translate([0,inlet_y-in/2,in/2]) translate([0,0,0]) sphere(r=in/2-wall);
                            translate([0,inlet_y-in/2,in*3/4]) translate([0,0,0]) sphere(r=ball_rad);
                        }
                    }else{
                        hull(){
                            translate([inlet_x,inlet_y-in/2,in/2]) translate([0,0,0]) sphere(r=in/2-wall);
                            translate([0,inlet_y-in/2,in*3/4]) translate([0,0,0]) sphere(r=ball_rad);
                        }
                    }
                    hull(){
                        translate([wall,wall,0]) cube([inlet_x-wall*2,inlet_y-wall*2,.1]);
                        translate([wall,wall,inlet_z+lift]) cube([inlet_x-wall*2+inset,inlet_y-wall*2,.1]);
                    } 
                    //translate([wall,wall,wall]) cube([inlet_x-wall*2-inset,inlet_y-wall*2,inlet_z]);
                }
                
                //this is the main body
                translate([wall,wall,wall*3]) cube([inlet_x-wall*2,inlet_y-wall*2,.1]);
                translate([0,wall,inlet_z+lift+.1]) rotate([0,-lift_angle,0])  translate([wall,0,0]) cube([inlet_x+inset-wall*2,inlet_y-wall*2,.1]);
            }
            
            //wall supports
            if(length >= 2){
                for(i=[1:length-1]){
                    translate([i*in,0,0]) rotate([30,0,0]) translate([0,0,in/4]) cube([wall/2, in+2*i,in+2*i], center=true);
                }
            }
        }

		  //ball exit
		  if(outlet == INLET_HOLE){
              hull(){
                    translate([inlet_x,inlet_y-in/2,in/2]) translate([0,0,0]) sphere(r=in/2-wall);
                    translate([inlet_x-in/2,inlet_y-in/2,in/2]) translate([0,0,0]) sphere(r=ball_rad);
                }
            }
            
            if(outlet == INLET_SLOT){
              hull(){
                    translate([inlet_x,inlet_y-in/2,in/2]) translate([0,0,0]) sphere(r=in/2-wall);
                    translate([inlet_x-in/2,inlet_y-in/2,in/2+wall]) translate([0,0,0]) sphere(r=ball_rad+wall/2);
                    translate([inlet_x,inlet_y+in/2-in*width,in/2]) translate([0,0,0]) sphere(r=in/2-wall);
                    #translate([inlet_x-in/2,inlet_y+in/2-in*width,in/2+wall]) translate([0,0,0]) sphere(r=ball_rad+wall/2);
                }
            }
            
            if(outlet == REVERSE){
                hull(){
                    translate([0,inlet_y-in/2,in/2]) translate([0,0,0]) sphere(r=in/2-wall);
                    translate([inlet_x-in/2,inlet_y-in/2,in/2]) translate([0,0,0]) sphere(r=ball_rad);
                    translate([0,inlet_y-in/2,in]) translate([0,0,0]) sphere(r=in/2-wall);
                }
            }
        
        //scalloped entry
        for(i=[board_inset:in:inlet_y-1]){
            translate([-in/2,inlet_y-i,inlet_z-in/2-.35]) track(rise=-1.5, run=17, solid=-1, track_rad=track_rad+.35);
            
        }
        
        //extra inlet holes
        for(i=[0:length-1]){
            translate([i*inlet_x/length,inlet_y,-in+inlet_z])
            hanger(solid=-1, hole=[1,1+hanger_height], drop =(hanger_height)*in);  }
    }
}

//two kinds of switch - manual or flip flop.
module switch(solid=1, type = SWITCH){
    post_rad = 2.5;
    bearing_rad = 10/2+slop;
    flange_rad = 12.25/2;
    translate([0,-post_rad*2-slop*2,0]){
        if(solid == 1){
            union(){
                cylinder(r=post_rad-slop/2, h=in);
                translate([0,0,wall*2]) cylinder(r=post_rad*2, h=in-wall*5);
                
                if(type == SWITCH){
                    rotate([0,0,-45]) union(){
                         hull(){
                            translate([0,0,wall*3]) cylinder(r=post_rad*2, h=in-wall*5);
                            translate([0,-in*1,wall*4]) cylinder(r=post_rad/2, h=in-wall*6);
                            
                             for(i=[0,1]) mirror([i,0,0]) rotate([0,0,72]) translate([0,-in*.25,wall*4]) cylinder(r=post_rad, h=in-wall*6);
                        }
                    }
                }
                
            }
        }
    
        if(solid == -1){
            hull(){
                
                
                cylinder(r=post_rad+slop*2, h=in*2.5, center=true);
                translate([0,-post_rad*1.33,in]) cylinder(r=post_rad+slop*4, h=in/2, center=true);
            }
            
            cylinder(r=bearing_rad+slop/2, h=wall*5, center=true);
            translate([0,0,wall*2]) cylinder(r=flange_rad, h=in-wall*3);
        }
    }
}

module switch_clip(){
    post_rad = 2.5;
    bearing_rad = 10/2;
    translate([0,0,in]){
        hull(){
            translate([0,-bearing_rad+wall-wall/2,0]) scale([1,1,1]) cylinder(r=bearing_rad+wall/2, h=wall*1.5);
        }
    }
}

module inlet_switch(height = 1, width = 3, inlet_length = 2, left_length = 3, right_length = 2, hanger_height=1, lift=5, outlet=INLET_HOLE, inset = inlet_x-ball_rad*2-wall*2){
    
    base_rise = 10;
    
    inlet_y = inlet_y/2*width;
    inlet_x = inlet_x*inlet_length;
    inlet_y = inlet_y/2*width;
    
    lift_angle = atan(lift/inlet_x);
    drop_top = 4.6;
    
    %translate([in,-in/2,(height-.5)*in]) translate([0,0,0]) sphere(r=ball_rad);
    %translate([-in,-in/2,(height-.5)*in]) translate([0,0,0]) sphere(r=ball_rad);
    
    difference(){
        union(){
            //the frame
            intersection(){
                translate([-in,0,0]) inlet(length = inlet_length);
                translate([in,0,0]) mirror([1,0,0]) inlet(length = inlet_length);
            }
            
            //new bottom
            //slope the base inwards, to better hit the flipper
            hull(){
                translate([0,-wall,wall]) cube([in*2, .1, wall*2], center=true);
                translate([0,-width*in+wall, (wall+base_rise)/2]) cube([in*2, .1, wall+base_rise], center=true);
            }
            
            //switch
            translate([0,-wall,0]){
                %switch(solid = 1);
                switch_clip();
            }
            
            //Exits!  We put in a ramp going out each side.
            //left:
            translate([-in,0,0]) mirror([1,0,0]) track(rise=(-.5*1.1)*in, run=(left_length*1.1)*in, solid=1, end_angle=0);
            //right
            translate([in,0,0]) mirror([0,0,0]) track(rise=(-.5*1.1)*in, run=(right_length*1.1)*in, solid=1, end_angle=0);
        }
        
        //Exits!  We put in a ramp going out each side.
        //left:
        translate([-50-in-left_length*in,0,0]) cube([100,100,100], center=true);
        //right
        translate([50+in+right_length*in,0,0]) cube([100,100,100], center=true);
        
        //ball path
        for(i=[0,1]) mirror([i,0,0]){
            hull(){
                translate([0,-peg_sep/2,in/2+wall]) translate([0,0,0]) sphere(r=in/2-wall*1.5);
                translate([-in-wall*2,-peg_sep/2,track_rad+wall+.75]) translate([0,0,ball_rad-track_rad]) sphere(r=track_rad);
            }
            
            //this just shores up the openings
            hull(){
                translate([-in,-peg_sep/2,track_rad+wall+2]) translate([0,0,ball_rad-track_rad]) sphere(r=track_rad);
                translate([-in,-peg_sep/2-in,track_rad+wall+.75+in]) translate([0,0,ball_rad-track_rad]) sphere(r=track_rad);
            }
        }
        
        //hole for the switch mount
        translate([0,-wall,0]) switch(solid = -1);
        
        //core out the new bottom
        translate([0,-wall,wall]) hull(){
            translate([0,0,wall*3]) cube([in*2-wall*2, .1, wall*4], center=true);
            translate([0,-width*in+wall*2, wall*2+base_rise]) cube([in*2-wall*2, .1, wall*4], center=true);
            
            //center the marbles a bit
            //translate([0,-in/2+wall,(height-.5)*in-wall*1.5]) translate([0,0,0]) sphere(r=ball_rad);
        }
        
        //remove some exess material
        translate([0,-wall,-wall*5]) hull(){
            translate([0,0,wall*2]) cube([in*2+wall, .1, wall*4], center=true);
            translate([0,-width*in+wall, wall*2+base_rise]) cube([in*2+wall, .1, wall*6], center=true);
        }
    }
}

//used to hang everything :-)
module hanger(solid=0, hole=[1,4], slot_size = 0, drop = in/2, rot = 0, chamfer_offset = .25){
    offset = (track_rad+wall);
    
    translate([in*hole[0]-peg_sep/2, 0, in*(hole[1]-1)]) 
    if(solid >= 0) union(){
        hull(){
            translate([-slot_size/2,0,peg_sep/2]) rotate([90,0,0]) cylinder(r=peg_sep/3, h=wall);
            translate([slot_size/2,0,peg_sep/2]) rotate([90,0,0]) cylinder(r=peg_sep/3, h=wall);
                
            rotate([0,rot,0]) translate([0,0,peg_sep/2-drop])rotate([90,0,0]) rotate([0,0,22.5]) cylinder(r=peg_rad+wall, h=wall, $fn=8);
        }
    }
    
    translate([in*hole[0]-peg_sep/2, 0, in*(hole[1]-1)]) 
    if(solid <= 0) union(){
        for(j=[0:1:ceil(drop/in)]) translate([0,0,-in*j])
        for(i=[0:1]){
            //chamfer
            hull() for(j=[0:1]) mirror([j,0,0]) {
                translate([slot_size/2,0,peg_sep/2]) rotate([90,0,0]) translate([0,0,wall/2]) mirror([0,0,i]) translate([0,0,chamfer_offset]) cylinder(r1=peg_rad-slop, r2=peg_rad+wall+wall, h=wall*2);
            }
            //center bore
            hull() for(j=[0:1]) mirror([j,0,0]) {
                translate([slot_size/2,0,peg_sep/2]) rotate([90,0,0]) translate([0,0,wall/2]) mirror([0,0,i]) translate([0,0,-.1]) cylinder(r=peg_rad+slop, h=wall*2);
            }
            
            //cap area, in case of thicker walls
            hull() for(j=[0:1]) mirror([j,0,0]) {
                translate([slot_size/2,0,peg_sep/2]) rotate([90,0,0]) translate([0,0,wall/2]) mirror([0,0,i]) translate([0,0,wall/2-.1]) cylinder(r=peg_cap_rad+slop*2, h=wall*2);
            }
        }
        //cut out t
    }
}

//track trough
module track_trough(angle=0, length=1, ta=240, z_angle = 0){
    difference(){
            union(){
                rotate([0,0,z_angle])
                rotate([0,angle,0]) difference(){
                    //%translate([length,0,0]) translate([0,0,ball_rad-track_rad]) sphere(r=ball_rad);
                    
                    rotate([0,90,0]) rotate([0,0,22.5]) cylinder(r=(track_rad+wall)/cos(180/8), h=length, $fn=8);
                    translate([-.5,0,0]) {
                        rotate([45,0,0]) cube([length+1, track_rad+wall*2, ball_rad+wall*2]);
                        for(i=[0,1]) mirror([0,i,0]) {
                            rotate([ta/2,0,0])  translate([0,0,-wall*2]) cube([length+1, track_rad+wall*2, track_rad+wall*2]);
                            translate([0,0,wall/2]) cube([length+1, track_rad+wall*2, track_rad+wall*2]);
                        }
                    }
                }
            }
        
            //ball path
            translate([-.5,0,0]) rotate([0,0,z_angle]) rotate([0,angle,0]) rotate([0,90,0]) cylinder(r=track_rad, h=length+2);
        }
}

module track_hollow(angle=0, length=1, ta=240, z_angle = 0){
    difference(){
        rotate([0,0,z_angle]) rotate([0,angle,0]) rotate([0,90,0]) rotate([0,0,22.5]) cylinder(r=(track_rad+wall)/cos(180/8)-.1, h=length, $fn=8);
        track_trough(angle=angle, length=length, ta=ta, z_angle = z_angle);
    }
}

//a 2d cross section of the track.  Used to make curves.
module track_slice(){
    projection() translate([0,0,1]) rotate([0,90,0]) track_trough(length=2);
}

module track_slice_2(){
    translate([0,0,-.01]) rotate([0,90,0]) track_trough(length=.02);
}

module track_hollow_slice_2(){
    difference(){
        intersection(){
            translate([wall,0,0]) cube([peg_sep,peg_sep-wall/2,.2], center=true);
            sphere(r=track_rad+wall);
        }
        translate([0,0,1]) rotate([0,90,0]) track_trough(length=2);
    }
}

module track_curve(angle=45){
    intersection(){
        translate([0,0,-peg_sep/2-.5]) cube([peg_sep+1, peg_sep+1, peg_sep+1]);
        translate([0,0,-peg_sep/2-.5]) rotate([0,0,angle]) cube([peg_sep, peg_sep, peg_sep]);
        rotate_extrude(convexity=10){
            rotate([0,0,90]) translate([0,in/2+.01,0]) track_slice();
        }
    }
}


module track_curve_2(angle=90, drop=-10, track_angle = -80){
    num_steps = 5;
    //translate([0,0,-peg_sep/2-.5]) cube([peg_sep+1, peg_sep+1, peg_sep+1]);
    //translate([0,0,-peg_sep/2-.5]) rotate([0,0,angle]) cube([peg_sep, peg_sep, peg_sep]);
    
    
    extra_drop = drop/(num_steps+1)*tan(90-track_angle);
    mirror([1,1,0])
    rotate([90,0,0]) 
    difference(){
        union(){
            //the inlet is extra-long, to meet the slope this attaches to.
            hull(){
                rotate([0,0,90]) translate([0*drop/(num_steps+1),in/2+.01,extra_drop]) track_slice_2();
                rotate([0,0,90]) translate([1*drop/(num_steps+1),in/2+.01,0]) track_slice_2();
            }
                
            //the curved angle
            for(i=[0:num_steps-1]){
                hull(){
                    rotate([0,i*angle/num_steps,0]) rotate([0,0,90]) translate([(i+1)*drop/(num_steps+1),in/2+.01,0]) track_slice_2();
                    rotate([0,(i+1)*angle/num_steps,0]) rotate([0,0,90]) translate([(i+2)*drop/(num_steps+1),in/2+.01,0]) track_slice_2();
                }
            }
        }
        //inlet
        hull(){
            rotate([0,0,90]) translate([0*drop/(num_steps+1),in/2+.01,extra_drop]) track_hollow_slice_2();
            rotate([0,0,90]) translate([1*drop/(num_steps+1),in/2+.01,0]) track_hollow_slice_2();
        }
        
        //curved part
        for(i=[0:num_steps-1]){
            hull(){
                rotate([0,i*angle/num_steps,0]) rotate([0,0,90]) translate([(i+1)*drop/(num_steps+1),in/2+.01,0]) track_hollow_slice_2();
                rotate([0,(i+1)*angle/num_steps,0]) rotate([0,0,90]) translate([(i+2)*drop/(num_steps+1),in/2+.01,0]) track_hollow_slice_2();
            }
        }
    }
}


//section of track.
//Length is in mm.
//Start is at 0 (move it where you want it) end is length units away horizontally, at the specified angle.
//rise and run are both inches - length and angle are calculated from them.
//solid = 1: draw the track
//solid = 0: draw both track and path
//solid = -1: draw the marble path - useful for making holes in things.
//
//start/end dictate the angle at the end of the track.  This is a 1" radius, period - defaults to 0, which is straight; angles over 90 or under -90 result in +/-90.
module track(rise=-in, run=in*5, z_out=0, solid=1, track_angle=120, start=0, end_angle=0, extra_len = in, end_scale=[1,1,1]){

	 angle = -atan(rise/run);
     z_angle = -atan(z_out/run);

    ta = 360-track_angle;
    
    //track_rad+wall
    //extra = abs(cos(90-angle)*(track_rad+wall)); //how much longer to make track due to its thickness
    extra = 0;
    length = sqrt(rise*rise+run*run);
    
    //
    end_subtract = sin(end_angle)*(track_rad+wall)*2;
    
    translate([0,0,track_rad+wall])
    if(solid>=0){
        difference(){
            union(){
                //%translate([0,-peg_sep/2,0]) translate([0,0,ball_rad-track_rad]) sphere(r=ball_rad);
                translate([0,-peg_sep*.5,0]) track_trough(angle, length+extra-end_subtract, ta, z_angle=z_angle);
            
                //#rotate([0,angle,0]) translate([length+extra,0,0]) translate([-peg_sep,-peg_sep, -peg_sep/2]) cube([peg_sep, peg_sep, peg_sep]);
            
                echo("track end echoes");
                echo(rise-in*rise/run);
                echo(length);
                echo(extra);
                echo(end_subtract);
                //curve the end, as needed
                translate([0,-peg_sep,0]) 
                rotate([0,angle,0]) translate([length+extra-end_subtract,0,0])
                //translate([0,0,rise-in*rise/run]) 
                rotate([0,-angle,0]) translate([0,0,-4*rise/run]) scale(end_scale) track_curve_2(angle=end_angle, drop=in*rise/run*1.125, track_angle=angle);
            }
            //make the ends flat
            translate([50+run+extra+(end_scale[0]-1)*end_subtract,0,0]) cube([100,200,200], center=true);
            translate([-50,0,0]) cube([100,200,200], center=true);
        }
    }
    
	 //this is used to hollow out things that the track is supposed to connect to, and to make sure that the ball path is clear.
    translate([0,0,track_rad+wall])
    if(solid<=0){
        *translate([-.5,0,0]) translate([0,-peg_sep*.5,track_rad+wall]) rotate([0,angle,0]) *rotate([0,90,0]) cylinder(r=track_rad, h=extra_len*2, center=true);
        
        translate([0,-peg_sep*.5,0]) track_hollow(angle, length+extra-end_subtract, ta, z_angle=z_angle);
    }
}

/********** Just a couple useful functions **********/
module d_slot(shaft=6, height=10, tolerance = .2, dflat=.25, $fn=30){
    translate([0,0,-.1]){
       difference(){ 
           cylinder(r1=shaft/2+tolerance, r2=shaft/2+tolerance/2, h=height+.01);
           translate([-shaft/2,shaft/2-dflat,0]) cube([shaft, shaft, height+.01]);
           translate([-shaft/2,-shaft/2-shaft+dflat,0]) cube([shaft, shaft, height+.01]);
       }
    }
}

module motorHoles(solid=1, motor_bump=4, support=false, slot=0, top_rad = 3.1){
    %translate([0,37/2-12,-20.8/2]) cube([22.3,37,20.8], center=true);
    %translate([0,37-12,-20.8/2]) rotate([-90,0,0]) cylinder(r=22/2, h=28);
    
    if(solid==1) translate([0,0,1]) {
        //mounting holes
            mirror([0,0,1]) translate([0,0,(20.8)*1]) {
                for(i=[0,1]) mirror([i,0,0]) translate([17.5/2,20,0]) {
                    //cylinder(r=3.3/2+wall, h=motor_bump);
                    #hull() for(j=[-slot/2, slot/2]) translate([j,0,0]) {
                        cylinder(r1=top_rad, r2=top_rad+wall, h=motor_bump+.1);
                        translate([0,0,motor_bump]) cylinder(r=top_rad+wall, h=wall/2);
                    }
                }
                if(support == true){
                    translate([0,0,0]) cylinder(r1=top_rad, r2=top_rad+wall, h=motor_bump+.1);
                    translate([0,0,motor_bump]) cylinder(r=top_rad+wall, h=wall/2);
                }
            }
    }
    
    if(solid==0){
        translate([0,0,-1]){
            //center hole is overwritten by the sprocket hole, but it's good to have
            //cylinder(r=5.2, h=30);
       
            //bump - straight up
            //translate([0,12,0]) cylinder(r=2.6, h=3.1);
            
            *hull() for(j=[-slot/2, slot/2]) translate([j,0,0]) {
                cylinder(r1=3.2, r2=3.2+wall, h=motor_bump+.1);
                translate([0,0,motor_bump]) cylinder(r=3.2+wall, h=wall/2);
                }
       
            //mounting holes
            for(j=[0,1]) mirror([0,0,1]) translate([0,0,(20.8-2)*1]) for(i=[0,1]) mirror([i,0,0]) translate([17.5/2,20,0]) {
                
                hull() for(s=[-slot/2, slot/2]) translate([s,0,0]) cylinder(r=3.4/2, h=30);
                translate([0,0,2.6]) hull() for(s=[-slot/2, slot/2]) translate([s,0,0]) cylinder(r1=3.4/2, r2=3.2, h=1.5);
                translate([0,0,wall+1]) hull() for(s=[-slot/2, slot/2]) translate([s,0,0]) cylinder(r=3.2, h=20);
            }
       }
   }       
}