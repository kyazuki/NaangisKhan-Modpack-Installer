#function naangiskhan:hell_cauldron/check_dropout

execute as @a[tag=hell_cauldron_player_alive] store result score @s ngk_tmp run data get entity @s Pos[1]
execute as @a[tag=hell_cauldron_player_alive] if score @s ngk_tmp < ngk_hc_height ngk_tmp run tag @s add hell_cauldron_player_dead
execute as @a[tag=hell_cauldron_player_dead] if entity @s[tag=hell_cauldron_player_alive] at @s positioned as @e[tag=hell_cauldron_center, sort=nearest,limit=1] run tp @s ~ ~6.5 ~
execute as @a[tag=hell_cauldron_player_dead] if entity @s[tag=hell_cauldron_player_alive] run tag @s remove hell_cauldron_player_alive