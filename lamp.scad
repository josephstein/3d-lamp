//////////////////////////////////
//         PROPERTIES           //
//////////////////////////////////

$fn = 50;

kPlatformWidthBase = 210;
kPlatformWidthTop = kPlatformWidthBase - 40;
kPlatformWidthBottom = kPlatformWidthBase - 60;

kCordDiameter = 6.27;
kCordBaseDiameter = 14.58;
kCordBasePadding = 7.0;

kDowelDiameter = 11.1125;
kDowelSleeveLength = 40;
kDowelSleeveTopLength = 45;
kDowelSleevePadding = 3.5;
kDowelFoundationLength = 19.0;
kDowelFoundationTopLength = 34.0;

kEndCapDiameter = kDowelDiameter + kDowelSleevePadding*1.5;

kLightbulbSocketDiameter = 39.69;
kLightbulbSocketLength = 58.74;

kLightbulbSocketNippleLength = 15.87;
kLightbulbSocketNippleDiameter =  12.0;

kLightbulbLength = 139.7;
kLightbulbDiameter = 25.57;

kTotalHeight = 350.0;
kTopToBottomHeightRatio = 0.6;

kZIndexBase = 0;
kZIndexTop = kTotalHeight * kTopToBottomHeightRatio;
kZIndexBottom = -(kTotalHeight * (1 - kTopToBottomHeightRatio));

//////////////////////////////////
//          FUNCTIONS           //
//////////////////////////////////

function rearLeftPoint(width, z) = [-width, width, z];
function rearRightPoint(width, z) = [width, width, z];
function frontLeftPoint(width, z) = [-width, -width, z];
function frontRightPoint(width, z) = [width, -width, z];

//////////////////////////////////
//          OBJECTS             //
//////////////////////////////////

module endCapBarObject(width, sleeveLength, foundationLength, name) {
    color("White", 1.0) {
        difference() {
            difference() {
                cylinder(r = kEndCapDiameter, h = width, center = true);
                dowelObject(width, foundationLength, "-");
            }
            
            cylinder(r = kEndCapDiameter + 1, h = width - sleeveLength*2, center = true);
        }
    }
    
    %color("Gold", 0.25) {
        dowelObject(width, foundationLength, name);
    }
}

module dowelObject(width, foundationLength, name) {
    height = width - foundationLength*2;
    cylinder(r = kDowelDiameter, h = height, center = true);
    
    if (name != "-") {
        echo(name, "Dowel Height = ", height);
    }
}

//////////////////////////////////
//        DRAWING MODULES       //
//////////////////////////////////

module drawLightbulb() {
    topHeight = kTopToBottomHeightRatio * kTotalHeight;
    
    %color("Yellow", 0.6) {
            union() {
                // Nipple
                nippleZIndex = kZIndexTop - kEndCapDiameter - (kLightbulbSocketNippleLength/2);
                translate([0, 0, nippleZIndex]) {
                    cylinder(r1 = kLightbulbSocketNippleDiameter, r2 = (kLightbulbSocketNippleDiameter * .6), h = kLightbulbSocketNippleLength, center = true);
                }
                
                // Socket
                porceleinZIndex = nippleZIndex - (kLightbulbSocketNippleLength/2) - (kLightbulbSocketLength/2);
                translate([0, 0, porceleinZIndex] ) {
                    cylinder(r = kLightbulbSocketDiameter, h = kLightbulbSocketLength, center = true);
                }
                
                // Lightbulb top sphere
                topSphereZIndex = porceleinZIndex - (kLightbulbSocketLength/2) - kLightbulbDiameter;
                translate([0, 0, topSphereZIndex]) {
                    sphere(r = kLightbulbDiameter, center = true);
                }
                
                // Lightbulb
                cylinderZIndex = topSphereZIndex - (kLightbulbLength/2);
                translate([0, 0, cylinderZIndex]) {
                    cylinder(r = kLightbulbDiameter, h = kLightbulbLength, center = true);
                }
                
                // Lightbulb bottom sphere
                bottomSphereZIndex = cylinderZIndex - (kLightbulbLength/2) ;
                translate([0, 0, bottomSphereZIndex]) {
                    sphere(r = kLightbulbDiameter, center = true);
                }
            }
     }
}

