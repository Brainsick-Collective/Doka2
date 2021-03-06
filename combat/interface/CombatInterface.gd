extends Control

#take in a player id, grab that control scheme,
#and listen to those input events

var moves1
var moves2 
var fighter1
var fighter2
var is_fighter1_first

onready var default_moves = {
    "offensive" :
        ["of. magic",
        "ability",
        "strike",
        "attack"],
    "defensive" :
        ["d. magic",
        "give up",
        "parry",
        "defend"]
}

enum move_types { empty = -1, normal, special, magic, effect }
onready var move_map = {
    "ui_up"    : 0,
    "ui_down"  : 1,
    "ui_right" : 2,
    "ui_left"  : 3
    }

# will be of the form {"offensive": [magic, ability, strike, attack], "defensive" : [magic, ability, strike, attack]}
# each of the 4 options is of type Action, and the action itself will have a function for activating it based on the other player's stats

func initialize(player1, player2):
    fighter1 = player1
    fighter2 = player2
    $Stats.set_fighters(fighter1, fighter2)
    
func decide_turns():
    if not get_tree():
        yield(self, "tree_entered")
    $Label.text = ""
    $Label.hide()
    $Options1.hide()
    $Options2.hide()
    $TurnOrderPopup.reset()
    $TurnOrderPopup.decide_turns(fighter1.stats.speed, fighter2.stats.speed)
# warning-ignore:return_value_discarded
    $TurnOrderPopup.connect("chosen", self, "_on_turns_chosen")
    
    
func _on_turns_chosen(fighter1_first):
    is_fighter1_first = fighter1_first
    do_combat_phase(is_fighter1_first)

func do_combat_phase(choice):
    if choice:
        $Label.text = "your Turn!"
        map_options($Options1, fighter1.moves["offense"])
        map_options($Options2, fighter2.moves["defense"])
    else:
        $Label.text = "opponents Turn!"
        map_options($Options2, fighter2.moves["offense"])
        map_options($Options1, fighter1.moves["defense"])
func map_options(Option, moves):
    for move in moves:
        if moves[move]:
            Option.get_child(moves[move].type).get_node("Label").text = moves[move].name


func _on_TurnOrderPopup_chosen(_choice):
    $Options1.show()
    $Options2.show()
    $AnimationPlayer.play("slide in")
    pass # Replace with function body.
