#function naangiskhan:hell_cauldron/start
tag @a[tag=hell_cauldron_player] remove hell_cauldron_player
execute store result score ngk_hc_player_count ngk_tmp at @e[tag=hell_cauldron_center] run tag @a[predicate=naangiskhan:in_event_dim, distance=..11] add hell_cauldron_player
tag @a[tag=hell_cauldron_player] add hell_cauldron_player_alive
tag @a[tag=hell_cauldron_player] remove hell_cauldron_player_dead
function naangiskhan:hell_cauldron/generate_floor
execute at @e[tag=hell_cauldron_center] run clone ~-6 ~-12 ~-6 ~6 ~-12 ~6 ~-6 ~-1 ~-6 replace normal
scoreboard players set ding ngk_tmp 3
tag @a[tag=hell_cauldron_player] add show_ding
function naangiskhan:countdowns/ding_sequence
scoreboard players set ngk_hc_round ngk_tmp 0
execute as @e[tag=hell_cauldron_center] store result score ngk_hc_height ngk_tmp run data get entity @s Pos[1]
scoreboard players remove ngk_hc_height ngk_tmp 3
schedule function naangiskhan:hell_cauldron/round_start 3s
scoreboard players set hell_cauldron_active ngk_persistent 1