module drawEndCapFrame(width, z, sleeveLength, foundationLength) {
    halfWidth = width/2;
    angle = 90;
    name = "endCapFrame";
    
    // back
    translate([0, width/2, z]) {
        rotate(a = angle, v = [0, 1, 0]) {
            endCapBarObject(width, sleeveLength, foundationLength, name);
        }
    }
    
    // front
    translate([0, -width/2, z]) {
        rotate(a = angle, v = [0, -1, 0]) {
            endCapBarObject(width, sleeveLength, foundationLength, name);
        }
    }
    
    // left
    translate([-width/2, 0, z]) {
        rotate(a = angle, v = [1, 0, 0]) {
            endCapBarObject(width, sleeveLength, foundationLength, name);
        }
    }
    
    // right
    translate([width/2, 0, z]) {
        rotate(a = angle, v = [-1, 0, 0]) {
            endCapBarObject(width, sleeveLength, foundationLength, name);
        }
    }
}

module drawEndCapBarObjectBetweenPoints(p1, p2, sleeveLength, foundationLength) {
    color("White", 1.0) {
        translate(p1) {
            sphere(r=kEndCapDiameter,center=true);
        }

        translate(p2) {
            sphere(r=kEndCapDiameter,center=true);
        }
    }
    
    vector = [ p2[0] - p1[0], p2[1] - p1[1] ,p2[2] - p1[2] ];
    distance = sqrt(pow(vector[0], 2) + pow(vector[1], 2) + pow(vector[2], 2));

    translate(vector/2 + p1)
        //rotation of XoY plane by the Z axis with the angle of the [p1 p2] line projection with the X axis on the XoY plane
        rotate([0, 0, atan2(vector[1], vector[0])]) //rotation
            //rotation of ZoX plane by the y axis with the angle given by the z coordinate and the sqrt(x^2 + y^2)) point in the XoY plane
            rotate([0, atan2(sqrt(pow(vector[0], 2)+pow(vector[1], 2)),vector[2]), 0])
                endCapBarObject(distance, sleeveLength, foundationLength, "vertical");
}

module drawEndCapFrameForCord(sleeveLength, foundationLength) {
    width = kPlatformWidthTop;
    angle = 90;
    z = kZIndexTop;
    baseDiameter = kCordBaseDiameter + kCordBasePadding;
    fixtureHeight = kEndCapDiameter + 23.0;
    
    difference() {
        difference() {
            union() {
                rearLeftP1 = rearLeftPoint(kPlatformWidthTop / 2, kZIndexTop);
                rearLeftP2 = rearLeftPoint(0, kZIndexTop);
                drawEndCapBarObjectBetweenPoints(rearLeftP1, rearLeftP2, sleeveLength, foundationLength);
                
                rearRightP1 = rearRightPoint(kPlatformWidthTop / 2, kZIndexTop);
                rearRightP2 = rearRightPoint(0, kZIndexTop);
                drawEndCapBarObjectBetweenPoints(rearRightP1, rearRightP2, sleeveLength, foundationLength);
                
                frontRightP1 = frontRightPoint(kPlatformWidthTop / 2, kZIndexTop);
                frontRightP2 = frontRightPoint(0, kZIndexTop);
                drawEndCapBarObjectBetweenPoints(frontRightP1, frontRightP2, sleeveLength, foundationLength);
                
                frontLeftP1 = frontLeftPoint(kPlatformWidthTop / 2, kZIndexTop);
                frontLeftP2 = frontLeftPoint(0, kZIndexTop);
                drawEndCapBarObjectBetweenPoints(frontLeftP1, frontLeftP2, sleeveLength, foundationLength);
                
                // Padding around cord
                color("White", 1.0) {
                    translate([0, 0, kZIndexTop]) {
                        cylinder(r = baseDiameter, h = fixtureHeight, center = true);
                    }
                }
            }
            
            color("White", 1.0) {
                cylinder(r = kCordBaseDiameter, h = kTotalHeight*2, center = true);
            }
        }
        
        // Cut for slipping through cord
        color("White", 1.0) {
            translate([0, -kCordBaseDiameter, kZIndexTop]) {
                rotate([0, 0, -90]) {
                    cylinder(r = kCordDiameter + 5, h = 50.0, $fn = 3, center = true);
                }
                
                cube([ (kCordDiameter*2) * 0.75, baseDiameter*2, fixtureHeight + 10.0], center = true);
            }
        }
    }
}

