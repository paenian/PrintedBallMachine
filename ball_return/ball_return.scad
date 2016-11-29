include<../configuration.scad>
use <../base.scad> 
use <../pins.scad>

part = 4;

if(part == 0)
    rotate([0,90,0]) rear_ball_return_inlet();

if(part == 2)
    rotate([0,90,0]) rear_ball_return_inlet(width=3);

if(part == 3)
    translate([0,0,0]) rotate([0,270,0]) rear_ball_return_outlet();

if(part == 4)
    translate([0,0,peg_thick/2-slop]) rotate([90,0,0]) ball_return_peg();

if(part == 10){
    %translate([-in*12,wall,-in*5]) pegboard([12,12]);
    
    translate([in*8, 0, -in*4]) offset_slope_module();
    translate([in*9+.1, 0, -in*7]) offset_slope_module();

    translate([in*13,0,-in*3]) rear_ball_return_inlet();
    translate([in*9,0,-in*4]) rear_ball_return_outlet();
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

module rear_ball_return_inlet(width=2){
    %translate([0,in/4+wall+wall,0]) cube([in,in,in]);
    inset = .75-.25-wall/in;
    
    front_inset = 0;
    
    difference(){
        union(){
            //inlet catcher - extends to the back, to deposit balls there.
            inlet(length=1, hanger_height=0, outlet=REVERSE, height=1, width=1+width+inset, board_inset = in+inset*in);
            
            //base stiffener
            hull(){
                translate([in-.1,-(width)*in,0]) cube([wall,in*(width)+inset*in,in]);
                translate([in-.1,0,-in/2]) cube([wall,wall*2+in/4,in/4]);
            }
            
            //false bottom, to make a better channel
            difference(){
                translate([wall/4,-(width)*in,0]) cube([in,in*(1+width)+inset*in,wall*4]);
                
                //exit slope
                hull(){
                    translate([in/2,inset*in+in/2,in/2+wall]) sphere(r=ball_rad+wall);
                    translate([-in/2,inset*in+in/2,in/2]) sphere(r=ball_rad+wall);
                }
                
                //horizontal slope
                hull(){
                    translate([in/2,inset*in+in/2,in/2+wall]) sphere(r=ball_rad+wall);
                    #translate([in/2,-in*(width-.5),in*.8]) sphere(r=ball_rad+wall);
                }
            }
            
            //newfangled pegboard attachment system
            pegboard_attach();
            
            //%pegboard_attach_old();

            
            //hold a couple dowels underneath, to run the balls to the outlet
            translate([in,in*.5+inset*in+front_inset,-in*.63]) dowel_holder();
        }
        
        translate([in,in*.5+inset*in+front_inset,-in*.63]) dowel_holes();
        
        
        
        //flatten the far side for printing on
        translate([100+in+wall/2,0,0]) cube([200,200,200], center=true);
        
        //flatten the back side for 
        translate([0,100+in*1.25+wall,0]) cube([200,200,200], center=true);
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

module pegboard_attach(){
    //so we're going to use two holes, but the far one's a double-sided bump
    difference(){
        translate([0,wall*1+peg_thick/2, 0]) 
        for(i=[0,1]) mirror([0,i,0]) translate([0,wall*1+peg_thick/2,0]) {
            hull(){
                hanger(solid=1, hole=[0,0], drop = in*2.5, rot=245);
                hanger(solid=1, hole=[-1,0], drop = in*3.25, rot=230);
            }
            
            //bump
            translate([-in*1.5,-wall,-in*.5]) hull(){
                translate([0,0,0]) scale([1,.8,1]) sphere(r=peg_rad);
                translate([0,-wall/4,0]) scale([.95,.5,.95]) sphere(r=peg_rad);
                translate([0,-wall/2,0]) scale([.8,.4,.8]) sphere(r=wall);
            }
        }
        
        //peg hole in the rear
        translate([0,wall*1+peg_thick/2, 0]) for(i=[0,1]) mirror([0,i,0]) translate([0,wall*1+peg_thick/2,0])
            hanger(solid=-1, hole=[0,0]);
        
        //ball hole
        hull(){
            translate([in/2,-wall,in*.45]) sphere(r=ball_rad+wall);
            translate([in/2,-wall,in*2]) sphere(r=ball_rad+wall);
            
            translate([in/2,wall*2+peg_thick,in*.45]) sphere(r=ball_rad+wall);
            translate([in/2,wall*2+peg_thick,in*2]) sphere(r=ball_rad+wall);
            
        }
    }
}

module rear_ball_return_outlet(){
    //%translate([0,in/2,0]) cube([in,in,in]);
    inset = .75-.25-wall/in;
    front_inset = 0;
    difference(){
        union(){
            //inlet catcher - extends to the back, to deposit balls there.
            translate([0,in/2-wall*2-inset*in,0]) rotate([0,0,180]) inlet(length=1, hanger_height=0, outlet=REVERSE, height=1, width=2+inset, board_inset = in*.75+inset);
            
            mirror([1,0,0]) hull(){
                translate([in-.1,-1*in,0]) cube([wall,in*2+in*inset,in]);
                translate([in-.1,0,-in/2]) cube([wall,wall*2+in/4,in/4]);
            }
            
            //false bottom, to make a better channel
            difference(){
                translate([-in-wall/4,-1*in,0]) cube([in,in*2+inset*in,wall*4]);
                
                //exit slope
                hull(){
                    translate([-in/2,-in/2,in/2+wall]) sphere(r=ball_rad+wall);
                    translate([in/2,-in/2,in/2]) sphere(r=ball_rad+wall);
                }
                
                //horizontal slope
                hull(){
                    translate([-in/2,-in/2,in/2+wall]) sphere(r=ball_rad+wall);
                    translate([-in/2,in/2+inset*in,in*.7]) sphere(r=ball_rad+wall);
                }
                
                //inlet slope
                hull(){
                    translate([-in/2,in/2+inset*in,in*.7]) sphere(r=ball_rad+wall);
                    translate([in/2,in/2+inset*in,in*.75]) sphere(r=ball_rad+wall);
                }
            }
                   
            //attach it to the pegboard
            mirror([1,0,0]) pegboard_attach();
            
            //hold a couple dowels underneath, to run the balls to the outlet
            mirror([0,0,1]) translate([wall,in+front_inset+inset,-in*.75]) dowel_holder();
            //translate([in,in*.5+inset*in+front_inset,-in*.63]) dowel_holder();
        }
        
        //rods coming in :-)
        #mirror([0,0,1]) translate([wall,in+front_inset+inset,-in*.75]) dowel_holes(dowel_hole=wall*3+.1);
        
        //ball entrance
        hull(){
            translate([-in/2,in/2+inset*in,in*.7]) sphere(r=ball_rad+wall);
            translate([in/2,in/2+inset*in,in*.75]) sphere(r=ball_rad+wall);
        }  
                
        //flatten the far side for printing on
        mirror([1,0,0]) translate([100+in+wall/2,0,0]) cube([200,200,200], center=true);
        
        //flatten the back side for 
        translate([0,100+in*1.25+wall,0]) cube([200,200,200], center=true);
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

module dowel_holder(){
    separation = 16-4-2;
    
    insert_angle = 30;
    
    difference(){
        union(){
            //the rod holders
            for(i=[-separation/2,separation/2]) translate([0-wall/2,i,in/2+1]){
                rotate([0,90,0]) cylinder(r=dowel_rad+wall, h=wall*2, center=true);
            }
            
        }
        
        //the rods
        for(i=[-separation/2,separation/2]) translate([0-wall/2,i,in/2+1]){
            rotate([0,90,0]) cylinder(r=dowel_rad, h=200, center=true);
            translate([wall*.75,0,0]) rotate([0,90,0]) cylinder(r1=dowel_rad, r2=dowel_rad*1.25, h=wall, center=true);
            translate([-wall*.75,0,0]) rotate([0,90,0]) cylinder(r2=dowel_rad, r1=dowel_rad*1.25, h=wall, center=true);
        }
        
        //rod insert area
        //%translate([0-wall/2,-wall*3/4-dowel_rad+separation/2,in/2+2-dowel_rad-wall]) rotate([0,90,0]) cylinder(r=dowel_rad, h=wall*30, center=true);
        translate([0-wall/2,0,in/2+1-separation/2]) difference(){
            translate([0,0,3]) cube([separation, separation, separation], center=true);
            translate([0,0,separation/2+3]) rotate([0,90,0]) scale([1,1,1.25]) sphere(r=4, h=40, center=true);
            
            for(i=[0,1]) mirror([0,i,0]) translate([0,separation/2,separation/2-dowel_rad-wall/2]) rotate([0,90,0]) cylinder(r=wall/2, h=40, center=true);
            
        }
    }
}

module dowel_holes(dowel_hole=50){
        separation = 16-4-2;
    
    insert_angle = 30;
    
    union(){
        
        //the rods
        for(i=[-separation/2,separation/2]) translate([0-wall/2,i,in/2+1]){
            rotate([0,90,0]) cylinder(r=dowel_rad, h=dowel_hole, center=true);
            translate([wall*.75,0,0]) rotate([0,90,0]) cylinder(r1=dowel_rad, r2=dowel_rad*1.25, h=wall, center=true);
            translate([-wall*.75,0,0]) rotate([0,90,0]) cylinder(r2=dowel_rad, r1=dowel_rad*1.25, h=wall, center=true);
        }
        
        //rod insert area
        //%translate([0-wall/2,-wall*3/4-dowel_rad+separation/2,in/2+2-dowel_rad-wall]) rotate([0,90,0]) cylinder(r=dowel_rad, h=wall*30, center=true);
        *translate([0-wall/2,0,in/2+1-separation/2]) difference(){
            translate([0,0,3]) cube([separation, separation, separation], center=true);
            translate([0,0,separation/2+3]) rotate([0,90,0]) scale([1,1,1.25]) sphere(r=4, h=40, center=true);
            
            for(i=[0,1]) mirror([0,i,0]) translate([0,separation/2,separation/2-dowel_rad-wall/2]) rotate([0,90,0]) cylinder(r=wall/2, h=40, center=true);
            
        }
    }
}