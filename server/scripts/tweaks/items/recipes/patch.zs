import crafttweaker.api.ingredient.type.IIngredientEmpty;

// 緊急パッチ用の処理
public function patch() as void {
    val empty = IIngredientEmpty.INSTANCE;

    // 重複対策
    recipes.remove(<item:tofucraft:filtercloth>);
    craftingTable.addShaped(
        "naangiskhan/tofu/filtercloth",
        <item:tofucraft:filtercloth> * 16,
        [[empty,empty,empty],
        [<item:minecraft:string>,<tag:items:minecraft:wool>,<item:minecraft:string>],
        [empty,empty,empty]]
    );

    recipes.remove(<item:handcrafted:acacia_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/acacia_pillar_trim",
        <item:handcrafted:acacia_pillar_trim> * 16,
        [[empty,<item:minecraft:acacia_planks>,empty],
        [empty,<item:minecraft:acacia_planks>,<item:minecraft:acacia_planks>],
        [empty,<item:minecraft:acacia_planks>,empty]]
    );
    recipes.remove(<item:handcrafted:bamboo_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/bamboo_pillar_trim",
        <item:handcrafted:bamboo_pillar_trim> * 16,
        [[empty,<item:minecraft:bamboo_planks>,empty],
        [empty,<item:minecraft:bamboo_planks>,<item:minecraft:bamboo_planks>],
        [empty,<item:minecraft:bamboo_planks>,empty]]
    );
    recipes.remove(<item:handcrafted:birch_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/birch_pillar_trim",
        <item:handcrafted:birch_pillar_trim> * 16,
        [[empty,<item:minecraft:birch_planks>,empty],
        [empty,<item:minecraft:birch_planks>,<item:minecraft:birch_planks>],
        [empty,<item:minecraft:birch_planks>,empty]]
    );
    recipes.remove(<item:handcrafted:cherry_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/cherry_pillar_trim",
        <item:handcrafted:cherry_pillar_trim> * 16,
        [[empty,<item:minecraft:cherry_planks>,empty],
        [empty,<item:minecraft:cherry_planks>,<item:minecraft:cherry_planks>],
        [empty,<item:minecraft:cherry_planks>,empty]]
    );
    recipes.remove(<item:handcrafted:crimson_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/crimson_pillar_trim",
        <item:handcrafted:crimson_pillar_trim> * 16,
        [[empty,<item:minecraft:crimson_planks>,empty],
        [empty,<item:minecraft:crimson_planks>,<item:minecraft:crimson_planks>],
        [empty,<item:minecraft:crimson_planks>,empty]]
    );
    recipes.remove(<item:handcrafted:dark_oak_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/dark_oak_pillar_trim",
        <item:handcrafted:dark_oak_pillar_trim> * 16,
        [[empty,<item:minecraft:dark_oak_planks>,empty],
        [empty,<item:minecraft:dark_oak_planks>,<item:minecraft:dark_oak_planks>],
        [empty,<item:minecraft:dark_oak_planks>,empty]]
    );
    recipes.remove(<item:handcrafted:jungle_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/jungle_pillar_trim",
        <item:handcrafted:jungle_pillar_trim> * 16,
        [[empty,<item:minecraft:jungle_planks>,empty],
        [empty,<item:minecraft:jungle_planks>,<item:minecraft:jungle_planks>],
        [empty,<item:minecraft:jungle_planks>,empty]]
    );
    recipes.remove(<item:handcrafted:mangrove_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/mangrove_pillar_trim",
        <item:handcrafted:mangrove_pillar_trim> * 16,
        [[empty,<item:minecraft:mangrove_planks>,empty],
        [empty,<item:minecraft:mangrove_planks>,<item:minecraft:mangrove_planks>],
        [empty,<item:minecraft:mangrove_planks>,empty]]
    );
    recipes.remove(<item:handcrafted:oak_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/oak_pillar_trim",
        <item:handcrafted:oak_pillar_trim> * 16,
        [[empty,<item:minecraft:oak_planks>,empty],
        [empty,<item:minecraft:oak_planks>,<item:minecraft:oak_planks>],
        [empty,<item:minecraft:oak_planks>,empty]]
    );
    recipes.remove(<item:handcrafted:spruce_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/spruce_pillar_trim",
        <item:handcrafted:spruce_pillar_trim> * 16,
        [[empty,<item:minecraft:spruce_planks>,empty],
        [empty,<item:minecraft:spruce_planks>,<item:minecraft:spruce_planks>],
        [empty,<item:minecraft:spruce_planks>,empty]]
    );
    recipes.remove(<item:handcrafted:warped_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/warped_pillar_trim",
        <item:handcrafted:warped_pillar_trim> * 16,
        [[empty,<item:minecraft:warped_planks>,empty],
        [empty,<item:minecraft:warped_planks>,<item:minecraft:warped_planks>],
        [empty,<item:minecraft:warped_planks>,empty]]
    );
    recipes.remove(<item:handcrafted:andesite_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/andesite_pillar_trim",
        <item:handcrafted:andesite_pillar_trim> * 16,
        [[empty,<item:minecraft:andesite>,empty],
        [empty,<item:minecraft:andesite>,<item:minecraft:andesite>],
        [empty,<item:minecraft:andesite>,empty]]
    );
    recipes.remove(<item:handcrafted:blackstone_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/blackstone_pillar_trim",
        <item:handcrafted:blackstone_pillar_trim> * 16,
        [[empty,<item:minecraft:blackstone>,empty],
        [empty,<item:minecraft:blackstone>,<item:minecraft:blackstone>],
        [empty,<item:minecraft:blackstone>,empty]]
    );
    recipes.remove(<item:handcrafted:bricks_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/bricks_pillar_trim",
        <item:handcrafted:bricks_pillar_trim> * 16,
        [[empty,<item:minecraft:bricks>,empty],
        [empty,<item:minecraft:bricks>,<item:minecraft:bricks>],
        [empty,<item:minecraft:bricks>,empty]]
    );
    recipes.remove(<item:handcrafted:calcite_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/calcite_pillar_trim",
        <item:handcrafted:calcite_pillar_trim> * 16,
        [[empty,<item:minecraft:calcite>,empty],
        [empty,<item:minecraft:calcite>,<item:minecraft:calcite>],
        [empty,<item:minecraft:calcite>,empty]]
    );
    recipes.remove(<item:handcrafted:deepslate_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/deepslate_pillar_trim",
        <item:handcrafted:deepslate_pillar_trim> * 16,
        [[empty,<item:minecraft:deepslate>,empty],
        [empty,<item:minecraft:deepslate>,<item:minecraft:deepslate>],
        [empty,<item:minecraft:deepslate>,empty]]
    );
    recipes.remove(<item:handcrafted:diorite_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/diorite_pillar_trim",
        <item:handcrafted:diorite_pillar_trim> * 16,
        [[empty,<item:minecraft:diorite>,empty],
        [empty,<item:minecraft:diorite>,<item:minecraft:diorite>],
        [empty,<item:minecraft:diorite>,empty]]
    );
    recipes.remove(<item:handcrafted:dripstone_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/dripstone_pillar_trim",
        <item:handcrafted:dripstone_pillar_trim> * 16,
        [[empty,<item:minecraft:dripstone_block>,empty],
        [empty,<item:minecraft:dripstone_block>,<item:minecraft:dripstone_block>],
        [empty,<item:minecraft:dripstone_block>,empty]]
    );
    recipes.remove(<item:handcrafted:granite_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/granite_pillar_trim",
        <item:handcrafted:granite_pillar_trim> * 16,
        [[empty,<item:minecraft:granite>,empty],
        [empty,<item:minecraft:granite>,<item:minecraft:granite>],
        [empty,<item:minecraft:granite>,empty]]
    );
    recipes.remove(<item:handcrafted:quartz_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/quartz_pillar_trim",
        <item:handcrafted:quartz_pillar_trim> * 16,
        [[empty,<item:minecraft:quartz_block>,empty],
        [empty,<item:minecraft:quartz_block>,<item:minecraft:quartz_block>],
        [empty,<item:minecraft:quartz_block>,empty]]
    );
    recipes.remove(<item:handcrafted:stone_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/stone_pillar_trim",
        <item:handcrafted:stone_pillar_trim> * 16,
        [[empty,<item:minecraft:stone>,empty],
        [empty,<item:minecraft:stone>,<item:minecraft:stone>],
        [empty,<item:minecraft:stone>,empty]]
    );
    recipes.remove(<item:handcrafted:sandstone_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/sandstone_pillar_trim",
        <item:handcrafted:sandstone_pillar_trim> * 16,
        [[empty,<item:minecraft:sandstone>,empty],
        [empty,<item:minecraft:sandstone>,<item:minecraft:sandstone>],
        [empty,<item:minecraft:sandstone>,empty]]
    );
    recipes.remove(<item:handcrafted:red_sandstone_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/red_sandstone_pillar_trim",
        <item:handcrafted:red_sandstone_pillar_trim> * 16,
        [[empty,<item:minecraft:red_sandstone>,empty],
        [empty,<item:minecraft:red_sandstone>,<item:minecraft:red_sandstone>],
        [empty,<item:minecraft:red_sandstone>,empty]]
    );
}