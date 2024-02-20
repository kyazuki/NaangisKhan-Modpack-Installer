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
        [[empty, <item:farmersdelight:straw>, empty],
        [empty, <item:farmersdelight:straw>, empty],
        [empty, empty, empty]]
    );
    craftingTable.addShaped(
        "naangiskhan/quark/rope",
        <item:quark:rope> * 3,
        [[empty, <item:supplementaries:flax>, empty],
        [empty, <item:supplementaries:flax>, empty],
        [empty, <item:supplementaries:flax>, empty]]
    );
    // 安全ネットのレシピをSupplementariesロープに変更
    recipes.remove(<item:farmersdelight:safety_net>);
    craftingTable.addShaped(
        "naangiskhan/farmersdelight/safety_net",
        <item:farmersdelight:safety_net> * 1,
        [[<item:supplementaries:rope>, <item:supplementaries:rope>, empty],
        [<item:supplementaries:rope>, <item:supplementaries:rope>, empty],
        [empty, empty, empty]]
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
        [[empty, <item:create:andesite_casing>, empty],
        [empty, <item:quark:rope>, empty],
        [empty, <item:create:iron_sheet>, empty]]
    );
    //beautifyの吊り鉢の素材をSupplementariesロープに変更
    recipes.remove(<item:beautify:hanging_pot>);
    craftingTable.addShaped(
        "naangiskhan/beautify/hanging_pot",
        <item:beautify:hanging_pot> * 1,
        [[<item:supplementaries:rope>,empty,empty],
        [<item:minecraft:flower_pot>,empty,empty],
        [empty,empty,empty]]
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

    //ブラックストーンのかまどをquarkに統一(チセル)
    craftingTable.removeByInput(<item:quark:blackstone_furnace>);//通常blast_furnaceなどへの進化を削除
    craftingTable.addShaped(
        "naangiskhan/nethersdelight/blackstone_blast_furnace",
        <item:nethersdelight:blackstone_blast_furnace> * 1,
        [[<item:minecraft:iron_ingot>,<item:minecraft:iron_ingot>,<item:minecraft:iron_ingot>],
        [<item:minecraft:iron_ingot>,<item:quark:blackstone_furnace>,<item:minecraft:iron_ingot>],
        [<item:minecraft:polished_blackstone>,<item:minecraft:polished_blackstone>,<item:minecraft:polished_blackstone>]]
    );
    craftingTable.addShaped(
        "naangiskhan/nethersdelight/nether_brick_smoker",
        <item:nethersdelight:nether_brick_smoker> * 1,
        [[empty,<item:minecraft:nether_bricks>,empty],
        [<item:minecraft:nether_bricks>,<item:quark:blackstone_furnace>,<item:minecraft:nether_bricks>],
        [empty,<item:minecraft:polished_blackstone>,empty]]
    ); 


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