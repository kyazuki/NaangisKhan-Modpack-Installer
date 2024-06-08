#function naangiskhan:countdowns/timer_cancel
schedule clear naangiskhan:countdowns/timer_sequence
tag @a[tag=show_timer] remove show_timer
scoreboard players reset timer ngk_tmp
scoreboard players reset timer_min ngk_tmp
scoreboard players reset timer_sec ngk_tmp