// screens/home.odin
package screens

import types "../globals"
import rl "vendor:raylib"

draw_home :: proc(ctx: ^types.Context) {
	rl.ClearBackground(rl.BLACK)

	// Title Rendering
	title: cstring = ctx.title
	font_size: i32 = 40
	title_width := rl.MeasureText(title, font_size)
	rl.DrawText(title, (rl.GetRenderWidth() - title_width) / 2, 60, font_size, rl.RAYWHITE)

	// Score Display
	score_text := rl.TextFormat("Last Score: %d", ctx.score)
	high_score_text := rl.TextFormat("High Score: %d", ctx.rally_count)

	score_font_size: i32 = 20
	score_width := rl.MeasureText(score_text, score_font_size)
	high_width := rl.MeasureText(high_score_text, score_font_size)

	rl.DrawText(score_text, (rl.GetRenderWidth() - score_width) / 2, 120, score_font_size, rl.GRAY)
	rl.DrawText(
		high_score_text,
		(rl.GetRenderWidth() - high_width) / 2,
		150,
		score_font_size,
		rl.GOLD,
	)

	// Button Logic
	if gui_button("START GAME", 220) {
		// Reset current session score before starting
		ctx.score = 0
		ctx.rally_count = 0
		gameplay_init(ctx)
		ctx.current_screen = .GAMEPLAY
	}
	// Button Logic (Simplified)
	if gui_button("SETTINGS", 260) {
		ctx.current_screen = .SETTINGS
	}
	if gui_button("QUIT", 320) {
		rl.CloseWindow()
	}
}

// Utility function to mimic your "Utility-First" UI preference
gui_button :: proc(label: cstring, y_pos: i32) -> bool {
	width: i32 = 200
	height: i32 = 40
	x_pos := (rl.GetRenderWidth() - width) / 2

	mouse_pos := rl.GetMousePosition()
	rect := rl.Rectangle{f32(x_pos), f32(y_pos), f32(width), f32(height)}

	is_hovered := rl.CheckCollisionPointRec(mouse_pos, rect)
	color := is_hovered ? rl.GRAY : rl.DARKGRAY

	rl.DrawRectangleRec(rect, color)
	rl.DrawText(label, x_pos + 20, y_pos + 10, 20, rl.WHITE)

	return is_hovered && rl.IsMouseButtonPressed(.LEFT)
}
