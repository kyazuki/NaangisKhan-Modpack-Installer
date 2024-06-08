#function naangiskhan:cow_sorting/check
data modify entity @s NoAI set value 1b
execute if entity @s[type=minecraft:mooshroom] if block ~ ~-1 ~ minecraft:red_concrete run tag @s add cow_sorting_counted
execute if entity @s[type=friendsandfoes:moobloom] if block ~ ~-1 ~ minecraft:yellow_concrete run tag @s add cow_sorting_counted
execute if entity @s[tag=cow_sorting_counted] run effect give @s minecraft:glowing infinite 1 true
execute if entity @s[tag=cow_sorting_counted] run scoreboard players add @e[tag=cow_sorting_center, distance=..10, sort=nearest, limit=1] ngk_tmp 1