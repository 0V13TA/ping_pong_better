package main

import "base:runtime"
import "core:fmt"
import types "globals"
import screens "screens"
import rl "vendor:raylib"

// 1. DESKTOP ENTRY POINT
when !types.ANDROID {
	main :: proc() {
		rl.InitWindow(800, 480, "Ping Pong Desktop")
		game_run()
	}
}

// 2. types.ANDROID ENTRY POINT
when types.ANDROID {
	AndroidApp :: struct {}

	@(export)
	android_entry :: proc "c" (_: i32, _: [^]cstring) -> i32 {
		context = runtime.default_context()
		rl.InitWindow(0, 0, "Ping Pong Android")
		game_run()
		return 0
	}
}

// SHARED GAME LOGIC
game_run :: proc() {
	global_context := types.Context {
		score          = 0,
		rally_count    = 0,
		score_point    = 1,
		highest_rally  = 0,

		//
		ball_speed     = 0.50,
		paddle_speed   = 0.50,

		//
		title          = "PING PONG",
		win_limit      = 3,

		//
		level          = .EASY,
		game_mode      = .MULTIPLAYER,
		current_screen = .HOME_SCREEN,
	}

	when !types.ANDROID {
		if !rl.ChangeDirectory("assets") {
			fmt.println("Warning: Could not find assets directory")
		}
	}

	types.load_settings(&global_context)
	defer types.save_settings(&global_context)

	rl.InitAudioDevice()
	defer rl.CloseAudioDevice()

	rl.SetTargetFPS(60)

	screens.gameplay_init(&global_context)

	for (!rl.WindowShouldClose()) {
		rl.BeginDrawing()
		rl.ClearBackground(rl.RAYWHITE)

		switch global_context.current_screen {
		case .HOME_SCREEN:
			screens.draw_home(&global_context)
		case .GAMEPLAY:
			screens.gameplay_update(&global_context)
			screens.gameplay_draw(&global_context)
			if rl.IsKeyPressed(.SPACE) || rl.IsKeyPressed(.ESCAPE) {
				global_context.current_screen = .PAUSE_SCREEN
			}
		case .SETTINGS:
			screens.draw_settings(&global_context)
		case .PAUSE_SCREEN:
			screens.gameplay_draw(&global_context) // Keep drawing game state underneath
			screens.draw_pause(&global_context)
		case .GAME_OVER:
			screens.draw_game_over(&global_context)
		}

		rl.EndDrawing()
	}

	rl.CloseWindow()
}
