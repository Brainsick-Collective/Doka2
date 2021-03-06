extends VBoxContainer

var player : Player

func initialize(_player):
    player = _player
    $Row/Column/TextureRect.texture = player.get_character_image()
    $Row/Column/CondensedPlayerPanel.set_condensed(player.get_combatant())
    $Row/VBoxContainer/grid/Exp/Label.text = String(player.stats.xp)
    $Row/VBoxContainer/grid/Next/Label.text = String(player.stats.next_level_xp - player.stats.xp)
    $Row/VBoxContainer/grid/Job/Label.text = player.stats.job.job_name
    $Row/VBoxContainer/grid/NewWorth/Label.text = String(player.get_net_worth())
