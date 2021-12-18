// bitmap file
// (c) Technion IIT, Department of Electrical Engineering 2021
// generated bythe automatic Python tool

import kong_pkg::*;

 module kong_sqrBitMap (

					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //use sqr obj of 64x64

                    input kong_icon icon,

					output	logic	drawingRequest, //output that the pixel should be dispalyed
					output	logic	[7:0] RGBout,  //rgb value from the bitmap
					output	logic	[3:0] HitEdgeCode, //one bit per edge
                    output logic [10:0] width

 ) ;


// generating the bitmap

localparam location BORDERS = KONG_WIDTH;
localparam location REAL_HIGHT = 48;
localparam logic [7:0] TRANSPARENT_ENCODING = 8'h00 ;// RGB value in the bitmap representing a transparent pixel
logic[0:47][0:63][7:0] object_colors = {
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h40,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h40,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h40,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h88,8'hfa,8'hfa,8'hfa,8'hfa,8'h89,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h80,8'h88,8'hc8,8'hc8,8'hc8,8'hc8,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hd1,8'hd1,8'hd1,8'hfa,8'hfa,8'hfa,8'hfa,8'hd1,8'h91,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h48,8'h48,8'h48,8'h48,8'h48,8'h48,8'h80,8'hc8,8'hd0,8'hd0,8'hd0,8'hc8,8'h80,8'h80,8'h80,8'h80,8'h80,8'h88,8'h89,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hd1,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hd0,8'hf0,8'hf0,8'hf0,8'hf0,8'hd0,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hd1,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfb,8'hff,8'hff,8'hfa,8'hd1,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h88,8'hc8,8'hc8,8'hc8,8'hc8,8'hc8,8'hc8,8'hc8,8'hc8,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hd1,8'hd1,8'hd1,8'h80,8'h88,8'hd1,8'hfa,8'hfa,8'hfa,8'hfa,8'hfb,8'hdb,8'hd2,8'hd2,8'hd1,8'h80,8'h80,8'h40,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h48,8'hc8,8'hd0,8'hd0,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h89,8'hd2,8'hfa,8'hfa,8'hc9,8'h88,8'h80,8'hd1,8'hd2,8'hfa,8'hfa,8'hfb,8'hdb,8'h88,8'hd2,8'hd2,8'h89,8'h89,8'h89,8'h89,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h48,8'hf0,8'h88,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h89,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hd1,8'h80,8'h80,8'hd1,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'h40,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hc8,8'hc8,8'h88,8'h80,8'h80,8'h80,8'h80,8'hc8,8'hd0,8'hd0,8'hc8,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h89,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hd1,8'h80,8'h80,8'h88,8'hc9,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hd1,8'h91,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h48,8'hc8,8'hc8,8'h80,8'h80,8'h80,8'h80,8'h80,8'hc8,8'hf0,8'hd0,8'hc8,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h88,8'hd1,8'hd1,8'hd2,8'hfa,8'hd1,8'hd1,8'h80,8'h80,8'h80,8'h80,8'hd1,8'hd2,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hd1,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h48,8'hf0,8'h88,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hc8,8'hf0,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hd1,8'hfa,8'h88,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hd1,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hd1,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h48,8'hf0,8'h88,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hc8,8'hf0,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hd1,8'hfa,8'hd1,8'hd1,8'h80,8'h80,8'h80,8'h80,8'hd1,8'hf2,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hd2,8'hd1},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h48,8'h88,8'hc8,8'h88,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hc8,8'hf0,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hc9,8'hd1,8'hfa,8'hd1,8'hc9,8'h80,8'h89,8'hd1,8'hfa,8'hfa,8'hfa,8'hfa,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hfa},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hc8,8'hd0,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hc8,8'hf0,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hf2,8'hfa,8'hfa,8'h80,8'hd1,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'h89,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hd1,8'hfa},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hc8,8'hd0,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hc8,8'hf0,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h89,8'hd1,8'hfa,8'hd1,8'hf2,8'hfa,8'hfa,8'hfa,8'hd2,8'h89,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'hd1,8'h89},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hc8,8'hd0,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hc8,8'hf0,8'hc8,8'h88,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hd1,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hd1,8'hd1,8'hd1,8'hd2,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hd1,8'h89,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hc8,8'hd0,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hc8,8'hf0,8'hf0,8'hc8,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hd1,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hd1,8'h89,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'h40,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h40,8'hd0,8'hd0,8'hd0,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hf0,8'hc8,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hd1,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hf2,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hd1,8'h40,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h40,8'hf0,8'hd0,8'hc8,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hf0,8'hc8,8'hc8,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hc9,8'hd1,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hd1,8'hd1,8'hd1,8'hd1,8'h89,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h40,8'hf0,8'hc8,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hf0,8'hf0,8'hd0,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'h89,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hc8,8'hf0,8'hf0,8'hc8,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hc8,8'hf0,8'hf0,8'hc8,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h40,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h88,8'hc8,8'hc8,8'hc8,8'h88,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hc8,8'hc8,8'hf0,8'hc8,8'hc8,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h40,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hf0,8'hc8,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hf0,8'hf0,8'hd0,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h88,8'hf0,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hc8,8'hf0,8'hf0,8'h88,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h80,8'h88,8'hc8,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hd1,8'hf1,8'hf1,8'h88,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h40,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hd1,8'hfa,8'hfa,8'h89,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h40,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h40,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hd1,8'hfa,8'hfa,8'h89,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h40,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h40,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hd1,8'hfa,8'hfa,8'hd1,8'hd1,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h40,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h88,8'h88,8'h88,8'hd1,8'hf2,8'hfa,8'hf2,8'hd1,8'h89,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h40,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hc8,8'hf0,8'hf0,8'hf0,8'hf1,8'hfa,8'hf1,8'hf1,8'hfa,8'h89,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h40,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hc8,8'hc8,8'hc8,8'hd0,8'hf0,8'hf0,8'hf0,8'hf0,8'hf1,8'hf1,8'hf1,8'hfa,8'h89,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h40,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h40,8'h48,8'h48,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h88,8'h88,8'hc8,8'hf0,8'hf0,8'hf0,8'hf0,8'hf0,8'hf1,8'hf1,8'hf1,8'hf2,8'hfa,8'hd1,8'h88,8'h40,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h40,8'h40,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hd0,8'hf0,8'hf0,8'h88,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hc8,8'hf0,8'hf0,8'hf0,8'hf0,8'hf0,8'hf0,8'hf0,8'hf0,8'hf1,8'hfa,8'hfa,8'hfa,8'hd1,8'h80,8'h80,8'h80,8'h00,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'hd1,8'hd1,8'h80,8'h80,8'h88,8'hd0,8'hd0,8'hd0,8'h88,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h88,8'hd0,8'hd0,8'hd0,8'hf0,8'hf0,8'hf0,8'hf0,8'hf0,8'hf0,8'hf0,8'hf2,8'hd1,8'h88,8'h88,8'h88,8'h88,8'h80,8'h80,8'h80,8'h80,8'h40,8'h40,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h88,8'hd2,8'hd1,8'hd2,8'hd1,8'h00,8'h00,8'h00},
	{8'h88,8'hd1,8'hf2,8'h80,8'h80,8'h88,8'hd0,8'hd0,8'hc8,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h88,8'hc8,8'hf0,8'hf0,8'hf0,8'hf0,8'hf0,8'hf0,8'hf0,8'hf0,8'hd0,8'hd0,8'hd1,8'hc9,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h00,8'h40,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h88,8'hd1,8'hfa,8'hfa,8'hfa,8'hfa,8'h40,8'h00,8'h00},
	{8'hf0,8'hf1,8'hf2,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hd0,8'hf0,8'hf0,8'hf0,8'hf0,8'hf0,8'hf0,8'hf0,8'hf0,8'hf0,8'hc8,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h00,8'h00,8'h00,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hd1,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'h40,8'h00,8'h00},
	{8'hf0,8'hf1,8'hfa,8'hd1,8'hc9,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hd0,8'hf0,8'hf0,8'hf0,8'hf0,8'hf0,8'hf0,8'hc8,8'h88,8'h88,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h40,8'h00,8'h40,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h88,8'hc9,8'hfa,8'hfa,8'hd1,8'h89,8'h00,8'h00,8'h00},
	{8'hf0,8'hf1,8'hfa,8'hfa,8'hd1,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h88,8'hc8,8'hc8,8'hc8,8'hc8,8'hc8,8'hc8,8'h88,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h00,8'h00,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hc9,8'hd1,8'hfa,8'hfa,8'hd1,8'h00,8'h00,8'h00,8'h00},
	{8'hf0,8'hf1,8'hfa,8'hfa,8'hd1,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h00,8'h00,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'hd1,8'hfa,8'hfa,8'hfa,8'hd1,8'h00,8'h00,8'h00,8'h00},
	{8'hf0,8'hf1,8'hfa,8'h89,8'h88,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h40,8'h40,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h40,8'h00,8'h00,8'h00,8'h00,8'h40,8'h80,8'hd1,8'hd1,8'hd1,8'hfa,8'hfa,8'hfa,8'hfa,8'hd2,8'hd1,8'h00,8'h00,8'h00},
	{8'hc8,8'hd1,8'hf2,8'h80,8'hc9,8'hc9,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h80,8'h40,8'h80,8'h80,8'h80,8'h80,8'h40,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h40,8'h80,8'h80,8'hd1,8'hd1,8'hc9,8'h80,8'h80,8'h88,8'hd1,8'h88,8'h80,8'h80,8'h89,8'h89,8'h88,8'h91,8'h48,8'h00,8'h80,8'hd1,8'hfa,8'hfa,8'hfa,8'hfa,8'hf1,8'hfa,8'hfa,8'hfa,8'h91,8'h89,8'h00},
	{8'h00,8'hd1,8'hf2,8'h80,8'hd1,8'hd1,8'h80,8'h80,8'h80,8'h80,8'h40,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h80,8'h80,8'h88,8'hfa,8'hfa,8'hd1,8'h80,8'h80,8'h89,8'hfa,8'h88,8'h80,8'h80,8'hf2,8'hf1,8'hf0,8'hfa,8'h89,8'h00,8'h00,8'hd1,8'hfa,8'hfa,8'hfa,8'hf1,8'hf0,8'hf1,8'hfa,8'hfa,8'hfa,8'hd1,8'h00},
	{8'h00,8'hd1,8'hfa,8'hfa,8'hfa,8'hd1,8'h80,8'hd1,8'hfa,8'hfa,8'hfa,8'hd1,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h80,8'hd1,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'h80,8'hd1,8'hfa,8'hf0,8'hf1,8'hfa,8'h00,8'h00,8'h48,8'hfa,8'hfa,8'hfa,8'hfa,8'hf1,8'hf1,8'hfa,8'hfa,8'hd1,8'h00},
	{8'h00,8'h89,8'hd1,8'hfa,8'hfa,8'hd2,8'hd1,8'hd1,8'hf1,8'hfa,8'hf1,8'hd1,8'h91,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hd1,8'hd1,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hd1,8'hd1,8'hfa,8'hf0,8'hf1,8'hd2,8'h00,8'h00,8'h48,8'hd1,8'hd1,8'hd1,8'hfa,8'hf1,8'hf1,8'hfa,8'hd1,8'h89,8'h00},
	{8'h00,8'h00,8'h40,8'hfa,8'hfa,8'hfa,8'hfa,8'hf1,8'hf1,8'hfa,8'hf1,8'hf1,8'hfa,8'h40,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hf0,8'hf1,8'hd2,8'h00,8'h00,8'h00,8'h00,8'h00,8'h89,8'hfa,8'hfa,8'hfa,8'hfa,8'h40,8'h00,8'h00}};



//////////--------------------------------------------------------------------------------------------------------------=
//hit bit map has one bit per edge:  hit_colors[3:0] =   {Left, Top, Right, Bottom}
//there is one bit per edge, in the corner two bits are set
 logic [0:3] [0:3] [3:0] hit_colors =
		   {16'hC446,
			16'h8C62,
			16'h8932,
			16'h9113};

logic rotate, flip;
logic [10:0] hight;

location rotated_x, rotated_y;
location fliped_rotated_x, fliped_rotated_y;

always_comb begin
    case(icon)
        KONG_WALK_LEFT, KONG_JUMP_LEFT: begin
            rotate = '0;
            flip = '1;
        end
        KONG_WALK_RIGHT, KONG_JUMP_RIGHT: begin
            rotate = '0;
            flip = '0;
        end
        KONG_CLIMB_LEFT: begin
            rotate = '1;
            flip = '1;
        end
        KONG_CLIMB_RIGHT: begin
            rotate = '1;
            flip = '0;
        end
        default: begin
            rotate = '0;
            flip = '1;
        end
    endcase
end


assign width = rotate ? KONG_WIDTH : KONG_HIGHT;
assign hight = rotate ? KONG_HIGHT : KONG_WIDTH;

always_comb begin
    rotated_x = offsetX;
    rotated_y = offsetY;
    if (rotate) begin
        if(flip) begin // assume head to the Left
            rotated_x = offsetY;
            rotated_y = BORDERS - offsetX;
        end else begin
            rotated_x = BORDERS - offsetY;
            rotated_y = offsetX;
        end
    end
end

assign fliped_rotated_x = flip ? (KONG_WIDTH -1 - rotated_x) : rotated_x;
assign fliped_rotated_y = rotated_y - (BORDERS -1 -REAL_HIGHT);
 // pipeline (ff) to get the pixel color from the array
//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;
		HitEdgeCode <= 4'h0;
	end
	else begin
		RGBout <= TRANSPARENT_ENCODING ; // default
		HitEdgeCode <= 4'h0;

		if (InsideRectangle == 1'b1 && (offsetX < width) && (offsetY < hight))
		begin // inside an external bracket
			HitEdgeCode <= hit_colors[offsetY >> 4][offsetX >> 4 ]; // get hitting edge from the colors table
            RGBout <= object_colors[fliped_rotated_y][fliped_rotated_x];
		end

	end
end

//////////--------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap

endmodule
