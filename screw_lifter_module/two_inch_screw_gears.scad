// OpenSCAD Herringbone Wade's Gears Script
// (c) 2011, Christopher "ScribbleJ" Jansen
//
// Thanks to Greg Frost for his great "Involute Gears" script.
//
// Licensed under the BSD license.
include <MCAD/involute_gears.scad> 
include <MCAD/teardrop.scad> 


in = 25.4;
rod_rad = 15/2+.25;
bearing_rad = 35/2+.25;
bearing_thick = 11.75;
screw_rad = in*2.5+.75; //large clearance on the screw
rod_ring_rad = screw_rad+rod_rad+.5;

motor_rad = 33/2;
motor_mount_rad = 38/2;
m3_rad = 1.7;
gear_inset = in+5.5;
motor_bump=3.5+3;
    
    

// set to 0 for meshed gears, 1 for printing plate with gears flipped and laid flat
printing = 1;

// OPTIONS COMMON TO BOTH GEARS:
distance_between_axles = rod_ring_rad-10;
gear_h = 10;
gear_shaft_h = 10;

// THIS SCRIPT IS MODIFIED TO FIT A eMaker HUXLEY (Pro) EXTRUDER WITH M6 HOBBED BOLT.

// GEAR1 (SMALLER GEAR, STEPPER GEAR) OPTIONS:
// It's helpful to choose prime numbers for the gear teeth.
gear1_teeth = 11;				// was 11 for Greg/Wade
gear1_shaft_d = 5.4;  			// diameter of motor shaft
gear1_shaft_r  = gear1_shaft_d/2;	
// gear1 shaft assumed to fill entire gear.
// gear1 attaches by means of a captive nut and bolt (or actual setscrew)
gear1_setscrew_offset = gear_h / 2;			// Distance from motor on motor shaft.
gear1_setscrew_d         = 3 / cos(180 / 8) + 0.4;
gear1_setscrew_r          = gear1_setscrew_d/2;
gear1_captive_nut_d = 5.5 / cos(180 / 6) + 0.4;
gear1_captive_nut_r  = gear1_captive_nut_d/2;
gear1_captive_nut_h = 2.6;



// GEAR2 (LARGER GEAR, DRIVE SHAFT GEAR) OPTIONS:
gear2_teeth = 83;			// was 45 for Wade/Greg
gear2_shaft_d = 6.2;		// was 8.3 for Wade/Greg
gear2_shaft_r  = gear2_shaft_d/2;
// gear2 has settable outer shaft diameter.
gear2_shaft_outer_d = 17;	//was 20 for Wade/Greg
gear2_shaft_outer_r  = gear2_shaft_outer_d/2;

// gear2 has a hex bolt set in it, is either a hobbed bolt or has the nifty hobbed gear from MBI on it.
gear2_bolt_hex_d       = 10.3;		// was 12.8 for Greg/Wade
gear2_bolt_hex_r        = gear2_bolt_hex_d/2;
// gear2_bolt_sink: How far down the gear shaft the bolt head sits; measured as distance from outer face of gear.
gear2_bolt_sink          = 4;
// gear2's shaft is a bridge above the hex bolt shaft; this creates 1/3bridge_helper_h sized steps at top of shaft to help bridging.  (so bridge_helper_h/3 should be > layer height to have any effect)
bridge_helper_h= 0.35 * 3;

gear2_rim_margin = 0;
gear2_cut_circles  = 5;			//was 5

// gear2 setscrew option; not likely needed.
gear2_setscrew_offset = 0;
gear2_setscrew_d         = 0;
gear2_setscrew_r          = gear2_setscrew_d/2;
// captive nut for the setscrew
gear2_captive_nut_d = 0;
gear2_captive_nut_r  = gear2_captive_nut_d/2;
gear2_captive_nut_h = 0;

// distance from center of M8 shaft to closest motor screw, so we can position access holes appropriately
motor_mount_access_radius = sqrt(((27 / 2) * (31 / 2)) * 2);


// Tolerances for geometry connections.
AT=0.02;
ST=AT*2;
TT=AT/2;

echo(gear1_teeth/gear2_teeth);

module bridge_helper()
{
	difference()
	{
		translate([0,0,-bridge_helper_h/2])
		cylinder(r=gear2_bolt_hex_r+TT, h=bridge_helper_h+TT,$fn=6,center=true);
		translate([0,0,-bridge_helper_h/2])
		cube([gear2_bolt_hex_d+ST, gear2_shaft_d, bridge_helper_h+AT], center=true);
	}
}



module gearsbyteethanddistance(t1=13,t2=51, d=60, teethtwist=1, which=1)
{

    
    
