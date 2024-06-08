#function ngk:hell_cauldron_toggle
execute unless score hell_cauldron_active ngk_persistent matches 1 run schedule function naangiskhan:hell_cauldron/start 1t
execute if score hell_cauldron_active ngk_persistent matches 1 run schedule function naangiskhan:hell_cauldron/reset 1t