extends Node2D


export(Script) var directory
export var is_interactive = true

var item
var instructions = "REPLACE WITH BERRY NAME"
var is_harvested = false
var counter = 0
var stage = null

func _ready():
	item = directory.new()
	switch_stage("STAGE_00")

func _process(_delta):
	counter += G.time.dspeed
	if counter > 50:
		print("counter")
		counter = 0
		#random_wait = randi()%50+10

func action():
	if G.player.add_to_inventory(item, 1):
		switch_stage("STAGE_02")

func switch_stage(new_stage):
	stage = new_stage
	# Used in winter (when it's frozen)
	if stage == "STAGE_00":
		$Berry.hide()
		$Bush.hide()
		is_interactive = false
		instructions = ""
	
	# Used when berry have grown and are ready to be harvested
	if stage == "STAGE_01":
		$Berry.show()
		$Bush.show()
		is_interactive = true
		instructions = item.i_name + " (harvest)"

	# Used when berries have been harvested
	if stage == "STAGE_02":
		$Berry.hide()
		$Bush.show()
		is_interactive = false
		instructions = ""

func compute_next_stage():
	# During winter we do nothing it will always be frozen
	if stage == "STAGE_00":
		pass

func save():
	var save_dict = {
		"name" : name,
		"is_harvested": is_harvested,
		"stage": stage
	}
	return save_dict

func restore(data):
	switch_stage(data["stage"])
