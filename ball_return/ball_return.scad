include<../configuration.scad>
use <../base.scad> 
use <../pins.scad>
use <../peg.scad>
use <../handle.scad>

part = 6;

if(part == 0)
    rotate([0,90,0]) rear_ball_return_inlet();

if(part == 1)
    rotate([0,90,0]) rear_ball_return_inlet_180(width=3);

if(part == 2)
    rotate([0,90,0]) rear_ball_return_inlet(width=3);

if(part == 3)
    translate([-in*1.5,0,0]) rotate([0,270,0]) rear_ball_return_outlet();

if(part == 4)   //deprecated
    translate([0,0,peg_thick/2-slop]) rotate([90,0,0]) ball_return_peg();

if(part == 5)   //probably shouldn't use :-)
    translate([0,0,peg_thick/2-slop]) rotate([0,90,0]) ball_return_joint();

if(part == 6)
    rotate([0,90,0]) rear_ball_return_inlet_90(width=3);

if(part == 10){
    basic_panel();
    translate([in*12,in+peg_thick*2,0]) rotate([0,0,180]) basic_panel();
}

module basic_panel(){
    union(){
        pegboard([12,12]);

        //ball return
        translate([in*12,0,in*5]) rear_ball_return_inlet_180();
        //translate([0,0,in*4]) rear_ball_return_outlet();
        
        //feet
        translate([peg_sep*10, 0, peg_sep]) peg_stand();
        translate([peg_sep,0,peg_sep]) mirror([1,0,0]) peg_stand();
        
        //handle
        translate([peg_sep*5.5,0,peg_sep*12.525]) rotate([270,0,0]) mirror([0,0,1]) translate([0,0,-peg_thick]) handle();
    }
}

module ball_return_joint(){
    lengthen = 1.75;
    difference(){
        union(){
            scale([lengthen,1,1]) dowel_holder();
            
            //center stop
            translate([-wall+dowel_holder_height*lengthen/2,0,17]) cube([2,dowel_sep+dowel_rad*2+1,dowel_rad], center=true);
            
            translate([-wall+.375+dowel_holder_height*lengthen/2,0,wall*2+ball_rad+dowel_rad]) cube([dowel_holder_height*lengthen*2,dowel_rad,dowel_rad], center=true);
            
            translate([dowel_holder_height*lengthen-.1,0,0]) scale([lengthen,1,1]) dowel_holder();
        }
        
        //ball path
        translate([0,0,wall]) hull(){
            for(i=[-dowel_holder_height*3, dowel_holder_height*3]) translate([i,0,0])
                sphere(r=ball_rad+slop*2, $fn=60);
        }
    }
}

module ball_return_peg(){
    //%translate([wall+peg_thick/2,in/2,in/2])
    %translate([in/2,-in/2,-peg_thick/2-wall]) rotate([90,0,0]) rear_ball_return_inlet();
    
    shoulder_rad = peg_rad+wall/2-slop*2;
    min_rad = 1;
    slit_rad = 1;
    
    difference(){
        union(){
            //core
            cylinder(r=peg_rad-slop, h=peg_thick+wall*2, center=true);
            
            //flare the ends
            for(i=[0:1]) mirror([0,0,i]) {
                translate([0,0,peg_thick/2+wall/2]) cylinder(r1=peg_rad-slop, r2=shoulder_rad, h=wall/2+.05);
                translate([0,0,peg_thick/2+wall]) cylinder(r2=peg_rad, r1=shoulder_rad, h=wall/2);
            }
            
            //handle
            translate([0,0,peg_thick/2+wall]) minkowski(){
                cylinder(r1=peg_rad-slop-min_rad, r2=peg_rad+wall/2-min_rad, h=in/3);
                sphere(r=min_rad);
            }
        }
        
        //slit
        hull(){
            rotate([90,0,0]) cylinder(r=slit_rad, h=peg_rad*4, center=true);
            translate([0,0,-peg_thick/2-wall*1.5]) rotate([90,0,0]) cylinder(r=slit_rad+slop, h=peg_rad*4, center=true);
        }
        
        //screwhole
        mirror([0,0,1]) translate([0,0,-in/4]) cylinder(r1=1.25, r2=1.5, h=in*.75);
        
        //flatten the top/bottom
        for(i=[0:1]) mirror([0,i,0]) translate([0,peg_rad+25-slop,0]) cube([50,50,50], center=true);
    }
}

