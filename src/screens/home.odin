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

	score_text := rl.TextFormat("Last Rally: %d", ctx.score)
	high_text := rl.TextFormat("Highest Rally: %d", ctx.highest_rally)

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
		ctx.shown_highscore = false
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

// Inside gameplay_draw
// Use this in screens/gameplay.odin or home.odin
draw_scoreboard :: proc(p1_score, p2_score: i32) {
	sw := f32(rl.GetScreenWidth())
	sh := f32(rl.GetScreenHeight())

	fs := i32(sh * 0.25) // Very large background numbers
	spacing := sw * 0.15

	s1 := rl.TextFormat("%d", p1_score)
	s2 := rl.TextFormat("%d", p2_score)

	// Very faint light gray so it's readable but doesn't distract
	color := rl.Fade(rl.BLACK, 0.15)

	rl.DrawText(s1, i32(sw / 2 - spacing - f32(rl.MeasureText(s1, fs))), i32(sh * 0.3), fs, color)
	rl.DrawText(s2, i32(sw / 2 + spacing), i32(sh * 0.3), fs, color)
}

// src/screens/gameplay.odin

draw_pause_button :: proc(ctx: ^types.Context) {
	sw := f32(rl.GetScreenWidth())
	sh := f32(rl.GetScreenHeight())

	// 1. Position it at the top-center to be reachable but out of the way
	btn_w := sw * 0.12
	btn_h := sh * 0.08
	rect := rl.Rectangle{(sw - btn_w) / 2, sh * 0.02, btn_w, btn_h}

	// 2. Interaction Logic (Raylib treats first touch as mouse)
	mouse_pos := rl.GetMousePosition()
	is_hovered := rl.CheckCollisionPointRec(mouse_pos, rect)

	// Minimalist CSS-style: Change opacity or border thickness on hover
	color := is_hovered ? rl.BLACK : rl.Fade(rl.BLACK, 0.3)
	thickness: f32 = is_hovered ? 3.0 : 1.5

	// 3. Draw "Ghost" Button
	rl.DrawRectangleLinesEx(rect, thickness, color)

	// Center the text "PAUSE" or "||" inside
	fs := i32(btn_h * 0.5)
	tw := rl.MeasureText("PAUSE", fs)
	rl.DrawText(
		"PAUSE",
		i32(rect.x + (btn_w - f32(tw)) / 2),
		i32(rect.y + (btn_h - f32(fs)) / 2),
		fs,
		color,
	)

	if is_hovered && rl.IsMouseButtonPressed(.LEFT) {
		ctx.current_screen = .PAUSE_SCREEN
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
