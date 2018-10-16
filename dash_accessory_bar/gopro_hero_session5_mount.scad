use <modules/gopro_mounts_mooncactus.scad>
use <modules/simple_gear.scad>

///////////////////////////// Module parameters /////////////////////////////
BAR_Length                              = 173;
BAR_Diameter                            = 18;
BAR_ToothDepth                          = 1;
BAR_NumberOfTeeth                       = 20;
CLAMP_Width                             = gopro_connector_z_func()*1.5;
CLAMP_Gap                               = 1;
POST_Height                             = 14.7;
POST_HoleRadius                         = gopro_connector_y_func()-5;



//////////////////////// 'Private' Calculated Values ////////////////////////
// Rick bar section
prv_goproGrooveDiameter         = BAR_Diameter;
prv_goproGrooveDepth            = BAR_ToothDepth;
prv_goproClampDiameter          = BAR_Diameter-BAR_ToothDepth-2;
prv_goproClampInnerToothNum     = BAR_NumberOfTeeth;
prv_goproClampWidth             = CLAMP_Width;
prv_gpproConnectorHeight        = 15.5;
prv_gporoPostHeight             = POST_Height;
prv_goproPostWidth              = gopro_connector_x_func()+1;
prv_goproPostDepth              = gopro_connector_y_func()+4.35;
prv_goproPostHoleRadius         = POST_HoleRadius;
prv_goproPostHoleHeight         = prv_gporoPostHeight;
prv_goproClampYPosition         = prv_gporoPostHeight;
prv_goproClampPadding           = 10;
prv_goproClampGap               = CLAMP_Gap;


// Add a bar mount/clamp to one of the connector
module mount_clamp(){
    // clamp
    union(){
        translate([0,prv_goproClampYPosition,0])
        gopro_bar_clamp(
            rod_d= prv_goproClampDiameter+prv_goproClampPadding, // rod diameter
            th= 7.8, // main thickness
            gap= prv_goproClampGap, // space between the clamps
            screw_d= 3, // screw diameter
            screw_head_d= 6.2, // screw head diameter
            screw_nut_d= 6.01, // nut diameter from corner to corner
            screw_shoulder_th=6, // thickness of the shoulder on which the nut clamps
            screw_reversed=false	 // true to mirror the orientation of the clamp bolts
        );
        translate([0,prv_goproClampDiameter/2+gopro_connector_z_func()+prv_goproClampPadding/2+prv_goproClampYPosition,0])
        difference(){
            difference(){
                cylinder(r=prv_goproClampDiameter-1, h=prv_goproPostHoleHeight, center=true);
                // inner groove
                color("blue")
                simple_gear(
                    cyl_length_mm           = prv_goproClampWidth+1,
                    cyl_diameter_mm         = prv_goproGrooveDiameter,
                    center_hole_diameter    = 0,
                    num_of_teeth            = prv_goproClampInnerToothNum,
                    groove_depth_mm         = prv_goproGrooveDepth
                );
            }
            cube([(prv_goproClampDiameter+prv_goproClampPadding)*2,prv_goproClampGap,prv_goproPostDepth],center=true);
        }
    }
}

module mount_post(){
    color("blue")
    translate([0,prv_gpproConnectorHeight,0])
    cube([prv_goproPostWidth,prv_gporoPostHeight,prv_goproPostDepth],center=true);
}

module mount_inner_hole(){
    color("yellow")
    rotate([90,0,0])
    translate([0,0,-prv_gpproConnectorHeight/2-3-prv_goproPostHoleHeight])
    cylinder(r=prv_goproPostHoleRadius, h=prv_goproPostHoleHeight, center=false);
}


// Create a "triple" gopro connector
union(){
    gopro_connector("triple");
    // clamp
    translate([0,-2,0])
    mount_clamp();
    mount_post();
    mount_inner_hole();
}