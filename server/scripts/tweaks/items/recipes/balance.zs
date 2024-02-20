import crafttweaker.api.ingredient.IIngredient;
import crafttweaker.api.ingredient.type.IIngredientEmpty;
import crafttweaker.api.item.IItemStack;
import crafttweaker.api.recipe.CraftingTableRecipeManager;
import crafttweaker.api.recipe.IRecipeComponent;
import mods.create.CrushingManager;
import mods.create.HauntingManager;

public function balanceChanges() as void { //レシピ改変
val empty = IIngredientEmpty.INSTANCE;
    //伝承の書を消す
    hideIndex(<item:aether:book_of_lore>);
    craftingTable.remove(<item:aether:book_of_lore>);


    //gravisandをグラビタイトの粉砕レシピに変更
    craftingTable.remove(<item:quark:gravisand>);
    <recipetype:create:crushing>.addRecipe("naangiskhan/quark/gravisand",
        [<item:quark:gravisand>],
        <item:aether:enchanted_gravitite>,
        100
    );
    //steampunk装備の難度を上げる
    craftingTable.remove(<item:immersive_armors:steampunk_helmet>);
    craftingTable.remove(<item:immersive_armors:steampunk_chestplate>);
    craftingTable.remove(<item:immersive_armors:steampunk_leggings>);
    craftingTable.remove(<item:immersive_armors:steampunk_boots>);
    craftingTable.addShaped(
        "naangiskhan/immersive_armors/steampunk_helmet",
        <item:immersive_armors:steampunk_helmet> * 1,
        [[<item:minecraft:redstone_torch>, empty, empty],
        [<item:create:cogwheel>, <item:create:goggles>, <item:create:cogwheel>],
        [empty, empty, empty]]
    );
    craftingTable.addShaped(
        "naangiskhan/immersive_armors/steampunk_chestplate",
        <item:immersive_armors:steampunk_chestplate> * 1,
        [[<item:createdeco:copper_sheet_metal>, empty, <item:create:copper_sheet>],
        [<item:create:cogwheel>, <item:create:brass_sheet>, <item:minecraft:clock>],
        [<item:minecraft:leather>, <item:minecraft:leather>, <item:minecraft:leather>]]
    );
    craftingTable.addShaped(
        "naangiskhan/immersive_armors/steampunk_leggings",
        <item:immersive_armors:steampunk_leggings> * 1,
        [[<item:create:steam_engine>,<item:create:copper_sheet>, <item:create:copper_sheet>],
        [<item:create:brass_sheet>, empty, <item:create:brass_sheet>],
        [<item:minecraft:leather>, empty, <item:minecraft:leather>]]
    );
    craftingTable.addShaped(
        "naangiskhan/immersive_armors/steampunk_boots",
        <item:immersive_armors:steampunk_boots> * 1,
        [[<item:create:steam_engine>,empty, <item:create:copper_backtank>],
        [<item:create:brass_sheet>, empty, <item:create:brass_sheet>],
        [empty, empty, empty]]
    );
    //クラウドブロワーの難度を上げる
    craftingTable.remove(<item:cloudstorage:cloud_blower>);
    craftingTable.addShaped(
        "naangiskhan/cloudstorage/cloud_blower",
        <item:cloudstorage:cloud_blower> * 1,
        [[<item:createdeco:industrial_iron_sheet>,<item:createdeco:industrial_iron_sheet>,<item:createdeco:industrial_iron_sheet> ],
        [<item:create:steam_engine>, <item:cloudstorage:happy_cloud_in_a_bottle>, <item:handcrafted:kitchen_hood_pipe>],
        [<item:createdeco:industrial_iron_sheet>, <item:create:copper_backtank>, <item:createdeco:industrial_iron_sheet>]]
    );
    //雲入り瓶をどうにかしてアニメイトして不機嫌な雲入り瓶にする
    <recipetype:create:haunting>.addRecipe("naangiskhan/cloudstorage/angry_cloud_in_a_bottle",
    [<item:cloudstorage:angry_cloud_in_a_bottle>],
    <item:quark:bottled_cloud>, 200);
    //全ての雲をcloudstorage雲に変換可能
    craftingTable.addShapeless(
        "naangiskhan/cloudstorage/cloud",
        <item:cloudstorage:cloud> * 1,
        [<tag:items:naangiskhan:cloud_blocks>,<item:supplementaries:soap>]
    );
}