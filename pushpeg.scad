include<configuration.scad>
use <pins.scad>
use <base.scad>

in = 25.4;

part = 20;

//laid out for printing
if(part == 0)  //peg stand
    rotate([-90,0,0]) rotate([0,90,0]) push_peg_stand();
if(part == 20)  //beefy peg stand
    rotate([0,90,0]) beefy_push_peg_stand();

if(part == 1)   //peg in TPU
    rotate([-90,0,0]) push_peg(gap_rad = (nub_height*2)/2, peg_length = peg_thick*2+wall/2);

if(part == 11)  //peg with handle in TPU
    rotate([-90,0,0]) push_peg_handle(gap_rad = (nub_height*2)/2, peg_length = peg_thick*2+wall/2);

if(part == 121)  //peg with handle in TPU
    rotate([-90,0,0]) push_peg_double_handle(gap_rad = (nub_height*2)/2, peg_length = peg_thick*2+wall/2);

if(part == 2)   //peg in PETG
    rotate([-90,0,0]) push_peg(gap_rad = (nub_height*2+1.4)/2);

if(part == 12)  //peg with handle in PETG
    rotate([-90,0,0]) push_peg_handle(gap_rad = (nub_height*2+1.4)/2);



if(part == 10){
    //TPU
    rotate([-90,0,0]) push_peg();
    translate([11,4,0]) rotate([-90,0,0]) push_peg_handle();
    !translate([29,-20,0]) rotate([0,90,0]) push_peg_stand();
}

cap_rad = peg_cap_rad;
cap_height = 3.25;
nub_height = 1.25; //increase for more lock; max=
nub_length = 2.5; //increase to make the pegs easier to remove
nub_inset = nub_length*.666;
gap_rad = (nub_height*2)/2;

%translate([0,in/8+3,0]) cube([in/4,in/4,in/4], center=true);

echo("WALL=", 4.6-(gap_rad*2));


lock_rad = m3_rad+.01;

peg_flat = 1;

echo(peg_rad);
echo(lock_rad);



module push_peg_handle(gap_rad = gap_rad, peg_length = peg_thick*2+wall){
    handle_length = 13;
    handle_rad = peg_rad*1.5;
    
    difference(){
        union(){
            push_peg(gap_rad = gap_rad, peg_length = peg_length);
            
            //easy pull handle
            minkowski(){
                hull(){
                    translate([0,0,-handle_length]) scale([1,1,.25]) sphere(r=handle_rad);
                    translate([0,0,-1]) cylinder(r=peg_rad, h=1);
                }
            }
        }
        
        //flatten the bottom again
        translate([0,25+peg_rad-peg_flat,0]) cube([50,50,50], center=true);
    }
}

module push_peg_double_handle(gap_rad = gap_rad, peg_length = peg_thick*2+wall){
    handle_length = 13;
    handle_rad = peg_rad*1.5;
    
    difference(){
        union(){
            //two pegs
            for(i=[0:1]) translate([in*i,0,0]) push_peg_handle(gap_rad = gap_rad, peg_length = peg_length);
            
            //join 'em
            hull(){
                for(i=[0:1]) translate([in*i,0,0]) {
                    translate([0,0,-cap_height]) cylinder(r2=cap_rad, r1=cap_rad-1, h=cap_height/3+.05);
            translate([0,0,-cap_height*2/3]) cylinder(r=cap_rad, h=cap_height/3+.05);
            translate([0,0,-cap_height*1/3]) cylinder(r1=cap_rad, r2=cap_rad-1, h=cap_height/3);
                }
            }
        }
        
        //flatten the bottom again
        translate([0,25+peg_rad-peg_flat,0]) cube([100,50,50], center=true);
    }
}

module push_peg(gap_rad = gap_rad, peg_length = peg_thick*2+wall){
    nub_start = peg_thick+wall-nub_inset;
    
