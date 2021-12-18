//-- feb 2021 add all colors square
// (c) Technion IIT, Department of Electrical Engineering 2021


module	back_ground_draw	(

					input	logic	clk,
					input	logic	resetN,
					input 	logic	[10:0]	pixelX,
					input 	logic	[10:0]	pixelY,

					output	logic	[7:0]	BG_RGB,
					output	logic		boardersDrawReq
);

assign BG_RGB = 8'b0;

const int	xFrameSize	=	640;
const int	yFrameSize	=	480;
const int	bracketOffset =	0;


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			
	end
	else begin

	// defaults
		boardersDrawReq <= 	1'b0 ;

		// draw  four lines with "bracketOffset" offset from the border

		if (        pixelX == bracketOffset ||
						pixelY == bracketOffset ||
						pixelX == (xFrameSize-bracketOffset-1) ||
						pixelY == (yFrameSize-bracketOffset-1))
			begin
					boardersDrawReq <= 	1'b1 ; // pulse if drawing the boarders
			end

	// note numbers can be used inline if they appear only once



	// 3.  draw red rectangle at the bottom right,  green on the left, and blue on top left
	//-------------------------------------------------------------------------------------


	// 4. draw a matrix of 16*16 rectangles with all the colors, each rectsangle 8*8 pixels
   // ---------------------------------------------------------------------------------------


//		if ((pixelX > COLOR_MATRIX_LEFT_X)  && (pixelX < COLOR_MATRIX_LEFT_X + COLOR_MARTIX_SIZE)
//		&& ( pixelY > COLOR_MATRIX_TOP_Y) && (pixelY < COLOR_MATRIX_TOP_Y + COLOR_MARTIX_SIZE ))
//		begin
//			 redBits <= pixelX[5:3] ;
//			greenBits <= pixelY[5:3] ;
//			blueBits <= { pixelX[6] , pixelY[6]} ;
//
//
//
//
//		end



	end;
end
endmodule
