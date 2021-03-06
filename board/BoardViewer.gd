extends KinematicBody2D

var direction : Vector2
var speed = 10
onready var camera = $Camera2D
var actors : Array
var collision_shapes = []
onready var ray = $feeler
var on_space = false

# TODO do we need this?
var moving = false

var selectable = null

signal actor_found(actors)
signal actor_left()
signal selected(pos)

func _ready():
    set_process_input(false)
    set_physics_process(false)
    pass


func _physics_process(_delta):
    direction = ControlsHandler.get_current_player_direction()
# warning-ignore:return_value_discarded
    move_and_collide(direction.normalized() * speed)
    
    if ray.is_colliding():
        get_board_collisions()
    elif on_space:
        emit_signal("actor_left")
        selectable = null
        on_space = false

func get_board_collisions():
    collision_shapes = []
    if not on_space:
        on_space = true
        
        while ray.is_colliding():
            var obj = ray.get_collider() #get the next object that is colliding.
            collision_shapes.append(obj) #add it to the array.
            ray.add_exception(obj) #add to ray's exception. That way it could detect something being behind it.
            ray.force_raycast_update() #update the ray's collision query.
        
        var previews = []
        
        for obj in collision_shapes:
            if obj.get_parent() is Spawner:
                var spawner_previews = obj.get_parent().get_previews()
                if spawner_previews is Array:
                    for prev in spawner_previews:
                        previews.append(prev)
                elif spawner_previews:
                    previews.append(spawner_previews)
            elif obj.get_parent() is Combatant:
                previews.append(obj.get_parent.get_actor())
            elif moving and obj is MoveMarker:
                selectable = obj.position
        if !previews.empty():
            emit_signal("actor_found", previews)
        
        for obj in collision_shapes:
            ray.remove_exception(obj)
        collision_shapes = []

func _input(event):
    if event and ControlsHandler.is_action_pressed_by_players(event, "ui_cancel", [get_parent().current_player.player]):
        get_parent().return_to_player(to_global(camera.position))
    
    if event.is_action_pressed("ui_accept") and moving and selectable != null:
        emit_signal("selected", selectable, to_global(camera.position))
#        get_parent().return_to_player(to_global(camera.position))
        
