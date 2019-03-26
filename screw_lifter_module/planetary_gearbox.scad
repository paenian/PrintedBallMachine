// Planetary gear bearing (customizable)
use <engine.scad>;

/* previous version
  D=51.7;
  T=6;//8;//15;
  tol=0.3;
  number_of_planets=5;
  number_of_teeth_on_planets=7;
  approximate_number_of_teeth_on_sun=9;
  P=45;//[30:60]
*/

in = 25.4; 
// outer diameter of ring
D=in*7.4;
// thickness
T=6;//8;//15;
// clearance
tol=0.3;
number_of_planets=6;
number_of_teeth_on_planets=23;
approximate_number_of_teeth_on_sun=39;
// pressure angle
P=26;//[30:60]
// number of teeth to twist across
nTwist=1;
// width of hexagonal hole
w=6.7;

DR=0.5*1;// maximum depth ratio of teeth

m=round(number_of_planets);
np=round(number_of_teeth_on_planets);
ns1=approximate_number_of_teeth_on_sun;
k1=round(2/m*(ns1+np));
k= k1*m%2!=0 ? k1+1 : k1;
ns=k*m/2-np;
echo("ns",ns);
nr=ns+2*np;
echo("nr",nr);
pitchD=0.9*D/(1+min(PI/(2*nr*tan(P)),PI*DR/nr));
pitch=pitchD*PI/nr;
echo("pitch",pitch);
helix_angle=45;//atan(2*nTwist*pitch/T);
echo("helix angle",helix_angle);

phi=$t*360/m;

// R	Number of teeth in ring gear
// S	Number of teeth in sun gear 
// ratio: S/(R+S)

echo("ratio",ns,":",nr+ns);
echo("ratio",(ns/(nr+ns)));

%cylinder(r=1.5*in, h=T+10);
%cylinder(r=3.7*in, h=T+5);

//mirror([0,0,1])
translate([0,0,T/2])
{
  planetary_gearbox();
  *planetary_flywheel();
  *translate([0,0,-T-2])
    planetary_engine_mount();
}

*shaft();

module shaft()
{
  difference()
  {
    cylinder(r=w/sqrt(3)-.3,h=T,$fn=6);
    cylinder(d=1.9,h=1000,$fn=20,center=true);
  }
}

module planetary_engine_mount()
{
  difference()
  {
    union()
    {
      block();
      translate([0,0,T/2])
        mirror([0,0,1])
          engine_mount();
    }
    translate([0,0,T/2])
      mirror([0,0,1])
        engine_room();
  }
}

module block(D=round(.8*D))
{
	difference()
  {
    union()
    {
      hull()
      {
        for(i=[-1,1])
        for(j=[-1,1])
        {
          translate([i*D/2,j*D/2,0])
            cylinder(d=7,h=T,center=true,$fn=20);
        }
      }
      {
        for(i=[-1,1])
        for(j=[-1,1])
        {
          translate([i*D/2,j*D/2,1.0])
            cylinder(d=7,h=T+2.0,center=true,$fn=20);
        }
      }
    }
    {
      for(i=[-1,1])
      for(j=[-1,1])
      {
        translate([i*D/2,j*D/2,0])
          cylinder(d=3.8,h=T+10,center=true,$fn=20);
      }
    }
	}
}

module planetary_flywheel()
{
	difference()
  {
    block();
		cylinder( d=.9*D, h=1000, center=true );
	}
    
  translate([0,0,-T/2])
  {
    difference()
    {
      cylinder(d=.8*D,h=T+1.4,$fn=100);
  		cylinder(r=w/sqrt(3),h=T+.2,$fn=6);
    }
  }
  
  // pentagon below hexagon, .8mm
  translate([0,0,T/2+.6])
  {
    // hexagonal shaft
    translate([0,0,.8])
    {
      // base, .6mm
      cylinder(d=1.5*w,h=.6,$fn=60);
      // shaft, T
      translate([0,0,.6])
        cylinder(r=w/sqrt(3)-.3,h=T,$fn=6);
    }
  }
}


