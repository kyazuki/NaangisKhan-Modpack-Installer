#function naangiskhan:countdowns/ding_cancel
schedule clear naangiskhan:countdowns/ding_sequence
tag @a[tag=show_ding] remove show_ding
scoreboard players reset ding ngk_tmp