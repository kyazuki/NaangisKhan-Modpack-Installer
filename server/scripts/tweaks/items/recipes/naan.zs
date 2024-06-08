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
import crafttweaker.api.food.FoodProperties;
    
public function naanCurrency() as void {
    val empty = IIngredientEmpty.INSTANCE;

    //ナンを可食に
    <item:lightmanscurrency:coin_iron>.setFood(
        FoodProperties.create(1, 0)
    );

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
    craftingTable.addShapeless(
        "naangiskhan/naan/uncraft_bag",
        <item:lightmanscurrency:coin_iron> * 10,
        [<item:lightmanscurrency:coin_copper>]
    );
    craftingTable.addShapeless(
        "naangiskhan/naan/uncraft_naan",
        <item:naangiskhan:naan_card> * 10,
        [<item:lightmanscurrency:coin_iron>]
    );

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

    //trading coreのレシピを削除
    recipes.remove(<item:lightmanscurrency:trading_core>);

    //mintingレシピを削除
    recipes.remove(<item:lightmanscurrency:coinmint>);
    <recipetype:lightmanscurrency:coin_mint>.removeAll();
    //atmのレシピを削除
    recipes.remove(<item:lightmanscurrency:atm>);
    //自販機のレシピを削除
    recipes.remove(<item:lightmanscurrency:vending_machine>);
    recipes.removeByInput(<item:lightmanscurrency:vending_machine_large>);
    recipes.remove(<item:lightmanscurrency:vending_machine_large>);
    recipes.removeByInput(<item:lightmanscurrency:vending_machine_large>);
    //portable gem terminalのレシピを削除
    recipes.remove(<item:lightmanscurrency:portable_gem_terminal>);

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
    craftingTable.remove(<item:lightmanscurrency:ticket_machine>);
    craftingTable.remove(<item:lightmanscurrency:portable_terminal>);
}