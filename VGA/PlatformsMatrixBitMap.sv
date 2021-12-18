// HartsMatrixBitMap File
// A two level bitmap. dosplaying harts on the screen FWbruary  2021
// (c) Technion IIT, Department of Electrical Engineering 2021



module	PlatformsMatrixBitMap	(
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket

					output	logic	drawingRequest, //output that the pixel should be dispalyed
					output	logic	[7:0] RGBout  //rgb value from the bitmap
 ) ;


// Size represented as Number of X and Y bits
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel
 /*  end generated by the tool */


// the screen is 640*480  or  20 * 15 squares of 32*32  bits ,  we wiil round up to 32*16 and use only the top left 20*15 pixels
// this is the bitmap  of the maze , if there is a one  the na whole 32*32 rectange will be drawn on the screen
// all numbers here are hard coded to simplify the  understanding


logic [0:14] [0:19]  MazeBiMapMask=
{20'b	00000000010000000000,
20'b	00000000100000000000,
20'b	00000001000000000000,
20'b	00001010000000000000,
20'b	00000100000000000000,
20'b	00000000000000000000,
20'b	00000000000000000000,
20'b	00000000000000000000,
20'b	00000000000000000000,
20'b	00000000111111111111,
20'b	00000000000000000000,
20'b	00000000000000000000,
20'b	00000000000000000000,
20'b	00000000000000000000,
20'b	11111111111111111111
};

 logic [0:31] [0:31] [7:0]  object_colors  = {
	{8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98},
	{8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98},
	{8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98},
	{8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98},
	{8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98},
	{8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98},
	{8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98},
	{8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h90,8'h90,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h90,8'h90,8'h90,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98},
	{8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h90,8'hd1,8'hd1,8'h91,8'h90,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h91,8'hd1,8'h91,8'h90,8'h98,8'h98,8'h98,8'h98,8'h98},
	{8'h98,8'h98,8'h98,8'h98,8'h98,8'h90,8'h91,8'hd1,8'hd1,8'hd1,8'h91,8'h90,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h90,8'h90,8'hd1,8'hd1,8'hd1,8'h91,8'h90,8'h98,8'h98,8'h98,8'h98},
	{8'h98,8'h98,8'h98,8'h98,8'h90,8'h91,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'h91,8'h90,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h98,8'h90,8'h91,8'h91,8'hd1,8'hd1,8'hd1,8'hd1,8'h91,8'h91,8'h90,8'h98,8'h98},
	{8'h98,8'h98,8'h90,8'h90,8'h91,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'h91,8'h90,8'h90,8'h98,8'h98,8'h98,8'h98,8'h90,8'h91,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'h91,8'h90,8'h98},
	{8'h98,8'h90,8'h91,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'h91,8'h90,8'h98,8'h90,8'h90,8'h91,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'h91,8'h90},
	{8'h91,8'h91,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'h91,8'h91,8'h91,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1},
	{8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1},
	{8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1},
	{8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1},
	{8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1},
	{8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1},
	{8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1},
	{8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1},
	{8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1},
	{8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1},
	{8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1},
	{8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1},
	{8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1},
	{8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1},
	{8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1},
	{8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1},
	{8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1},
	{8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1},
	{8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1}};


// pipeline (ff) to get the pixel color from the array

//==----------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;
	end
	else begin
		RGBout <= TRANSPARENT_ENCODING ; // default

		if ((InsideRectangle == 1'b1 )		& 	// only if inside the external bracket
		   (MazeBiMapMask[offsetY[9:5] ][offsetX[9:5]] == 1'b1 )) // take bits 5,6,7,8,9,10 from address to select  position in the maze
						RGBout <= object_colors[offsetY[4:0]][offsetX[4:0]] ;
		end
end

//==----------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap
endmodule
