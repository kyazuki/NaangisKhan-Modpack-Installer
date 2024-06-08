#function naangiskhan:countdowns/buzzer_sequence

execute unless score buzzer ngk_tmp matches 0 as @a[tag=show_buzzer] at @s run playsound supplementaries:block.clock.tick_1 master @s ~ ~ ~ 1
execute if score buzzer ngk_tmp matches 0 as @a[tag=show_buzzer] at @s run playsound create:whistle_high master @s ~ ~ ~ 1 1.4
title @a[tag=show_buzzer] title {"score":{"name":"buzzer","objective":"ngk_tmp"}}
scoreboard players remove buzzer ngk_tmp 1
execute if score buzzer ngk_tmp matches 0.. run schedule function naangiskhan:countdowns/buzzer_sequence 1s replace
execute if score buzzer ngk_tmp matches -1 run scoreboard players reset buzzer ngk_tmp
execute if score buzzer ngk_tmp matches -1 run tag @a[tag=show_buzzer] remove show_buzzer