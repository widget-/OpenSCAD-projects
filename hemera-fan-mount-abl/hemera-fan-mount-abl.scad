// This model requires the BOSL2 library. Get it from https://github.com/revarbat/BOSL2
include <BOSL2/std.scad>

// user parmeters
thickness = 3; // thickness of all parts

abl_diameter = 12; // commonly 8, 10, 12, 16.
abl_mount_height = 8; // how tall of tube to create to put the ABL into
abl_mount_distance = 4; // how far away the inside of the ABL should be from the fan cover
abl_mount_vertical_offset = -4; // vertically offset ABL mount, 0 = aligned to bottom
abl_mount_horizontal_offset = -29; // horizontally offset ABL mount, 0 = aligned to front

fan_guard = true; // add honeycomb pattern to protect your fingies from the mean fan
fan_guard_cell_size = 8; // size of honeycombs in fan guard, if enabled
fan_guard_cell_thickness = 1; // walls for fan guard, if enabled

bolt_hole_diameter = 4; // M4 should be 4, etc.
bolt_cap_diameter = 7.5; // heads for the bolts

hole_slop = 0.5; // add this much to all hole diameters, since printers might overextrude a bit

// design parameters
fan_screw_distance = 32;
fan_cover_size = fan_screw_distance + bolt_hole_diameter + thickness*2; // both width and height
fan_hole_cutout_diameter = sqrt(2*fan_screw_distance*fan_screw_distance) - bolt_hole_diameter - thickness*2; // allow `thickness` between fan hole and screw holes
fan_hole_cutout_clip = fan_cover_size - thickness*2; // allow `thickness` between fan hole and edges

$fa = 1;
$fs = 0.5;

_skew_front = abl_mount_horizontal_offset > 0;
_skew_back = abl_mount_horizontal_offset < abl_diameter + thickness*2 - fan_cover_size;
_skew_down = abl_mount_vertical_offset < 0;
_skew_up = abl_mount_vertical_offset > fan_cover_size - abl_mount_height;

echo("_skew_front", _skew_front);
echo("_skew_back", _skew_back);
echo("_skew_down", _skew_down);
echo("_skew_up", _skew_up);

module fan_mount_2d(screw_holes=true) {
    difference() {
        rect([fan_cover_size, fan_cover_size], center=true, rounding=thickness);

        intersection() {
            oval(d=fan_hole_cutout_diameter);
            rect([fan_hole_cutout_clip, fan_hole_cutout_clip], center=true);

            if (fan_guard) {
                grid2d(size=[fan_cover_size, fan_cover_size], spacing=fan_guard_cell_size+fan_guard_cell_thickness, stagger=true)
                oval(d=fan_guard_cell_size, $fn=6, circum=true, spin=180/6);
            }
        }

        if (screw_holes)
        xcopies(fan_screw_distance)
        ycopies(fan_screw_distance)
        oval(d=bolt_hole_diameter+hole_slop);
    }
}

module fan_mount(anchor=CENTER, spin=0, orient=UP) {
    // attachable() makes it function as any other BOSL 3d shape would
    attachable(anchor, spin, orient, size=[fan_cover_size, fan_cover_size, thickness]) {
        union() {
            linear_extrude(height=thickness, center=true)
            fan_mount_2d();
        }
        children();
    }
}

