package globals
import rl "vendor:raylib"

// Config flag passed from build script
ANDROID :: #config(ANDROID, false)
PACKAGE_NAME :: "com.raylib.game"
ANDROID_PATH :: "/data/data/com.raylib.game/"
ANDROID_PATH_FALLBACK :: "/storage/emulated/0/Android/data/com.raylib.game/"

Screen :: enum {
	GAMEPLAY,
	SETTINGS,
	GAME_OVER,
	HOME_SCREEN,
	PAUSE_SCREEN,
}

Level :: enum {
	EASY,
	HARD,
	NORMAL,
}

Mode :: enum {
	MULTIPLAYER,
	SINGLE_PLAYER,
	LAN_MULTIPLAYER,
}

Context :: struct {
	score:             i32,
	rally_count:       i32,
	ball_speed:        f32,
	paddle_speed:      f32,
	score_point:       i32,
	win_limit:         i32,
	winner_name:       cstring,
	game_mode:         Mode,
	level:             Level,
	current_screen:    Screen,
	hit_sound:         rl.Sound,
	title:             cstring,
	highest_rally:     i32,
	record_anim_timer: f32,
}

// NOTE: The way I plan on handling this, is to
// Multiply the speed by the direction and then add it
// to the position.
// -1 is for up and +1 is for down and 0
// for not moving at all.
// Speed can now be easily modified.
Paddle :: struct {
	dir:      i8,
	speed:    f32,
	score:    i32,
	color:    rl.Color,
	size:     rl.Vector2,
	position: rl.Vector2,
	controls: struct {
		up:   rl.KeyboardKey,
		down: rl.KeyboardKey,
	},
}

// NOTE: So basically to extract information from the
// dir which is the angle, first you'll realize that the
// speed is the hypotenuse and then you can simply do trigonometry
// y = speed * sin(dir)
// x = speed * cos(dir)
// Unit is in degrees
Ball :: struct {
	dir:      f32, // NOTE: Direction Defined By The Angle
	speed:    f32,
	radius:   f32,
	color:    rl.Color,
	position: rl.Vector2,
}
