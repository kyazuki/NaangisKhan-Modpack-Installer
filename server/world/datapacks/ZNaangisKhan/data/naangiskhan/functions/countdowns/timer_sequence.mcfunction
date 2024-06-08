#function naangiskhan:countdowns/timer_sequence
scoreboard players operation timer_min ngk_tmp = timer ngk_tmp
scoreboard players operation timer_min ngk_tmp /= const_60 ngk_persistent
scoreboard players operation timer_sec ngk_tmp = timer ngk_tmp
scoreboard players operation timer_sec ngk_tmp %= const_60 ngk_persistent

execute if score timer_min ngk_tmp matches ..9 run scoreboard players set timer_placeholder_min ngk_tmp 0
execute if score timer_sec ngk_tmp matches ..9 run scoreboard players set timer_placeholder_sec ngk_tmp 0

title @a[tag=show_timer] actionbar [{"score":{"name":"timer_placeholder_min","objective":"ngk_tmp"}},{"score":{"name":"timer_min","objective":"ngk_tmp"}},":",{"score":{"name":"timer_placeholder_sec","objective":"ngk_tmp"}},{"score":{"name":"timer_sec","objective":"ngk_tmp"}}]
scoreboard players reset timer_placeholder_min ngk_tmp
scoreboard players reset timer_placeholder_sec ngk_tmp

scoreboard players remove timer ngk_tmp 1
execute if score timer ngk_tmp matches 0.. run schedule function naangiskhan:countdowns/timer_sequence 1s replace
execute if score timer ngk_tmp matches ..-1 run function naangiskhan:countdowns/timer_cancel