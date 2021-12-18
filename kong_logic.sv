
import kong_pkg::*;

module kong_logic(  // todo: borders, rope side switching, double jump & cheats (falling & free movement)
	input logic clk,
	input logic resetN,
	input logic startOfFrame,

	input logic collision_rope,
	input logic collision_platform,
	input logic collision_border,
	input logic [3:0] HitEdgeCode,   // Left-Top-Right-Bottom

	// keypad:
	input logic ask_move_right,
	input logic ask_move_left,
	input logic ask_move_up,
	input logic ask_move_down,
	input logic ask_move_jump,

	input location width,

	// outputs will be updated on startOfFrame
	output kong_icon icon,
	output location topLeftX, // output the top left corner
	output location topLeftY  // can be negative , if the object is partliy outside
	);


	// int is the fixed_point datatype
	parameter location default_X = 60;
	parameter location default_Y = 10;
	parameter int MAX_Y_SPEED = 230; // in freefall
	parameter int ABS_X_SPEED = 80; // walking or jumping
	parameter int CLIMB_SPEED = 80;
	parameter int JUMP_SPEED  = -240; // initial y speed
	const int  Y_ACCEL = 2;
	const int	FIXED_POINT_MULTIPLIER	=	64; // power of 2

	// state, updated on startOfFrame
	kong_state curr_state, next_state;
	kong_direction curr_direction, next_direction;
	logic moved;

	int speed_x, next_speed_x;
	int speed_y, next_speed_y;
	int x, next_x;
	int y, next_y;

	// in-frame state:
	logic collided_rope;
	logic collided_platform;
	logic collided_border;
	logic asked_left, asked_up, asked_right, asked_down, asked_jump;
	logic move_left, move_up, move_right, move_down, move_jump;
	logic [3:0] hit_rope; // note: all bits can be active, from different pixels
	logic [3:0] hit_platform;
	logic [3:0] hit_border;

	assign move_down  = asked_down  & !asked_up       & !asked_jump;
	assign move_up    = asked_up    & !asked_down     & !asked_jump;
	assign move_left  = asked_left  & !ask_move_right & !asked_jump;
	assign move_right = asked_right & !asked_left     & !asked_jump;
	assign move_jump  = (collided_rope || collided_platform) & asked_jump; // remove '&' when implementing double jump

	assign 	topLeftX = x / FIXED_POINT_MULTIPLIER;
	assign 	topLeftY = y / FIXED_POINT_MULTIPLIER;

	// in-frame logic (valid at the startOfFrame clock):
	always_ff @(posedge clk or negedge resetN) begin
		if (!resetN) begin
			collided_rope <= '0;
			collided_platform <= '0;
			collided_border <= '0;
			{asked_up, asked_down, asked_right, asked_left, asked_jump} <= '0;
			hit_rope <= 4'b0;
			hit_platform <= 4'b0;
			hit_border <= 4'b0;
		end else if (startOfFrame) begin
			collided_rope <= '0;
			collided_platform <= '0;
			collided_border <= '0;
			{asked_up, asked_down, asked_right, asked_left, asked_jump} <= '0;
			hit_rope <= 4'b0;
			hit_platform <= 4'b0;
			hit_border <= 4'b0;
		end else begin
			collided_rope <= collided_rope | collision_rope;
			collided_platform <= collided_platform | collision_platform;
			collided_border <= collided_border | collision_border;
			asked_up <= asked_up | ask_move_up;
			asked_down <= asked_down | ask_move_down;
			asked_right <= asked_right | ask_move_right;
			asked_left <= asked_left | ask_move_left;
			asked_jump <= asked_jump | ask_move_jump;
			if (collision_rope)
				hit_rope <= hit_rope | HitEdgeCode; // bitwise
			else
				hit_rope <= hit_rope;
			if (collision_platform)
				hit_platform <= hit_platform | HitEdgeCode;
			else
				hit_platform <= hit_platform;
			if (collision_border)
				hit_border <= hit_border | HitEdgeCode; // bitwise
			else
				hit_border <= hit_border;
		end
	end

	// each-frame logic:
	always_ff @(posedge clk or negedge resetN) begin
		if (!resetN) begin // game reset
			moved <= '0;
			speed_x <= '0;
			speed_y <= '0;
			x <= default_X * FIXED_POINT_MULTIPLIER;
			y <= default_Y * FIXED_POINT_MULTIPLIER;
			curr_state <= KONG_IS_JUMPING;
			curr_direction <= KONG_LOOK_RIGHT; // todo: change to middle?

		end else if (startOfFrame) begin // todo: will it happen on the same clock of the reset?
			moved <= move_down || move_up || move_right || move_left || move_jump;
			curr_direction <= next_direction;
			curr_state <= next_state;
			x <= next_x;
			y <= next_y;
			speed_x <= next_speed_x;
			speed_y <= next_speed_y;
		end else begin
			curr_direction <= curr_direction;
			curr_state <= curr_state;
			x <= x;
			y <= y;
			speed_x <= speed_x;
			speed_y <= speed_y;
		end
	end

	always_comb begin
		next_state = curr_state;
		next_speed_x = speed_x;
		next_speed_y = speed_y;
		next_x = x + speed_x;
		next_y = y + speed_y;
		next_direction = curr_direction;

		case(curr_state)
			KONG_IS_STANDING: begin
				next_speed_x = 0;
				next_speed_y = 0;
				if (collided_platform) begin // still standing
					if (move_jump) begin
						next_state = KONG_IS_JUMPING_IN_PLATFORM; // untill all pixels will leave the platform
						next_speed_y = JUMP_SPEED;
						next_speed_x = direction_sign(curr_direction) * ABS_X_SPEED;
					end else if (move_right | move_left) begin
						next_direction = move_right ? KONG_LOOK_RIGHT : KONG_LOOK_LEFT;
						next_speed_x = direction_sign(next_direction) * ABS_X_SPEED;
					end
				end else begin // no floor, falling
					next_state = KONG_IS_JUMPING_IN_PLATFORM; // will ensure 1 cycle of falling?
				end
			end

			KONG_IS_CLIMBING: begin
				next_speed_x = 0;
				next_speed_y = 0;
				if (collided_rope) begin
					if (move_jump) begin
						next_state = KONG_IS_JUMPING_FROM_ROPE;
						// todo: jump backwards
						// next_direction = curr_direction == KONG_LOOK_LEFT ? KONG_LOOK_LEFT : KONG_LOOK_RIGHT;
						next_speed_y = JUMP_SPEED;
						next_speed_x = direction_sign(next_direction) * ABS_X_SPEED;
					end else if (move_down | move_up) begin
						next_speed_y = move_down ? CLIMB_SPEED : - CLIMB_SPEED;
					end else if (move_left | move_right) begin
						if (curr_direction == KONG_LOOK_LEFT) begin
							if (move_left) begin
								next_x = x + direction_sign(curr_direction) * KONG_HIGHT;
								next_direction = KONG_LOOK_RIGHT;
							end
							else if (move_right && ! moved) begin
								next_direction = KONG_LOOK_RIGHT;
								next_state = KONG_IS_JUMPING_FROM_ROPE;
								next_speed_y = JUMP_SPEED;
								next_speed_x = direction_sign(next_direction) * ABS_X_SPEED;
							end
						end else begin // look right = figure left to the rope
							if (move_right) begin
								next_x = x + direction_sign(curr_direction) * KONG_HIGHT;
								next_direction = KONG_LOOK_LEFT;
							end
							else if (move_left && ! moved) begin
								next_direction = KONG_LOOK_RIGHT;
								next_state = KONG_IS_JUMPING_FROM_ROPE;
								next_speed_y = JUMP_SPEED;
								next_speed_x = direction_sign(next_direction) * ABS_X_SPEED;
							end
						end
					end
				end else begin // no rope any more
					next_state = KONG_IS_JUMPING_FROM_ROPE;
				end
			end

			KONG_IS_JUMPING: begin
				next_speed_y = speed_y + Y_ACCEL;
				if (collided_platform & hit_platform[E_BOTTOM]) begin // now standing
					next_state = KONG_IS_STANDING;
					next_speed_x = 0;
					next_speed_y = 0; // will not support moving platforms
					next_x = x;
					next_y = y; // todo: this discards last cycle speed, is it wanted?
				end else if (collided_rope) begin
					next_state = KONG_IS_CLIMBING; // now on rope
					next_speed_x = 0; // will not support moving ropes
					next_speed_y = 0;
					next_x = x;
					next_y = y;
					if (hit_rope[E_LEFT])
						next_direction = KONG_LOOK_LEFT;
					else if (hit_rope[E_RIGHT])
						next_direction = KONG_LOOK_RIGHT;
					// else keep your direction
				end else if (collided_platform) begin // from down below
					next_state = KONG_IS_JUMPING_IN_PLATFORM;
				end
			end

			KONG_IS_JUMPING_IN_PLATFORM: begin
				next_speed_y = speed_y + Y_ACCEL;
				if (collided_rope) begin
					next_state = KONG_IS_CLIMBING; // now on rope
					next_speed_x = 0; // will not support moving ropes
					next_speed_y = 0;
					next_x = x;
					next_y = y;
					next_direction = hit_rope[E_LEFT] ? KONG_LOOK_LEFT : KONG_LOOK_RIGHT;
				end else if (! collided_platform) begin // back in air
					next_state = KONG_IS_JUMPING;
				end
			end

			KONG_IS_JUMPING_FROM_ROPE: begin
				next_speed_y = speed_y + Y_ACCEL;
				if (collided_platform & hit_platform[E_BOTTOM]) begin // now standing. todo: check exclusive bottom?
					next_state = KONG_IS_STANDING;
					next_speed_x = 0;
					next_speed_y = 0; // will not support moving platforms
					next_x = x;
					next_y = y;
				end else if (!collided_rope) begin // back in air
					next_state = KONG_IS_JUMPING;
				end
			end
		endcase
		// boundry collision code here
		if (collided_border) begin
			if ((next_x > x) && (x > (SCREEN_WIDTH/2)*FIXED_POINT_MULTIPLIER)) begin
				next_speed_x = 0;
				next_x = x - ABS_X_SPEED;
			end else if ((next_x < x) && (x < (SCREEN_WIDTH/2)*FIXED_POINT_MULTIPLIER)) begin
				next_speed_x = 0;
				next_x = x + ABS_X_SPEED;
			end
		end
	end

	// select icon
	always_comb begin
		case(curr_state)
			KONG_IS_STANDING:
				icon = (curr_direction == KONG_LOOK_RIGHT) ? KONG_WALK_RIGHT : KONG_WALK_LEFT;
			KONG_IS_CLIMBING:
				icon = (curr_direction == KONG_LOOK_RIGHT) ? KONG_CLIMB_RIGHT : KONG_CLIMB_LEFT;
			KONG_IS_JUMPING, KONG_IS_JUMPING_IN_PLATFORM, KONG_IS_JUMPING_FROM_ROPE:
				icon = (curr_direction == KONG_LOOK_RIGHT) ? KONG_JUMP_RIGHT : KONG_JUMP_LEFT;
		endcase
	end

	function int direction_sign(kong_direction d);
		return (d == KONG_LOOK_RIGHT)? 1 : -1;
	endfunction

endmodule