module planetary_gearbox()
{
	difference()
  {
    block();
		herringbone(nr,pitch,P,DR,-tol,helix_angle,T+0.2);
*		difference(){
			translate([0,-D/2,0])rotate([90,0,0])monogram(h=10);
			cylinder(r=D/2-0.25,h=T+2,center=true,$fn=100);
		}
	}
	rotate([0,0,(np+1)*180/ns+phi*(ns+np)*2/ns])
	difference(){
		mirror([0,1,0])
			herringbone(ns,pitch,P,DR,tol,helix_angle,T);
		cylinder(r=w/sqrt(3),h=T+1,center=true,$fn=6);
	}
	for(i=[1:m])
    rotate([0,0,i*360/m+phi])
    translate([pitchD/2*(ns+np)/nr,0,0])
		rotate([0,0,i*ns/m*360/np-phi*(ns+np)/np-phi])
    {
      difference()
      {
        herringbone(np,pitch,P,DR,tol,helix_angle,T);
        //cylinder( d=w, h=T+1, center=true, $fn=40 );
        translate([0,0,-.01])
          roll(w,T+.02,clearance=true);
      }
      intersection()
      {
        roll(w,T);
        *union()
        {
          cylinder(d=100,h=2*T,center=false,$fn=60);
          translate([0,0,-T])
            cylinder(d=w-1.0,h=2*T,center=true,$fn=60);
        }
      }
      translate([0,0,T/2])
        cylinder(d=w,h=1.0,$fn=60);
    }
    
  // rail below pentagon
  //translate([0,0,50])
  *translate([0,0,T/2+.6])
  {
    difference()
    {
      for(i=[1:m])
      {
        hull()
        {
          for(j=[0,1])
            rotate([0,0,(i+j)*360/m+phi])
              translate([pitchD/2*(ns+np)/nr,0,0])
                cylinder(d=w,h=.2,$fn=60);
                //translate([0,0,.1])cube([w,.02,.2],center=true);
        }
      }
      for(i=[1:m])
      {
        hull()
        {
          for(j=[0,1])
            rotate([0,0,(i+j)*360/m+phi])
              translate([pitchD/2*(ns+np)/nr-w,0,0])
                cylinder(d=w,h=10,$fn=60,center=true);
        }
      }
    }
  }
  
  // pentagon below hexagon, .8mm
  *translate([0,0,T/2+.8])
  {
    hull()
	    for(i=[1:m])
        rotate([0,0,i*360/m+phi])
          translate([pitchD/2*(ns+np)/nr,0,0])
            cylinder(d=w,h=.8,$fn=60);
    
    // hexagonal shaft
    translate([0,0,.8])
    {
      // base, .6mm
      cylinder(d=1.5*w,h=.4,$fn=60);
      // shaft, T
      translate([0,0,.4])
        cylinder(r=w/sqrt(3)-.3,h=T,$fn=6);
    }
  }
}

module rack(
	number_of_teeth=15,
	circular_pitch=10,
	pressure_angle=28,
	helix_angle=0,
	clearance=0,
	gear_thickness=5,
	flat=false){
addendum=circular_pitch/(4*tan(pressure_angle));

flat_extrude(h=gear_thickness,flat=flat)translate([0,-clearance*cos(pressure_angle)/2])
	union(){
		translate([0,-0.5-addendum])square([number_of_teeth*circular_pitch,1],center=true);
		for(i=[1:number_of_teeth])
			translate([circular_pitch*(i-number_of_teeth/2-0.5),0])
			polygon(points=[[-circular_pitch/2,-addendum],[circular_pitch/2,-addendum],[0,addendum]]);
	}
}

module monogram(h=1)
linear_extrude(height=h,center=true)
translate(-[3,2.5])union(){
	difference(){
		square([4,5]);
		translate([1,1])square([2,3]);
	}
	square([6,1]);
	translate([0,2])square([2,1]);
}

module herringbone(
	number_of_teeth=15,
	circular_pitch=10,
	pressure_angle=28,
	depth_ratio=1,
	clearance=0,
	helix_angle=0,
	gear_thickness=5){
union(){
	gear(number_of_teeth,
		circular_pitch,
		pressure_angle,
		depth_ratio,
		clearance,
		helix_angle,
		gear_thickness/2);
	mirror([0,0,1])
		gear(number_of_teeth,
			circular_pitch,
			pressure_angle,
			depth_ratio,
			clearance,
			helix_angle,
			gear_thickness/2);
}}

