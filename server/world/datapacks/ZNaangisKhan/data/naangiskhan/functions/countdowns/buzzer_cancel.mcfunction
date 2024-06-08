#function naangiskhan:countdowns/buzzer_cancel
schedule clear naangiskhan:countdowns/buzzer_sequence
tag @a[tag=show_buzzer] remove show_buzzer
scoreboard players reset buzzer ngk_tmp