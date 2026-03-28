package screens

import types "../globals"
import objects "../objects/"
import rl "vendor:raylib"


player1: types.Paddle
player2: types.Paddle
ball: types.Ball
gameplay_init :: proc(ctx: ^types.Context) {
	ctx.hit_sound = rl.LoadSound("assets/sounds_ping_pong_8bit/ping_pong_8bit_plop.ogg")
	player1 = objects.create_paddle(true, ctx)
	player2 = objects.create_paddle(false, ctx)
	ball = objects.create_ball(ctx)
}

gameplay_draw :: proc(ctx: ^types.Context) {
	screen_w := f32(rl.GetScreenWidth())
	screen_h := f32(rl.GetScreenHeight())

	// === GAME OBJECTS ===
	objects.draw_paddle(&player1)
	objects.draw_paddle(&player2)
	objects.draw_ball(&ball)

	// === HUD LAYOUT CONSTANTS ===
	top_margin := screen_h * 0.03
	center_x := screen_w / 2

	title_font := i32(screen_h * 0.035)
	rally_font := i32(screen_h * 0.03)
	score_font := i32(screen_h * 0.04)

	// === TITLE ===
	title_w := rl.MeasureText(ctx.title, title_font)

	rl.DrawText(
		ctx.title,
		i32(center_x - f32(title_w) / 2),
		i32(top_margin),
		title_font,
		rl.ORANGE,
	)

	// === RALLY COUNT ===
	rally_text := rl.TextFormat("Rally - %d", ctx.rally_count)
	rally_w := rl.MeasureText(rally_text, rally_font)

	rl.DrawText(
		rally_text,
		i32(center_x - f32(rally_w) / 2),
		i32(top_margin + screen_h * 0.04),
		rally_font,
		rl.ORANGE,
	)

	// === SCORES ===
	p1_text := rl.TextFormat("%d", player1.score)
	p2_text := rl.TextFormat("%d", player2.score)

	p1_w := rl.MeasureText(p1_text, score_font)
	p2_w := rl.MeasureText(p2_text, score_font)

	padding := screen_w * 0.03

	// Left (Player 1)
	rl.DrawText(p1_text, i32(padding), i32(top_margin), score_font, rl.ORANGE)

	// Right (Player 2) — FIXED alignment
	rl.DrawText(
		p2_text,
		i32(screen_w - padding - f32(p2_w)),
		i32(top_margin),
		score_font,
		rl.ORANGE,
	)
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
