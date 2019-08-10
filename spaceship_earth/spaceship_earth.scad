// unit = 1 foot
include <BOSL/constants.scad>
use <BOSL/transforms.scad>
use <BOSL/shapes.scad>
use <BOSL/sliders.scad>
use <BOSL/masks.scad>


// most units found from http://tampasteelerecting.com/images/epcot.pdf
sphere_radius = 80;
sphere_ground_clearance = 16;

leg_spread_distance = 55;
hex_support_width = 110;

leg_thickness = 7;

module ball_outer() {
    import("geodesic-polyhedron-kdcccdI.stl", convexity=15);
} 

module ball_inner() {
    import("geodesic-polyhedron-dcccdI.stl", convexity=15);
} 

module sparser_strut(w, l, h, thick=2, maxang=45, max_bridge=10, 
                     strut=2, orient=ORIENT_Y, align=V_CENTER) {
    // like sparse_strut_3d but without the insides
    xspread(l=l-thick, n=2)
    sparse_strut(l=w, h=h, thick=thick, strut=strut, maxang=maxang,
                 max_bridge=max_bridge, orient=ORIENT_Y, align=align);
    yspread(l=w-thick, n=2)
    sparse_strut(l=l, h=h, thick=thick, strut=strut, maxang=maxang,
                 max_bridge=max_bridge, orient=ORIENT_X, align=align);
    zspread(l=h-thick, n=2)
    sparse_strut(l=l, h=w, thick=thick, strut=strut, maxang=maxang,
                 max_bridge=max_bridge, orient=ORIENT_X_90, align=align);

}

// this STL has inner radius 1 and outer radius 1.035:
module ball() {
    color("#FFF9")
    up(sphere_radius*2+sphere_ground_clearance)
    scale(sphere_radius*2)
    difference() {
        union() {
            scale(1.002)
            ball_inner();

            ball_outer();
        }
        // sphere(r=1, $fn=50);
        scale(0.9)
        ball_inner();
    }
}

module leg_strut() {
    back(hex_support_width)
    zrot(30)
    left(leg_spread_distance)
    skew_xy(0, -25)
    union() {
        xspread(l=leg_spread_distance, n=2)
        sparser_strut(w=15, l=15, h=100, maxang=60, strut=1, thick=1);
    }
}

module leg_shell_side() {
    back(30)
    difference() {
        square(size=[100, 100], center=true);

        r1 = 75;
        left(50)
        back(50)
        circle(r=r1, $fn=100);

        r2 = 25;
        back(50-12.5)
        right(50-12.5-5)
        difference() {
            square(size=[r2,r2], center=true);

            right(r2/2)
            fwd(r2/2)
            circle(r=r2, $fn=100);
        }
    }
}

module leg_shell() {
    yrot(90)
    difference() {
        linear_extrude(height=80, center=true, convexity=10, twist=0)
        leg_shell_side();

        linear_extrude(height=80-leg_thickness*2, center=true, convexity=10, twist=0)
        offset(r=-leg_thickness)
        leg_shell_side();
    }
}

module large_leg_shell_side() {
    back(30)
    difference() {
        fwd(25)
        square(size=[100, 50], center=true);

        r1 = 75;
        left(50)
        back(50)
        circle(r=r1, $fn=100);
    }

    polygon(points=[
        [50,0],
        [50,120],
        [40,120],
        [0,25]
    ]);
    
}

module large_leg_shell() {
    yrot(90)
    difference() {
        linear_extrude(height=80, center=true, convexity=10, twist=0)
        large_leg_shell_side();

        linear_extrude(height=80-leg_thickness*2, center=true, convexity=10, twist=0)
        offset(r=-leg_thickness)
        large_leg_shell_side();
    }
}

module leg_struts() {
    up(100/2) {
        zrot(240)
        union() {
            color("#F00")
            leg_strut();
            
            difference() {
                back(hex_support_width)
                zrot(30)
                left(leg_spread_distance)
                skew_xy(0, -25)
                color("#00F9")
                large_leg_shell();
                        
                up(sphere_radius*2+sphere_ground_clearance-100/2)
                scale(sphere_radius*2/20)
                sphere(r=20, $fn=50);
            }
        }

        rot_copies(rots=[0,120],v=[0,0,1]) {
            color("#F00")
            leg_strut();
            
            difference() {
                back(hex_support_width)
                zrot(30)
                left(leg_spread_distance)
                skew_xy(0, -25)
                color("#00F9")
                leg_shell();
                        
                up(sphere_radius*2+sphere_ground_clearance-100/2)
                scale(sphere_radius*2/20)
                sphere(r=20, $fn=50);
            }
        }
    }
}


difference() {
    union() {
        leg_struts();
        ball();
    }

    cylinder(r=10, h=101, center=false);

    rot_copies(rots=[0,120,240],v=[0,0,1])
    right(150)
    cylinder(r=10, h=30, center=true);
}

