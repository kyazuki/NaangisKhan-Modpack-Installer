#function naangiskhan:cow_sorting/calculate_scores
execute unless entity @a[tag=cow_sorting_player] run return
scoreboard players set @e[tag=cow_sorting_center] ngk_tmp 0
execute at @e[tag=cow_sorting_center] as @e[tag=cow_sorting,distance= ..10] at @s run function naangiskhan:cow_sorting/check
tellraw @a[predicate=naangiskhan:in_event_dim] ""
tellraw @a[predicate=naangiskhan:in_event_dim] ["=====",{"text":"リザルト", "underlined":true,"bold":true},"====="]
execute as @e[tag=cow_sorting_center] at @s if entity @a[distance=..10, tag=cow_sorting_player] run tellraw @a[predicate=naangiskhan:in_event_dim] [{"selector":"@a[tag=cow_sorting_player,sort=nearest,limit=1]"},": ",{"score":{"name":"@s","objective":"ngk_tmp","bold":true}}]
tellraw @a[predicate=naangiskhan:in_event_dim] ["================"]