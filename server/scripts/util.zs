import crafttweaker.api.ingredient.IIngredient;
import crafttweaker.api.item.IItemStack;
import crafttweaker.api.item.ItemDefinition;
import crafttweaker.api.text.Component;
import crafttweaker.api.text.MutableComponent;

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