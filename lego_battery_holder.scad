// holder inner length (X axis)
HOLDER_L = 60;

// holder inner width (Y axis)
HOLDER_W = 46;

// holder height
HOLDER_H = 15;

THICKNESS_W = 3;
THICKNESS_L = 1.5;

// LEGO part height
LEGO_HEIGHT = 6;

// LEGO part length
LEGO_L = 9;

// width/radius of support
SUPPORT_WIDTH = 8.5;

CORNER_RADIUS = 10;

$fn = 40;

// calc
TOTAL_WIDTH = HOLDER_W + THICKNESS_W * 2;
TOTAL_LENGTH = HOLDER_L + THICKNESS_L * 2;

module SUPPORT_ONE()
{
	difference(){
		cube([HOLDER_L, SUPPORT_WIDTH, SUPPORT_WIDTH]);

		translate([-1, SUPPORT_WIDTH, SUPPORT_WIDTH])
			rotate([0, 90, 0])
				cylinder(r=SUPPORT_WIDTH, h=HOLDER_L+2);
	}
}

module SUPPORT()
{
	translate([THICKNESS_L, THICKNESS_W, 0])
		SUPPORT_ONE();

	translate([THICKNESS_L + HOLDER_L, THICKNESS_W + HOLDER_W, 0])
		rotate([0, 0, 180])
		SUPPORT_ONE();
}

module BASE()
{
	difference()
	{
		cube([HOLDER_L + THICKNESS_L * 2, HOLDER_W + THICKNESS_W * 2, HOLDER_H]);
		translate([THICKNESS_L, THICKNESS_W, -2])
			cube([HOLDER_L, HOLDER_W, HOLDER_H + 3]);
	}
}

STEP = 8;
DIAM_LEGO = 4.8;
module GEN_LEGO_HOLES(cnt)
{
	for (x = [0: STEP: STEP * (cnt - 1)])
	{
		translate([0, x, -2])
			cylinder(h = 20, r = DIAM_LEGO / 2);
	}
}

module LEGO_HANDLE_ONE()
{
	cube([LEGO_L, HOLDER_W + THICKNESS_W * 2, LEGO_HEIGHT]);
}

module LEGO_HANDLES_WO_HOLES()
{
	translate([-LEGO_L, 0, 0])
		LEGO_HANDLE_ONE();
	translate([HOLDER_L + THICKNESS_L * 2, 0, 0])
		LEGO_HANDLE_ONE();
}

module LEGO_HANDLES()
{
	difference()
	{
		LEGO_HANDLES_WO_HOLES();
		
		HOLES_CNT = 5;
		HOLES_DIFF = 9;
		
		OFFSET_X = -7+2.5;
		OFFSET_Y = (HOLDER_W + THICKNESS_W * 2) / 2 - ((HOLES_CNT-1) * STEP) / 2;
		
		translate([OFFSET_X, OFFSET_Y, 0])
			GEN_LEGO_HOLES(HOLES_CNT);
		
		translate([OFFSET_X + HOLES_DIFF * STEP, OFFSET_Y, 0])
			GEN_LEGO_HOLES(HOLES_CNT);
	}
}

module OUTPUT_SQUARE_CORNER()
{
	BASE();
	SUPPORT();
	LEGO_HANDLES();
}

module CUTTER()
{
	difference()
	{
		cube([CORNER_RADIUS, CORNER_RADIUS, 35]);
		
		translate([CORNER_RADIUS, CORNER_RADIUS, -2])
		cylinder(r=CORNER_RADIUS, h=40);
	}
}
module OUTPUT_ROUNDED_CORNER()
{
	difference()
	{
		OUTPUT_SQUARE_CORNER();
		
		OFF = 0.1;
		translate([-LEGO_L - OFF, -OFF, -5])
			CUTTER();	
		translate([-LEGO_L - OFF, TOTAL_WIDTH + OFF, -5])
			rotate([0, 0, -90])
				CUTTER();
		translate([TOTAL_LENGTH + LEGO_L + OFF, TOTAL_WIDTH + OFF, -5])
			rotate([0, 0, 180])
				CUTTER();
		translate([TOTAL_LENGTH + LEGO_L + OFF, -OFF, -5])
			rotate([0, 0, 90])
				CUTTER();
	}
}

OUTPUT_ROUNDED_CORNER();