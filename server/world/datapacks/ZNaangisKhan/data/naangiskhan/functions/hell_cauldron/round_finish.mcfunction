#function naangiskhan:hell_cauldron/round_finish
execute as @a[tag=hell_cauldron_player] at @s run playsound minecraft:block.lava.extinguish master @s ~ ~ ~ 1 1
execute at @e[tag=hell_cauldron_center] run function naangiskhan:hell_cauldron/remove_floors
schedule function naangiskhan:hell_cauldron/interval 3s
schedule function naangiskhan:hell_cauldron/check_dropout 15t append
schedule function naangiskhan:hell_cauldron/check_dropout 1s append
schedule function naangiskhan:hell_cauldron/check_dropout 25t append
schedule function naangiskhan:hell_cauldron/check_dropout 30t append
schedule function naangiskhan:hell_cauldron/check_dropout 35t append
schedule function naangiskhan:hell_cauldron/check_dropout 2s append
schedule function naangiskhan:hell_cauldron/check_dropout 45t append
schedule function naangiskhan:hell_cauldron/check_dropout 50t append