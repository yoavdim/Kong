
module	square_activate	(	// for testing only
					output 	logic signed	[10:0] topLeftX, //position on the screen 
					output 	logic	signed [10:0] topLeftY   // can be negative , if the object is partliy outside 
);

parameter X = 0;
parameter Y = 0;

assign topLeftX = X;
assign topLeftY = Y;

endmodule