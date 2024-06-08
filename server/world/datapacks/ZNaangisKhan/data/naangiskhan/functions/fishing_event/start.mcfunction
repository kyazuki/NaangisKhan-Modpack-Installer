#function naangiskhan:fishing_event/start
scoreboard players set fishing_event_active ngk_persistent 1
scoreboard players set @a fishing_event 0
scoreboard objectives setdisplay sidebar fishing_event

tag @a add show_ding
scoreboard players set ding ngk_tmp 3
function naangiskhan:countdowns/ding_sequence
tag @a add show_timer
scoreboard players set timer ngk_tmp 120
schedule function naangiskhan:countdowns/timer_sequence 3s
tag @a add show_buzzer
scoreboard players set buzzer ngk_tmp 5
schedule function naangiskhan:countdowns/buzzer_sequence 118s
schedule function naangiskhan:fishing_event/calculate 133s