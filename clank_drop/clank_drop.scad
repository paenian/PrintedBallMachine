include<../configuration.scad>
use <../base.scad>

%translate([-in*5, 0, -in*5]) pegboard([12,12]);

%translate([-in*5, 0, -in*0]) offset_slope_module();
translate([0,0,in]) clank_drop(width=3, length=3, height = 4.4);

%translate([in*3, 0, -in*6]) offset_slope_module();

tray_height = in*.4;

module clank_drop(width = 2, length = 2, height = 2.3){
    num_drops = floor(height*in / (ball_rad*2+wall*3));
    echo(num_drops);
    echo(ball_rad*2+wall*3);
    
    
    lift = -.25;
    height = height+lift;
    drop_dist = height*in/num_drops;
    
     
    difference(){
        union(){
            //hangers
            for(i=[1:length]){
                hanger(solid=1, hole=[i,1], drop = (height-lift)*in);
            }
            
            //drops!
            translate([0,0,lift*in]) for(i=[0:num_drops-1]) translate([0,0,-i*drop_dist]) {
                drop_inlet(width = width, length = length, outlet=NONE, rot_steps=i+1);
            }
            
            //the exit
            translate([0,0,lift*in]) translate([0,0,-num_drops*drop_dist]) intersection(){
                inlet(width = width, length = length, inset = 0);
                mirror([0,1,0]) cube([in*width, in*length, in*.5]);
            }
        }
        
        //hangers
        for(i=[1:length]){
            hanger(solid=-1, hole=[i,1]);
        }
    }
}

module drop_inlet(width = 2, length = 2, rot_steps = 0){
    %translate([ball_rad+wall, -ball_rad-wall, ball_rad+wall*1.5]) sphere(r=ball_rad);
    //handle rotation
    translate([width*in/2,-length*in/2,0]) rotate([0,0, -rot_steps*90]) translate([-width*in/2,length*in/2,0]) 
    difference(){
        union(){
            mirror([0,1,0]) cube([in*width, in*length, tray_height]);
            
            //corner stilts
            for(i=[0:90:350]) translate([width*in/2,-length*in/2,0]) rotate([0,0, i]) translate([-width*in/2,length*in/2 - wall,-in]){
                cube([wall, wall, in]);
            }
            
            //floor to get cut out
            mirror([0,1,0]) cube([in*width, in*length, tray_height]);
        }
        
        //new floor
        difference(){
            hull(){
             mirror([0,1,0]) translate([wall,wall,wall*1.5]) cube([in*width-wall*2, in*length-wall*2, in*.5]);
             mirror([0,1,0]) translate([wall/2,wall/2,in*.5]) cube([in*width-wall, in*length-wall, in*.5]);
             translate([length*in-ball_rad-wall*1.5,-width*in+ball_rad+wall*1.5,ball_rad+wall/2]) sphere(r=ball_rad+wall*.5);
            }
            
            //angle the front
            translate([width*in/2,-length*in/2,0]) rotate([0,0, rot_steps*90]) translate([-width*in/2,length*in/2,0]) {
                translate([length*in+wall,-width*in,0]) rotate([0,-90,0]) cylinder(r=in*.5, h=length*in+wall, $fn=3);
            }
        }
        
        hull(){
            translate([length*in-ball_rad-wall*1.5,-width*in+ball_rad+wall*1.5,ball_rad+wall]) sphere(r=ball_rad+wall*.5);
            translate([length*in-ball_rad-wall*1.5,-width*in+ball_rad+wall*1.5,-ball_rad]) sphere(r=ball_rad+wall*.5);
        }
    }
}