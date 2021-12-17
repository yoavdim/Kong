//import kong_pkg::*;
//
//module rope_mux(
//	parameter N = 10,
//	
//	output logic drawingRequest,
//	output logic[7:0] RGBOut,
//	
//	input logic clk,
//	input logic resetN,
//	input logic startOfFrame,
//	
//	input location pixelX,
//	input location pixelY
//	);
//	
//	logic[N-1:0] requests;
//	logic[7:0][N-1:0] RGBs;
//	
//	rope_config[N-1:0] cfgs; // assign constant, later, recive from the level selector
//	
//	
//	//
//	// map the ropes to the vectors
//	genvar i;
//	generate
//		for (i=0; i<N; i=i+1) begin
//			rope r (requests[i], RGBs[i], 
//						clk, resetN, startOfFrame,
//						pixelX, pixelY, cfgs[i]);
//		end
//		
//		// find right rgb
//		always_comb begin
//			RGBOut = '0; // TODO transperent
//			for (i=0; i<N; i=i+1) begin
//				if( requests[i]) begin
//			end
//		end
//	endgenerate
//endmodule
//
//
//module rope(
//	output logic drawingRequest,
//	output logic[7:0] RGBOut,
//	
//	input logic clk,
//	input logic resetN,
//	input logic startOfFrame,
//	
//	input location pixelX,
//	input location pixelY,
//	
//	input rope_config cfg
//	);
//	// TODO
//endmodule
//	
	