#function naangiskhan:hell_cauldron/round_start
scoreboard players add ngk_hc_round ngk_tmp 1
tellraw @a[tag=hell_cauldron_player] ["ラウンド",{"score":{"name":"ngk_hc_round","objective":"ngk_tmp","bold":true}}]
execute at @e[tag=hell_cauldron_center] run function naangiskhan:hell_cauldron/generate_panels
execute as @a[tag=hell_cauldron_player] at @s run playsound minecraft:block.note_block.guitar master @s ~ ~ ~ 1 2
scoreboard players set ngk_hc_timer ngk_tmp 11
scoreboard players operation ngk_hc_timer ngk_tmp -= ngk_hc_round ngk_tmp
execute if score ngk_hc_timer ngk_tmp matches ..2 run scoreboard players set ngk_hc_timer ngk_tmp 3
execute if score ngk_hc_round ngk_tmp matches ..10 run scoreboard players operation timer ngk_tmp = ngk_hc_timer ngk_tmp
execute if score ngk_hc_round ngk_tmp matches ..10 run tag @a[tag=hell_cauldron_player] add show_timer
execute if score ngk_hc_round ngk_tmp matches ..10 run schedule function naangiskhan:countdowns/timer_sequence 1s
schedule function naangiskhan:hell_cauldron/round_sequence 1s