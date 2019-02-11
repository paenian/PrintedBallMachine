in = 25.4;

$fn=30;

slop = .2;

//pegboard variables
peg_rad = 1/4*in/2;
peg_sep = 1*in;
peg_thick = 1/4*in;
peg_cap_rad = .25*in;

wall=3;

//used for the ball return
dowel_rad = (3/8)/2*in;
dowel_sep = 16-2;
dowel_holder_height = 20;
rear_gap = 1.25*in;

//ball variables
ball_rad = 5/8*in/2;

//track_rad = ball_rad+1+.5;  //this is the minimum size, I think
track_rad = in/2-wall; //this makes the track an inch wide

//inlet variables
inlet_x = in;
inlet_y = in*2;
inlet_z = in*1;
INLET_HOLE = 1;
INLET_SLOT = 2;
INLET_NONE=0;
NONE = 0;
NORMAL = 0;
REVERSE = 5;
SWITCH = 8;
FLIP_FLOP = 9;
CENTER = 4;

PEG_PIN = 1;
PEG_HOOK = 2;
PEG_LOWER_HOOK = 3;
PEG_NONE = 0;

m3_rad = 3/2 + slop;
m3_cap_rad = 6/2 + slop;


m5_nut_rad = 8.79/2;
m5_sq_nut_rad = (8*sqrt(2)+slop/2)/2;
m5_nut_rad_laser = 8.79/2-.445;
m5_nut_height = 4.7;
m5_rad = 5/2+slop;
m5_rad_laser = 5/2-.1;
m5_cap_rad = 10/2+slop;
m5_cap_height = 3;
m5_washer_rad = 11/2+slop;

//pin variables
pin_tolerance = .25;
pin_rad = 4;
pin_lt = 1;

//motor shaft variables
motor_dflat=.9;
motor_shaft=7+slop/4;
motor_bump=1.5;