module drawBaseToTopEndCapFrame(sleeveLength, foundationLength) {
    rearLeftP1 = rearLeftPoint(kPlatformWidthBase / 2, kZIndexBase);
    rearLeftP2 = rearLeftPoint(kPlatformWidthTop / 2, kZIndexTop);
    drawEndCapBarObjectBetweenPoints(rearLeftP1, rearLeftP2, sleeveLength, foundationLength);
    
    rearRightP1 = rearRightPoint(kPlatformWidthBase / 2, kZIndexBase);
    rearRightP2 = rearRightPoint(kPlatformWidthTop / 2, kZIndexTop);
    drawEndCapBarObjectBetweenPoints(rearRightP1, rearRightP2, sleeveLength, foundationLength);
    
    frontLeftP1 = frontLeftPoint(kPlatformWidthBase / 2, kZIndexBase);
    frontLeftP2 = frontLeftPoint(kPlatformWidthTop / 2, kZIndexTop);
    drawEndCapBarObjectBetweenPoints(frontLeftP1, frontLeftP2, sleeveLength, foundationLength);
    
    frontRightP1 = frontRightPoint(kPlatformWidthBase / 2, kZIndexBase);
    frontRightP2 = frontRightPoint(kPlatformWidthTop / 2, kZIndexTop);
    drawEndCapBarObjectBetweenPoints(frontRightP1, frontRightP2, sleeveLength, foundationLength);
}

module drawBaseToBottomEndCapFrame(sleeveLength, foundationLength) {
    rearLeftP1 = rearLeftPoint(kPlatformWidthBase / 2, kZIndexBase);
    rearLeftP2 = rearLeftPoint(kPlatformWidthBottom / 2, kZIndexBottom);
    drawEndCapBarObjectBetweenPoints(rearLeftP1, rearLeftP2, sleeveLength, foundationLength);
    
    rearRightP1 = rearRightPoint(kPlatformWidthBase / 2, kZIndexBase);
    rearRightP2 = rearRightPoint(kPlatformWidthBottom / 2, kZIndexBottom);
    drawEndCapBarObjectBetweenPoints(rearRightP1, rearRightP2, sleeveLength, foundationLength);
    
    frontLeftP1 = frontLeftPoint(kPlatformWidthBase / 2, kZIndexBase);
    frontLeftP2 = frontLeftPoint(kPlatformWidthBottom / 2, kZIndexBottom);
    drawEndCapBarObjectBetweenPoints(frontLeftP1, frontLeftP2, sleeveLength, foundationLength);
    
    frontRightP1 = frontRightPoint(kPlatformWidthBase / 2, kZIndexBase);
    frontRightP2 = frontRightPoint(kPlatformWidthBottom / 2, kZIndexBottom);
    drawEndCapBarObjectBetweenPoints(frontRightP1, frontRightP2, sleeveLength, foundationLength);
}

//////////////////////////////////
//          MAIN                //
//////////////////////////////////

module main() {
    drawLightbulb();
    
    drawEndCapFrameForCord(kDowelSleeveTopLength, kDowelFoundationTopLength);
    
    drawEndCapFrame(kPlatformWidthBase, kZIndexBase, kDowelSleeveLength,  kDowelFoundationLength);
    drawEndCapFrame(kPlatformWidthTop, kZIndexTop, kDowelSleeveTopLength, kDowelFoundationTopLength);
    drawEndCapFrame(kPlatformWidthBottom, kZIndexBottom, kDowelSleeveLength, kDowelFoundationLength);
    
    drawBaseToTopEndCapFrame(kDowelSleeveLength, kDowelFoundationLength);
    drawBaseToBottomEndCapFrame(kDowelSleeveLength, kDowelFoundationLength);
}

main();