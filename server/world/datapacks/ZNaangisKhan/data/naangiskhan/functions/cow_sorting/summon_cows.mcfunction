#function naangiskhan:cow_sorting/summon_cows
scoreboard players remove @s ngk_tmp 1
summon minecraft:mooshroom ~ ~ ~ {Tags:["cow_sorting"], Invulnerable:1b}
summon friendsandfoes:moobloom ~ ~ ~ {Tags:["cow_sorting"], Invulnerable:1b}
execute if score @s ngk_tmp matches 1.. run function naangiskhan:cow_sorting/summon_cows