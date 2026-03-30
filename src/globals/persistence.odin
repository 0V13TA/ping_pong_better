// ping_pong/globals/persistence.odin
package globals

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

SAVE_FILE :: "settings.txt"
HIGHEST_RALLY :: "highest_rally"
WIN_LIMIT :: "win_limit"
LEVEL :: "level"
MODE :: "mode"

save_settings :: proc(ctx: ^Context) {
	f, err := os.open(SAVE_FILE, os.O_WRONLY | os.O_CREATE | os.O_TRUNC, 0o644)
	if err != os.ERROR_NONE {
		fmt.println("Nigga I can't save this file")
		fmt.println(err)
		return
	}
	defer os.close(f)

	// Write values in "name value" format
	fmt.fprintf(f, "%s %d\n", HIGHEST_RALLY, ctx.highest_rally)
	fmt.fprintf(f, "%s %d\n", WIN_LIMIT, ctx.win_limit)
	fmt.fprintf(f, "%s %d\n", LEVEL, int(ctx.level))
	fmt.fprintf(f, "%s %d\n", MODE, int(ctx.game_mode))
}

load_settings :: proc(ctx: ^Context) {
	data, ok := os.read_entire_file(SAVE_FILE)
	if !ok {
		fmt.println("Nigga I Can't Read This File")
		return
	}
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
		case HIGHEST_RALLY:
			ctx.highest_rally = i32(val)
		case WIN_LIMIT:
			ctx.win_limit = i32(val)
		case LEVEL:
			ctx.level = Level(val)
		case MODE:
			ctx.game_mode = Mode(val)
		}
	}
}
