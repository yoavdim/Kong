
// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2021 
//updated --Eyal Lev 2021


module	game_controller_all	(	
			input	logic	clk,
			input	logic	resetN,
			input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
			input	logic	drawing_request_kong,
			input	logic	drawing_request_1, 
			input logic drawing_request_2,
			input logic drawing_request_3, 
			input logic drawing_request_4,
			
			output logic collision_1,
			output logic collision_2,
			output logic collision_3,
			output logic collision_4,

			output logic SingleHitPulse1, // critical code, generating A single pulse in a frame 
			output logic SingleHitPulse2,
			output logic SingleHitPulse3,
			output logic SingleHitPulse4
);


assign collision_1 = drawing_request_kong &&  drawing_request_1;
assign collision_2 = drawing_request_kong &&  drawing_request_2;
assign collision_3 = drawing_request_kong &&  drawing_request_3;
assign collision_4 = drawing_request_kong &&  drawing_request_4;


logic flag1, flag2, flag3, flag4; // a semaphore to set the output only once per frame / regardless of the number of collisions 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		{flag1, flag2, flag3, flag4} <= 3'b0;
		{SingleHitPulse1, SingleHitPulse2, SingleHitPulse3, SingleHitPulse4} <= 4'b0 ; 
	end 
	else begin 

		{SingleHitPulse1, SingleHitPulse2, SingleHitPulse3, SingleHitPulse4} <= 4'b0 ; // default 
		if(startOfFrame) 
				{flag1, flag2, flag3, flag4} <= 4'b0; ; // reset for next time 


		if ( collision_1  && (flag1 == 1'b0)) begin  // can miss collisions in pixel (0,0)
			flag1	<= 1'b1; // to enter only once 
			SingleHitPulse1 <= 1'b1; 
		end 
		if ( collision_2  && (flag2 == 1'b0)) begin 
			flag2	<= 1'b1; 
			SingleHitPulse2 <= 1'b1; 
		end
		if ( collision_3  && (flag3 == 1'b0)) begin 
			flag3	<= 1'b1;
			SingleHitPulse3 <= 1'b1; 
		end
		if ( collision_4  && (flag4 == 1'b0)) begin 
			flag4	<= 1'b1;
			SingleHitPulse4 <= 1'b1; 
		end
	end 
end

endmodule