module rear_ball_return_inlet_90(width=3){
    rear_ball_return_inlet(dowel = false, exit_extend = -in, extra_attach=false, 90_attach=true, straight_exit=true);
}

module rear_ball_return_inlet_180(width=3){
    rear_ball_return_inlet(dowel = false, exit_extend = in*1.5, extra_attach=true);
}

module rear_ball_return_inlet(width=2, dowel = true, exit_extend = 0, extra_attach=false, 90_attach=false, straight_exit=false){
    %translate([0,in/4+wall,0]) cube([rear_gap,rear_gap,rear_gap]);
    
    front_inset = 0;
    
    inset = rear_gap/in-.25-.25-wall/in-wall/in+exit_extend/in;    //for some reason I left this in inches.  bleck.
    
    
    exit_offset = peg_thick+wall + rear_gap/2 + wall/2 - wall + exit_extend+wall-1;
    dowel_lift = -in*.55;
    
   
    difference(){
        union(){
            //inlet catcher - extends to the back, to deposit balls there.
            inlet(length=1, hanger_height=0, outlet=REVERSE, height=1, width=1+width+inset, board_inset = in+inset*in);
            
            //base stiffener
            hull(){
                translate([in-.1,-(width)*in,0]) cube([wall,in*(width)+inset*in+in,in]);
                translate([in-.1,0,-in/2]) cube([wall,wall*2+in/4,in/4]);
            }
            
            //false bottom, to make a better channel
            translate([wall/4,-(width)*in,0]) cube([in,in*(1+width)+inset*in,wall*4.5]);
            
            //newfangled pegboard attachment system
            translate([0,-wall,0]) pegboard_attach();
            
            if(extra_attach == true){
                translate([0,exit_extend-peg_thick-wall,0]) pegboard_attach();
            }
            
            //%pegboard_attach_old();

            
            //hold a couple dowels underneath, to run the balls to the outlet
            if(dowel == true)
                translate([0, exit_offset, dowel_lift]) dowel_holder();
        }
        
        //channel in the false bottom
        union(){
                //exit slope
                if(straight_exit == false){
                    hull(){
                        translate([in/2,exit_offset,in-wall*3]) sphere(r=ball_rad+wall);
                        translate([-in/2,exit_offset,in-wall*4.25]) sphere(r=ball_rad+wall/2);
                    }
                }else{
                    hull(){
                        //go straight!
                        translate([in/2,exit_offset,in-wall*3]) sphere(r=ball_rad+wall);
                        translate([in/2,exit_offset+in,in-wall*4.25]) sphere(r=ball_rad+wall/2);
                    }
                }
                
                //horizontal slope
                hull(){
                    translate([in/2,exit_offset,in-wall*3]) sphere(r=ball_rad+wall);
                    translate([in/2,-in*(width-.5),in-wall]) sphere(r=ball_rad+wall);
                }
        }
       
        //dowel holes
        if(dowel == true)
            translate([0,exit_offset,dowel_lift]) dowel_holes(flare_len = dowel_holder_height/3);
        
        //flatten the far side for printing on
        translate([100+in+wall/2,0,0]) cube([200,200,200], center=true);
        
        //flatten the back side so it sits flush with the handle mounts
        translate([0,100+peg_thick+wall+rear_gap+exit_extend,0]) cube([200,200,200], center=true);
    }
}

//pegboard attachment
module pegboard_attach_old(){
                //attach it to the pegboard
            translate([0,0,0]) difference(){
                hull(){
                    hanger(solid=1, hole=[0,0], drop = in*2.5, rot=245);
                    hanger(solid=1, hole=[-1,0], drop = in*3.25, rot=230);
                    //cylinder(r=in, h=wall);
                }
                
                hanger(solid=-1, hole=[0,0]);
                hanger(solid=-1, hole=[-1,0]);
                
                //ball hole
                hull(){
                    translate([in/2,0,in*.45]) sphere(r=ball_rad+wall);
                    translate([in/2,0,in*2]) sphere(r=ball_rad+wall);
                }
            }
            
