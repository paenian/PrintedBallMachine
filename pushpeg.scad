include<configuration.scad>
use <pins.scad>
use <base.scad>

part = 0;

//laid out for printing
if(part == 0)   //peg
    rotate([-90,0,0]) push_peg();

if(part == 1)  //peg lock
    rotate([-90,0,0]) push_peg_handle();

cap_rad = .25*in;
cap_height = 3.25;
nub_height = 1; //increase for more lock; max=
nub_length = 3; //increase to make the pegs easier to remove
nub_inset = nub_length*.75;
gap_rad = (nub_height*2+1.4)/2;

%cube([4.6,5,5], center=true);
%cube([gap_rad*2,7,4.5], center=true);
echo("WALL=", 4.6-(gap_rad*2));


lock_rad = m3_rad+.1;

peg_flat = 1;

echo(peg_rad);
echo(lock_rad);

//better equation for peg_flat
//translate([0,0,0]) cube([3*peg_rad,peg_rad*sqrt(2)-2*gap,2*peg_thick*2+3*peg_rad],center=true);

module push_peg_handle(){
    handle_length = 13;
    handle_rad = peg_rad*1.5;
    
    difference(){
        union(){
            push_peg();
            
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

module push_peg(){
    peg_length = peg_thick*2+wall;
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