extends Button

var description = ""
var item : Item
var draggable : bool = false
onready var DragIcon = preload("res://interface/menus/EquipMenu/DragIcon.tscn")

signal button_dragged(drag_icon)

func _ready():
    set_default_cursor_shape(Control.CURSOR_POINTING_HAND)

func initialize(_item, store = false):
    item = _item
    $Margins/Row/Name.text = item.display_name
    $Margins/Row/Amount.text = str(item.amount)
    $Margins/Row/Icon.texture = item.icon
    $Margins/Row/Cost.text = String(item.price) + " G"
    description = item.description
    if store or item is Equipment:
        $Margins/Row/Amount.text = ""
    
    if !store:
        $Margins/Row/Cost.visible = false
    
    disabled = !item.usable
    
    item.connect("amount_changed", self, "_on_Item_amount_changed")
    item.connect("depleted", self, "queue_free")

func _on_Item_amount_changed(amount):
    $Margins/Row/Amount.text = str(amount)
    
func _process(_delta):
    if item:
        disabled =  !item.usable
    if (!$Margins/Row/Equipped.visible and item 
        and item is Equipment and item.equipped):
        $Margins/Row/Equipped.show()
    elif $Margins/Row/Equipped.visible and !item.equipped:
        $Margins/Row/Equipped.hide()
            
func get_drag_data(_pos):
    if draggable:
        var preview = TextureRect.new()
        preview.texture = item.icon
        set_drag_preview(preview)
        print("dragging")
        return item
    else:
        return null
