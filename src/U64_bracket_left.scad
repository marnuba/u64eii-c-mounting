
include <BOSL2/std.scad>;

width = 20;
rest_len = 70; // how long the part is the keyboard rest on
rest_thickness = 6;

kb_len = 126.25;  // the length (actually depth) of the keyb
kb_angle = 13;  // un degree!

kb_ground_len = kb_len * cos(kb_angle);

base_start_abs = 30;
base_len = kb_ground_len - base_start_abs;
base_thickness = 2;

screwpod_height = 4;
screwpod_dia = 6.3;
screwpod_well_dia = 8;

rest_elevation = (kb_len - rest_len) * sin(kb_angle);
rest_start_abs = (kb_len - rest_len) * cos(kb_angle);

rest_start = rest_start_abs - base_start_abs;

module Rest() {
    edgeheight = 2;
    edgewidth = 2;
    restsize = [width, rest_len, rest_thickness];
    edgesize = [restsize.x, edgewidth, restsize.z+edgeheight];
       
    cube(restsize);
    back(restsize.y) cube(edgesize);
}

module Base(basewidth=width) {
    cube([basewidth, base_len, 2]);   
}

module Arm() {
    echo(rest_elevation);
    cube([width, 20, rest_elevation]);
}

module ArmRest() {
    Arm();
    
    fwd(base_start_abs+rest_start)
    xrot(kb_angle) back(kb_len - rest_len)
    down(rest_thickness)
    Rest();
}

module Screwpod() {
    sp_len = rest_start;
     right(width/2) back(sp_len/2) up(2) prismoid(size1=[width, sp_len], h=2, xang=[50,50], yang=[50,90]);
}

module Structure(basewidth) {
    Base(basewidth);
    back(rest_start) ArmRest();
    Screwpod();
}


module Screwhole(x, y) {
    down(0.01) right(x) back(y) cylinder(r=screwpod_dia/2, h=40.02);
}


module Left_Holder() {
    difference() {
        Structure(width);
        Screwhole(7, 13.1);
        Screwhole(13, 13.1+40.4);
    }
}

module Right_Holder() {
    difference() {
        basewidth = width + 10;
        Structure(basewidth);
        Screwhole(basewidth - 10.5 + screwpod_dia/2, 13.1);
        Screwhole(basewidth - 7.4 + screwpod_dia/2, 13.1+52);
    }
}


//Left_Holder();
Right_Holder();