import crafttweaker.api.ingredient.IIngredient;
import crafttweaker.api.ingredient.type.IIngredientEmpty;
import crafttweaker.api.item.IItemStack;
import crafttweaker.api.recipe.CraftingTableRecipeManager;
import crafttweaker.api.recipe.IRecipeComponent;
import crafttweaker.api.recipe.replacement.ITargetingStrategy;
import crafttweaker.api.recipe.replacement.Replacer;
import crafttweaker.api.recipe.replacement.IFilteringRule;
import crafttweaker.api.recipe.replacement.ITargetingFilter;
import crafttweaker.api.recipe.replacement.type.NameFilteringRule;
import mods.farmersdelight.CookingPot;
import mods.create.CrushingManager;
import mods.farmersdelight.CuttingBoard;

public function fixDupeItems() as void {//重複アイテムの統一・調整
    val empty = IIngredientEmpty.INSTANCE;
    
    // TofuCraftReloadの米をFarmer's Delightの米に統一
    hideIndexs([
        <item:tofucraft:seeds_rice>,
        <item:tofucraft:rice>
    ]);
    recipes.remove(<item:tofucraft:rice>);
    recipes.remove(<item:tofucraft:rice_block>);
    craftingTable.addShapeless(
        "naangiskhan/tofucraft/rice",
        <item:farmersdelight:rice> * 4,
        [<item:tofucraft:rice_block>]
    );
    craftingTable.addShapeless(
        "naangiskhan/tofucraft/rice_convert",
        <item:farmersdelight:rice> * 1,
        [<item:tofucraft:rice>]
    );

    // Beautify!のロープを削除し、SupplementariesとFarmer's Delightのロープを統一。(データパックでChisel)
    // SupplementariesロープをFarmer's Delightロープレシピに、
    // QuarkロープをSupplementariesロープレシピに変更
    hideIndex(<item:beautify:rope>);
    recipes.remove(<item:beautify:rope>);
    recipes.remove(<item:farmersdelight:rope>);
    recipes.remove(<item:supplementaries:rope>);
    recipes.remove(<item:quark:rope>);
    craftingTable.addShaped(
        "naangiskhan/supplementaries/rope",
        <item:supplementaries:rope> * 4,
        [[ <item:farmersdelight:straw>],
        [<item:farmersdelight:straw>]]
    );
    craftingTable.addShaped(
        "naangiskhan/quark/rope",
        <item:quark:rope> * 3,
        [[<item:supplementaries:flax>],
        [<item:supplementaries:flax>],
        [<item:supplementaries:flax>]]
    );
    // 安全ネットのレシピをSupplementariesロープに変更
    recipes.remove(<item:farmersdelight:safety_net>);
    craftingTable.addShaped(
        "naangiskhan/farmersdelight/safety_net",
        <item:farmersdelight:safety_net> * 1,
        [[<item:supplementaries:rope>, <item:supplementaries:rope>],
        [<item:supplementaries:rope>, <item:supplementaries:rope>]]
    );
    craftingTable.addShapeless(
        "naangiskhan/supplementaries/uncraft_rope",
        <item:supplementaries:rope> * 4,
        [<item:farmersdelight:safety_net>]
    );
    // Rope Pulleyの素材を羊毛->Quarkロープに変更
    recipes.remove(<item:create:rope_pulley>);
    craftingTable.addShaped(
        "naangiskhan/create/rope_pulley",
        <item:create:rope_pulley> * 1,
        [[ <item:create:andesite_casing>],
        [ <item:quark:rope>],
        [ <item:create:iron_sheet>]]
    );
    //beautifyの吊り鉢の素材をSupplementariesロープに変更
    recipes.remove(<item:beautify:hanging_pot>);
    craftingTable.addShaped(
        "naangiskhan/beautify/hanging_pot",
        <item:beautify:hanging_pot> * 1,
        [[<item:supplementaries:rope>],
        [<item:minecraft:flower_pot>]]
    );

    // 鉄はしごの通常レシピを削除 (データパックでChiselに追加済み)
    craftingTable.remove(<item:quark:iron_ladder>);
    craftingTable.remove(<item:twilightforest:iron_ladder>);

    //farmersdelightのココアをcreate confectioneryに統一
    hideIndex(<item:farmersdelight:hot_cocoa>);
    <recipetype:farmersdelight:cooking>.remove(<item:farmersdelight:hot_cocoa>);
    <recipetype:farmersdelight:cooking>.addRecipe(
        "naangiskhan/create_confectionery/hot_chocolate_bottle",
        <item:create_confectionery:hot_chocolate_bottle>,
        [<tag:items:forge:milk>,<item:minecraft:sugar>,<item:minecraft:cocoa_beans>,<item:minecraft:cocoa_beans>],<constant:farmersdelight:cooking_pot_recipe_book_tab:misc>,
        <item:minecraft:glass_bottle>,
        1, 200);

    //ブラックストーンのかまどをnaangiskhanに統一
    hideIndex(<item:nethersdelight:blackstone_furnace>);
    craftingTable.removeByInput(<item:quark:blackstone_furnace>);//通常blast_furnaceなどへの進化を削除
    craftingTable.addShaped(
        "naangiskhan/nethersdelight/blackstone_blast_furnace",
        <item:nethersdelight:blackstone_blast_furnace> * 1,
        [[<item:minecraft:iron_ingot>,<item:minecraft:iron_ingot>,<item:minecraft:iron_ingot>],
        [<item:minecraft:iron_ingot>,<item:naangiskhan:blackstone_furnace>,<item:minecraft:iron_ingot>],
        [<item:minecraft:polished_blackstone>,<item:minecraft:polished_blackstone>,<item:minecraft:polished_blackstone>]]
    );
    craftingTable.addShaped(
        "naangiskhan/nethersdelight/nether_brick_smoker",
        <item:nethersdelight:nether_brick_smoker> * 1,
        [[empty,<item:minecraft:nether_bricks>,empty],
        [<item:minecraft:nether_bricks>,<item:naangiskhan:blackstone_furnace>,<item:minecraft:nether_bricks>],
        [empty,<item:minecraft:polished_blackstone>,empty]]
    );
    //キャンディケインをconfectioneryにクラフト可能
    craftingTable.remove(<item:aetherdelight:festive_sweets>);
    craftingTable.addShaped(
        "naangiskhan/aetherdelight/festive_sweets",
        <item:aetherdelight:festive_sweets> * 1,
        [[<item:create_confectionery:candy_cane>,<item:farmersdelight:sweet_berry_cookie>,<item:farmersdelight:honey_cookie>],
        [<item:twilightdelight:torchberry_cookie>,<item:minecraft:bowl>,empty]]
    );
    craftingTable.addShapeless(
        "naangiskhan/create_confectionery/candy_cane",
        <item:create_confectionery:candy_cane> * 1,
        [<item:aether:candy_cane>,<item:aether:candy_cane>]
    );
    //ジンジャーブレッドマンをconfectioneryにクラフト可能
    craftingTable.addShapeless(
        "naangiskhan/create_confectionery/gingerbread_man",
        <item:create_confectionery:gingerbread_man> * 1,
        [<item:aether:gingerbread_man>,<item:minecraft:honey_bottle>]
    );
    
    //delightfulの重複アイテムを非表示
    hideIndexs([<item:undergardendelight:gloomgourd_pie_slice>,<item:delightful:gravitite_knife>,<item:delightful:holystone_knife>,<item:delightful:skyroot_knife>,<item:delightful:zanite_knife>,<item:delightful:skyjade_knife>,<item:delightful:stratus_knife>, <item:aetherdelight:veridium_knife>]);
    craftingTable.remove(<item:aetherdelight:veridium_knife>);
    recipes.removeByInput(<item:aetherdelight:veridium_knife>);

    //centralkitchenの入手不可パイを非表示
    hideIndexs([<item:create_central_kitchen:cherry_pie_slice>,<item:create_central_kitchen:truffle_pie_slice>,<item:create_central_kitchen:mulberry_pie_slice>,<item:create_central_kitchen:chocolate_cake_slice>,<item:create_central_kitchen:honey_cake_slice>,<item:create_central_kitchen:yucca_cake_slice>,<item:create_central_kitchen:aloe_cake_slice>,<item:create_central_kitchen:passionfruit_cake_slice>,<item:create_central_kitchen:pumpkin_cake_slice>,<item:create_central_kitchen:sweet_berry_cake_slice>]);
    
    //コーラスフルーツ木箱をEndsDelightに統一
    craftingTable.remove(<item:quark:chorus_fruit_block>);
    craftingTable.remove(<item:ends_delight:chorus_fruit_crate>);

    //tofucraft apricotを消す
    hideIndexs([<item:tofucraft:apricot>,<item:tofucraft:apricotjerry_bottle>,<item:tofucraft:sapling_apricot>,<item:tofucraft:leaves_apricot>]);
    craftingTable.removeByName("tofucraft:apricotseed");
    craftingTable.removeByName("tofucraft:apricotjerry_bread"); 
    craftingTable.addShapeless(
        "naangiskhan/croptopia/apricot_jam_from_tofucraft",
        <item:croptopia:apricot_jam> * 1,
        [<item:tofucraft:apricotjerry_bottle>,<item:tofucraft:apricotjerry_bottle>]
    );
    craftingTable.addShapeless(
        "naangiskhan/tofucraft/apricotjerry_bread",
        <item:tofucraft:apricotjerry_bread> * 1,
        [<item:croptopia:apricot_jam>,<item:minecraft:bread>]
    );
    <recipetype:farmersdelight:cutting>.addRecipe("naangiskhan/tofucraft/apricotseed", <item:croptopia:apricot>, [<item:tofucraft:apricotseed>], <tag:items:forge:tools/knives>);

    // Replacer
    // Replacer.create()
    // .replace<IItemStack>(
    //     <recipecomponent:crafttweaker:input/ingredients>,
    //     <item:naangiskhan:before>,
    //     <item:naangiskhan:after>
    // )
    // .replace<IItemStack>(
    //     <recipecomponent:crafttweaker:output/items>,
    //     <item:naangiskhan:before>,
    //     <item:naangiskhan:after>
    // )
    // .execute();
}