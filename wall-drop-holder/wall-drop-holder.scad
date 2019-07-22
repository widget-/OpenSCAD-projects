in = 25.4;
cm = 10;
mm = 1;

// params
wall_thickness = 15*mm;

mdf_wall_thickness = 0.55*in;
panel_thickness_sm = 1.25*cm;
panel_thickness_lg = 19*mm;

holder_length = 1*cm;//12*cm
holder_offset = 3.5*in;

mdf_holder_length = 2*cm;
panel_holder_length = 5*cm;


rotate([0, -90, 0]) 
{
    // bottom
    cube([holder_length, wall_thickness*2 + panel_thickness_lg, wall_thickness]);

    // between wall and panel
    cube([holder_length, wall_thickness, wall_thickness*2 + holder_offset]);

    // top
    translate([0, -wall_thickness-mdf_wall_thickness, wall_thickness*2 + holder_offset])
    cube([holder_length, wall_thickness*2 + mdf_wall_thickness, wall_thickness]);

    // wall side
    translate([0, -wall_thickness-mdf_wall_thickness, holder_offset + wall_thickness*2 - mdf_holder_length])
    cube([holder_length, wall_thickness, wall_thickness + mdf_holder_length]);

    // panel
    translate([0, wall_thickness+panel_thickness_lg])
    cube([holder_length, wall_thickness, wall_thickness*2 + panel_holder_length]);
}