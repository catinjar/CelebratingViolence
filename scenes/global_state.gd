extends Node

enum Rule
{
	ULTRAVIOLENCE = 0,
	DAY_OF_THE_DEAD = 1,
	HALLOWEEN = 2,
	CINEMA = 3,
	NEW_YEAR = 4,
	POSTMODERNISM = 5,
	POSTPROCESS = 6,
	VALENTINES_DAY = 7,
	MUSIC = 8,
	BIRTHDAY = 9,
	CHINESE_NEW_YEAR = 10,
	CHRIST_JESUS = 11,
	BLOOD = 12,
	MONEY = 13,
	LOVE = 14
}

var high_score = 0
var score = 0

var level = 0
var health = 100
var money = 0
var used_rules : Array[Rule]

func _ready():
	used_rules.append(Rule.LOVE)
	pass

func reset():
	if score > high_score:
		high_score = score
	score = 0
	
	health = 100
	money = 0
	used_rules.clear()

func get_needed_money():
	return 100 + level * 100

func get_spawn_time_bonus():
	return level * -0.04

func add_score(amount):
	score += amount

func add_money(amount):
	money += amount * 1.5
	add_score(5)
	if money >= get_needed_money():
		get_tree().paused = true
		var upgrade_window = get_node("/root/Main/UpgradeWindow")
		upgrade_window.show()
		upgrade_window.set_rules(GlobalState.get_new_rules())
		money = 0
		
		level += 1
		
		$LevelUpSound.play()
		
func add_health(amount):
	health += amount
	if health > 100:
		health = 100

func take_damage(amount):
	health -= amount
	if health <= 0:
		game_over()

func game_over():
	reset()
	get_tree().change_scene_to_file("res://start_screen.tscn")

func get_new_rules():
	var available_rules : Array[Rule]
	for rule_name in Rule:
		var rule = Rule.get(rule_name)
		if used_rules.find(rule) == -1:
			available_rules.append(rule)
	
	if available_rules.size() < 2:
		game_over()
	
	var new_rules : Array[Rule]
	for i in 2:
		var rule_index = randi_range(0, available_rules.size() - 1)
		var new_rule = available_rules[rule_index] as Rule
		new_rules.append(new_rule)
		available_rules.erase(new_rule)
		
	return new_rules

func add_new_rule(rule):
	assert(used_rules.find(rule) == -1)
	used_rules.append(rule)
	update_rule_conditions()
	
func has_rule(rule):
	return used_rules.find(rule) != -1
	
func update_rule_conditions():
	pass
