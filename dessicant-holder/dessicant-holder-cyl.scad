include <BOSL/constants.scad>
use <BOSL/transforms.scad>
use <BOSL/shapes.scad>

radius = 20; // note that cylinder_thickness is added to radius for total size
height = 80;
hole_spacing = 1.75;
cylinder_thickness = 2;
hole_wall_thickness = 0.5;

$fn=50;

// cylinder(r=radius+cylinder_thickness, h=cylinder_thickness, center=false);

linear_extrude(height=cylinder_thickness) {
    difference() {
        offset(r=cylinder_thickness)
        circle(r=radius);
        circle(r=radius);
    }
}

// bottom
for (i=[0:ceil(radius/(hole_spacing+hole_wall_thickness))-1]) {
    echo(str(i));
    zrot(i*30)
    zrot_copies(n=max(4,ceil(2*PI*i)), r=i*(hole_spacing+hole_wall_thickness))
    fwd(hole_wall_thickness/2)
    cube([hole_spacing+hole_wall_thickness, hole_wall_thickness, cylinder_thickness]);
}
for (i=[0:ceil(radius/(hole_spacing+hole_wall_thickness))]) {
    linear_extrude(height=cylinder_thickness) {
        difference() {
            offset(r=hole_wall_thickness)
            circle(r=i*(hole_spacing+hole_wall_thickness));
            circle(r=i*(hole_spacing+hole_wall_thickness));
        }
    }
}

// middle
echo(ceil(2*PI*radius/(hole_spacing+hole_wall_thickness)));
up(cylinder_thickness)
zrot_copies(n=ceil(2*PI*radius/(hole_spacing+hole_wall_thickness)), r=radius)
cube([cylinder_thickness, hole_wall_thickness, height-2*cylinder_thickness]);

up(cylinder_thickness)
zspread(n=height/(hole_spacing+hole_spacing), spacing=hole_spacing+hole_spacing, sp=[0,0,0])
linear_extrude(height=hole_wall_thickness) {
    difference() {
        offset(r=cylinder_thickness)
        circle(r=radius);
        circle(r=radius);
    }
}

// top
up(height-cylinder_thickness) {
    linear_extrude(height=cylinder_thickness) {
        difference() {
            offset(r=cylinder_thickness)
            circle(r=radius);
            circle(r=radius);
        }
    }

    for (i=[3:ceil(radius/(hole_spacing+hole_wall_thickness))-1]) {
        echo(str(i));
        zrot(i*30)
        zrot_copies(n=max(4,ceil(2*PI*i)), r=i*(hole_spacing+hole_wall_thickness))
        cube([hole_spacing+hole_wall_thickness, hole_wall_thickness, cylinder_thickness]);
    }
    for (i=[3:ceil(radius/(hole_spacing+hole_wall_thickness))]) {
        linear_extrude(height=cylinder_thickness) {
            difference() {
                offset(r=hole_wall_thickness)
                circle(r=i*(hole_spacing+hole_wall_thickness));
                circle(r=i*(hole_spacing+hole_wall_thickness));
            }
        }
    }
}