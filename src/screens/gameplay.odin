package screens

import types "../globals"
import objects "../objects/"
import rl "vendor:raylib"


player1: types.Paddle
player2: types.Paddle
ball: types.Ball
gameplay_init :: proc(ctx: ^types.Context) {
	ctx.hit_sound = rl.LoadSound("sounds_ping_pong_8bit/ping_pong_8bit_plop.ogg")
	player1 = objects.create_paddle(true, ctx)
	player2 = objects.create_paddle(false, ctx)
	ball = objects.create_ball(ctx)
}


// src/screens/gameplay.odin

gameplay_draw :: proc(ctx: ^types.Context) {
	// rl.ClearBackground(rl.RAYWHITE) // Minimalist light background

	// 1. Background Elements (Score)
	// We draw these first so paddles/ball appear on top
	draw_scoreboard(player1.score, player2.score)

	// 2. The Court (Optional minimalist center line)
	rl.DrawLineEx(
		{f32(rl.GetScreenWidth()) / 2, 0},
		{f32(rl.GetScreenWidth()) / 2, f32(rl.GetScreenHeight())},
		1.0,
		rl.Fade(rl.GRAY, 0.2),
	)


	// 3. Current Rally Count (Top Center)
	screen_w := f32(rl.GetScreenWidth())
	screen_h := f32(rl.GetScreenHeight())

	rally_text := rl.TextFormat("RALLY: %d", ctx.rally_count)
	// Use a size relative to screen height for responsiveness
	rally_font_size := i32(screen_h * 0.05)
	rally_w := rl.MeasureText(rally_text, rally_font_size)

	// Position it slightly below the top edge
	rl.DrawText(
		rally_text,
		i32((screen_w - f32(rally_w)) / 2),
		i32(screen_h * 0.12), // Adjusted to not overlap your new Pause button
		rally_font_size,
		rl.DARKGRAY,
	)


	// 3. === GAME OBJECTS ===
	objects.draw_paddle(&player1)
	objects.draw_paddle(&player2)
	objects.draw_ball(&ball)

	// 4. The UI Layer (Pause Button)
	draw_pause_button(ctx)
}

gameplay_update :: proc(ctx: ^types.Context) {
	// Dynamic Speed Scaling
	if ctx.rally_count >= 90 {
		ctx.ball_speed = 0.90
		ctx.paddle_speed = 0.90
	} else if ctx.rally_count >= 50 {
		ctx.ball_speed = 0.75
		ctx.paddle_speed = 0.75
	} else if ctx.rally_count >= 20 {
		ctx.ball_speed = 0.65
		ctx.paddle_speed = 0.65
	} else {
		// Default speeds defined in your main.odin
		ctx.ball_speed = 0.50
		ctx.paddle_speed = 0.50
	}

	objects.update_paddle(ctx, &player1, &ball)
	objects.update_paddle(ctx, &player2, &ball)
	objects.update_ball(ctx, &ball, &player1, &player2)
}
