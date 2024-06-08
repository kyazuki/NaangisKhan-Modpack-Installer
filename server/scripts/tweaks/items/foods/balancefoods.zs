import crafttweaker.api.food.FoodProperties;
import crafttweaker.api.entity.effect.MobEffectInstance;

public function balanceFoods() as void {
    <item:aether:enchanted_berry>.setFood(
        FoodProperties.create(4, 0.5)
    );
    <item:aetherdelight:bowl_of_enchanted_berries>.setFood(
        FoodProperties.create(13, 0.6)
    );
    <item:aetherdelight:bowl_of_ginger_cookies>.setFood(
        FoodProperties.create(6, 0.5)
    );
    <item:croptopia:apple_pie>.setFood(
        FoodProperties.create(10, 0.25)
    );
    <item:croptopia:cherry_pie>.setFood(
        FoodProperties.create(10, 0.25)
    );
    <item:croptopia:pecan_pie>.setFood(
        FoodProperties.create(10, 0.25)
    );
    <item:croptopia:rhubarb_pie>.setFood(
        FoodProperties.create(10, 0.25)
    );
    <item:croptopia:banana_cream_pie>.setFood(
        FoodProperties.create(10, 0.25)
    );
    <item:croptopia:shepherds_pie>.setFood(
        FoodProperties.create(12, 0.7)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:nourishment>, 6000, 0, true, true, true), 1)
    );
    <item:croptopia:pizza>.setFood(
        FoodProperties.create(13, 0.6)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:nourishment>, 6000, 0, true, true, true), 1)
    );
    <item:croptopia:cheese_pizza>.setFood(
        FoodProperties.create(15, 0.8)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:nourishment>, 6000, 0, true, true, true), 1)
        .addEffect(new MobEffectInstance(<mobeffect:quark:resilience>, 6000, 1, true, true, true), 1)
    );
    <item:croptopia:pineapple_pepperoni_pizza>.setFood(
        FoodProperties.create(15, 0.8)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:nourishment>, 6000, 0, true, true, true), 1)
        .addEffect(new MobEffectInstance(<mobeffect:minecraft:luck>, 6000, 1, true, true, true), 1)
    );
    <item:croptopia:anchovy_pizza>.setFood(
        FoodProperties.create(15, 0.8)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:nourishment>, 6000, 0, true, true, true), 1)
        .addEffect(new MobEffectInstance(<mobeffect:botania:soul_cross>, 6000, 1, true, true, true), 1)
    );
    <item:croptopia:supreme_pizza>.setFood(
        FoodProperties.create(18, 0.8)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:nourishment>, 9600, 0, true, true, true), 1)
        .addEffect(new MobEffectInstance(<mobeffect:ars_nouveau:shielding>, 6000, 1, true, true, true), 1)
    );
    <item:croptopia:yam_jam>.setFood(
        FoodProperties.create(4, 0.5)
    );
    <item:croptopia:mango_ice_cream>.setFood(
        FoodProperties.create(6, 0.5)
        .addEffect(new MobEffectInstance(<mobeffect:botania:allure>, 600, 0, true, true, true), 1)
    );
    <item:croptopia:pecan_ice_cream>.setFood(
        FoodProperties.create(6, 0.5)
        .addEffect(new MobEffectInstance(<mobeffect:minecraft:invisibility>, 600, 0, true, true, true), 1)
    );
    <item:croptopia:strawberry_ice_cream>.setFood(
        FoodProperties.create(6, 0.5)
        .addEffect(new MobEffectInstance(<mobeffect:minecraft:jump_boost>, 600, 0, true, true, true), 1)
    );
    <item:croptopia:vanilla_ice_cream>.setFood(
        FoodProperties.create(6, 0.5)
        .addEffect(new MobEffectInstance(<mobeffect:botania:feather_feet>, 600, 0, true, true, true), 1)
    );
    <item:croptopia:rum_raisin_ice_cream>.setFood(
        FoodProperties.create(6, 0.5)
        .addEffect(new MobEffectInstance(<mobeffect:ars_nouveau:mana_regen>, 600, 0, true, true, true), 1)
    );
    <item:croptopia:chocolate_ice_cream>.setFood(
        FoodProperties.create(6, 0.5)
        .addEffect(new MobEffectInstance(<mobeffect:create_confectionery:stimulation>, 600, 0, true, true, true), 1)
    );
    <item:croptopia:kiwi_sorbet>.setFood(
        FoodProperties.create(6, 0.5)
    );
    <item:croptopia:raisin_oatmeal_cookie>.setFood(
        FoodProperties.create(3, 0.25)
    );
    <item:croptopia:nutty_cookie>.setFood(
        FoodProperties.create(2, 0.25)
    );
    <item:croptopia:lemon_coconut_bar>.setFood(
        FoodProperties.create(4, 0.25)
    );
    <item:croptopia:rhubarb_crisp>.setFood(
        FoodProperties.create(4, 0.25)
    );
    <item:croptopia:pumpkin_bars>.setFood(
        FoodProperties.create(6, 0.5)
    );
    <item:croptopia:protein_bar>.setFood(
        FoodProperties.create(10, 0.3)
    );
    <item:croptopia:beef_jerky>.setFood(
        FoodProperties.create(5, 0.25)
    );
    <item:croptopia:pork_jerky>.setFood(
        FoodProperties.create(5, 0.25)
    );
    <item:croptopia:baked_crepes>.setFood(
        FoodProperties.create(8, 0.25)
    );
    <item:croptopia:sweet_crepes>.setFood(
        FoodProperties.create(5, 0.25)
    );
    <item:croptopia:blt>.setFood(
        FoodProperties.create(14, 1.2)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 6000, 0, true, true, true), 1)
    );
    <item:croptopia:banana_nut_bread>.setFood(
        FoodProperties.create(10, 0.9)
    );
    <item:croptopia:beetroot_salad>.setFood(
        FoodProperties.create(12, 0.6)
    );
    <item:croptopia:cucumber_salad>.setFood(
        FoodProperties.create(12, 0.5)
    );
    <item:croptopia:caesar_salad>.setFood(
        FoodProperties.create(12, 0.5)
    );
    <item:croptopia:leafy_salad>.setFood(
        FoodProperties.create(11, 0.5)
    );
    <item:croptopia:fruit_salad>.setFood(
        FoodProperties.create(8, 0.4)
    );
    <item:croptopia:veggie_salad>.setFood(
        FoodProperties.create(11, 0.5)
    );
    <item:croptopia:peanut_butter>.setFood(
        FoodProperties.create(6, 0.5)
    );
    <item:croptopia:toast>.setFood(
        FoodProperties.create(6, 0.5)
    );
    <item:croptopia:peanut_butter_and_jam>.setFood(
        FoodProperties.create(11, 0.8)
    );
    <item:croptopia:peanut_butter_with_celery>.setFood(
        FoodProperties.create(7, 0.25)
    );
    <item:croptopia:borscht>.setFood(
        FoodProperties.create(11, 0.7)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 6000, 0, true, true, true), 1)
    );
    <item:croptopia:brownies>.setFood(
        FoodProperties.create(11, 0.3)
    );
    <item:croptopia:burrito>.setFood(
        FoodProperties.create(10, 0.6)
    );
    <item:croptopia:tortilla>.setFood(
        FoodProperties.create(4, 0.4)
    );
    <item:croptopia:tostada>.setFood(
        FoodProperties.create(10, 0.5)
    );
    <item:croptopia:trail_mix>.setFood(
        FoodProperties.create(8, 1)
    );
    <item:croptopia:tres_leche_cake>.setFood(
        FoodProperties.create(8, 0.5)
    );
    <item:croptopia:tuna_roll>.setFood(
        FoodProperties.create(7, 0.5)
    );
    <item:croptopia:yoghurt>.setFood(
        FoodProperties.create(6, 0.5)
    );
    <item:croptopia:toast>.setFood(
        FoodProperties.create(6, 0.5)
    );
    <item:croptopia:buttered_toast>.setFood(
        FoodProperties.create(9, 0.6)
    );
    <item:croptopia:toast_with_jam>.setFood(
        FoodProperties.create(9, 0.8)
    );
    <item:croptopia:ajvar_toast>.setFood(
        FoodProperties.create(14, 0.8)
    );
    <item:croptopia:avocado_toast>.setFood(
        FoodProperties.create(7, 0.8)
    );
    <item:croptopia:snicker_doodle>.setFood(
        FoodProperties.create(2,0.25)
    );
    <item:croptopia:stuffed_artichoke>.setFood(
        FoodProperties.create(18,0.4)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 3600, 0, true, true, true), 1)
    );
    <item:croptopia:stir_fry>.setFood(
        FoodProperties.create(10,0.8)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 3600, 0, true, true, true), 1)
    );
    <item:croptopia:beef_stir_fry>.setFood(
        FoodProperties.create(16,0.6)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 6000, 0, true, true, true), 1)
    );
    <item:croptopia:sticky_toffee_pudding>.setFood(
        FoodProperties.create(14,0.4)
    );
    <item:croptopia:figgy_pudding>.setFood(
        FoodProperties.create(14,0.4)
    );
    <item:croptopia:steamed_broccoli>.setFood(
        FoodProperties.create(7,0.7)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 3600, 0, true, true, true), 1)
    );
    <item:croptopia:steamed_green_beans>.setFood(
        FoodProperties.create(7,0.7)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 3600, 0, true, true, true), 1)
    );
    <item:croptopia:buttered_green_beans>.setFood(
        FoodProperties.create(9,0.6)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 3600, 0, true, true, true), 1)
    );
    <item:croptopia:scones>.setFood(
        FoodProperties.create(10,0.4)
    );
    <item:croptopia:roasted_turnips>.setFood(
        FoodProperties.create(9,0.6)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 3600, 0, true, true, true), 1)
    );
    <item:croptopia:roasted_radishes>.setFood(
        FoodProperties.create(9,0.6)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 3600, 0, true, true, true), 1)
    );
    <item:croptopia:roasted_squash>.setFood(
        FoodProperties.create(9,0.6)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 3600, 0, true, true, true), 1)
    );
    <item:croptopia:roasted_asparagus>.setFood(
        FoodProperties.create(9,0.6)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 3600, 0, true, true, true), 1)
    );
    <item:croptopia:pumpkin_soup>.setFood(
        FoodProperties.create(6,0.8)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 3600, 0, true, true, true), 1)
    );
    <item:croptopia:leek_soup>.setFood(
        FoodProperties.create(12,0.8)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 6000, 0, true, true, true), 1)
    );
    <item:croptopia:potato_soup>.setFood(
        FoodProperties.create(13,0.8)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 6000, 0, true, true, true), 1)
    );
    <item:croptopia:nether_wart_stew>.setFood(
        FoodProperties.create(9,0.6)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 6000, 0, true, true, true), 1)
    );
    <item:croptopia:fruit_cake>.setFood(
        FoodProperties.create(12,0.6)
    );
    <item:croptopia:fish_and_chips>.setFood(
        FoodProperties.create(12,0.5)
    );
    <item:croptopia:french_fries>.setFood(
        FoodProperties.create(5,0.6)
    );
    <item:croptopia:eggplant_parmesan>.setFood(
        FoodProperties.create(16,0.6)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:nourishment>, 3600, 0, true, true, true), 1)
    );
    <item:croptopia:cornish_pasty>.setFood(
        FoodProperties.create(10,0.7)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:nourishment>, 3600, 0, true, true, true), 1)
    );
    <item:croptopia:ajvar>.setFood(
        FoodProperties.create(7,0.6)
    );
    <item:croptopia:saucy_chips>.setFood(
        FoodProperties.create(14,0.5)
    );
    <item:croptopia:potato_chips>.setFood(
        FoodProperties.create(3,0.3)
    );
    <item:croptopia:salsa>.setFood(
        FoodProperties.create(6,0.5)
    );
    <item:croptopia:artichoke_dip>.setFood(
        FoodProperties.create(6,0.5)
    );
    <item:croptopia:roasted_nuts>.setFood(
        FoodProperties.create(4,0.5)
    );
    <item:croptopia:candy_corn>.setFood(
        FoodProperties.create(4,0.4)
    );
    <item:croptopia:carnitas>.setFood(
        FoodProperties.create(13,0.8)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 6000, 0, true, true, true), 1)
    );
    <item:croptopia:cashew_chicken>.setFood(
        FoodProperties.create(13,0.6)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:nourishment>, 3600, 0, true, true, true), 1)
    );
    <item:croptopia:cheeseburger>.setFood(
        FoodProperties.create(13,0.6)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:nourishment>, 600, 0, true, true, true), 1)
        .addEffect(new MobEffectInstance(<mobeffect:minecraft:resistance>, 600, 0, true, true, true), 1)
    );
    <item:croptopia:hamburger>.setFood(
        FoodProperties.create(13,0.6)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:nourishment>, 600, 0, true, true, true), 1)
        .addEffect(new MobEffectInstance(<mobeffect:minecraft:resistance>, 600, 0, true, true, true), 1)
    );
    <item:croptopia:tofuburger>.setFood(
        FoodProperties.create(13,0.6)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:nourishment>, 600, 0, true, true, true), 1)
        .addEffect(new MobEffectInstance(<mobeffect:minecraft:resistance>, 600, 0, true, true, true), 1)
    );
    <item:croptopia:chicken_and_dumplings>.setFood(
        FoodProperties.create(13,0.6)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:nourishment>, 3600, 0, true, true, true), 1)
    );
    <item:croptopia:chicken_and_noodles>.setFood(
        FoodProperties.create(13,0.6)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:nourishment>, 6000, 0, true, true, true), 1)
    );
    <item:croptopia:chimichanga>.setFood(
        FoodProperties.create(14,0.6)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:nourishment>, 1200, 0, true, true, true), 1)
    );
    <item:croptopia:chili_relleno>.setFood(
        FoodProperties.create(11,0.5)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 1200, 0, true, true, true), 1)
    );
    <item:croptopia:steamed_crab>.setFood(
        FoodProperties.create(6,0.5)
    );
    <item:croptopia:crab_legs>.setFood(
        FoodProperties.create(13,0.6)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:nourishment>, 1200, 0, true, true, true), 1)
    );
    <item:croptopia:croque_monsieur>.setFood(
        FoodProperties.create(13,0.6)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:nourishment>, 1200, 0, true, true, true), 1)
    );
    <item:croptopia:croque_madame>.setFood(
        FoodProperties.create(13,0.6)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:nourishment>, 1200, 0, true, true, true), 1)
    );
    <item:croptopia:beef_stew>.setFood(
        FoodProperties.create(10, 0.5)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 1200, 0, true, true, true), 1)
    );
    <item:croptopia:dauphine_potatoes>.setFood(
        FoodProperties.create(12, 0.5)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 1200, 0, true, true, true), 1)
    );
    <item:croptopia:doughnut>.setFood(
        FoodProperties.create(8, 0.25)
    );
    <item:croptopia:egg_roll>.setFood(
        FoodProperties.create(10, 0.5)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 600, 0, true, true, true), 1)
    );
    <item:croptopia:enchilada>.setFood(
        FoodProperties.create(10, 0.6)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 600, 0, true, true, true), 1)
    );
    <item:croptopia:fajitas>.setFood(
        FoodProperties.create(15, 0.7)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:nourishment>, 1200, 0, true, true, true), 1)
    );
    <item:croptopia:refried_beans>.setFood(
        FoodProperties.create(13, 0.6)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 1200, 0, true, true, true), 1)
    );
    <item:croptopia:fried_calamari>.setFood(
        FoodProperties.create(11, 0.7  )
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 1200, 0, true, true, true), 1)
    );
    <item:croptopia:deep_fried_shrimp>.setFood(
        FoodProperties.create(10, 0.7)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 1200, 0, true, true, true), 1)
    );
    <item:croptopia:fried_chicken>.setFood(
        FoodProperties.create(11, 0.7)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 1200, 0, true, true, true), 1)
    );
    <item:croptopia:fried_frog_legs>.setFood(
        FoodProperties.create(8, 0.7)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 1200, 0, true, true, true), 1)
    );
    <item:croptopia:mashed_potatoes>.setFood(
        FoodProperties.create(8, 0.5)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 600, 0, true, true, true), 1)
    );
    <item:croptopia:lemon_chicken>.setFood(
        FoodProperties.create(10, 0.8)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:nourishment>, 1200, 0, true, true, true), 1)
    );
    <item:croptopia:goulash>.setFood(
        FoodProperties.create(13, 0.6)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 1200, 0, true, true, true), 1)
    );
    <item:croptopia:meringue>.setFood(
        FoodProperties.create(6, 0.4)
    );
    <item:croptopia:nougat>.setFood(
        FoodProperties.create(6, 1)
    );
    <item:croptopia:pork_and_beans>.setFood(
        FoodProperties.create(10, 0.6)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:nourishment>, 1200, 0, true, true, true), 1)
    );
    <item:croptopia:quesadilla>.setFood(
        FoodProperties.create(10, 0.6)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:nourishment>, 1200, 0, true, true, true), 1)
    );
    <item:croptopia:quiche>.setFood(
        FoodProperties.create(12, 0.6)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 3600, 0, true, true, true), 1)
    );
    <item:croptopia:ravioli>.setFood(
        FoodProperties.create(4, 0.3)
    );
    <item:croptopia:sushi>.setFood(
        FoodProperties.create(12, 0.5)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:comfort>, 3600, 0, true, true, true), 1)
    );
    <item:croptopia:taco>.setFood(
        FoodProperties.create(10, 0.7)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:nourishment>, 1200, 0, true, true, true), 1)
    );
    <item:croptopia:stuffed_poblanos>.setFood(
        FoodProperties.create(16,0.7)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:nourishment>, 1200, 0, true, true, true), 1)
    );
    <item:croptopia:tamales>.setFood(
        FoodProperties.create(10,0.6)
        .addEffect(new MobEffectInstance(<mobeffect:farmersdelight:nourishment>, 1200, 0, true, true, true), 1)
    );
    <item:croptopia:cheese_cake>.setFood(
        FoodProperties.create(15,0.5)
        .addEffect(new MobEffectInstance(<mobeffect:minecraft:speed>, 2400, 0, true, true, true), 1)
    );
    <item:croptopia:coffee>.setFood(
        FoodProperties.create(0,0)
        .setCanAlwaysEat(true)
        .addEffect(new MobEffectInstance(<mobeffect:aether_redux:adrenaline_rush>, 1200, 0, true, true, true), 1)
    );
    <item:croptopia:tea>.setFood(
        FoodProperties.create(0,0)
        .setCanAlwaysEat(true)
        .addEffect(new MobEffectInstance(<mobeffect:aether:remedy>, 600, 0, true, true, true), 1)
    );
    <item:croptopia:lemonade>.setFood(
        FoodProperties.create(1,3)
        .setCanAlwaysEat(true)
    );
    <item:croptopia:limeade>.setFood(
        FoodProperties.create(1,3)
        .setCanAlwaysEat(true)
    );
    <item:croptopia:kale_smoothie>.setFood(
        FoodProperties.create(2,2.5)
        .setCanAlwaysEat(true)
    );
    <item:croptopia:fruit_smoothie>.setFood(
        FoodProperties.create(2,2.5)
        .setCanAlwaysEat(true)
    );
    <item:croptopia:chocolate_milkshake>.setFood(
        FoodProperties.create(4,0.5)
        .setCanAlwaysEat(true)
        .addEffect(new MobEffectInstance(<mobeffect:create_confectionery:stimulation>, 1200, 0, true, true, true), 1)
    );
    <item:croptopia:pumpkin_spice_latte>.setFood(
        FoodProperties.create(6,0.5)
        .setCanAlwaysEat(true)
    );
    <item:croptopia:rum>.setFood(
        FoodProperties.create(0,0)
        .setCanAlwaysEat(true)
        .addEffect(new MobEffectInstance(<mobeffect:botania:allure>, 1200, 0, true, true, true), 1)
        .addEffect(new MobEffectInstance(<mobeffect:minecraft:unluck>, 1200, 0, true, true, true), 1)
        .addEffect(new MobEffectInstance(<mobeffect:aether:inebriation>, 600, 0, true, true, true), 0.2)
    );
    <item:croptopia:mead>.setFood(
        FoodProperties.create(0,0)
        .setCanAlwaysEat(true)
        .addEffect(new MobEffectInstance(<mobeffect:botania:bloodthirst>, 1200, 0, true, true, true), 1)
        .addEffect(new MobEffectInstance(<mobeffect:aether:inebriation>, 600, 0, true, true, true), 0.2)
    );
    <item:croptopia:beer>.setFood(
        FoodProperties.create(0,0)
        .setCanAlwaysEat(true)
        .addEffect(new MobEffectInstance(<mobeffect:botania:emptiness>, 1200, 0, true, true, true), 1)
        .addEffect(new MobEffectInstance(<mobeffect:aether:inebriation>, 600, 0, true, true, true), 0.2)
    );
    <item:croptopia:wine>.setFood(
        FoodProperties.create(0,0)
        .setCanAlwaysEat(true)
        .addEffect(new MobEffectInstance(<mobeffect:botania:clear>, 1200, 0, true, true, true), 1)
        .addEffect(new MobEffectInstance(<mobeffect:aether:inebriation>, 600, 0, true, true, true), 0.2)
    );
}