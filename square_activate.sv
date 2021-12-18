
module	square_activate	#(
X = 0,
Y = 0,
bussize = 11
)(	// for testing only
					output 	logic signed	[bussize-1:0] topLeftX, //position on the screen 
					output 	logic	signed [bussize-1:0] topLeftY   // can be negative , if the object is partliy outside 
);

assign topLeftX = X;
assign topLeftY = Y;

endmodule