// This model requires the BOSL2 library. Get it from https://github.com/revarbat/BOSL2
include <BOSL2/std.scad>

_presupported = true;
_support_xy_distance = 1;
_support_z_distance = 0.4;
_support_xy_overhang = 2.5;

thickness = 1.2;

button_diameter = 25;
triangle_diameter = 49;
rect_width = 47;
rect_length = 29;

arrow_spacing = 115;
rect_spacing = 50;

depth = 70;
width = 190;
height = 100;
shape_depth = 7;
front_depth = thickness;

insert_diameter = 4.75;
insert_bolt_diameter = 3.5; // m3
insert_depth = 5;
insert_inset = insert_diameter/2;

rear_grid_spacing = 34;

wire_cutout_size = [35, 10];

$fa = 1;
$fs = 1;

xrot(90)
// left_half()
union() {
    difference() {
        union() {
            difference() {
                cuboid([width, depth, height], anchor=FRONT);
                back(front_depth)
                cuboid([width-thickness*2, depth, height-thickness*2], anchor=FRONT);
            }

            xflip_copy(arrow_spacing/2)
            cyl(d=triangle_diameter+thickness*2, h=shape_depth+thickness, $fn=3, circum=false, anchor=TOP, orient=FRONT);

            zcopies(rect_spacing)
            cuboid([rect_width+thickness*2, shape_depth+thickness, rect_length+thickness*2], anchor=FRONT);

            xcopies(l=width, spacing=rear_grid_spacing)
            cuboid([thickness, shape_depth, height], anchor=FRONT);

            zcopies(l=height, spacing=rear_grid_spacing)
            cuboid([width, shape_depth, thickness], anchor=FRONT);
        }

        // triangle cutouts
        xflip_copy(arrow_spacing/2) {
            cyl(d=triangle_diameter, h=shape_depth, $fn=3, circum=false, anchor=TOP, orient=FRONT);
            cyl(d=button_diameter, h=depth, orient=FRONT);
        }

        // rectangle cutouts
        zcopies(rect_spacing) {
            cuboid([rect_width, shape_depth, rect_length], anchor=FRONT);
            cyl(d=button_diameter, h=depth, orient=FRONT);
        }

        // cable hole cutouts for main box
        back(depth-wire_cutout_size[1]/2+.01)
        yrot_copies([0,90])
        cuboid([width*2, wire_cutout_size[1], wire_cutout_size[0]]);
    }

    // threaded insert mounts
    xflip_copy((width-thickness*2-insert_diameter-insert_inset*2)/2)
    zflip_copy((height-thickness*2-insert_diameter-insert_inset*2)/2)
    back(front_depth) 
    difference() {
        union() {
            cyl(d=insert_diameter+thickness*2, h=depth-front_depth-thickness, orient=FRONT, anchor=TOP);

            yrot_copies([0,90])
            cuboid([thickness, depth-front_depth-thickness, insert_diameter/2+thickness+insert_inset], anchor=FRONT+BOTTOM);
        }

        back(depth-front_depth-thickness*2-insert_depth)
        cyl(d=insert_diameter, h=depth-front_depth, orient=FRONT, anchor=TOP);
    }

    // separateable parts to help us print the circles better
    if (_presupported) {
        xflip_copy(arrow_spacing/2)
        difference() {
            intersection() {
                cyl(d=triangle_diameter-_support_xy_distance*2*sqrt(2), h=shape_depth-_support_z_distance, $fn=3, circum=false, orient=FRONT, anchor=TOP);
                cyl(d=button_diameter+_support_xy_overhang*2, h=shape_depth-_support_z_distance, orient=FRONT, anchor=TOP);
            }
            cyl(d=button_diameter-_support_xy_overhang*2, h=shape_depth-_support_z_distance, orient=FRONT, anchor=TOP);
        }
        
        zcopies(rect_spacing)
        
        difference() {
            intersection() {
                cuboid([rect_width-_support_xy_distance*2, shape_depth-_support_z_distance, rect_length-_support_xy_distance*2], anchor=FRONT);
                cyl(d=button_diameter+_support_xy_overhang*2, h=shape_depth-_support_z_distance, orient=FRONT, anchor=TOP);
            }
            cyl(d=button_diameter-_support_xy_overhang*2, h=shape_depth-_support_z_distance, orient=FRONT, anchor=TOP);
        }
    }
}


*back((front_depth+depth) * 1.5)
difference() {
    cuboid([width, thickness, height], anchor=FRONT);

    xcopies(width-thickness*2-insert_diameter-insert_inset*2)
    zcopies(height-thickness*2-insert_diameter-insert_inset*2)
    cyl(d=insert_bolt_diameter, h=depth-front_depth, orient=FRONT, anchor=TOP);
    
    down(height/3)
    rotate([90,0,90])
    cuboid([width*2, wire_cutout_size[1], wire_cutout_size[0]]);

}

