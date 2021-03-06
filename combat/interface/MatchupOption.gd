extends PanelContainer

onready var GoodTex = load("res://assets/ui/Interface_17.png")
onready var BadTex = load("res://assets/ui/Interface_16.png")
onready var LeftArrow = load("res://assets/ui/left.png")
onready var RightArrow = load("res://assets/ui/right.png")

func initialize(_attacker, attack, defender, defend):
    $Row/AttackerMove.text = attack.move.name
    $Row/DefenderMove.text = defend.name
    var hit = attack.execute(defender, defend)
    if hit.damage >= defender.stats.health:
        $Row/ResultIcon.texture = BadTex
    else:
        $Row/ResultIcon.texture = GoodTex
    return hit
