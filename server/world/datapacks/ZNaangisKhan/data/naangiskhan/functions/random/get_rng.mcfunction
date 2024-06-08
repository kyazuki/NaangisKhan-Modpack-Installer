summon minecraft:area_effect_cloud ~ ~ ~ {Tags:["ngk_random"]}
execute store result score ngk_rng0 ngk_tmp run data get entity @e[tag=ngk_random,limit=1] UUID[0]
execute store result score ngk_rng1 ngk_tmp run data get entity @e[tag=ngk_random,limit=1] UUID[1]
execute store result score ngk_rng2 ngk_tmp run data get entity @e[tag=ngk_random,limit=1] UUID[2]
execute store result score ngk_rng3 ngk_tmp run data get entity @e[tag=ngk_random,limit=1] UUID[3]
kill @e[tag=ngk_random]