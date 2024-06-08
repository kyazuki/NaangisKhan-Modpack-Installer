#naangiskhan:init
scoreboard objectives add ngk_tmp dummy
scoreboard objectives add ngk_persistent dummy
scoreboard objectives add fishing_event minecraft.custom:minecraft.fish_caught "釣った数"

#数値
scoreboard players set const_60 ngk_persistent 60
scoreboard players set const_16 ngk_persistent 16
scoreboard players set const_4 ngk_persistent 4
scoreboard players set const_2 ngk_persistent 2
#餌袋が釣れ、スコアが反映される状態
scoreboard players set fishing_event_active ngk_persistent 0
#釣り餌1個あたりのスコア
scoreboard players set fishing_event_baitbag_score ngk_persistent 5