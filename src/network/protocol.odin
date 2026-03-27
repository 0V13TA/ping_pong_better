package network

import "../globals"
import "core:fmt"
import "core:strings"

serialize_game_state :: proc(
	p1: ^globals.Paddle,
	p2: ^globals.Paddle,
	ball: ^globals.Ball,
) -> string {
	// We use a builder to efficiently construct the string
	sb := strings.builder_make()

	// Format: name value
	fmt.sbprintf(&sb, "p1_y %.2f\n", p1.position.y)
	fmt.sbprintf(&sb, "p2_y %.2f\n", p2.position.y)
	fmt.sbprintf(&sb, "ball_x %.2f\n", ball.position.x)
	fmt.sbprintf(&sb, "ball_y %.2f\n", ball.position.y)
	fmt.sbprintf(&sb, "ball_dir %.2f\n", ball.dir)

	return strings.to_string(sb)
}

deserialize_game_state :: proc(
	data: string,
	p1: ^globals.Paddle,
	p2: ^globals.Paddle,
	ball: ^globals.Ball,
) {
	lines := strings.split(data, "\n")
	defer delete(lines)

	for line in lines {
		if len(line) == 0 do continue
		parts := strings.split(line, " ")
		if len(parts) < 2 do continue

		name := parts[0]
		val := f32(strconv.parse_f64(parts[1]) or_else 0.0)

		switch name {
		case "p1_y":
			p1.position.y = val
		case "p2_y":
			p2.position.y = val
		case "ball_x":
			ball.position.x = val
		case "ball_y":
			ball.position.y = val
		case "ball_dir":
			ball.dir = val
		}
	}
}
