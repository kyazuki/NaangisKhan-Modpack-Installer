import crafttweaker.api.ingredient.type.IIngredientEmpty;
import crafttweaker.api.recipe.FurnaceRecipeManager;
import mods.create.MechanicalCrafterManager;
import mods.farmersdelight.CuttingBoard;

// 緊急パッチ用の処理
public function patch() as void {
    val empty = IIngredientEmpty.INSTANCE;

    // 重複対策
    recipes.remove(<item:tofucraft:filtercloth>);
    craftingTable.addShaped(
        "naangiskhan/tofu/filtercloth",
        <item:tofucraft:filtercloth> * 16,
        [[<item:minecraft:string>,<tag:items:minecraft:wool>,<item:minecraft:string>]]
       
    );

    recipes.remove(<item:handcrafted:acacia_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/acacia_pillar_trim",
        <item:handcrafted:acacia_pillar_trim> * 16,
        [[<item:minecraft:acacia_planks>,empty],
        [<item:minecraft:acacia_planks>,<item:minecraft:acacia_planks>],
        [<item:minecraft:acacia_planks>,empty]]
    );
    recipes.remove(<item:handcrafted:bamboo_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/bamboo_pillar_trim",
        <item:handcrafted:bamboo_pillar_trim> * 16,
        [[<item:minecraft:bamboo_planks>,empty],
        [<item:minecraft:bamboo_planks>,<item:minecraft:bamboo_planks>],
        [<item:minecraft:bamboo_planks>,empty]]
    );
    recipes.remove(<item:handcrafted:birch_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/birch_pillar_trim",
        <item:handcrafted:birch_pillar_trim> * 16,
        [[<item:minecraft:birch_planks>,empty],
        [<item:minecraft:birch_planks>,<item:minecraft:birch_planks>],
        [<item:minecraft:birch_planks>,empty]]
    );
    recipes.remove(<item:handcrafted:cherry_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/cherry_pillar_trim",
        <item:handcrafted:cherry_pillar_trim> * 16,
        [[<item:minecraft:cherry_planks>,empty],
        [<item:minecraft:cherry_planks>,<item:minecraft:cherry_planks>],
        [<item:minecraft:cherry_planks>,empty]]
    );
    recipes.remove(<item:handcrafted:crimson_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/crimson_pillar_trim",
        <item:handcrafted:crimson_pillar_trim> * 16,
        [[<item:minecraft:crimson_planks>,empty],
        [<item:minecraft:crimson_planks>,<item:minecraft:crimson_planks>],
        [<item:minecraft:crimson_planks>,empty]]
    );
    recipes.remove(<item:handcrafted:dark_oak_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/dark_oak_pillar_trim",
        <item:handcrafted:dark_oak_pillar_trim> * 16,
        [[<item:minecraft:dark_oak_planks>,empty],
        [<item:minecraft:dark_oak_planks>,<item:minecraft:dark_oak_planks>],
        [<item:minecraft:dark_oak_planks>,empty]]
    );
    recipes.remove(<item:handcrafted:jungle_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/jungle_pillar_trim",
        <item:handcrafted:jungle_pillar_trim> * 16,
        [[<item:minecraft:jungle_planks>,empty],
        [<item:minecraft:jungle_planks>,<item:minecraft:jungle_planks>],
        [<item:minecraft:jungle_planks>,empty]]
    );
    recipes.remove(<item:handcrafted:mangrove_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/mangrove_pillar_trim",
        <item:handcrafted:mangrove_pillar_trim> * 16,
        [[<item:minecraft:mangrove_planks>,empty],
        [<item:minecraft:mangrove_planks>,<item:minecraft:mangrove_planks>],
        [<item:minecraft:mangrove_planks>,empty]]
    );
    recipes.remove(<item:handcrafted:oak_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/oak_pillar_trim",
        <item:handcrafted:oak_pillar_trim> * 16,
        [[<item:minecraft:oak_planks>,empty],
        [<item:minecraft:oak_planks>,<item:minecraft:oak_planks>],
        [<item:minecraft:oak_planks>,empty]]
    );
    recipes.remove(<item:handcrafted:spruce_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/spruce_pillar_trim",
        <item:handcrafted:spruce_pillar_trim> * 16,
        [[<item:minecraft:spruce_planks>,empty],
        [<item:minecraft:spruce_planks>,<item:minecraft:spruce_planks>],
        [<item:minecraft:spruce_planks>,empty]]
    );
    recipes.remove(<item:handcrafted:warped_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/warped_pillar_trim",
        <item:handcrafted:warped_pillar_trim> * 16,
        [[<item:minecraft:warped_planks>,empty],
        [<item:minecraft:warped_planks>,<item:minecraft:warped_planks>],
        [<item:minecraft:warped_planks>,empty]]
    );
    recipes.remove(<item:handcrafted:andesite_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/andesite_pillar_trim",
        <item:handcrafted:andesite_pillar_trim> * 16,
        [[<item:minecraft:andesite>,empty],
        [<item:minecraft:andesite>,<item:minecraft:andesite>],
        [<item:minecraft:andesite>,empty]]
    );
    recipes.remove(<item:handcrafted:blackstone_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/blackstone_pillar_trim",
        <item:handcrafted:blackstone_pillar_trim> * 16,
        [[<item:minecraft:blackstone>,empty],
        [<item:minecraft:blackstone>,<item:minecraft:blackstone>],
        [<item:minecraft:blackstone>,empty]]
    );
    recipes.remove(<item:handcrafted:bricks_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/bricks_pillar_trim",
        <item:handcrafted:bricks_pillar_trim> * 16,
        [[<item:minecraft:bricks>,empty],
        [<item:minecraft:bricks>,<item:minecraft:bricks>],
        [<item:minecraft:bricks>,empty]]
    );
    recipes.remove(<item:handcrafted:calcite_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/calcite_pillar_trim",
        <item:handcrafted:calcite_pillar_trim> * 16,
        [[<item:minecraft:calcite>,empty],
        [<item:minecraft:calcite>,<item:minecraft:calcite>],
        [<item:minecraft:calcite>,empty]]
    );
    recipes.remove(<item:handcrafted:deepslate_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/deepslate_pillar_trim",
        <item:handcrafted:deepslate_pillar_trim> * 16,
        [[<item:minecraft:deepslate>,empty],
        [<item:minecraft:deepslate>,<item:minecraft:deepslate>],
        [<item:minecraft:deepslate>,empty]]
    );
    recipes.remove(<item:handcrafted:diorite_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/diorite_pillar_trim",
        <item:handcrafted:diorite_pillar_trim> * 16,
        [[<item:minecraft:diorite>,empty],
        [<item:minecraft:diorite>,<item:minecraft:diorite>],
        [<item:minecraft:diorite>,empty]]
    );
    recipes.remove(<item:handcrafted:dripstone_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/dripstone_pillar_trim",
        <item:handcrafted:dripstone_pillar_trim> * 16,
        [[<item:minecraft:dripstone_block>,empty],
        [<item:minecraft:dripstone_block>,<item:minecraft:dripstone_block>],
        [<item:minecraft:dripstone_block>,empty]]
    );
    recipes.remove(<item:handcrafted:granite_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/granite_pillar_trim",
        <item:handcrafted:granite_pillar_trim> * 16,
        [[<item:minecraft:granite>,empty],
        [<item:minecraft:granite>,<item:minecraft:granite>],
        [<item:minecraft:granite>,empty]]
    );
    recipes.remove(<item:handcrafted:quartz_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/quartz_pillar_trim",
        <item:handcrafted:quartz_pillar_trim> * 16,
        [[<item:minecraft:quartz_block>,empty],
        [<item:minecraft:quartz_block>,<item:minecraft:quartz_block>],
        [<item:minecraft:quartz_block>,empty]]
    );
    recipes.remove(<item:handcrafted:stone_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/stone_pillar_trim",
        <item:handcrafted:stone_pillar_trim> * 16,
        [[<item:minecraft:stone>,empty],
        [<item:minecraft:stone>,<item:minecraft:stone>],
        [<item:minecraft:stone>,empty]]
    );
    recipes.remove(<item:handcrafted:sandstone_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/sandstone_pillar_trim",
        <item:handcrafted:sandstone_pillar_trim> * 16,
        [[<item:minecraft:sandstone>,empty],
        [<item:minecraft:sandstone>,<item:minecraft:sandstone>],
        [<item:minecraft:sandstone>,empty]]
    );
    recipes.remove(<item:handcrafted:red_sandstone_pillar_trim>);
    craftingTable.addShaped(
        "naangiskhan/handcrafted/red_sandstone_pillar_trim",
        <item:handcrafted:red_sandstone_pillar_trim> * 16,
        [[<item:minecraft:red_sandstone>,empty],
        [<item:minecraft:red_sandstone>,<item:minecraft:red_sandstone>],
        [<item:minecraft:red_sandstone>,empty]]
    );

    //なぜか消えてるcabbage seedを再追加
    craftingTable.addShapeless(
        "naangiskhan/farmersdelight/cabbage_seeds",
        <item:farmersdelight:cabbage_seeds>,
        [<item:farmersdelight:cabbage>]
    );
    
    //オークション台非表示
    hideIndexs([
        <item:lightmanscurrency:auction_stand_oak>,
        <item:lightmanscurrency:auction_stand_spruce>,
        <item:lightmanscurrency:auction_stand_birch>,
        <item:lightmanscurrency:auction_stand_jungle>,
        <item:lightmanscurrency:auction_stand_acacia>,
        <item:lightmanscurrency:auction_stand_dark_oak>,
        <item:lightmanscurrency:auction_stand_mangrove>,
        <item:lightmanscurrency:auction_stand_cherry>,
        <item:lightmanscurrency:auction_stand_bamboo>,
        <item:lightmanscurrency:auction_stand_crimson>,
        <item:lightmanscurrency:auction_stand_warped>,
        <item:lightmanscurrency:auction_stand_quark_ancient>,
        <item:lightmanscurrency:auction_stand_quark_azalea>,
        <item:lightmanscurrency:auction_stand_quark_blossom>
    ]);

    //養蜂箱非表示
    hideIndexs([
        <item:friendsandfoes:spruce_beehive>,
        <item:friendsandfoes:bamboo_beehive>,
        <item:friendsandfoes:acacia_beehive>,
        <item:friendsandfoes:dark_oak_beehive>,
        <item:friendsandfoes:mangrove_beehive>,
        <item:friendsandfoes:birch_beehive>,
        <item:friendsandfoes:warped_beehive>,
        <item:friendsandfoes:jungle_beehive>
    ]);
    craftingTable.remove(<item:friendsandfoes:spruce_beehive>);
    craftingTable.remove(<item:friendsandfoes:bamboo_beehive>);
    craftingTable.remove(<item:friendsandfoes:acacia_beehive>);
    craftingTable.remove(<item:friendsandfoes:dark_oak_beehive>);
    craftingTable.remove(<item:friendsandfoes:mangrove_beehive>);
    craftingTable.remove(<item:friendsandfoes:birch_beehive>);
    craftingTable.remove(<item:friendsandfoes:warped_beehive>);
    craftingTable.remove(<item:friendsandfoes:jungle_beehive>);
    craftingTable.remove(<item:minecraft:beehive>);
    craftingTable.addShaped(
        "naangiskhan/beehive",
        <item:minecraft:beehive>,
        [[<tag:items:minecraft:planks>,<tag:items:minecraft:planks>,<tag:items:minecraft:planks>],
        [<item:minecraft:honeycomb>,<item:minecraft:honeycomb>,<item:minecraft:honeycomb>],
        [<tag:items:minecraft:planks>,<tag:items:minecraft:planks>,<tag:items:minecraft:planks>]]
    );
}