// ping_pong/screens/game_over.odin
package screens

import types "../globals"
import rl "vendor:raylib"

draw_game_over :: proc(ctx: ^types.Context) {

	// Show Winner
	font_size: i32 = 40
	w_width := rl.MeasureText(ctx.winner_name, font_size)
	rl.DrawText(ctx.winner_name, (rl.GetRenderWidth() - w_width) / 2, 100, font_size, rl.GOLD)

	if gui_button("REPLAY", 200) {
		ctx.score = 0
		ctx.rally_count = 0
		gameplay_init(ctx) // Reset paddles and ball
		ctx.current_screen = .GAMEPLAY
	}

	if gui_button("HOME", 260) {
		ctx.current_screen = .HOME_SCREEN
	}
}
