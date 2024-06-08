#function naangiskhan:hell_cauldron/interval

#パネルをリセット
execute at @e[tag=hell_cauldron_center] run place template naangiskhan:hell_cauldron/panels/default ~-7 ~ ~-7

#床を再生成
execute at @e[tag=hell_cauldron_center] run clone ~-6 ~-12 ~-6 ~6 ~-12 ~6 ~-6 ~-1 ~-6 replace normal

#1秒後に回転
execute if score ngk_hc_round ngk_tmp matches 10 run schedule function naangiskhan:hell_cauldron/rotate_floor 1s
execute if score ngk_hc_round ngk_tmp matches 15 run schedule function naangiskhan:hell_cauldron/rotate_floor 1s

execute store result score ngk_hc_survivors ngk_tmp if entity @a[tag=hell_cauldron_player_alive]
execute if score ngk_hc_player_count ngk_tmp matches 1 if score ngk_hc_round ngk_tmp matches ..19 if score ngk_hc_survivors ngk_tmp matches 1 run schedule function naangiskhan:hell_cauldron/round_start 3s
execute unless score ngk_hc_player_count ngk_tmp matches ..1 if score ngk_hc_round ngk_tmp matches ..19 if score ngk_hc_survivors ngk_tmp matches 2.. run schedule function naangiskhan:hell_cauldron/round_start 3s
execute if score ngk_hc_player_count ngk_tmp matches 1 if score ngk_hc_round ngk_tmp matches ..19 if score ngk_hc_survivors ngk_tmp matches 0 run schedule function naangiskhan:hell_cauldron/result
execute unless score ngk_hc_player_count ngk_tmp matches ..1 if score ngk_hc_round ngk_tmp matches ..19 if score ngk_hc_survivors ngk_tmp matches ..1 run function naangiskhan:hell_cauldron/result
execute if score ngk_hc_round ngk_tmp matches 20.. run function naangiskhan:hell_cauldron/result