module gear (
	number_of_teeth=15,
	circular_pitch=10,
	pressure_angle=28,
	depth_ratio=1,
	clearance=0,
	helix_angle=0,
	gear_thickness=5,
	flat=false){
pitch_radius = number_of_teeth*circular_pitch/(2*PI);
twist=tan(helix_angle)*gear_thickness/pitch_radius*180/PI;

flat_extrude(h=gear_thickness,twist=twist,flat=flat)
	gear2D (
		number_of_teeth,
		circular_pitch,
		pressure_angle,
		depth_ratio,
		clearance);
}

module flat_extrude(h,twist,flat){
	if(flat==false)
		linear_extrude(height=h,twist=twist,slices=twist/6)child(0);
	else
		child(0);
}

module gear2D (
	number_of_teeth,
	circular_pitch,
	pressure_angle,
	depth_ratio,
	clearance){
pitch_radius = number_of_teeth*circular_pitch/(2*PI);
base_radius = pitch_radius*cos(pressure_angle);
depth=circular_pitch/(2*tan(pressure_angle));
outer_radius = clearance<0 ? pitch_radius+depth/2-clearance : pitch_radius+depth/2;
root_radius1 = pitch_radius-depth/2-clearance/2;
root_radius = (clearance<0 && root_radius1<base_radius) ? base_radius : root_radius1;
backlash_angle = clearance/(pitch_radius*cos(pressure_angle)) * 180 / PI;
half_thick_angle = 90/number_of_teeth - backlash_angle/2;
pitch_point = involute (base_radius, involute_intersect_angle (base_radius, pitch_radius));
pitch_angle = atan2 (pitch_point[1], pitch_point[0]);
min_radius = max (base_radius,root_radius);

intersection(){
	rotate(90/number_of_teeth)
		circle($fn=number_of_teeth*3,r=pitch_radius+depth_ratio*circular_pitch/2-clearance/2);
	union(){
		rotate(90/number_of_teeth)
			circle($fn=number_of_teeth*2,r=max(root_radius,pitch_radius-depth_ratio*circular_pitch/2-clearance/2));
		for (i = [1:number_of_teeth])rotate(i*360/number_of_teeth){
			halftooth (
				pitch_angle,
				base_radius,
				min_radius,
				outer_radius,
				half_thick_angle);		
			mirror([0,1])halftooth (
				pitch_angle,
				base_radius,
				min_radius,
				outer_radius,
				half_thick_angle);
		}
	}
}}

module halftooth (
	pitch_angle,
	base_radius,
	min_radius,
	outer_radius,
	half_thick_angle){
index=[0,1,2,3,4,5];
start_angle = max(involute_intersect_angle (base_radius, min_radius)-5,0);
stop_angle = involute_intersect_angle (base_radius, outer_radius);
angle=index*(stop_angle-start_angle)/index[len(index)-1];
p=[[0,0],
	involute(base_radius,angle[0]+start_angle),
	involute(base_radius,angle[1]+start_angle),
	involute(base_radius,angle[2]+start_angle),
	involute(base_radius,angle[3]+start_angle),
	involute(base_radius,angle[4]+start_angle),
	involute(base_radius,angle[5]+start_angle)];

difference(){
	rotate(-pitch_angle-half_thick_angle)polygon(points=p);
	square(2*outer_radius);
}}

// Mathematical Functions
//===============

// Finds the angle of the involute about the base radius at the given distance (radius) from it's center.
//source: http://www.mathhelpforum.com/math-help/geometry/136011-circle-involute-solving-y-any-given-x.html

function involute_intersect_angle (base_radius, radius) = sqrt (pow (radius/base_radius, 2) - 1) * 180 / PI;

// Calculate the involute position for a given base radius and involute angle.

function involute (base_radius, involute_angle) =
[
	base_radius*(cos (involute_angle) + involute_angle*PI/180*sin (involute_angle)),
	base_radius*(sin (involute_angle) - involute_angle*PI/180*cos (involute_angle))
];


dd=.4; //clearance
dh=.2; //clearance

module roll(W,H,W2=0,clearance=false)
{
  W2 = W2 ? W2 : 3*W/4;
  D1= clearance ? W+3*dd : W;
  D2= clearance ? W2+2*dd : W2;
  translate([0,0,-H/2])
  {
    cylinder(d1=D1,d2=D2,h=H/2,$fn=60);
    cylinder(d=D2,h=H,$fn=60);
    translate([0,0,H/2])
      cylinder(d1=D2,d2=D1,h=H/2,$fn=60);
    translate([0,0,H])
      cylinder(d=D1,h=dh,$fn=60);
  }
}
