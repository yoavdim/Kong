// HartsMatrixBitMap File
// A two level bitmap. dosplaying harts on the screen FWbruary  2021
// (c) Technion IIT, Department of Electrical Engineering 2021


import digit_pkg::*;

module	TargetMatrixBitMap	(
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket

					input logic collision, // will remove the target
					input logic level,

					output	logic	drawingRequest, //output that the pixel should be dispalyed
					output	logic	[7:0] RGBout,  //rgb value from the bitmap
					output logic    [3:0] Value,
					output logic Scored
 ) ;


// Size represented as Number of X and Y bits
localparam logic [7:0] TRANSPARENT_ENCODING = 8'h00 ;// RGB value in the bitmap representing a transparent pixel
 parameter  logic	[7:0] digit_color = 8'hF6 ;
 /*  end generated by the tool */

logic [4:0] inner_offset_x;
logic [4:0] inner_offset_y;
logic inside_digit;
logic [4:0] digit_offset_x;
logic [4:0] digit_offset_y;
logic [3:0] rtValue;




// the screen is 640*480  or  20 * 15 squares of 32*32  bits ,  we wiil round up to 32*16 and use only the top left 20*15 pixels
// this is the bitmap  of the maze , if there is a one  the na whole 32*32 rectange will be drawn on the screen
// all numbers here are hard coded to simplify the  understanding

// 0 = no target
//logic [0:14] [0:19] [3:0]  OriginalMazeBiMapMask = {{4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0},
logic [0:1][0:14] [0:19][3:0]  OriginalMazeBiMapMask={
{
{4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0}, // lvl 1
{4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0},
{4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd9,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0},
{4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0},
{4'd0,4'd0,4'd7,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd7,4'd0,4'd0},
{4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd4,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0},
{4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0},
{4'd0,4'd0,4'd0,4'd0,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd0,4'd0,4'd0,4'd0},
{4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0},
{4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0},
{4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0},
{4'd0,4'd0,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0},
{4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0},
{4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0},
{4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0}
},{
{4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0}, // lvl 2
{4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0},
{4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd9,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0},
{4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd7,4'd0,4'd0,4'd0},
{4'd0,4'd0,4'd4,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0},
{4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0},
{4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd7,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0},
{4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0},
{4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0},
{4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0},
{4'd0,4'd0,4'd4,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0},
{4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0},
{4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0},
{4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0},
{4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0}
}};

logic [0:1][0:14] [0:19] [3:0]  MazeBiMapMask;

// background for the digit
 logic [0:31] [0:31] [7:0]  object_colors  = {
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h00,8'h00},
	{8'h00,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h00},
	{8'h00,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h00},
	{8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07},
	{8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07},
	{8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07},
	{8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07},
	{8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07},
	{8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07},
	{8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07},
	{8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07},
	{8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07},
	{8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07},
	{8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07},
	{8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07},
	{8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07},
	{8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07},
	{8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07},
	{8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07},
	{8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07},
	{8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07},
	{8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07},
	{8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07},
	{8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07},
	{8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07},
	{8'h00,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h00},
	{8'h00,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h00},
	{8'h00,8'h00,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h00,8'h00,8'h00,8'h00,8'h00}};


// pipeline (ff) to get the pixel color from the array
assign inner_offset_x = offsetX[4:0];
assign inner_offset_y = offsetY[4:0];
assign digit_offset_x = inner_offset_x - 5'd8;
assign digit_offset_y = inner_offset_y;
assign inside_digit = (inner_offset_x < 5'd24) && (inner_offset_x >= 5'd8) && InsideRectangle;
assign rtValue = MazeBiMapMask[level][offsetY[9:5] ][offsetX[9:5]];

//==----------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	TRANSPARENT_ENCODING;
		Value <= 4'd0;
	end
	else begin
		RGBout <= TRANSPARENT_ENCODING ; // default
		Value <= rtValue;
		if ((InsideRectangle == 1'b1 ) && (rtValue != 4'd0)) begin // take bits 5,6,7,8,9,10 from address to select  position in the maze
				RGBout <= object_colors[offsetY[4:0]][inner_offset_x] ;
				if (inside_digit) begin
					if (number_bitmap[rtValue][digit_offset_y][digit_offset_x] != 4'd0)
						RGBout <= digit_color;
				end
		end
	end
end


//==----------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap



// remove target:
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		MazeBiMapMask <= OriginalMazeBiMapMask;
		Scored <= '0;
	end
	else begin
		Scored <= '0;
		if(collision) begin // TODO : not on start_of_frame
			MazeBiMapMask[level][offsetY[9:5] ][offsetX[9:5]] <= 4'b0;
			Scored <= 1'b1;
		end
	end
end

endmodule
