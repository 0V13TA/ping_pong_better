// ping_pong/globals/persistence.odin
package globals

import types "../globals"
import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

SAVE_FILE :: "settings.txt"
HIGHEST_RALLY :: "highest_rally"
WIN_LIMIT :: "win_limit"
LEVEL :: "level"
MODE :: "mode"

save_settings :: proc(ctx: ^Context) {
	when ANDROID {
		path := strings.concatenate({ANDROID_PATH, SAVE_FILE})

		f, err := os.open(path, os.O_WRONLY | os.O_CREATE | os.O_TRUNC, 0o644)

		if err != os.ERROR_NONE {
			path = strings.concatenate({ANDROID_PATH_FALLBACK, SAVE_FILE})
			f, err = os.open(path, os.O_WRONLY | os.O_CREATE | os.O_TRUNC, 0o644)

			if err != os.ERROR_NONE {
				rl.TraceLog(.ERROR, "Nigga I didn't save")
				return
			}
		}
		defer os.close(f)
	}

	when !ANDROID {
		f, err := os.open(SAVE_FILE, os.O_WRONLY | os.O_CREATE | os.O_TRUNC, 0o644)

		if err != os.ERROR_NONE {
			return
		}
		defer os.close(f)
	}

	// Write values in "name value" format
	fmt.fprintf(f, "%s %d\n", HIGHEST_RALLY, ctx.highest_rally)
	fmt.fprintf(f, "%s %d\n", WIN_LIMIT, ctx.win_limit)
	fmt.fprintf(f, "%s %d\n", LEVEL, int(ctx.level))
	fmt.fprintf(f, "%s %d\n", MODE, int(ctx.game_mode))
}

load_settings :: proc(ctx: ^Context) {

	when ANDROID {
		path := strings.concatenate({ANDROID_PATH, SAVE_FILE})

		data, ok := os.read_entire_file(path)
		if !ok {
			path = strings.concatenate({types.ANDROID_PATH_FALLBACK, SAVE_FILE})
			data, ok = os.read_entire_file(path)
			if !ok {
				fmt.println(path)
				rl.TraceLog(.INFO, strings.clone_to_cstring(path))
				rl.TraceLog(.ERROR, "Nigga I didn't load")
				return
			}
		}
		defer delete(data)
	}

	when !ANDROID {
		data, ok := os.read_entire_file(SAVE_FILE)
		if !ok {
			fmt.println("I didn't load")
			return
		}
		defer delete(data)
	}

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
