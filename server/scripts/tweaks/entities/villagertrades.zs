import crafttweaker.api.villagers.VillagerTrades;
public function modifyVillagerTrades() as void {
    villagerTrades.removeTradesSelling(<profession:ars_nouveau:shady_wizard>, 2, <item:ars_nouveau:warp_scroll>);
    villagerTrades.removeAllTrades(<profession:lightmanscurrency:banker>,1);
    villagerTrades.removeAllTrades(<profession:lightmanscurrency:cashier>,1);
    //tood:wanderingtrader atm
}