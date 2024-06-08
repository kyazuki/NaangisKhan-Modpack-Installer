import crafttweaker.api.ingredient.IIngredient;
import crafttweaker.api.ingredient.type.IIngredientEmpty;
import crafttweaker.api.item.IItemStack;
import crafttweaker.api.recipe.CraftingTableRecipeManager;
import crafttweaker.api.recipe.IRecipeComponent;
import mods.create.CrushingManager;
import mods.create.HauntingManager;
import crafttweaker.api.GenericRecipesManager;
import mods.create.DeployerApplicationManager;
import mods.create.ItemApplicationManager;
import mods.create.CompactingManager;
import mods.create.MixingManager;
import mods.create.EmptyingManager;


public function balanceChanges() as void { //バランス調整のためのレシピ改変
val empty = IIngredientEmpty.INSTANCE;
    //伝承の書を消す
    hideIndex(<item:aether:book_of_lore>);
    craftingTable.remove(<item:aether:book_of_lore>);
    //クラウドストレージガイドを消す
    hideIndex(<item:cloudstorage:guide_book>);
    craftingTable.remove(<item:cloudstorage:guide_book>);
    //twilightdelightガイドを消す
    hideIndex(<item:patchouli:guide_book>);//tofuも一緒に表示消えるけどいいや
    craftingTable.removeByName("twilightdelight:patchouli_book");
    //terminalを消す
    craftingTable.remove(<item:lightmanscurrency:gem_terminal>);
    craftingTable.remove(<item:lightmanscurrency:terminal>);

    
    //steampunk装備の難度を上げる
    craftingTable.remove(<item:immersive_armors:steampunk_helmet>);
    craftingTable.remove(<item:immersive_armors:steampunk_chestplate>);
    craftingTable.remove(<item:immersive_armors:steampunk_leggings>);
    craftingTable.remove(<item:immersive_armors:steampunk_boots>);
    craftingTable.addShaped(
        "naangiskhan/immersive_armors/steampunk_helmet",
        <item:immersive_armors:steampunk_helmet> * 1,
        [[<item:minecraft:redstone_torch>, empty, empty],
        [<item:create:cogwheel>, <item:create:goggles>, <item:create:cogwheel>]]
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
        [<item:create:brass_sheet>, empty, <item:create:brass_sheet>]]
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
    
    //everlastingsteakの難度を上げる
    recipes.remove(<item:artifacts:eternal_steak>);
    <recipetype:create:compacting>.addRecipe(
        "naangiskhan/artifacts/eternal_steak",
        <constant:create:heat_condition:superheated>,
        [<item:artifacts:eternal_steak>],
        [<item:outer_end:halite_crystal>,<item:quark:ancient_fruit>,
            <item:twilightforest:raw_meef>,<item:artifacts:everlasting_beef>],
        [],
        400
    );
    //ガイアの支柱の難度を上げる
    craftingTable.remove(<item:botania:gaia_pylon>);
    <recipetype:create:mixing>.addRecipe(
        "naangiskhan/botania/gaia_pylon",
        <constant:create:heat_condition:superheated>,
        [<item:botania:gaia_pylon>],
        [
            <item:botania:elementium_ingot> * 2,
            <item:botania:pixie_dust>,
            <item:outer_end:rose_crystal>,
            <item:botania:mana_pylon>
        ],[],
        200
    );

    

    //注釈の写本を消す
    hideIndex(<item:ars_nouveau:annotated_codex>);
    craftingTable.remove(<item:ars_nouveau:annotated_codex>);
    //転移の巻物をナン販売のみにする
    craftingTable.remove(<item:ars_nouveau:warp_scroll>);
    <recipetype:ars_nouveau:enchanting_apparatus>.removeByName("ars_nouveau:warp_scroll_copy");
    craftingTable.addShapeless(
        "naangiskhan/ars_nouveau/reset_warp_scroll",
        <item:ars_nouveau:warp_scroll> * 1,
        [<item:ars_nouveau:warp_scroll>,<item:supplementaries:soap>]
    );
    //転移巻物の安定化レシピは高貴な光輝(ナン販売？)使用にする
    craftingTable.remove(<item:ars_nouveau:stable_warp_scroll>);
    <recipetype:ars_nouveau:enchanting_apparatus>.removeByName("ars_nouveau:stable_warp_scroll");
    addArsEnchantingApparatus(
        "naangiskhan/ars_nouveau/stable_warp_scroll",
        <item:ars_nouveau:warp_scroll>,
        [
            <item:create:refined_radiance>
        ],
        <item:ars_nouveau:stable_warp_scroll>,
        1000, true
    );
    craftingTable.addShapeless(
        "naangiskhan/ars_nouveau/reset_stable_warp_scroll",
        <item:ars_nouveau:stable_warp_scroll> * 1,
        [<item:ars_nouveau:stable_warp_scroll>,<item:supplementaries:soap>]
    );

    //remove uncrafting
    hideIndex(<item:twilightforest:uncrafting_table>);

    //gingerdoughにgingerを使う
    <recipetype:create:mixing>.remove(<item:create_confectionery:gingerdough>);
    <recipetype:create:mixing>.addRecipe(
        "naangiskhan/create_confectionery/gingerdough",
        <constant:create:heat_condition:none>,
        [<item:create_confectionery:gingerdough>],
        [
            <item:minecraft:sugar>,
            <item:croptopia:ginger>,
            <item:create:wheat_flour>
        ],[<fluid:create:honey> * 250],
        200
    );

    //drainできなかったバケツ達
    <recipetype:create:emptying>.addRecipe("naangiskhan/deep_aether/emptying_poison", <item:minecraft:bucket>, <fluid:deep_aether:poison_fluid> * 1000, <item:deep_aether:poison_bucket>);
    <recipetype:create:emptying>.addRecipe("naangiskhan/deep_aether/emptying_virulent_mix", <item:minecraft:bucket>, <fluid:undergarden:virulent_mix_source> * 1000, <item:undergarden:virulent_mix_bucket>);
    <recipetype:create:emptying>.addRecipe("naangiskhan/create/emptying_honey", <item:minecraft:bucket>, <fluid:create:honey> * 1000, <item:create:honey_bucket>);
    <recipetype:create:emptying>.addRecipe("naangiskhan/create/emptying_chocolate", <item:minecraft:bucket>, <fluid:create:chocolate> * 1000, <item:create:chocolate_bucket>);

    //pebbleあるやん
    <recipetype:farmersdelight:cutting>.addRecipe("naangiskhan/botania/pebble", <item:minecraft:cobblestone>, [<item:botania:pebble> * 2, (<item:botania:pebble> * 2) %25], <tag:items:minecraft:pickaxes>);
}