    difference(){
        union(){
            //cap
            translate([0,0,-cap_height]) cylinder(r2=cap_rad, r1=cap_rad-1, h=cap_height/3+.05);
            translate([0,0,-cap_height*2/3]) cylinder(r=cap_rad, h=cap_height/3+.05);
            translate([0,0,-cap_height*1/3]) cylinder(r1=cap_rad, r2=cap_rad-1, h=cap_height/3);
            
            
            //peg
            cylinder(r=peg_rad, h=peg_length);
            translate([0,0,peg_length]) sphere(r=peg_rad);
            
            //nub
            intersection(){
                union(){
                    translate([0,0,nub_start]) for(i=[0,1]) mirror([0,0,i]) translate([0,0,-i*nub_length*2]) cylinder(r1=peg_rad, r2=peg_rad+nub_height, h=nub_length);
                }
                
                //this ensures that the tips of the nub can go through the hole when compressed.
                hull(){
                    for(i=[0,1]) mirror([i,0,0]) translate([gap_rad*.5,0,0]) cylinder(r=peg_rad, h=peg_length);
                }
            }
        }
        
        //center hollow for pinching
        difference(){
            hull(){
                translate([0,0,wall]) rotate([90,0,0]) cylinder(r=gap_rad, h=20, center=true);
                translate([0,0,peg_length]) rotate([90,0,0]) cylinder(r=gap_rad, h=20, center=true);
            }
            
            //leave a little for the locking screw
            for(i=[0,1]) mirror([i,0,0]) translate([10,0,peg_thick+wall-nub_inset+nub_length]) cylinder(r=10, h=wall/2, center=true, $fn=4);
        }
        
        //flatten the bottom for easy printing
        translate([0,25+peg_rad-peg_flat,0]) cube([50,50,50], center=true);
        
        //and the top so it'll fit in the hole - but leave the cap
        translate([0,-1*(25+peg_rad-peg_flat),25]) cube([50,50,50], center=true);
        
        //hole for a locking peg
        cylinder(r1=lock_rad, r2=lock_rad-.25, h=peg_length*2, center=true, $fn=8);
    }
}

module push_peg_stand(peg_units = 1, thick = in*.5, height=3, front_drop=1, base_length = in*5){
    cutoff=1;
    
    
    brace_height = peg_sep*1.25;
    
    //translate([peg_sep/2,0,peg_sep*1.5]) 
    difference(){
        union(){
            translate([-peg_sep/2,0,-peg_sep*1.5]) peg(peg=NONE, peg_units=peg_units, lower_peg_thick=-wall);
            
            //stiffen the spine
            hull(){
                translate([0,0,peg_rad-thick/2]) 
                rotate([90,0,0]) cylinder(r=thick/2, h=wall*2);
                translate([0,0,-peg_sep*height]) rotate([90,0,0]) cylinder(r=thick/2, h=wall*4);
            }
            
            //front brace
            translate([0,wall+in/4,0]) hull(){
                translate([0,0,peg_rad-thick/2-peg_sep*front_drop]) 
                rotate([90,0,0]) cylinder(r=thick/2, h=wall);
                translate([0,0,-peg_sep*height]) rotate([90,0,0]) cylinder(r=thick/2, h=wall);
            }
            
            //peg in the front brace
            *translate([0,0,-peg_sep*front_drop]) hull(){
                //rotate([90,0,0]) translate([0,0,-wall-in/4]) cylinder(r1=peg_rad, r2=peg_rad-slop, h=peg_thick-.333);
                translate([0,peg_thick,0]) sphere(r=peg_rad);
                translate([0,peg_thick/2+peg_rad/2,0]) scale([.9,.75,.9]) sphere(r=peg_rad-slop);
            }
            
            //base
            translate([0,(wall+in/4)/2-wall/2,0])
            for(i=[0:1]) mirror([0,i,0]) translate([0,0,-peg_sep*height]) difference(){
                union(){
                    rotate([90,0,0]) cube([thick, thick, peg_sep], center=true);
                    hull(){ //bottom
                        translate([0,-base_length/2,0]) 
                        rotate([90,0,0]) translate([-thick/2,-thick/2,0])cube([thick, thick, wall]);
                        translate([0,-(wall+in/4)/2,0]) rotate([90,0,0]) translate([-thick/2,-thick/2,0]) cube([thick, thick, wall]);
                        translate([0,-(wall+in/4)/2,brace_height]) rotate([90,0,0]) translate([-thick/2,-thick/2,0]) cube([thick, thick, wall]);
                    }
                }
                
                hull(){
                    translate([0,-base_length/2-wall,brace_height+thick/2-i*thick/2]) scale([1,(base_length-wall*2)/in,(2*brace_height+thick)/in-i/2]) rotate([0,90,0]) cylinder(r=in/2, h=20, center=true, $fn=60);
                    translate([0,-base_length/2-wall,brace_height+thick/2]) scale([1,(base_length-wall*2)/in,(2*brace_height+thick)/in]) rotate([0,90,0]) cylinder(r=in/2, h=20, center=true, $fn=60);
                    
                }
            }
        }
        
        //hole for the top, front pushpeg
        #translate([0,.1,-peg_sep/4]) rotate([90,0,0]) cylinder(r=peg_rad+.125, h=50);
        translate([0,-wall,-peg_sep/4]) rotate([90,0,0]) cylinder(r=cap_rad+nub_height, h=50);
        
        //hole for the bottom, back pushpeg
        mirror([0,1,0]) translate([0,.1,-peg_sep/4-peg_sep]) rotate([90,0,0]) cylinder(r=peg_rad+.125, h=50, center=true);

        
        
        //cut off side for easier printing
        //translate([-200-peg_rad+cutoff,0,0]) cube([400,400,400], center=true);
        
        //cut off bottom so it can stand
        //translate([-100-peg_rad+cutoff,0,0]) cube([200,200,200], center=true);
        
        //cut off the back cuz we don't really need it
        translate([0,100+peg_thick+rear_gap+wall,0]) cube([200,200,200], center=true);
        
        %translate([0,in/4,-in*4]) cube([in,in,in]);
    }
}

