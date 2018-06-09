extends Node

var highscore = 0
var score_file = "user://highscore.txt"

enum color_schemes {NEON1, NEON2, NEON3}

var colors = {
	color_schemes.NEON1: {
		'background': Color8(0, 0, 0),
		'player_body': Color8(203, 255, 0), # YELLOW
		'player_trail': Color8(204, 0, 255),
        'circle_shrinking': Color8(0, 102, 255), # BLUE
        'circle_fill': Color8(255, 0, 0), # RED
        'circle_static': Color8(0, 255, 102), # GREEN
		'circle_limited': Color8(204, 0, 255) # PURPLE
	},
	color_schemes.NEON2: {
		'background': Color8(0, 0, 0),
		'player_body': Color8(246, 255, 0),
		'player_trail': Color8(255, 255, 255),
        'circle_shrinking': Color8(0, 102, 255),
        'circle_fill': Color8(255, 0, 110),
        'circle_static': Color8(151, 255, 48),
		'circle_limited': Color8(127, 0, 255)
	},
	color_schemes.NEON3: {
		'background': Color8(0, 0, 0),
		'player_body': Color8(255, 0, 187),
		'player_trail': Color8(255, 148, 0),
        'circle_shrinking': Color8(1,1,1),
        'circle_fill': Color8(255, 148, 0),
        'circle_static': Color8(170, 255, 0),
		'circle_limited': Color8(204, 0, 255)
	}
}
var theme = colors[color_schemes.NEON3]

var enable_sound = true
var enable_music = true

func _ready():
	load_score()

func load_score():
	var f = File.new()
	if f.file_exists(score_file):
		f.open(score_file, File.READ)
		var content = f.get_as_text()
		highscore = int(content)
		f.close()

func save_score():
	var f = File.new()
	f.open(score_file, File.WRITE)
	f.store_string(str(highscore))
	f.close()
