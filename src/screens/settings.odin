package screens

import types "../globals"
import rl "vendor:raylib"
// ping_pong/screens/settings.odin
draw_settings :: proc(ctx: ^types.Context) {
	screen_w := f32(rl.GetScreenWidth())
	screen_h := f32(rl.GetScreenHeight())

	center_x := screen_w / 2

	// === TITLE ===
	title: cstring = "SETTINGS"
	title_font := i32(screen_h * 0.06)

	title_w := rl.MeasureText(title, title_font)

	rl.DrawText(
		title,
		i32(center_x - f32(title_w) / 2),
		i32(screen_h * 0.1),
		title_font,
		rl.RAYWHITE,
	)

	// === SETTINGS STACK ===
	start_y := screen_h * 0.25
	gap := screen_h * 0.11

	// --- LEVEL ---
	level_label := rl.TextFormat("LEVEL: %v", ctx.level)
	if gui_button(level_label, start_y) {
		switch ctx.level {
		case .EASY:
			ctx.level = .NORMAL
		case .NORMAL:
			ctx.level = .HARD
		case .HARD:
			ctx.level = .EASY
		}
		types.save_settings(ctx) // Save immediately to persist mode changes
	}

	// --- MODE ---
	mode_label := rl.TextFormat("MODE: %v", ctx.game_mode)
	if gui_button(mode_label, start_y + gap) {
		ctx.game_mode = (ctx.game_mode == .SINGLE_PLAYER) ? .MULTIPLAYER : .SINGLE_PLAYER
		types.save_settings(ctx) // Save immediately to persist mode changes
	}

	// --- WIN LIMIT ---
	limit_label := rl.TextFormat("WIN LIMIT: %d", ctx.win_limit)
	if gui_button(limit_label, start_y + gap * 2) {
		ctx.win_limit += 2
		if ctx.win_limit > 11 do ctx.win_limit = 1
		types.save_settings(ctx) // Save immediately to persist mode changes
	}

	// === SEPARATOR (visual grouping) ===
	sep_y := start_y + gap * 3 + screen_h * 0.03
	sep_w := screen_w * 0.4

	rl.DrawRectangle(i32(center_x - sep_w / 2), i32(sep_y), i32(sep_w), 2, rl.DARKGRAY)

	// === BACK BUTTON ===
	if gui_button("BACK", sep_y + screen_h * 0.06) {
		ctx.current_screen = .HOME_SCREEN
	}
}