            //back nub
            translate([0,wall*2+in*.25,0]) difference(){
                difference(){
                    translate([in*.025,0,in/2]) rotate([90,0,0]) cylinder(r=in/4, h=wall);
                    translate([in*.025,-in/2,0]) cube([in,in,in]);
                }
            }
}

module pegboard_attach(upper=false){
    //so we're going to use two holes, but the far one's a double-sided bump
    reg_wall = wall;
    wall = wall+1.25;
    bump = 3;
    difference(){
        translate([0,wall*1+peg_thick/2-1, 0]) 
        for(i=[0,0]) mirror([0,i,0]) translate([0,wall*1+peg_thick/2,0]) {
            hull(){
                //if(upper==false){
                    //lower
                    hanger(solid=1, hole=[0,0], drop = in*2.5, rot=245, wall=wall);
                    hanger(solid=1, hole=[-1,0], drop = in*3.25, rot=240, wall=wall);
                //}else{
                    //upper
                    hanger(solid=1, hole=[0,1], drop = in*3.25, rot=260, wall=wall);
                    hanger(solid=1, hole=[-1,1], drop = in*3.25, rot=245, wall=wall);
                //}
            }
            
            //bump
            *translate([-in*1.5,-wall,-in*.5]) hull(){
                translate([0,0,0]) scale([1,.8,1]) sphere(r=peg_rad+slop);
                translate([0,-wall/4,0]) scale([.97,.5,.97]) sphere(r=peg_rad+slop);
                translate([0,-bump/2,0]) scale([.8,.4,.8]) sphere(r=peg_rad+slop);
            }
        }
        
        //peg hole in the rear
        translate([0,wall*1+peg_thick/2-1, 0]) {
            //lower
            translate([0,reg_wall*1+peg_thick/2,0]) hanger(solid=-1, hole=[0,0]);
            translate([0,reg_wall*1+peg_thick/2,0]) hanger(solid=-1, hole=[-1,0]);
            
            //upper
                translate([0,reg_wall*1+peg_thick/2,0]) hanger(solid=-1, hole=[0,1]);
                translate([0,reg_wall*1+peg_thick/2,0]) hanger(solid=-1, hole=[-1,1]);
            
        }
        
        //ball hole
        hull(){
            translate([in/2,-wall,in*.45]) sphere(r=ball_rad+wall);
            //translate([in/2,-wall,in*2]) sphere(r=ball_rad+wall);
            
            translate([in/2,wall*2+peg_thick,in*.45]) sphere(r=ball_rad+wall);
            //translate([in/2,wall*2+peg_thick,in*2]) sphere(r=ball_rad+wall);
            
        }
    }
}

module rear_ball_return_outlet(){
    %translate([0,in/4+wall,0]) cube([rear_gap,rear_gap,rear_gap]);
    //inset = .75-.25-wall/in;
    front_inset = 0;
    
    inset = rear_gap/in-.25-.25-wall/in-wall/in;    //for some reason I left this in inches.  bleck.
    exit_offset = peg_thick+wall + rear_gap/2 + wall/2 - wall;
    
    dowel_lift = -in*.75;
    
