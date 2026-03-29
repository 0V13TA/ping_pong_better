package objects
import types "../globals"
import "core:math"
import rl "vendor:raylib"

create_ball :: proc(ctx: ^types.Context) -> types.Ball {
	temp := types.Ball {
		dir      = f32(rl.GetRandomValue(5, 355)),
		speed    = ctx.ball_speed,
		radius   = 0.025 * f32(rl.GetRenderHeight()),
		color    = rl.GRAY,
		position = rl.Vector2{f32(rl.GetRenderWidth()) / 2, f32(rl.GetRenderHeight()) / 2},
	}
	return temp
}

draw_ball :: proc(ball: ^types.Ball) {
	rl.DrawCircleV(ball.position, ball.radius, ball.color)
	rl.DrawCircleLinesV(ball.position, ball.radius, rl.BLACK)
}

update_ball :: proc(
	ctx: ^types.Context,
	ball: ^types.Ball,
	paddle1: ^types.Paddle,
	paddle2: ^types.Paddle,
) {
	dt := rl.GetFrameTime() // Use Delta Time for smooth movement

	// Calculate movement based on radians
	rad := ball.dir * (math.PI / 180.0)
	move_vec := rl.Vector2{math.cos_f32(rad), math.sin_f32(rad)}

	// Apply movement scaled by screen size and speed
	ball.position.x += move_vec.x * (ctx.ball_speed * f32(rl.GetRenderWidth())) * dt
	ball.position.y += move_vec.y * (ctx.ball_speed * f32(rl.GetRenderWidth())) * dt

	// Top/Bottom Collision (Bounce Y)
	if (ball.position.y - ball.radius <= 0) {
		rl.PlaySound(ctx.hit_sound) // Play hit sound
		ball.position.y = ball.radius // Reset to edge
		ball.dir = 360 - ball.dir
	} else if (ball.position.y + ball.radius >= f32(rl.GetRenderHeight())) {
		rl.PlaySound(ctx.hit_sound) // Play hit sound
		ball.position.y = f32(rl.GetRenderHeight()) - ball.radius // Reset to edge
		ball.dir = 360 - ball.dir
	}

	if (ball.position.x - ball.radius <= 0) {
		paddle2.score += ctx.score_point
		if paddle2.score >= ctx.win_limit {
			ctx.winner_name = "PLAYER 2 WINS!"
			ctx.current_screen = .GAME_OVER
		} else {
			// Reset ball to center for next point
			ball.position = {f32(rl.GetRenderWidth()) / 2, f32(rl.GetRenderHeight()) / 2}
			ball.dir = f32(rl.GetRandomValue(150, 210)) // Aim toward winner
		}
	} else if (ball.position.x >= f32(rl.GetRenderWidth())) {
		paddle1.score += ctx.score_point
		if paddle1.score >= ctx.win_limit {
			ctx.winner_name = "PLAYER 1 WINS!"
			ctx.current_screen = .GAME_OVER
		} else {
			ball.position = {f32(rl.GetRenderWidth()) / 2, f32(rl.GetRenderHeight()) / 2}
			ball.dir = f32(rl.GetRandomValue(-30, 30))
		}
	}

	// logic for Player 1 (Left)
	if rl.CheckCollisionCircleRec(
		ball.position,
		ball.radius,
		rl.Rectangle{paddle1.position.x, paddle1.position.y, paddle1.size.x, paddle1.size.y},
	) {
		rl.PlaySound(ctx.hit_sound)
		ball.position.x = paddle1.position.x + paddle1.size.x + ball.radius

		// Find hit factor (0.5 is center, 0 is top, 1 is bottom)
		hit_factor := (ball.position.y - paddle1.position.y) / paddle1.size.y
		// Map hit_factor to an angle between -45 and 45 degrees
		ball.dir = (hit_factor - 0.5) * 90.0

		ctx.rally_count += 1
		if ctx.rally_count > ctx.highest_rally {
			ctx.highest_rally = ctx.rally_count
		}
	}

	// logic for Player 2 (Right)
	if rl.CheckCollisionCircleRec(
		ball.position,
		ball.radius,
		rl.Rectangle{paddle2.position.x, paddle2.position.y, paddle2.size.x, paddle2.size.y},
	) {
		rl.PlaySound(ctx.hit_sound)
		ball.position.x = paddle2.position.x - ball.radius

		hit_factor := (ball.position.y - paddle2.position.y) / paddle2.size.y
		// Map to 135 to 225 degrees (facing left)
		ball.dir = 180.0 - ((hit_factor - 0.5) * 90.0)

		ctx.rally_count += 1
		if ctx.rally_count > ctx.highest_rally {
			ctx.highest_rally = ctx.rally_count
		}
	}
}
