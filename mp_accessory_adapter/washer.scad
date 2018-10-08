module washer(
    diameter_mm             = 10,
    hole_diameter_mm        = 4,
    thickness_mm            = 2,
    slice_angle             = [0,0,0]
){
    PLANE_RADIUS=diameter_mm/2;
    HOLE_RADIUS=hole_diameter_mm/2;
    MARGIN=0.001;

    module washer_plane(){
        difference(){
            cylinder(h=thickness_mm*diameter_mm, r1=PLANE_RADIUS, r2=PLANE_RADIUS, center=true);
            cylinder(h=thickness_mm*diameter_mm+MARGIN, r1=HOLE_RADIUS, r2=HOLE_RADIUS, center=true);
        }
    }

    module slicing_plane(){
        size_factor=diameter_mm;
        slicing_plane_thickness=size_factor*diameter_mm;
        // bottom slicing cube
        translate([0,0,-(slicing_plane_thickness/2+thickness_mm/2)])
        cube (
            // size=[x,y,z]
            size=[(size_factor*diameter_mm+MARGIN),(size_factor*diameter_mm+MARGIN),slicing_plane_thickness],
            center = true
        ); 
        // top slicing cube
        translate([0,0,(slicing_plane_thickness/2+thickness_mm/2)]) 
        cube (
            size=[(size_factor*diameter_mm+MARGIN),(size_factor*diameter_mm+MARGIN),slicing_plane_thickness],
            center = true
        );
    }

    difference(){
        washer_plane();
        rotate(slice_angle)
        slicing_plane();
    }
}

// example:
//--------------------------------------------
// washer(
//     diameter_mm=25,
//     hole_diameter_mm=5,
//     thickness_mm=2,
//     slice_angle=[0,45,0]
// );