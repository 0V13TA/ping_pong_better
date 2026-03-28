// screens/home.odin
package screens

import types "../globals"
import rl "vendor:raylib"

draw_home :: proc(ctx: ^types.Context) {
	screen_w := f32(rl.GetScreenWidth())
	screen_h := f32(rl.GetScreenHeight())

	center_x := screen_w / 2

	// === TITLE ===
	title_font := i32(screen_h * 0.06) // responsive font
	title_width := rl.MeasureText(ctx.title, title_font)

	rl.DrawText(
		ctx.title,
		i32(center_x - f32(title_width) / 2),
		i32(screen_h * 0.1),
		title_font,
		rl.RAYWHITE,
	)

	// === SCORES ===
	score_font := i32(screen_h * 0.03)

	score_text := rl.TextFormat("Last Score: %d", ctx.score)
	high_text := rl.TextFormat("High Score: %d", ctx.rally_count)

	score_w := rl.MeasureText(score_text, score_font)
	high_w := rl.MeasureText(high_text, score_font)

	rl.DrawText(
		score_text,
		i32(center_x - f32(score_w) / 2),
		i32(screen_h * 0.22),
		score_font,
		rl.GRAY,
	)
	rl.DrawText(
		high_text,
		i32(center_x - f32(high_w) / 2),
		i32(screen_h * 0.26),
		score_font,
		rl.GOLD,
	)

	// === BUTTON STACK ===
	start_y := screen_h * 0.4
	gap := screen_h * 0.12

	if gui_button("START GAME", start_y) {
		ctx.score = 0
		ctx.rally_count = 0
		gameplay_init(ctx)
		ctx.current_screen = .GAMEPLAY
	}

	if gui_button("SETTINGS", start_y + gap) {
		ctx.current_screen = .SETTINGS
	}

	if gui_button("QUIT", start_y + gap * 2) {
		rl.CloseWindow()
	}
}


gui_button :: proc(label: cstring, y: f32) -> bool {
	screen_w := f32(rl.GetScreenWidth())
	screen_h := f32(rl.GetScreenHeight())

	width := screen_w * 0.35
	height := screen_h * 0.08

	x := (screen_w - width) / 2

	rect := rl.Rectangle{x, y, width, height}

	mouse := rl.GetMousePosition()
	hover := rl.CheckCollisionPointRec(mouse, rect)

	// === COLORS ===
	bg := hover ? rl.Color{100, 100, 100, 255} : rl.Color{60, 60, 60, 255}
	border := hover ? rl.LIGHTGRAY : rl.DARKGRAY

	// === DRAW ===
	rl.DrawRectangleRec(rect, bg)
	rl.DrawRectangleLinesEx(rect, 2, border)

	// === TEXT ===
	font_size := i32(height * 0.4)
	text_w := rl.MeasureText(label, font_size)

	text_x := i32(x + (width - f32(text_w)) / 2)
	text_y := i32(y + (height - f32(font_size)) / 2)

	rl.DrawText(label, text_x, text_y, font_size, rl.WHITE)

	return hover && rl.IsMouseButtonPressed(.LEFT)
}
