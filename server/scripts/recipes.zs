import crafttweaker.api.ingredient.IIngredient;
import crafttweaker.api.ingredient.type.IIngredientEmpty;
import crafttweaker.api.item.IItemStack;
import crafttweaker.api.recipe.CraftingTableRecipeManager;
import crafttweaker.api.recipe.IRecipeComponent;
import crafttweaker.api.recipe.replacement.ITargetingStrategy;
import crafttweaker.api.recipe.replacement.Replacer;

public function modifyRecipes() as void {
    val empty = IIngredientEmpty.INSTANCE;

    // TofuCraftReloadの米をFarmer's Delightの米に統一
    hideIndexs([
        <item:tofucraft:seeds_rice>,
        <item:tofucraft:rice>
    ]);

    // Beautify!のロープを削除し、SupplementariesとFarmer's Delightのロープを統一。(データパックでChisel)
    // SupplementariesロープをFarmer's Delightロープレシピに、
    // QuarkロープをSupplementariesロープレシピに変更
    hideIndex(<item:beautify:rope>);
    recipes.remove(<item:beautify:rope>);
    recipes.remove(<item:farmersdelight:rope>);
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

    // 鉄はしごの通常レシピを削除 (データパックでChiselに追加済み)
    craftingTable.remove(<item:quark:iron_ladder>);
    craftingTable.remove(<item:twilightforest:iron_ladder>);

    // 銅コインの山のレシピを削除
    recipes.remove(<item:lightmanscurrency:coinpile_copper>);
}