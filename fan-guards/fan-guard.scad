include <BOSL2/std.scad>


thickness = 1.4;

outer_diameter = 195;
inner_diameter = outer_diameter-thickness*2;

guard = true; // true for guard, false for airflow tube

screw_spacing = [
    [154, 154],
    [170, 170],
    [110, 180],
    [180, 110]
];

square_part_width = 165;
screw_cutout_diameter = 4.5;

outer_height = 5;
tube_height = 100;
guard_height = 5;

$fa = 1;
$fs = 0.5;


difference() {
    union() {
        if (guard) {
            difference() {
                cyl(d=outer_diameter, h=guard_height+thickness, anchor=BOTTOM);
                down(.1)
                cyl(d=inner_diameter, h=guard_height+thickness+1, anchor=BOTTOM);
                
            }

            for (r = [outer_diameter/5 : outer_diameter/5 : outer_diameter*4/5])
                tube(id=r, od=r+thickness, h=guard_height+thickness, anchor=BOTTOM);
                
            zrot_copies([0,60,120])
            cuboid([outer_diameter, thickness, guard_height+thickness], anchor=BOTTOM);
        } else {
            difference() {
                cyl(d=outer_diameter, h=tube_height+thickness, anchor=BOTTOM);
                down(.1)
                cyl(d=inner_diameter, h=tube_height+thickness+1, anchor=BOTTOM);
            }
        }
        // cuboid([outer_diameter, outer_diameter, tube_height], rounding=outer_diameter/2, edges=[RIGHT+BACK, RIGHT+FRONT] ,anchor=BOTTOM);
        // cuboid([square_part_width, square_part_width, thickness], rounding=screw_cutout_diameter/2, edges="Z", anchor=BOTTOM);


        difference() {
            cuboid([outer_diameter, outer_diameter, thickness], rounding=screw_cutout_diameter/2, edges="Z", anchor=BOTTOM);
            down(.1)
            cyl(d=inner_diameter, h=outer_height+thickness+1, anchor=BOTTOM);
        }
        
        up(thickness+outer_height/2)
        difference() {
            cuboid([outer_diameter, outer_diameter, outer_height], rounding=screw_cutout_diameter/2, edges="Z");
            cuboid([outer_diameter-thickness*2, outer_diameter-thickness*2, outer_height+1], rounding=screw_cutout_diameter/2, edges="Z");
        }
    }

    down(0.1) {
        if (!guard)
            cyl(d=inner_diameter, h=tube_height+1, anchor=BOTTOM);

        for (spacing = screw_spacing) {
            xcopies(l=spacing[0], n=2)
            ycopies(l=spacing[1], n=2)
            cyl(d=screw_cutout_diameter, h=thickness+1, anchor=BOTTOM);
        }

        cyl(r=outer_diameter/10, h=guard_height+thickness+1, anchor=BOTTOM);

        // up(tube_height-screw_cutout_diameter*2)
        // zrot_copies(n=4, r=outer_diameter/2-thickness/2)
        // cyl(d=screw_cutout_diameter, h=thickness+1, orient=[1,0,0]);

        up(outer_height/2+thickness/2)
        zrot_copies(n=4)
        zrot(45)
        left(outer_diameter*2/3)
        cuboid([thickness, outer_diameter, outer_height/2]);
    }

}
