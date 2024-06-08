import crafttweaker.api.ingredient.IIngredient;
import crafttweaker.api.item.IItemStack;
import crafttweaker.api.item.ItemDefinition;
import crafttweaker.api.text.Component;
import crafttweaker.api.text.MutableComponent;
import crafttweaker.api.data.IData;
import mods.create.HauntingManager;
import crafttweaker.api.util.random.Percentaged;
import crafttweaker.api.resource.ResourceLocation;

// EMI
public function hideIndex(item as IItemStack) as void {
    <tag:items:c:hidden_from_recipe_viewers>.add([item.getDefinition()]);
}

public function hideIndexs(items as IItemStack[]) as void {
    <tag:items:c:hidden_from_recipe_viewers>.add(
        items.map<ItemDefinition>((it) => it.getDefinition())
    );
}

// Tooltip
public function replaceTooltip(ingredient as IIngredient, from as string, translationKey as string) as void {
    ingredient.modifyTooltip(
        (itemStack, tooltip, flag) => {
            var index = 0;
            for t in tooltip {
                if t.getString().indexOf(from) != null {
                    break;
                }
                index++;
            }
            if index >= tooltip.length as int {
                return;
            }
            tooltip[index] = Component.translatable(translationKey).plainCopy().withStyle(tooltip[index].getStyle());
        }
    );
}

//arsnouveau enchantment
public function addArsEnchantingApparatus(name as string, reagent as IIngredient, pedestalItems as IIngredient[], resultItem as IItemStack, cost as int = 1000, keepNbtOfReagent as bool = false) as void{
    val pItems = {} as IData;
    for pItem in pedestalItems{
        pItems.merge({"item": pItem});
    }
    <recipetype:ars_nouveau:enchanting_apparatus>.addJsonRecipe(
        name,
        {
            "type": "ars_nouveau:enchanting_apparatus",
            "keepNbtOfReagent": keepNbtOfReagent,
            "output": resultItem as IData,
            "pedestalItems": [pItems],
            "reagent": [reagent as IData],
            "sourceCost": cost
        }
    );
}

public function addHaunting(name as string, input as IIngredient, output as Percentaged<IItemStack>[]) as void{
<recipetype:create:haunting>.addRecipe(name + "_create", output, input,200);
<recipetype:naangiskhan:haunting>.addJsonRecipe(
    name,
    {
        "type": "naangiskhan:haunting",
        "ingredients": [
        {
            "item": input.items[0].registryName.toString()
        }
        ],
        "results": [
            {
            "item": output[0].getData().registryName.toString()
            }
        ]
    }
);
}

public function compareItemResourceNames(nameToMatch as ResourceLocation, listToMatch as IItemStack[]) as bool{
    for stack in listToMatch{
        if(nameToMatch.equals(stack.registryName)){
            return true;
        }
    }
    return false;
}