	cp = 360*d/(t1+t2);

	g1twist = 360 * teethtwist / t1 / 2;
	g2twist = 360 * teethtwist / t2 / 2;

	g1p_d  =  t1 * cp / 180;
	g2p_d  =  t2 * cp / 180;
	g1p_r   = g1p_d/2;
	g2p_r   = g2p_d/2;

	echo(str("Your small ", t1, "-toothed gear will be ", g1p_d, "mm across (plus 1 gear tooth size) (PR=", g1p_r,")"));
	echo(str("Your large ", t2, "-toothed gear will be ", g2p_d, "mm across (plus 1 gear tooth size) (PR=", g2p_r,")"));
	echo(str("Your minimum drive bolt length (to end of gear) is: ", gear2_bolt_sink+bridge_helper_h, "mm and your max is: ", gear_h+gear_shaft_h, "mm."));
	echo(str("Your gear mount axles should be ", d,"mm (", g1p_r+g2p_r,"mm calculated) from each other."));
	if(which == 1)
	{
		// GEAR 1
		difference()
		{
			render()
			union()
			{
				translate([0,0,(gear_h/2) - TT])
					gear(	twist = g1twist, 
						number_of_teeth=t1, 
						circular_pitch=cp, 
						gear_thickness = (gear_h/2)+TT,
						rim_thickness = (gear_h/2)+TT, 
						rim_width = 0,
						hub_thickness = (gear_h/2)+TT, 
						hub_width = 0,
						bore_diameter=0);
	
				translate([0,0,(gear_h/2) + TT]) rotate([180,0,0]) 
					gear(	twist = -g1twist, 
						number_of_teeth=t1, 
						circular_pitch=cp, 
						gear_thickness = (gear_h/2)+TT, 
						rim_thickness = (gear_h/2)+TT, 
						hub_thickness = (gear_h/2)+TT, 
						bore_diameter=0); 
				
                translate([0, 0, gear_h])
					cylinder(r=7, h=motor_bump);
			}
			//DIFFERENCE:
            d_height = TT;
            round_inset = 7;
            round_height = 4.5;
            round_rad = 3.25/2;
            #translate([0,0,0]) d_slot(shaft=7.1, height=d_height+round_height+round_inset+5.25, dflat=.725, double_d=true, round_inset=round_inset, round_height=round_height, round_rad=round_rad, $fn=72);
            
            //unstar to see the shaft inside
            *translate([25,0,0]) cube([50,50,50], center=true);
		}
	}
	else
	{
		// GEAR 2
		difference()
		{
			render()
			union()
			{
				translate([0,0,(gear_h/2) - TT])
					gear(	twist = -g2twist, 
						number_of_teeth=t2, 
						circular_pitch=cp, 
						gear_thickness = (gear_h/2)+TT, 
						rim_thickness = (gear_h/2)+TT, 
						rim_width = gear2_rim_margin,
						hub_diameter = gear2_shaft_outer_d,
						hub_thickness = (gear_h/2)+TT, 
						bore_diameter=0); 
	
				translate([0,0,(gear_h/2) + TT]) rotate([180,0,0])
					gear(	twist = g2twist, 
						number_of_teeth=t2, 
						circular_pitch=cp, 
						gear_thickness = (gear_h/2)+TT, 
						rim_thickness = (gear_h/2)+TT, 
						rim_width = gear2_rim_margin,
						hub_diameter = gear2_shaft_outer_d,
						hub_thickness = (gear_h/2)+TT, 
						bore_diameter=0); 
                        
                %cylinder(r=rod_rad, h=100, center=true);
                for(i=[60:360/3:359]) rotate([0,0,i]) translate([rod_ring_rad,0,0]) {
                    %cylinder(r=bearing_rad, h=50, center=false);
                    %translate([0,0,-49]) cylinder(r=rod_rad, h=50);
                }
                
			}
			//DIFFERENCE:
			//shafthole
			translate([0,0,-TT]) 
				cylinder(r=gear2_shaft_r / cos(180 / 24), h=gear_h+gear_shaft_h+ST, $fn=24);

			//setscrew shaft
			translate([0,0,gear_h+gear_shaft_h-gear2_setscrew_offset])
				rotate([0,90,0])
				cylinder(r=gear2_setscrew_r, h=gear2_shaft_outer_d);

			//setscrew captive nut
			translate([(gear2_shaft_outer_d)/2, 0, gear_h+gear_shaft_h-gear2_captive_nut_r-gear2_setscrew_offset]) 
				translate([0,0,(gear2_captive_nut_r+gear2_setscrew_offset)/2])
					#cube([gear2_captive_nut_h, gear2_captive_nut_d, gear2_captive_nut_r+gear2_setscrew_offset+ST],center=true);

			//trim shaft
			difference()
			{
				translate([0,0,gear_h+AT])	cylinder(h=gear_shaft_h+ST, r=g2p_r);
				translate([0,0,gear_h])	cylinder(h=gear_shaft_h, r=gear2_shaft_outer_r);
			}

			//hex bolt nut socket
			translate([0,0,-AT]) cylinder(r=gear2_bolt_hex_r  / cos(180 / 6), h=gear2_bolt_sink, $fn=6);

			// sunken face
			translate([0, 0, gear_h / 4])
				difference() {
					cylinder(r = g2p_r - (cp / 45), h=gear_h, center=true, $fn=64);
					cylinder(r = bearing_rad+3, h=gear_h + TT, center=true, $fn=32);
				}

			// motor mount access screw
			*for(i = [0:7]) {
				rotate([0, 0, (45 * i) + 22.5])
					translate([motor_mount_access_radius, 0, gear_h / 2])
					rotate([0, 90, 90])
						teardrop(3, gear_h * 2, 90);
			}

			// weight/plastic reduction and branding
			for (i = [0:5]) {
				rotate([0, 0, 60 * i])
				translate([41, 0, gear_h / 2])
					rotate([0, -90, 0])
					teardrop(g2p_r / 7+5, gear_h * 2, 90);
			}
            
            //bearing support
            translate([0,0,1]) cylinder(r=bearing_rad, h=bearing_thick*9, $fn=6, center=true);
            #translate([0,0,10]) cylinder(r=bearing_rad, h=bearing_thick, center=true);
            
            //attach the bearing to the helix
            //holes to lock to the screw
            for(i=[30:360/6:359]) rotate([0,0,i]) translate([22,0,5]) {
                cylinder(r=3.4/2, h=5*2, center=true, $fn=30);
                translate([0,0,-7.5]) cylinder(r=3.5, h=5*2, $fn=30);
            }
		}

		// hex bolt shaft bridge aid.
		/*
		translate([0, 0, gear2_bolt_sink]) {
			translate ([0,0,])
				bridge_helper();
			translate ([0,0,bridge_helper_h/3])
				rotate([0,0,60]) bridge_helper();
			translate ([0,0,((bridge_helper_h/3)*2)])
				rotate([0,0,-60]) bridge_helper();
		}
		/**/	
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


t1 = gear1_teeth;
t2 = gear2_teeth;
cp = 360*distance_between_axles/(t1+t2);
g1p_d  =  t1 * cp / 180;
g2p_d  =  t2 * cp / 180;
g1p_r   = g1p_d/2;
g2p_r   = g2p_d/2;


translate([printing * cp / -35, 0, 0])
	//render()
		rotate([180,0,0]) mirror([0,0,1]) 
        translate([-g1p_r,0,0]) rotate([0,0,($t*360/gear1_teeth)]) {
			intersection() {
				union() {
					translate([0, 0, 0]) cylinder(r1=g1p_r, r2=g1p_r + 5, h=5.1);
					translate([0, 0, 5]) cylinder(r2=g1p_r, r1=g1p_r + 5, h=5.1);
					translate([0, 0, 10]) cylinder(r1=g1p_r, r2=g1p_r + 10, h=10.1);
				}
				gearsbyteethanddistance(t1 = gear1_teeth, t2=gear2_teeth, d=distance_between_axles, which=1);
			}
		}


translate([0, 0, gear_h * printing]) rotate([180 * printing, 0, 0])
	//render()
		translate([g2p_r,0,0])  rotate([0,0,($t*360/gear2_teeth)*-1]) {
			intersection() {
				union() {
					translate([0, 0, 0]) cylinder(r1=g2p_r, r2=g2p_r + (cp / 180), h=(cp / 180));
					translate([0, 0, (cp / 180) - 0.01]) cylinder(r=g2p_r + (cp / 180), h=10.02 - (cp / 180) - (cp / 180));
					translate([0, 0, 10 - (cp / 180)]) cylinder(r2=g2p_r, r1=g2p_r + (cp / 180), h=(cp / 180));
					translate([0, 0, 10]) cylinder(r1=g2p_r, r2=g2p_r + (cp / 180) + 0.1, h=(cp / 180) + 0.2);
				}
				gearsbyteethanddistance(t1 = gear1_teeth, t2=gear2_teeth, d=distance_between_axles, which=2);
			}
		}


*translate([0, 37, 0]) import_stl("gregs-accessible-wade.stl");
