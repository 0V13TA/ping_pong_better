// ping_pong/globals/persistence.odin
package globals

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
foreign import rl "vendor:raylib"
GetStoragePath :: proc() -> cstring

SAVE_FILE :: "settings.txt"
HIGHEST_RALLY :: "highest_rally"
WIN_LIMIT :: "win_limit"
LEVEL :: "level"
MODE :: "mode"

save_settings :: proc(ctx: ^Context) {
	path := SAVE_FILE
	when ANDROID {
		// Use the internal storage path where we have write permissions
		app := rl.GetAndroidApp()
		if app != nil {
			path = fmt.tprintf("%s/%s", app.activity.internalDataPath, SAVE_FILE)
		}
	}

	// Convert string to cstring for Raylib's TraceLog
	path_cstr := strings.clone_to_cstring(path, context.temp_allocator)
	rl.TraceLog(.INFO, rl.TextFormat("Saving settings to: %s", path_cstr))
	rl.TraceLog(.INFO, "%d", ANDROID)


	f, err := os.open(path, os.O_WRONLY | os.O_CREATE | os.O_TRUNC, 0o644)
	if err != os.ERROR_NONE {
		rl.TraceLog(.ERROR, "Nigga I can't save this file")
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
	path := SAVE_FILE
	when ANDROID {
		// Use the internal storage path where we have write permissions
		app := rl.GetAndroidApp()
		rl.Getpath
		if app != nil {
			path = fmt.tprintf("%s/%s", app.activity.internalDataPath, SAVE_FILE)
		}
	}

	// Convert string to cstring for Raylib's TraceLog
	path_cstr := strings.clone_to_cstring(path, context.temp_allocator)
	rl.TraceLog(.INFO, rl.TextFormat("Loading settings to: %s", path_cstr))
	rl.TraceLog(.INFO, rl.GetWorkingDirectory())
	rl.TraceLog(.INFO, "%d", ANDROID)

	fmt.println("Loading from path: %s", path)
	data, ok := os.read_entire_file(path)
	if !ok {
		rl.TraceLog(.ERROR, "Nigga I Can't Read This File")
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
