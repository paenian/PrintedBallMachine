include <configuration.scad>;
use <base.scad>;
use <base_module.scad>;
use <pins.scad>;
use <ball_return/ball_return.scad>;

base_module();

module base_module(){
    //pegboard([12,12]);
    basic_panel();
}