module abl_holder(anchor=CENTER, spin=0, orient=UP) {
    // _round_edges = [ for (x = [
    //     (_skew_up || _skew_down && !_skew_back) ? FRONT+LEFT : 0,
    //     (_skew_up || _skew_down && !_skew_front) ? BACK+LEFT : 0,
    //     (_skew_front  && !(_skew_up || _skew_down)) ? BACK+RIGHT : 0,
    //     (_skew_back  && !(_skew_up || _skew_down)) ? FRONT+RIGHT : 0,
    //     (!(_skew_back || _skew_front || _skew_up || _skew_down)) ? FRONT+LEFT : 0,
    //     (!(_skew_back || _skew_front || _skew_up || _skew_down)) ? BACK+LEFT : 0
    // ]) if (x != 0) x ];
    difference() {
        up(abl_mount_vertical_offset + abl_mount_height/2)
        left(abl_mount_distance+abl_diameter/2+thickness)
        fwd(fan_cover_size/2-abl_diameter+thickness)
        fwd(abl_mount_horizontal_offset)
        difference() {
            // cuboid([abl_diameter+thickness*2, abl_diameter+thickness*2, abl_mount_height], rounding=abl_diameter/2+thickness, edges=_round_edges);
            // diff("mask")
            union() {
                cuboid([abl_diameter+thickness*2, abl_diameter+thickness*2, abl_mount_height], rounding=abl_diameter/2+thickness, edges=[FRONT+LEFT, BACK+LEFT]);

                // right(abl_diameter/2+thickness)
                // prismoid(size1=[abl_mount_height, abl_diameter+thickness*2], size2=[0, 0], h=max(abl_mount_height, abl_diameter+thickness*2)/4, orient=RIGHT);
            }
            cyl(d=abl_diameter+hole_slop, h=abl_mount_height+1);
        }
        // tube(id=abl_diameter, wall=thickness, h=abl_mount_height, anchor=BOTTOM+RIGHT);

        up(fan_cover_size/2)
        ycopies(fan_screw_distance)
        zcopies(fan_screw_distance)
        cyl(d=bolt_hole_diameter+hole_slop, h=abl_mount_distance+abl_diameter+thickness*3, anchor=BOTTOM, orient=LEFT);
    }
}


module abl_mount_attachment() {
    _attach_offset_v =
        _skew_up ? fan_cover_size-abl_mount_height :
        _skew_down ? 0 :
        abl_mount_vertical_offset;
    _attach_offset_h =
        _skew_front ? fan_cover_size/2-abl_diameter+thickness :
        _skew_back ? -(fan_cover_size/2-abl_diameter+thickness) :
        fan_cover_size/2-abl_diameter+thickness + abl_mount_horizontal_offset;
    _skew_z =
        (_skew_up) ? -(abl_mount_vertical_offset+abl_mount_height-fan_cover_size) / abl_mount_distance :
        (_skew_down) ? -abl_mount_vertical_offset / abl_mount_distance : 0;
    _skew_y =
        (_skew_front) ? abl_mount_horizontal_offset / abl_mount_distance :
        (_skew_back) ? (fan_cover_size - abl_diameter - thickness*2 + abl_mount_horizontal_offset) / abl_mount_distance : 0;
    difference() {
        union() {
            difference() {
                skew(szx=_skew_z)
                skew(syx=_skew_y)
                up(_attach_offset_v)
                // fwd(fan_cover_size/2-abl_diameter+thickness*2)
                fwd(_attach_offset_h)
                cuboid([abl_mount_distance, abl_diameter+thickness*2, abl_mount_height], anchor=RIGHT+BOTTOM);
                
                skew(szx=_skew_z)
                skew(syx=_skew_y)
                up(fan_cover_size/2)
                left((abl_mount_distance+abl_diameter+thickness*3)/2-0.01)
                yrot(90)
                linear_extrude(height=abl_mount_distance+abl_diameter+thickness*3, center=true, convexity=20)
                difference() {
                    rect([fan_cover_size+thickness, fan_cover_size+thickness], center=true);
                    fan_mount_2d(screw_holes=false);
                }

                left(abl_mount_distance+abl_diameter/2+thickness)
                fwd(fan_cover_size/2-abl_diameter+thickness*2)
                fwd(abl_mount_horizontal_offset)
                cyl(d=abl_diameter, h=fan_cover_size*2);
            }

            // #up(abl_mount_vertical_offset + abl_mount_height/2)
            // left(abl_mount_distance)
            // fwd(fan_cover_size/2-abl_diameter+thickness)
            // fwd(abl_mount_horizontal_offset)
            
            skew(szx=_skew_z)
            skew(syx=_skew_y)
            up(_attach_offset_v)
            fwd(_attach_offset_h)
            left(abl_mount_distance)
            prismoid(size1=[abl_mount_height, abl_diameter+thickness*2], size2=[0, 0], h=abl_mount_distance, orient=RIGHT, anchor=RIGHT+BOTTOM);

        }
        up(fan_cover_size/2)
        ycopies(fan_screw_distance)
        zcopies(fan_screw_distance)
        cyl(d=bolt_cap_diameter, h=abl_mount_distance+abl_diameter+thickness*3, anchor=BOTTOM, orient=LEFT);
    }
}

fan_mount(orient=RIGHT, anchor=BOTTOM+RIGHT);

abl_holder(anchor=BOTTOM+RIGHT);

abl_mount_attachment();