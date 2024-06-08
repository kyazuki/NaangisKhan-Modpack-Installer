#function naangiskhan:hell_cauldron/generate_floor

execute at @e[tag=hell_cauldron_center] run function naangiskhan:random/get_rng
#床パターンを決める
scoreboard players operation ngk_rng0 ngk_tmp %= const_4 ngk_persistent
#回転を決める
scoreboard players operation ngk_rng1 ngk_tmp %= const_4 ngk_persistent
#反転を決める
scoreboard players operation ngk_rng2 ngk_tmp %= const_2 ngk_persistent

execute if score ngk_rng0 ngk_tmp matches 0 at @e[tag=hell_cauldron_center] run function naangiskhan:hell_cauldron/floor_patterns/generate_pattern_1
execute if score ngk_rng0 ngk_tmp matches 1 at @e[tag=hell_cauldron_center] run function naangiskhan:hell_cauldron/floor_patterns/generate_pattern_2
execute if score ngk_rng0 ngk_tmp matches 2 at @e[tag=hell_cauldron_center] run function naangiskhan:hell_cauldron/floor_patterns/generate_pattern_3
execute if score ngk_rng0 ngk_tmp matches 3 at @e[tag=hell_cauldron_center] run function naangiskhan:hell_cauldron/floor_patterns/generate_pattern_4

#床パターンを保存
scoreboard players operation ngk_hc_floor_pattern ngk_tmp = ngk_rng0 ngk_tmp