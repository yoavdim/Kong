// Copyright (C) 2017  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel MegaCore Function License Agreement, or other 
// applicable license agreement, including, without limitation, 
// that your use is for the sole purpose of programming logic 
// devices manufactured by Intel and sold by Intel or its 
// authorized distributors.  Please refer to the applicable 
// agreement for further details.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 17.0.0 Build 595 04/25/2017 SJ Lite Edition"
// CREATED		"Thu Nov 25 17:13:37 2021"

module Smiley_Block(
	clk,
	resetN,
	startOfFrame,
	collision_rope,
	collision_platform,
	up,
	down,
	left,
	right,
	jump,
	pixelX,
	pixelY,
	smileyDR,
	smileyRGB
);

parameter	initial_x = 280;
parameter	initial_x_speed = 60;
parameter	initial_y = 185;
parameter	initial_y_speed = 20;

input wire	clk;
input wire	resetN;
input wire	startOfFrame;
input wire	collision_rope;
input wire	collision_platform;
input wire	up;
input wire	down;
input wire	left;
input wire	right;
input wire	jump;
input wire	[10:0] pixelX;
input wire	[10:0] pixelY;
output wire	smileyDR;
output wire	[7:0] smileyRGB;

wire	[3:0] HitEdgeCode;
wire	[10:0] initial_x;
wire	[10:0] initial_y;
wire	[10:0] smileyOffsetX;
wire	[10:0] smileyOffsety;
wire	smileyRecDR;
wire	[10:0] SmileyTLX;
wire	[10:0] SmileyTLY;





smileyBitMap	b2v_inst1(
	.clk(clk),
	.resetN(resetN),
	.InsideRectangle(smileyRecDR),
	.offsetX(smileyOffsetX),
	.offsetY(smileyOffsety),
	.drawingRequest(smileyDR),
	.HitEdgeCode(HitEdgeCode),
	.RGBout(smileyRGB));


kong_logic	b2v_inst2(
	.clk(clk),
	.resetN(resetN),
	.startOfFrame(startOfFrame),
	.collision_rope(collision_rope),
	.collision_platform(collision_platform),
	.ask_move_right(right),
	.ask_move_left(left),
	.ask_move_up(up),
	.ask_move_down(down),
	.ask_move_jump(jump),
	.default_X(initial_x),
	.default_Y(initial_y),
	.HitEdgeCode(HitEdgeCode)
	
	
	);
	defparam	b2v_inst2.ABS_X_SPEED = 100;
	defparam	b2v_inst2.CLIMB_SPEED = 100;
	defparam	b2v_inst2.JUMP_SPEED = -100;
	defparam	b2v_inst2.MAX_Y_SPEED = 230;


square_object	b2v_inst6(
	.clk(clk),
	.resetN(resetN),
	.pixelX(pixelX),
	.pixelY(pixelY),
	.topLeftX(SmileyTLX),
	.topLeftY(SmileyTLY),
	.drawingRequest(smileyRecDR),
	.offsetX(smileyOffsetX),
	.offsetY(smileyOffsety)
	);
	defparam	b2v_inst6.OBJECT_COLOR = 2'b00;
	defparam	b2v_inst6.OBJECT_HEIGHT_Y = 32;
	defparam	b2v_inst6.OBJECT_WIDTH_X = 64;


endmodule
