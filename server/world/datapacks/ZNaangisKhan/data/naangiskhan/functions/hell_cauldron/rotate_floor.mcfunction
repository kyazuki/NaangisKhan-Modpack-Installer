#function naangiskhan:hell_cauldron/rotate_floor

execute at @e[tag=hell_cauldron_center] run function naangiskhan:random/get_rng
#保存されていた床パターンを使う
scoreboard players operation ngk_rng0 ngk_tmp = ngk_hc_floor_pattern ngk_tmp
#回転を決める
scoreboard players operation ngk_rng1 ngk_tmp %= const_4 ngk_persistent
#反転を決める
scoreboard players operation ngk_rng2 ngk_tmp %= const_2 ngk_persistent

execute if score ngk_rng0 ngk_tmp matches 0 at @e[tag=hell_cauldron_center] run function naangiskhan:hell_cauldron/floor_patterns/generate_pattern_1
execute if score ngk_rng0 ngk_tmp matches 1 at @e[tag=hell_cauldron_center] run function naangiskhan:hell_cauldron/floor_patterns/generate_pattern_2
execute if score ngk_rng0 ngk_tmp matches 2 at @e[tag=hell_cauldron_center] run function naangiskhan:hell_cauldron/floor_patterns/generate_pattern_3
execute if score ngk_rng0 ngk_tmp matches 3 at @e[tag=hell_cauldron_center] run function naangiskhan:hell_cauldron/floor_patterns/generate_pattern_4

#効果音を鳴らす
execute as @a[tag=hell_cauldron_player] at @s run playsound minecraft:entity.elder_guardian.curse master @s ~ ~ ~ 1 0.5

#床を生成
execute at @e[tag=hell_cauldron_center] run clone ~-6 ~-12 ~-6 ~6 ~-12 ~6 ~-6 ~-1 ~-6 replace normal