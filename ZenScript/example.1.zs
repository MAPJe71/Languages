
// Hello! Thanks for using the ZenScript highlighter for Notepad++
// This file is a demonstration so you can see the colouring for yourself.

/* Hooray for
   Multi-line comments! */

# Lonely comment is lonesome..

print("Loading custom ZenScript.");

import mods.betterbeginnings.Kiln;
import mods.betterbeginnings.Oven;
import mods.jei.JEI;

game.setLocalization("en_US", "entity.Rabbit.name", "Hare");

var bread = <ore:bread>;
	bread.add(<minecraft:bread>);
	bread.add(<primal:corn_bread>);
	bread.add(<primal:valus_bread>);
	bread.add(<survivalist:round_bread>);
	
<ore:ingotIron>.mirror(<ore:ingotTin>);
<ore:dustSalt>.addAll(<ore:foodSalt>);
	
<minecraft:wheat_seeds>.displayName = "Wheat Seeds";

<minecraft:jukebox>.addTooltip(format.darkPurple("Uhn tss uhn tss uhn tss."));
<minecraft:stick>.addTooltip(format.green(format.italic("This is a stick") + " with " + format.strikethrough("text")) + " in multiple styles");

var pick = <minecraft:stone_pickaxe>.anyDamage();

recipes.remove(<minecraft:arrow>);
recipes.removeShapeless(<minecraft:stick>);
recipes.addShaped(<minecraft:arrow> *1, [
	[<ore:arrowHeads>],
	[<ore:stickWood>],
	[<ore:feathers>]
]);

recipes.addShapedMirrored(<minecraft:stick> *4, [
	[<minecraft:planks:*>, null], [null, <minecraft:planks:*>]
]);

furnace.remove(<minecraft:bread>);
furnace.add(<minecraft:bread>);
furnace.setFuel(<minecraft:rotten_flesh>, 100);

for item in <ore:ingotCopper>.items {
    print(item);
}

val damagedPick = pick.withDamage(10);
val stickedPick = pick.withTag({
	display: {
		Name: "Sticked pick", 
		Lore: ["This pick", "Has been sticked"]
	}
});

myItem.onlyDamaged();
myItem.onlyDamageAtLeast(15); 
myItem.onlyDamageAtMost(100); 
myItem.onlyDamageBetween(15, 100); 
myItem.onlyDamaged().onlyWithTag({display: {Name: "Sticked pick"}});

recipes.addShaped(<minecraft:grass>, [[
	<minecraft:dirt>,
	<minecraft:water_bucket>.noReturn(),
	<minecraft:wheat>
]]);

recipes.addShaped(<minecraft:grass>, [[
	<minecraft:dirt>,
	<minecraft:water_bucket>.giveBack(<minecraft:iron_ore> *3),
	<minecraft:wheat>
]]);

recipes.addShapeless(<minecraft:stone_pickaxe>, [<minecraft:stone_pickaxe>.anyDamage().marked("pick"), <minecraft:cobblestone>], function(output, inputs, crafting) {
  return inputs.pick.withDamage(max(0, inputs.pick.damage - 25));
});

vanilla.loot.addChestLoot("dungeonChest", <minecraft:stick>.weight(100), 1, 5);
vanilla.loot.removeChestLoot("dungeonChest", <minecraft:enchanted_book>);

vanilla.seeds.addSeed(<minecraft:planks>.weight(100));
vanilla.seeds.removeSeed(<Natura:barley.seed:*>);

import minetweaker.data.IData;
import minetweaker.item.IItemStack;

var myData = {display: {Name: "Axed plank"}} as IData;
var myLogs = [<minecraft:log:0>, <minecraft:log:1>, <minecraft:log:2>, <minecraft:log:3>, <minecraft:log:4>, <minecraft:log:5>] as IItemStack[];
var myPlanks = [<minecraft:planks:0>, <minecraft:planks:1>, <minecraft:planks:2>, <minecraft:planks:3>, <minecraft:planks:4>,<minecraft:planks:5>] as IItemStack[]; 
var stoneAxe = <minecraft:stone_axe>.anyDamage().transformDamage();
var ironAxe = <minecraft:iron_axe>.anyDamage().transformDamage();
var goldenAxe = <minecraft:golden_axe>.anyDamage().transformDamage();
var diamondAxe = <minecraft:diamond_axe>.anyDamage().transformDamage();

for i, log in myLogs {
    var plank = myPlanks[i].withTag(myData);
    
    recipes.removeShapeless(plank, [log]);
    recipes.addShapeless(plank * 2, [log]);
    recipes.addShapeless(plank * 3, [log, stoneAxe]);
    recipes.addShapeless(plank * 4, [log, ironAxe]);
    recipes.addShapeless(plank * 5, [log, goldenAxe]);
    recipes.addShapeless(plank * 6, [log, diamondAxe]);
}