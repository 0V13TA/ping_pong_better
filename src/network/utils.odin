package network

import types "../globals"
import rl "vendor:raylib"

NormalizedValues :: struct {
	p1:   f32,
	p2:   f32,
	ball: struct {
		y: f32,
		x: f32,
	},
}

// NOTE: Things to normalize:
// 1. Paddle Position
// 3. Ball Position
normalizeValues :: proc(
	ctx: ^types.Context,
	p1, p2: types.Paddle,
	ball: types.Ball,
) -> NormalizedValues {
	p1_y := (p1.position.y * 100) / rl.GetRenderHeight()
	p2_y := (p2.position.y * 100) / rl.GetRenderHeight()
	ball_x := (ball.position.x * 100) / rl.GetRenderWidth()
	ball_y := (ball.position.y * 100) / rl.GetRenderWidth()

	value := NormalizedValues {
		p1 = p1_y,
		p2 = p2_y,
		ball = {x = ball_x, y = ball_y},
	}
	return value
}
