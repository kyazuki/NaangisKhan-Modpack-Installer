import crafttweaker.api.ingredient.IIngredient;
import crafttweaker.api.ingredient.type.IIngredientEmpty;
import crafttweaker.api.item.IItemStack;
import crafttweaker.api.recipe.CraftingTableRecipeManager;
import crafttweaker.api.recipe.IRecipeComponent;
import crafttweaker.api.recipe.replacement.Replacer;
import crafttweaker.api.recipe.replacement.IFilteringRule;
import crafttweaker.api.recipe.replacement.type.NameFilteringRule;
//import crafttweaker.api.recipe.replacement.type.CustomFilteringRule;
//import crafttweaker.api.recipe.type.Recipe;
import crafttweaker.api.recipe.SmithingRecipeManager; 
 
public function naanCurrency() as void {
    val empty = IIngredientEmpty.INSTANCE;

    //ナンを追加
    //var naan = mods.contenttweaker.VanillaFactory.createItemFood("naangiskhan.naan.naan", 0.5);
    //naan.setSaturation(0.5);
    //naan.setAlwaysEdible(true);

    // 銅コインのレシピを削除
    recipes.removeByInput(<item:lightmanscurrency:coin_iron>);
    recipes.remove(<item:lightmanscurrency:coin_iron>);
    recipes.removeByInput(<item:lightmanscurrency:coin_copper>);
    recipes.remove(<item:lightmanscurrency:coin_copper>);
    recipes.removeByInput(<item:lightmanscurrency:coinblock_copper>);
    recipes.remove(<item:lightmanscurrency:coinblock_copper>);
    
    craftingTable.addShapeless(
        "naangiskhan/naan/uncraft_block",
        <item:lightmanscurrency:coin_copper> * 10,
        [<item:lightmanscurrency:coinblock_copper>]
    );
    //craftingTable.addShapeless(
    //    "naangiskhan/naan/uncraft_bag",
    //    <item:lightmanscurrency:coin_iron> * 10,
    //    [<item:lightmanscurrency:coin_copper>]
    //);

    //各種財布のレシピを削除
    recipes.remove(<item:lightmanscurrency:wallet_copper>);
    recipes.remove(<item:lightmanscurrency:wallet_iron>);
    recipes.remove(<item:lightmanscurrency:wallet_gold>);
    recipes.remove(<item:lightmanscurrency:wallet_emerald>);
    recipes.remove(<item:lightmanscurrency:wallet_diamond>);
    recipes.remove(<item:lightmanscurrency:wallet_netherite>);
    //アップグレード作成レシピ削除
    recipes.removeByInput(<item:lightmanscurrency:upgrade_smithing_template>);
    smithing.removeByModid("lightmanscurrency");
    //財布レシピ追加
    smithing.addTransformRecipe(
        "naangiskhan/lightmanscurrency/iron_wallet",
        <item:lightmanscurrency:wallet_iron>,
        <item:lightmanscurrency:upgrade_smithing_template>,
        <item:lightmanscurrency:wallet_copper>,
        <item:lightmanscurrency:coin_iron>
     );

    //trading coreのレシピを削除
    recipes.remove(<item:lightmanscurrency:trading_core>);

    //mintingレシピを削除
    recipes.remove(<item:lightmanscurrency:coinmint>);
    <recipetype:lightmanscurrency:coin_mint>.removeAll();


    //作成して欲しいトレーダーのみナンで作成可能にする
    Replacer.create().filter(
        //CustomFilteringRule.of(
        //    (r as Recipe) => {
        //        return True;//return r.group == "auction_stand" || r.group = "bookshelf_trader";
        //    }
        //)
        //CustomFilteringRule.of((r as Recipe<foo>) => 1 == 1)
        NameFilteringRule.regex("lightmanscurrency:traders/(bookshelf|shelf|card_display|armor_display|display_case).*")
    )
    .replace<IItemStack>(
         <recipecomponent:crafttweaker:input/ingredients>,
         <item:lightmanscurrency:trading_core>,
         <item:lightmanscurrency:coin_copper>
    ).execute();
    recipes.removeByInput(<item:lightmanscurrency:trading_core>);
}