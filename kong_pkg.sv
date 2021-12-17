
package kong_pkg;

	// -- types & FSM: --
	typedef enum logic[3:0] {	
					KONG_STAND, 
					KONG_WALK_LEFT, 
					KONG_WALK_RIGHT,
					KONG_JUMP_LEFT,  // todo, different for rise & fall
					KONG_JUMP_RIGHT,
					KONG_CLIMB_LEFT,
					KONG_CLIMB_RIGHT} kong_icon;
	
	typedef enum logic[3:0] {	
					KONG_IS_STANDING,
					KONG_IS_CLIMBING,
					KONG_IS_JUMPING,
					KONG_IS_JUMPING_IN_PLATFORM,
					KONG_IS_JUMPING_FROM_ROPE} kong_state;
					
	typedef enum {	KONG_LOOK_RIGHT, KONG_LOOK_LEFT } kong_direction;
	
	typedef logic signed [10:0] location;
	
	// rope & platform

	
	// -- project parameters: --
	
	// edge detection - the index in logic[3:0] 
	parameter E_LEFT   = 2'd3;
	parameter E_TOP    = 2'd2;
	parameter E_RIGHT  = 2'd1;
	parameter E_BOTTOM = 2'd0;
	
	// GUI SIZES
	parameter location SCREEN_WIDTH = 10'd640;
	parameter location SCREEN_HIGHT = 10'd480;
	
	parameter location KONG_WIDTH = 10'd64; // update when final
	parameter location KONG_HIGHT = 10'd32;
	parameter location ROPE_WIDTH = 10'd8 ;
	
	
	
endpackage