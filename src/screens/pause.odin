package screens

import types "../globals"
import rl "vendor:raylib"

draw_pause :: proc(ctx: ^types.Context) {
	screen_w := f32(rl.GetScreenWidth())
	screen_h := f32(rl.GetScreenHeight())

	center_x := screen_w / 2

	// === DIM BACKGROUND ===
	rl.DrawRectangle(
		0,
		0,
		i32(screen_w),
		i32(screen_h),
		rl.Color{0, 0, 0, 180}, // softer + consistent overlay
	)

	// === TITLE ===
	title: cstring = "PAUSED"
	title_font := i32(screen_h * 0.07)

	title_w := rl.MeasureText(title, title_font)

	rl.DrawText(title, i32(center_x - f32(title_w) / 2), i32(screen_h * 0.2), title_font, rl.WHITE)

	// === BUTTON STACK ===
	start_y := screen_h * 0.4
	gap := screen_h * 0.12

	if gui_button("RESUME", start_y) {
		ctx.current_screen = .GAMEPLAY
	}

	if gui_button("MAIN MENU", start_y + gap) {
		ctx.current_screen = .HOME_SCREEN
		types.save_settings(ctx)
	}
}
