import crafttweaker.api.food.FoodProperties;

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
}