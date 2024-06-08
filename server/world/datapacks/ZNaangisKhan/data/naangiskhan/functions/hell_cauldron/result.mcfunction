#function naangiskhan:hell_cauldron/result
execute unless entity @a[tag=hell_cauldron_player] run return
tellraw @a[predicate=naangiskhan:in_event_dim] ""
tellraw @a[predicate=naangiskhan:in_event_dim] ["=====",{"text":"リザルト", "underlined":true,"bold":true,"color":"red"},"====="]
tellraw @a[predicate=naangiskhan:in_event_dim] ["ラウンド数: ",{"score":{"name":"ngk_hc_round","objective":"ngk_tmp","bold":true}}]
tellraw @a[predicate=naangiskhan:in_event_dim] "生存者: "
execute as @a[tag=hell_cauldron_player_alive] run tellraw @a[predicate=naangiskhan:in_event_dim] {"selector":"@s"}
execute if score ngk_hc_survivors ngk_tmp matches ..0 run tellraw @a[predicate=naangiskhan:in_event_dim] "なし"
tellraw @a[predicate=naangiskhan:in_event_dim] ["================"]