// ping_pong/globals/persistence.odin
package globals

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

SAVE_FILE :: "assets/settings.txt"

save_settings :: proc(ctx: ^Context) {
	f, err := os.open(SAVE_FILE, os.O_WRONLY | os.O_CREATE | os.O_TRUNC, 0o644)
	if err != os.ERROR_NONE do return
	defer os.close(f)

	// Write values in "name value" format
	fmt.fprintf(f, "high_score %d\n", ctx.highest_rally)
	fmt.fprintf(f, "win_limit %d\n", ctx.win_limit)
	fmt.fprintf(f, "level %d\n", int(ctx.level))
	fmt.fprintf(f, "mode %d\n", int(ctx.game_mode))
}

load_settings :: proc(ctx: ^Context) {
	data, ok := os.read_entire_file(SAVE_FILE)
	if !ok do return
	defer delete(data)

	lines := strings.split(string(data), "\n")
	defer delete(lines)

	for line in lines {
		if len(line) == 0 do continue
		parts := strings.split(line, " ")
		if len(parts) < 2 do continue

		name := parts[0]
		val_str := parts[1]
		val, _ := strconv.parse_int(val_str)

		switch name {
		case "high_score":
			ctx.highest_rally = i32(val)
		case "win_limit":
			ctx.win_limit = i32(val)
		case "level":
			ctx.level = Level(val)
		case "mode":
			ctx.game_mode = Mode(val)
		}
	}
}
