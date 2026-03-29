package objects
import types "../globals"
import "core:math"
import rl "vendor:raylib"

create_paddle :: proc(isPlayer1: bool, ctx: ^types.Context) -> types.Paddle {
	temp := types.Paddle {
		dir      = 0,
		score    = 0,
		color    = rl.BLACK,
		speed    = ctx.paddle_speed * f32(rl.GetRenderHeight()),
		size     = rl.Vector2{30, f32(rl.GetRenderHeight()) * 0.3},

		//
		position = rl.Vector2 {
			f32(rl.GetRenderWidth()) * 0.05 - 30,
			f32(rl.GetRenderHeight()) * 0.5 - ((f32(rl.GetRenderHeight()) * 0.3) / 2),
		},
		controls = {.W, .S},
	}

	if (isPlayer1 == false) {
		temp.position.x = f32(rl.GetRenderWidth()) * 0.95
		temp.controls = {.UP, .DOWN}
	}

	if (ctx.game_mode == .SINGLE_PLAYER && isPlayer1 == false) {
		temp.controls = {.KEY_NULL, .KEY_NULL}
		temp.position.x = f32(rl.GetRenderWidth()) * 0.95
	}

	return temp
}

draw_paddle :: proc(paddle: ^types.Paddle) {
	rl.DrawRectangleV(paddle.position, paddle.size, paddle.color)
}

// Calculate where the ball will be when it reaches the paddle's X position
get_ai_target_y :: proc(ball: ^types.Ball, paddle_x: f32) -> f32 {
	// If the ball is moving away from the AI, stay at the center
	rad := ball.dir * (3.14159 / 180.0)
	vel_x := math.cos_f32(rad)
	if (paddle_x > ball.position.x && vel_x < 0) || (paddle_x < ball.position.x && vel_x > 0) {
		return f32(rl.GetRenderHeight()) / 2
	}

	// Distance to the paddle
	dist_x := paddle_x - ball.position.x
	vel_y := math.sin_f32(rad)

	// Time it takes to reach the paddle
	// Note: We use a simplified version since speed is scaled in your update_ball
	if vel_x == 0 do return ball.position.y
	time := dist_x / vel_x

	// Predicted Y without bounces
	predicted_y := ball.position.y + (vel_y * time)

	// Account for wall bounces (Top/Bottom)
	height := f32(rl.GetRenderHeight())
	ball_area := height - (ball.radius * 2)

	// This math "folds" the trajectory back into the screen bounds
	relative_y := math.mod(predicted_y - ball.radius, ball_area * 2)
	if relative_y < 0 do relative_y += ball_area * 2

	if relative_y > ball_area {
		return (ball_area * 2 - relative_y) + ball.radius
	}
	return relative_y + ball.radius
}

update_paddle :: proc(ctx: ^types.Context, paddle: ^types.Paddle, ball: ^types.Ball) {
	dt := rl.GetFrameTime()
	paddle.dir = 0

	is_player2 := paddle.position.x > f32(rl.GetRenderWidth()) / 2

	// AI LOGIC for Player 2 in Single Player Mode
	if ctx.game_mode == .SINGLE_PLAYER && is_player2 {
		target_y := get_ai_target_y(ball, paddle.position.x)
		paddle_center := paddle.position.y + (paddle.size.y / 2)

		// Add a "Dead Zone" based on difficulty to prevent jitter
		dead_zone: f32 = 10.0
		if ctx.level == .EASY do dead_zone = 40.0
		if ctx.level == .HARD do dead_zone = 5.0

		if math.abs(target_y - paddle_center) > dead_zone {
			if target_y < paddle_center do paddle.dir = -1
			else do paddle.dir = 1
		}
	} else {
		// MANUAL CONTROLS (Keyboard)
		if (rl.IsKeyDown(paddle.controls.up)) do paddle.dir = -1
		if (rl.IsKeyDown(paddle.controls.down)) do paddle.dir = 1

		// MOUSE/TOUCH Support
		touch_count := rl.GetTouchPointCount()
		screen_w := f32(rl.GetScreenWidth())

		for i in 0 ..< touch_count {
			touch_pos := rl.GetTouchPosition(i)

			// Is this the left or right paddle?
			is_left_paddle := paddle.position.x < screen_w / 2
			// Is the finger on the left or right side?
			touch_on_left := touch_pos.x < screen_w / 2

			// Match them up
			if is_left_paddle == touch_on_left {
				// Only move if it's not a CPU paddle in single player
				if !(ctx.game_mode == .SINGLE_PLAYER && !is_left_paddle) {
					paddle.position.y = touch_pos.y - (paddle.size.y / 2)
				}
			}
		}

	}

	// Apply movement and clamp
	paddle.position.y += f32(paddle.dir) * ctx.paddle_speed * f32(rl.GetRenderWidth()) * dt
	paddle.position.y = math.clamp(paddle.position.y, 0, f32(rl.GetRenderHeight()) - paddle.size.y)
}
