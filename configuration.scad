in = 25.4;

$fn=30;

slop = .2;

//pegboard variables
peg_rad = 1/4*in/2;
peg_sep = 1*in;
peg_thick = 1/4*in;

wall=3;

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

PEG_PIN = 1;
PEG_HOOK = 2;
PEG_NONE = 0;

//pin variables
pin_tolerance = .25;
pin_rad = 4;
pin_lt = 1;

//motor shaft variables
motor_dflat=.9;
motor_shaft=7+slop/4;
motor_bump=1.5;