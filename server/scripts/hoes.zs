import stdlib.List;

import crafttweaker.api.item.type.tiered.TieredItem;
import crafttweaker.api.item.IItemStack;

public function setHarvestingHoes() as void {
    var bigs = new List<IItemStack>();
    for hoe in <tag:items:minecraft:hoes> {
        var level = (hoe as TieredItem).getTier().getLevel();
        if level >= 3 {
            bigs.add(hoe);
        }
    }
    <tag:items:quark:big_harvesting_hoes>.add(bigs);
}