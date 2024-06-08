#function naangiskhan:cow_sorting/start
execute at @e[tag=cow_sorting_center] run tag @p[distance=..10] add cow_sorting_player
function naangiskhan:countdowns/ding_start
tag @a[predicate=naangiskhan:in_event_dim] add show_timer
scoreboard players set timer ngk_tmp 60
schedule function naangiskhan:countdowns/timer_sequence 3s
schedule function naangiskhan:countdowns/buzzer_start 58s
schedule function naangiskhan:cow_sorting/calculate_scores 63s
scoreboard players set cow_sorting_active ngk_persistent 1