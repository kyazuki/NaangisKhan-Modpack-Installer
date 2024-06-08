#function naangiskhan:fishing_event/calculate_self
execute store result score @s ngk_tmp run clear @s croptopia:salt
scoreboard players operation @s ngk_tmp *= fishing_event_baitbag_score ngk_persistent
scoreboard players operation @s fishing_event += @s ngk_tmp
scoreboard players reset @s ngk_tmp