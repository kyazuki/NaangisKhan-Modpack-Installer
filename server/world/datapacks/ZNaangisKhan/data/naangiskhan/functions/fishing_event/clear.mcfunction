#function naangiskhan:fishing_event/clear

scoreboard players set fishing_event_active ngk_persistent 0
scoreboard objectives setdisplay sidebar
clear @a croptopia:salt

#cancel timers
function naangiskhan:countdowns/ding_cancel
function naangiskhan:countdowns/buzzer_cancel
function naangiskhan:countdowns/timer_cancel