    //lower the inlet entirely - split the difference, basically
    extra_drop = in/4;
    
    
    difference(){
        union(){
            //inlet catcher - extends to the back, to deposit balls there.
            translate([0,in/2-wall*2-inset*in-wall*2,0]) rotate([0,0,180]) inlet(length=1, hanger_height=0, outlet=REVERSE, height=1, width=2+inset, board_inset = inset*in);
            
            //stiffen the back a bit
            mirror([1,0,0]) hull(){
                translate([in-.1,-1*in,0]) cube([wall,in*2+in*inset,in]);
                translate([in-.1,0,in/2+extra_drop+in/2]) cube([wall,wall*2+in/4,in/4]);
            }
            
            //false bottom, to make a better channel
            translate([-in-wall/4,-1*in,0]) cube([in,in*2+inset*in,wall*4]);

                   
            //attach it to the pegboard
            translate([0,-wall,extra_drop]) mirror([1,0,0]) pegboard_attach(upper=true);
            
            //hold a couple dowels underneath, to run the balls to the outlet
            mirror([0,0,1]) translate([dowel_holder_height/2+1,exit_offset,dowel_lift]) dowel_holder();
            //translate([in,in*.5+inset*in+front_inset,-in*.63]) dowel_holder();
        }
        
        //ball path, cut into the false bottom
        union(){          
                //exit slope
                hull(){
                    translate([-in/2,-in/2,in/2+wall]) sphere(r=ball_rad+wall);
                    translate([in/2,-in/2,in/2]) sphere(r=ball_rad+wall);
                }
                
                //horizontal slope
                hull(){
                    translate([-in/2,-in/2,in/2+wall]) sphere(r=ball_rad+wall);
                    translate([-in/2,exit_offset,in*.7]) sphere(r=ball_rad+wall);
                }
                
                //inlet slope
                hull(){
                    translate([-in/2,exit_offset,in*.7]) sphere(r=ball_rad+wall);
                    translate([in,exit_offset,in*.75]) sphere(r=ball_rad+wall);
                }
            }
        
        //rods coming in :-)
        mirror([0,0,1]) translate([dowel_holder_height/2+1,exit_offset,dowel_lift]) dowel_holes(dowel_holder_height/3);
                
        //flatten the far side for printing on
        mirror([1,0,0]) translate([100+in+wall/2,0,0]) cube([200,200,200], center=true);
        
        //flatten the back side for matching the handle mounts
        translate([0,100+peg_thick+wall+rear_gap,0]) cube([200,200,200], center=true);
    }
}

module pegboard_attach_2_old(){
    translate([0,wall*3+in*.25,0]) mirror([1,0,0]) difference(){
                hull(){
                    hanger(solid=1, hole=[0,0], drop = in*2.5, rot=245);
                    hanger(solid=1, hole=[-1,0], drop = in*3.25, rot=230);
                    
                    //translate([in*.025,0,-in*.75-in*.125]) rotate([90,0,0]) cylinder(r=in, h=wall);
                }
                
                hanger(solid=-1, hole=[0,0]);
                hanger(solid=-1, hole=[-1,0]);
                //translate([-in*2+1,-wall-.5,-in-1]) cube([in*2,wall+1,in*2]);
                
                //ball hole
                hull(){
                    translate([in/2,0,in*.45]) sphere(r=ball_rad+wall);
                    translate([in/2,0,in*2]) sphere(r=ball_rad+wall);
                }
            }
        }

module dowel_holder(flare_len = dowel_holder_height/4){
    separation = dowel_sep;
    
    insert_angle = 30;
    
    height = dowel_holder_height;
    
    difference(){
        union(){
            //the rod holders
            for(i=[-separation/2,separation/2]) translate([0-wall/2,i,in/2+1]){
                rotate([0,90,0]) cylinder(r=dowel_rad+wall, h=height, center=true);
            }
        }
        
        dowel_holes(flare_len=flare_len);
    }
}

module dowel_holes(flare_len = dowel_holder_height/4){
        separation = dowel_sep;
    
    insert_angle = 30;
    
    height = dowel_holder_height;
    
    union(){
        
        //the rods
        for(i=[-separation/2,separation/2]) translate([0-wall/2,i,in/2+1]){
            rotate([0,90,0]) cylinder(r=dowel_rad, h=height+1, center=true);
            
            //flare the inlet/outlet
            translate([height/2-flare_len,0,0]) rotate([0,90,0]) cylinder(r1=dowel_rad-.1, r2=dowel_rad*1.25, h=flare_len+.1);
            translate([-height/2-.1,0,0]) rotate([0,90,0]) cylinder(r2=dowel_rad-.1, r1=dowel_rad*1.25, h=flare_len+.2);
        }
        
        //rod insert area
        //%translate([0-wall/2,-wall*3/4-dowel_rad+separation/2,in/2+2-dowel_rad-wall]) rotate([0,90,0]) cylinder(r=dowel_rad, h=wall*30, center=true);
        translate([0-wall/2,0,in/2+1-separation/2]) difference(){
            translate([0,0,3]) cube([height+1, separation, separation], center=true);
            translate([0,0,separation/2+3]) rotate([0,90,0]) scale([1,1,height/4]) sphere(r=4, h=40, center=true);
            
            for(i=[0,1]) mirror([0,i,0]) translate([0,separation/2,separation/2-dowel_rad-wall/2]) rotate([0,90,0]) cylinder(r=wall, h=40, center=true);
            
        }
    }
}