include <../configuration.scad>;
use <../base.scad>;
use <../pins.scad>;
use <../screw_drop/screw_drop.scad>;

//motor variables
dflat=.2;
shaft=5+slop;
shaft_offset = -2;
motor_rad = 33/2;
motor_mount_rad = 38/2;
m3_rad = 1.7;
m3_nut_rad = 3.5;

part = 3;

if(part == 10)
    assembled();

if(part == 1)
    rotate([-90,0,0]) stair_inlet();

if(part == 2)
    rotate([90,0,0]) moving_stair();

if(part == 3)
    cam();

//stair variables
stair_length = 6*in;
num_steps = 4;
step_drop = .125*in;    //the slope per step
step_length = stair_length/num_steps;
step_width = in-wall;
step_height = in*1.5;
    
cam_rad = 59;
cam_scale = .37;

module assembled(){
    %pegboard([12,12]);
    //previous bit
    %translate([-in*5,0,in*7]) slope_module();
    //next bit
    %translate([in*12,0,in*7]) slope_module();
    //handle
    %translate([in*6.5,0,in*12]) cube([in*4, in, in], center=true);
    
    translate([0,0,in*6]) offset_slope_module(inlet_length = 3, height = 1.5);
    
    translate([in*5,0,in*6]) {
        stair_inlet();
    
        translate([0,-5.5,-1]) moving_stair();
        //translate([0,-5.5,-45]) moving_stair();
        
        translate([num_steps*step_length/2+step_length/2+in, -in, -in/2]) rotate([90,0,0]) cam();
    }
}


module stair_inlet(){
    $fn=30;
    difference(){
        union(){
            inlet(height=2, width=3, length=1, outlet=INLET_HOLE, hanger_height=3, inset=0);
            translate([in*1,0,in*1.5-step_height]) fixed_stair();
        }
    }
}

//need a rail with a tolerance, so we can inset it.
module rail(solid = 1, step_extra=0){
    rail_width = 9;
    rail_thick = 5;
    jut = 1;
    
    rad = (solid==1)?.5:1;
    
    //a jut out bit to lower friction
    if(solid == 1) for(i=[step_length*.25, step_length*.75]){
        
        translate([i-rail_width/2,-step_width-jut,-step_extra])
        cube([rail_width,jut*2,step_height+step_extra]);
    }
    
    //the rail itself - a triangle made of cylinders.
    if(solid == 1){
        for(i=[step_length*.75]) translate([i,-step_width,-step_extra])
        hull(){
            cylinder(r=rad, h=step_height+step_extra);
            for(i=[-rail_width/2, rail_width/2]) translate([i, -rail_thick,0]) cylinder(r=rad, h=step_height+step_extra);
        }
    }
    
    if(solid == 0){
        for(i=[step_length*.25]) translate([i,-step_width-jut-.1,0])
        hull(){
            cylinder(r=rad, h=step_height*3, center=true);
            for(i=[-rail_width/2, rail_width/2]) translate([i, rail_thick,0]) cylinder(r=rad, h=step_height*3, center=true);
        }
    }
}

module stair_step(solid = 1, entrance = 0, exit = 0, rail_solid = 1, step_extra = 0){
    rear = step_length*.25;
    front = step_length*.75;
    
    if(solid == 1){
        //the step
        translate([0,-step_width,-step_extra]) cube([step_length, step_width, step_height+step_extra]);
        
        //Rails to guide the sliding parts
        if(rail_solid == 1) rail(rail_solid, step_width = step_width, step_extra = step_extra);
    }
    
    if(solid == -1){
        //ball path in
        translate([0,-in/2,step_height]) hull(){
            if(entrance == 1){
                translate([rear-in,0,step_drop]) sphere(r=ball_rad + wall);
            }else{
                translate([rear, -in, step_drop]) sphere(r=ball_rad + wall);
            }
            
            translate([rear,0,0]) sphere(r=ball_rad + wall);
        }
        
        //cut out a ball path forward on each step
        translate([0,-in/2,step_height]) hull(){
            translate([rear,0,0]) sphere(r=ball_rad + wall);
            translate([front,0,-step_drop]) sphere(r=ball_rad + wall);
        }
        
        //and a ball path sideways
        translate([0,-in/2,step_height]) hull(){
            translate([front,0,-step_drop]) sphere(r=ball_rad + wall);
            if(exit == 1){
                translate([front+in,0,-step_drop*2]) sphere(r=ball_rad + wall);
            }else{
                translate([front,-in,-step_drop*2]) sphere(r=ball_rad + wall);
            }
        }
        
        //cut out the rail
        if(rail_solid != 1) rail(rail_solid, step_width=step_width);
    }
}

