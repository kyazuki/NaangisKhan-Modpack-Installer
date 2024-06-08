#function ngk:cow_sorting_toggle
execute unless score cow_sorting_active ngk_persistent matches 1 run schedule function naangiskhan:cow_sorting/start 1t
execute if score cow_sorting_active ngk_persistent matches 1 run schedule function naangiskhan:cow_sorting/reset 1t