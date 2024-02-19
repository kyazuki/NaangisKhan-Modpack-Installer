import crafttweaker.api.text.Component;
import crafttweaker.api.text.MutableComponent;

public function fixAtherDelightKnives() as void {
    replaceTooltip(<item:aetherdelight:holystone_knife>,
        "Chance to get ambrosia dew from slain mobs", "tooltip.aetherdelight.holystone_knife"
    );
    replaceTooltip(<item:aetherdelight:zanite_knife>,
        "Deals extra damage to mimics", "tooltip.aetherdelight.zanite_knife"
    );
    replaceTooltip(<item:aetherdelight:gravitite_knife>,
        "Has chance to make the target levitate", "tooltip.aetherdelight.gravitite_knife"
    );
    replaceTooltip(<item:aetherdelight:stratus_knife>,
        "Has chance to weaken the target", "tooltip.aetherdelight.stratus_knife"
    );
    replaceTooltip(<item:aetherdelight:veridium_knife>,
        "Cannot be infused", "tooltip.aetherdelight.veridium_knife"
    );
}