module motor_mount(solid = 1){
    translate([step_length/2,0,0]) 
    if(solid == 1){
        //motor mount
        hull(){
            translate([num_steps*step_length/2, -in, -in/2]) rotate([90,0,0])  rotate([0,0,90]){            
                *%translate([0,0,2]) rotate([0,0,35]) scale([1,cam_scale,1]) cylinder(r=cam_rad, h=ball_rad);
                *%translate([0,0,2]) rotate([0,0,35+90]) scale([1,cam_scale,1]) cylinder(r=cam_rad, h=ball_rad);
                *%translate([0,0,2]) rotate([0,0,60]) scale([1,cam_scale,1]) cylinder(r=cam_rad, h=ball_rad);
                
                translate([0,0,-.1]) hull() rotate([0,0,-90]) motorHoles(1, slot=5);
            }
        }
        hull(){
            intersection(){
                translate([num_steps*step_length/2, -in, -in/2]) rotate([90,0,0])  rotate([0,0,90]) translate([0,0,-.1]) hull() rotate([0,0,-90]) motorHoles(1, slot=5);
                
                cube([500,wall*2,500], center=true);
            }
            translate([num_steps*step_length/2,-wall/2,step_height*2]) cube([in*2,wall,in], center=true);
        }
    }else{
        translate([num_steps*step_length/2, -in, -in/2]) rotate([90,0,0])  rotate([0,0,90]){
            #translate([0,0,-.1]) rotate([0,0,-90]) motorHoles(0, slot=5);
        }
    }
}


module moving_stair(step_lift = in){
    //travel maximums
    top = 11;
    bottom = -32;
    
    bottom_extra = 12;
    
    translate([in-step_length/2,-step_width*2-1.1,top]) 
    difference(){
        union(){
            for(i=[1:num_steps-1]){
                //stair steps
                mirror([0,1,0]) translate([step_length*i, 0, step_lift*i]) stair_step(solid = 1, rail_solid=0);
            }
            
            //make a slope for pushing
            hull(){
                //first start
                mirror([0,1,0]) translate([step_length*.7, -step_width, step_lift*.7-bottom_extra]) cube([step_length*.666, step_width/2, bottom_extra+1]);
                
                for(i=[1:num_steps-1]){
                    //stair steps
                    mirror([0,1,0]) translate([step_length*i, -step_width, step_lift*i-bottom_extra]) cube([step_length*.666, step_width/2, bottom_extra+1]);
                }
            }
        }
        
        for(i=[0:num_steps-1]){
            //stair step cutouts
            mirror([0,1,0]) translate([step_length*i, 0, step_lift*i]) stair_step(solid = -1, entrance = 0, exit = 0, rail_solid=0);
        }
    }
}

module fixed_stair(step_lift = in, extra_width = 5){
    difference(){
        union(){
            for(i=[0:num_steps-1]){
                //stair steps
                translate([step_length*i, 0, step_lift*i]) stair_step(solid = 1, step_width = step_width+extra_width, step_extra = 5);
                
                echo(floor((step_length*i)/in));
                //stair hangers
                hanger(hole=[ceil((step_length*i)/in),num_steps+1], solid=1, drop=in*(num_steps-i));
                
                hanger(hole=[ceil((step_length*i)/in),num_steps+1], solid=1, drop=in*(num_steps-i), rot=-45);
            }
            
            motor_mount(solid = 1);
        }
        
        for(i=[0:num_steps-1]){
            //stair step cutouts
            translate([step_length*i, 0, step_lift*i]) stair_step(solid = -1, entrance = i+1, exit = i-num_steps+2);
        }
        
        for(i=[0:(num_steps*step_length)/in+1]){
            echo(i);
            //stair hangers
            hanger(hole=[ceil(i),num_steps+1], solid=-1, drop=in*(num_steps-1));
        }
        
        motor_mount(solid = -1);
        
        //chop the very end off
        translate([num_steps*step_length+50-1, 0, num_steps*step_lift]) cube([100,100,100], center=true);
    }
}

//stuff below here is for the cam


module collar(radius=10, height=10, pitch=6.35, teeth=8, tolerance=.2,roller=3){
    distance_from_center=pitch/(2*sin(180/teeth));
    angle=(360/teeth);
    
    link_height=5.85;
    
    difference(){
        cylinder(r=radius, h=height);
        
        //set screw
        //translate([0,0,roller+(height-roller)/2]) rotate([-90,0,0]) cylinder(r=2.75/2, h=10);
        
        for(tooth=[1:teeth]){
            rotate(a=[0,0,angle*(tooth+0.5)]){
                translate([distance_from_center,0,-1]){
                    cylinder(r=link_height/2+tolerance,h=height+2);
                }
			}
		}
        
        for(tooth=[1:teeth]) hull(){
            rotate(a=[0,0,angle*(tooth+0.5)]){
                translate([distance_from_center,0,-1]){
                    cylinder(r=roller/2+tolerance,h=height+2);
                }
			}
            rotate(a=[0,0,angle*(tooth+0.5+1)]){
                translate([distance_from_center,0,-1]){
                    cylinder(r=roller/2+tolerance,h=height+2);
                }
			}
		}
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

module cam(){
    cam_height = ball_rad/2+1;
    collar_height = cam_height+4.5+1; 
    
    d_height = 5.25;
    
    round_inset=2.5;
    round_height= 5.7-round_inset;
    round_rad=3.25/2;
    
    echo("round_height");
    echo(collar_height-round_height);
    
    rotate([0,0,35]) 
    difference(){
        union(){
            //collar
            collar(radius=8, height=collar_height, pitch=12.7, teeth=6);
            scale([1,cam_scale,1]) cylinder(r=cam_rad, h=cam_height, $fn=90);
            %rotate([0,0,90]) scale([1,cam_scale,1]) cylinder(r=cam_rad, h=cam_height);
        }
        
        //cut out the D shaft, and a screw fastener.
        d_slot(shaft=7.1, height=d_height+round_height+round_inset, dflat=.625, double_d=true, round_inset=round_inset, round_height=round_height, round_rad=round_rad);
    }
}