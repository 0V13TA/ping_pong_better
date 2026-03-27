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
	objects.draw_paddle(&player1)
	objects.draw_paddle(&player2)
	objects.draw_ball(&ball)

	title_font_size: i32 = 30
	title_width := rl.MeasureText(rl.TextFormat(ctx.title), title_font_size)

	rattle_font_size: i32 = 30
	rattle_width := rl.MeasureText(rl.TextFormat("Rattle - %d", ctx.rally_count), rattle_font_size)

	scores_font_size: i32 = 20
	paddle1_score_width := rl.MeasureText(rl.TextFormat("%d", player1.score), scores_font_size)
	paddle2_score_width := rl.MeasureText(rl.TextFormat("%d", player2.score), scores_font_size)

	rl.DrawText(ctx.title, (rl.GetRenderWidth() - title_width) / 2, 10, title_font_size, rl.ORANGE)
	rl.DrawText(
		rl.TextFormat("Rattle - %d", ctx.rally_count),
		(rl.GetRenderWidth() - rattle_width) / 2,
		35,
		rattle_font_size,
		rl.ORANGE,
	)

	rl.DrawText(rl.TextFormat("%d", player1.score), 20, 23, scores_font_size, rl.ORANGE)
	rl.DrawText(
		rl.TextFormat("%d", player2.score),
		rl.GetRenderWidth() - 20,
		23,
		scores_font_size,
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
