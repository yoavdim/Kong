module random_bit	
 ( 
	input	logic  clk,
	output logic dout	
  ) ;

 
	
always_ff @(posedge clk) begin
		dout <= dout ? '0: '1;
	
end
 
endmodule
