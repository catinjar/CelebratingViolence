extends Node

enum Rule
{
	ULTRAVIOLENCE = 0,
	DAY_OF_THE_DEAD = 1
}

var health = 100
var money = 0
var used_rules : Array[Rule]

func add_money(amount):
	money += amount
	if money >= 100:
		get_tree().paused = true
		var upgrade_window = get_node("/root/Main/UpgradeWindow")
		upgrade_window.show()
		upgrade_window.set_rules(GlobalState.get_new_rules())
		money = 0
		
		$LevelUpSound.play()

func take_damage(amount):
	health -= amount
	if health <= 0:
		get_tree().change_scene_to_file("res://start_screen.tscn")

func get_new_rules():
	var available_rules : Array[Rule]
	for rule_name in Rule:
		var rule = Rule.get(rule_name)
		if used_rules.find(rule) == -1:
			available_rules.append(rule)
	
	assert(available_rules.size() >= 2)
	
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