module beefy_push_peg_stand(peg_units = 2, thick = in*1.875, height=4, front_drop=1, base_length = in*7){
    cutoff=2;
    
    
    brace_height = peg_sep*1.25;
    
    //translate([peg_sep/2,0,peg_sep*1.5]) 
    difference(){
        union(){
            
            //stiffen the spine
            hull(){
                translate([0,0,peg_rad-in/2]) 
                rotate([90,0,0]) cylinder(r=thick/2, h=wall*2);
                translate([0,0,-peg_sep*height]) rotate([90,0,0]) cylinder(r=thick/2, h=wall*4);
            }
            
            //front brace
            translate([0,wall+in/4,0]) hull(){
                translate([0,wall,peg_rad-in/2-peg_sep*front_drop]) 
                rotate([90,0,0]) cylinder(r=thick/2, h=wall*2);
                translate([0,wall*3,-peg_sep*height]) rotate([90,0,0]) cylinder(r=thick/2, h=wall*4);
            }
            
            //base
            translate([0,(wall+in/4)/2-wall/2,0])
            for(i=[0:1]) mirror([0,i,0]) translate([0,0,-peg_sep*height]) difference(){
                union(){
                    translate([0,0,-in/4]) rotate([90,0,0]) cube([thick, in/2, peg_sep], center=true);
                    hull(){ //bottom
                        translate([0,-base_length/2,0]) 
                        rotate([90,0,0]) translate([-thick/2,-in/2,0]) cube([thick, in/2, wall]);
                        translate([0,-(wall+in/4)/2,0]) rotate([90,0,0]) translate([-thick/2,-in/2,0]) cube([thick, in/2, wall]);
                        translate([0,-(wall+in/4)/2,brace_height]) rotate([90,0,0]) translate([-thick/2,-in/4,0]) cube([thick, in/2, wall]);
                    }
                }
                
                //round out the legs
                translate([0,-base_length/2-wall,brace_height+thick/2]) scale([1,(base_length-wall*2)/in-.125,(2*brace_height+thick)/in]) rotate([0,90,0]) cylinder(r=in/2, h=60, center=true, $fn=60);
            }
        }
        
        //hole for the front pushpegs
        for(j=[0,1]) for(i=[0:height-2]) mirror([j,0,0]) translate([peg_sep/2,0,-i*peg_sep]) {
            translate([0,.1,-peg_sep/4]) rotate([90,0,0]) cylinder(r=peg_rad+.125, h=50);
            translate([0,-wall,-peg_sep/4]) rotate([90,0,0]) cylinder(r=cap_rad+nub_height, h=50);
        }
        
        //hole for the back pushpegs
        mirror([0,1,0]) for(j=[0,1]) for(i=[0:height-2]) mirror([j,0,0]) translate([peg_sep/2,-peg_sep/4,-i*peg_sep]) {
            translate([0,.1,-peg_sep/4]) rotate([90,0,0]) cylinder(r=peg_rad+.125, h=50);
            translate([0,-wall,-peg_sep/4]) rotate([90,0,0]) cylinder(r=cap_rad+nub_height, h=50);
        }

        
        
        //cut off side for easier printing
        for(i=[0,1]) mirror([i,0,0]) translate([200+thick/2-cutoff,0,0]) cube([400,400,400], center=true);
        
        //cut off bottom so it can stand
        translate([0,0,-100-peg_sep*height-in/2+.1]) cube([200,200,200], center=true);
        
        //cut off the back cuz we don't really need it
        //translate([0,100+peg_thick+rear_gap+wall,0]) cube([300,200,300], center=true);
        
        %translate([0,in/4,-in*4]) cube([in,in,in]);
    }
}