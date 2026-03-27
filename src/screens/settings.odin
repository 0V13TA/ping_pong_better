package screens

import types "../globals"
import rl "vendor:raylib"
// ping_pong/screens/settings.odin

draw_settings :: proc(ctx: ^types.Context) {
	rl.ClearBackground(rl.BLACK)

	// Title
	font_size: i32 = 30
	title_width := rl.MeasureText("SETTINGS", font_size)
	rl.DrawText("SETTINGS", (rl.GetRenderWidth() - title_width) / 2, 60, font_size, rl.RAYWHITE)

	// 1. Difficulty Level Toggle (The New Part)
	level_label := rl.TextFormat("LEVEL: %v", ctx.level)
	if gui_button(level_label, 140) {
		// Cycle through the Level enum
		switch ctx.level {
		case .EASY:
			ctx.level = .NORMAL
		case .NORMAL:
			ctx.level = .HARD
		case .HARD:
			ctx.level = .EASY
		}
	}
	// Inside draw_settings proc
	limit_label := rl.TextFormat("WIN LIMIT: %d", ctx.win_limit)
	if gui_button(limit_label, 260) {
		ctx.win_limit += 2
		if ctx.win_limit > 11 do ctx.win_limit = 1 // Cycle back
	}

	// 2. Existing Mode Toggle
	mode_label := rl.TextFormat("MODE: %v", ctx.game_mode)
	if gui_button(mode_label, 200) {
		ctx.game_mode = (ctx.game_mode == .SINGLE_PLAYER) ? .MULTIPLAYER : .SINGLE_PLAYER
	}

	// 3. Back Button
	if gui_button("BACK", 320) {
		ctx.current_screen = .HOME_SCREEN
	}
}
