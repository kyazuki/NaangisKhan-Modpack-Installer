#function naangiskhan:hell_cauldron/reset

#パネルを初期状態に戻す
execute at @e[tag=hell_cauldron_center] run place template naangiskhan:hell_cauldron/panels/default ~-7 ~ ~-7
#床を初期状態に戻す
execute at @e[tag=hell_cauldron_center] run fill ~-6 ~-1 ~-6 ~6 ~-1 ~6 quark:framed_glass
#最下層を初期状態に戻す
execute at @e[tag=hell_cauldron_center] run fill ~-6 ~-12 ~-6 ~6 ~-12 ~6 minecraft:bedrock

#落下中のプレイヤーがいれば回収する
function naangiskhan:hell_cauldron/check_dropout

#使用したスコアをクリア
function naangiskhan:random/clear
scoreboard players reset ngk_hc_round ngk_tmp
scoreboard players reset ngk_hc_timer ngk_tmp
scoreboard players reset ngk_hc_height ngk_tmp
scoreboard players reset ngk_hc_survivors ngk_tmp
scoreboard players reset ngk_hc_floor_pattern ngk_tmp
scoreboard players reset ngk_hc_player_count ngk_tmp
scoreboard players reset @e[tag=hell_cauldron_player] ngk_tmp


##スケジュールをクリア
function naangiskhan:countdowns/timer_cancel
function naangiskhan:countdowns/ding_cancel
schedule clear naangiskhan:hell_cauldron/round_start
schedule clear naangiskhan:hell_cauldron/round_sequence
schedule clear naangiskhan:hell_cauldron/interval
schedule clear naangiskhan:hell_cauldron/check_dropout

#タグをクリア
execute as @e[tag=hell_cauldron_center] at @s positioned ~ ~8 ~ run tp @a[distance=..4] @s
tag @a[tag=hell_cauldron_player_dead] remove hell_cauldron_player_dead
tag @a[tag=hell_cauldron_player_alive] remove hell_cauldron_player_alive
tag @a[tag=hell_cauldron_player] remove hell_cauldron_player

scoreboard players set hell_cauldron_active ngk_persistent 0