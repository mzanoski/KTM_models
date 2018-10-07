use <publicDomainGearV1.1.scad>

module grooved_cylinder(
    // model resolution
    $fn=100,       
    CYL_LENGTH_MM=100,
    CYL_DIAMETER_MM=20, 
    CENTRE_HOLE_DIAMETER=8,        
    NUM_OF_TEETH=40,
    GROOVE_DEPTH_MM=1.5, 
){
    // ============ Calculated Values ============== \\
    pi=3.1415926;
    ACTUAL_DIAMETER=CYL_DIAMETER_MM-GROOVE_DEPTH_MM;
    CYL_CIRCUMFERENCE=pi*CYL_DIAMETER_MM;
    MM_PER_TOOTH=(pi*CYL_DIAMETER_MM)/(NUM_OF_TEETH+(0.64*pi));
    RADIUS=ACTUAL_DIAMETER/2;
    HOLE_RADIUS=CENTRE_HOLE_DIAMETER/2;

    union(){
        gear(
            mm_per_tooth=MM_PER_TOOTH, 
            number_of_teeth=NUM_OF_TEETH, 
            thickness=CYL_LENGTH_MM, 
            pressure_angle=28, 
            hole_diameter=CENTRE_HOLE_DIAMETER
        );
        difference(){
            cylinder(h=CYL_LENGTH_MM, r1=RADIUS, r2=RADIUS, center=true);
            cylinder(h=CYL_LENGTH_MM+0.01, r1=HOLE_RADIUS, r2=HOLE_RADIUS, center=true);
        };
    };
}

grooved_cylinder();

