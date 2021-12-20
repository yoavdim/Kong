
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018

//-- Eyal Lev 31 Jan 2021

module	objects_mux	(	 	
					input		logic	clk,
					input		logic	resetN,
					
					input		logic winDrawingRequest,
				   input 	logic [7:0] winRGB, 
					
					input		logic loseDrawingRequest,
				   input 	logic [7:0] loseRGB, 

					input		logic kongDrawingRequest, // two set of inputs per unit
					input		logic [7:0] kongRGB,   
                            
					input    logic targetDrawingRequest, 
               input		logic [7:0] targetRGB,   
									
					input    logic ropeDrawingRequest,
					input		logic [7:0] ropeRGB, 
                    
				   input		logic platformDrawingRequest,
				   input 	logic [7:0] platformRGB, 
					
					input		logic lavaDrawingRequest,
				   input 	logic [7:0] lavaRGB, 
					
					input		logic scoreDrawingRequest,
				   input	   logic [7:0] scoreRGB,	
				 
					input		logic [7:0] backGroundRGB, 
		  
				    output	    logic [7:0] RGBOut
);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			RGBOut	<= 8'b0;
	end
	else begin
		if (winDrawingRequest == 1'b1 )   
			RGBOut <= winRGB;   //first priority 
		else if (loseDrawingRequest == 1'b1 )   
			RGBOut <= loseRGB;  
		else if (kongDrawingRequest == 1'b1 )   
			RGBOut <= kongRGB;  
		else if (targetDrawingRequest)
			RGBOut <= targetRGB;
		else if (ropeDrawingRequest == 1'b1)
			RGBOut <= ropeRGB;
      else if (platformDrawingRequest == 1'b1)
           RGBOut <= platformRGB;
		else if (lavaDrawingRequest == 1'b1)
           RGBOut <= lavaRGB;
	   else if (scoreDrawingRequest == 1'b1)
           RGBOut <= scoreRGB;
		else 
			RGBOut <= backGroundRGB ; // last priority 
	end
end

endmodule


