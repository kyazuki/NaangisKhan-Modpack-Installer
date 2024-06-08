#function naangiskhan:cow_sorting/reset
tag @e[tag=cow_sorting] add cow_sorting_reset
effect clear @e[tag=cow_sorting_reset]
execute as @e[tag=cow_sorting_reset] at @s run tp @s ~ -100 ~
schedule function naangiskhan:cow_sorting/kill_reset_cows 8t
scoreboard players set @e[tag=cow_sorting_center] ngk_tmp 15
execute as @e[tag=cow_sorting_center] at @s run function naangiskhan:cow_sorting/summon_cows
tag @a[tag=cow_sorting_player] remove cow_sorting_player
scoreboard players reset @e[tag=cow_sorting_center] ngk_tmp
execute as @e[tag=cow_sorting_center] at @s unless block ~ ~-1 ~ minecraft:red_concrete run kill @s

#cancel timers
schedule clear naangiskhan:countdowns/buzzer_start
schedule clear naangiskhan:cow_sorting/calculate_scores
function naangiskhan:countdowns/ding_cancel
function naangiskhan:countdowns/buzzer_cancel
function naangiskhan:countdowns/timer_cancel

scoreboard players set cow_sorting_active ngk_persistent 0