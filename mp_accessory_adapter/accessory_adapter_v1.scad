use <modules/washer.scad>
use <modules/quadratic_bezier.scad>
use <modules/simple_gear.scad>

MID_SECTION_LENGTH=100;
MID_SECTION_DIAMETER=18;
MID_SECTION_HOLE_DIAMETER=10;
ADAPTER_GROOVED_MID_SECTION_LENGTH=10;
ADAPTER_SMOOTH_MID_SECTION_LENGTH=10;
GROOVE_DEPTH=1;
NUMBER_OF_TEETH=20;
WASHER_OUTTER_DIAMETER=20;
WASHER_INNER_DIAMETER=5;
WAHSER_THICKNESS=2;
CONE_THICKNESS=2;
// Calculated Values 
GROOVED_MID_SECTION_LENGTH=MID_SECTION_LENGTH-2*ADAPTER_GROOVED_MID_SECTION_LENGTH-2*ADAPTER_SMOOTH_MID_SECTION_LENGTH;

// entire accessory adapter
union(){
    // left screen adapter
    union(){
        translate([0,0,30+CONE_THICKNESS/2])
        rotate([0,90,0])
        washer(
            diameter_mm=WASHER_OUTTER_DIAMETER,
            hole_diameter_mm=WASHER_INNER_DIAMETER,
            thickness_mm=WAHSER_THICKNESS,
            slice_angle=[0,0,0]
        );
        rotate([0,0,-135])
        color("yellow") bezier_cone(
            p0=[10,29],
            p1=[10,15],
            p2=[5,0],
            w=CONE_THICKNESS,
            fill_degrees=180
        );
        // smooth cylinder section
        rotate([0,90,0])
        translate([-20, -1.5, WASHER_OUTTER_DIAMETER/2+CONE_THICKNESS])
        color("yellow") 
        difference(){
            cylinder(h=ADAPTER_SMOOTH_MID_SECTION_LENGTH, r1=MID_SECTION_DIAMETER/2, r2=MID_SECTION_DIAMETER/2, $fn=100);
            translate([0,0,1])
            cylinder(h=ADAPTER_SMOOTH_MID_SECTION_LENGTH, r1=MID_SECTION_HOLE_DIAMETER/2, r2=MID_SECTION_HOLE_DIAMETER/2, $fn=100);
        }
        // grooved cylinder section
        rotate([0,90,0])
        translate([-20, -1.5, WASHER_OUTTER_DIAMETER/2+ADAPTER_SMOOTH_MID_SECTION_LENGTH+ADAPTER_GROOVED_MID_SECTION_LENGTH/2+CONE_THICKNESS])
        color("yellow") simple_gear(
            cyl_length_mm=ADAPTER_GROOVED_MID_SECTION_LENGTH,
            cyl_diameter_mm=MID_SECTION_DIAMETER,
            center_hole_diameter=MID_SECTION_HOLE_DIAMETER,
            num_of_teeth=NUMBER_OF_TEETH,
            groove_depth_mm=GROOVE_DEPTH
        );
    };

    // right screen adapter
    union(){
        translate([MID_SECTION_LENGTH+WASHER_OUTTER_DIAMETER+CONE_THICKNESS*2,0,0]) 
        mirror(){
            rotate([0,0,-135])
            color("yellow") bezier_cone(
                p0=[10,29],
                p1=[10,15],
                p2=[5,0],
                w=CONE_THICKNESS,
                fill_degrees=180
            );
            translate([0,0,30+CONE_THICKNESS/2])
            rotate([0,90,0])
            washer(
                diameter_mm=WASHER_OUTTER_DIAMETER,
                hole_diameter_mm=WASHER_INNER_DIAMETER,
                thickness_mm=WAHSER_THICKNESS,
                slice_angle=[0,0,0]
            );   
        };
        // smooth cylinder sction
        rotate([0,90,0])
        translate([-20, -1.5, GROOVED_MID_SECTION_LENGTH+WASHER_OUTTER_DIAMETER/2+ADAPTER_GROOVED_MID_SECTION_LENGTH*2+ADAPTER_SMOOTH_MID_SECTION_LENGTH+CONE_THICKNESS])
        color("yellow") 
        difference(){
            cylinder(h=ADAPTER_SMOOTH_MID_SECTION_LENGTH, r1=MID_SECTION_DIAMETER/2, r2=MID_SECTION_DIAMETER/2, $fn=100);
            translate([0,0,-1])
            cylinder(h=ADAPTER_SMOOTH_MID_SECTION_LENGTH, r1=MID_SECTION_HOLE_DIAMETER/2, r2=MID_SECTION_HOLE_DIAMETER/2, $fn=100);
        }
        // grooved cylinder section
        rotate([0,90,0])
        translate([-20, -1.5, GROOVED_MID_SECTION_LENGTH+WASHER_OUTTER_DIAMETER/2+ADAPTER_GROOVED_MID_SECTION_LENGTH+ADAPTER_SMOOTH_MID_SECTION_LENGTH+ADAPTER_GROOVED_MID_SECTION_LENGTH/2+CONE_THICKNESS])
        color("yellow") simple_gear(
            cyl_length_mm=ADAPTER_GROOVED_MID_SECTION_LENGTH,
            cyl_diameter_mm=MID_SECTION_DIAMETER,
            center_hole_diameter=MID_SECTION_HOLE_DIAMETER,
            num_of_teeth=NUMBER_OF_TEETH,
            groove_depth_mm=GROOVE_DEPTH
        );
    };

    // middle accessory attachment
    rotate([0,90,0])
    translate([-20, -1.5,GROOVED_MID_SECTION_LENGTH/2+ADAPTER_GROOVED_MID_SECTION_LENGTH+ADAPTER_SMOOTH_MID_SECTION_LENGTH+WASHER_OUTTER_DIAMETER/2+CONE_THICKNESS]) 
    simple_gear(
        cyl_length_mm=GROOVED_MID_SECTION_LENGTH,
        cyl_diameter_mm=MID_SECTION_DIAMETER,
        center_hole_diameter=MID_SECTION_HOLE_DIAMETER,
        num_of_teeth=NUMBER_OF_TEETH,
        groove_depth_mm=GROOVE_DEPTH
    );
};