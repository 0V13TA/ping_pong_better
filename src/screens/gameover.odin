// ping_pong/screens/game_over.odin
package screens

import types "../globals"
import rl "vendor:raylib"

draw_game_over :: proc(ctx: ^types.Context) {
	screen_w := f32(rl.GetScreenWidth())
	screen_h := f32(rl.GetScreenHeight())

	center_x := screen_w / 2

	// === TITLE (GAME OVER) ===
	title: cstring = "GAME OVER"
	title_font := i32(screen_h * 0.07)

	title_w := rl.MeasureText(title, title_font)

	rl.DrawText(
		title,
		i32(center_x - f32(title_w) / 2),
		i32(screen_h * 0.12),
		title_font,
		rl.RAYWHITE,
	)

	// === WINNER TEXT ===
	winner_font := i32(screen_h * 0.05)
	winner_w := rl.MeasureText(ctx.winner_name, winner_font)

	rl.DrawText(
		ctx.winner_name,
		i32(center_x - f32(winner_w) / 2),
		i32(screen_h * 0.22),
		winner_font,
		rl.GOLD,
	)

	// === OPTIONAL: SCORE INFO ===
	score_font := i32(screen_h * 0.03)
	score_text := rl.TextFormat("Final Rally: %d", ctx.rally_count)

	score_w := rl.MeasureText(score_text, score_font)

	rl.DrawText(
		score_text,
		i32(center_x - f32(score_w) / 2),
		i32(screen_h * 0.30),
		score_font,
		rl.GRAY,
	)

	// === BUTTON STACK ===
	start_y := screen_h * 0.45
	gap := screen_h * 0.12

	if gui_button("REPLAY", start_y) {
		ctx.score = 0
		ctx.rally_count = 0
		gameplay_init(ctx)
		ctx.current_screen = .GAMEPLAY
	}

	if gui_button("HOME", start_y + gap) {
		ctx.current_screen = .HOME_SCREEN
	}
}
