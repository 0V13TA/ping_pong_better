package screens

import types "../globals"
import rl "vendor:raylib"

draw_pause :: proc(ctx: ^types.Context) {
	// Dim the background
	rl.DrawRectangle(0, 0, rl.GetRenderWidth(), rl.GetRenderHeight(), rl.ColorAlpha(rl.BLACK, 0.5))

	rl.DrawText("PAUSED", (rl.GetRenderWidth() - 100) / 2, 150, 30, rl.WHITE)

	if gui_button("RESUME", 220) {
		ctx.current_screen = .GAMEPLAY
	}
	if gui_button("MAIN MENU", 280) {
		ctx.current_screen = .HOME_SCREEN
	}
}
