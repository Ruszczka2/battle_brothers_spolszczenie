local crossbow_2h = "Kusza, Broń dwuręczna";
local tooltip = function ()
{
	local result = this.weapon.getTooltip();

	if (!this.m.IsLoaded)
	{
		result.push({
			id = 10,
			type = "text",
			icon = "ui/tooltips/warning.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]Musi zostać przeładowana przed ponownym strzałem[/color]"
		});
	}

	return result;
};
::mods_hookNewObject("items/weapons/light_crossbow", function ( o )
{
	o.m.Name = "Lekka Kusza";
	o.m.Description = "Lżejsza wersja kuszy z lewarem, która miota bełtami na średnie odległości. Skuteczna nawet w rękach prostego chłopa, choć wymaga niemal całej tury, by ją przeładować.";
	o.m.Categories = crossbow_2h;
	o.getTooltip = tooltip;
});
::mods_hookNewObject("items/weapons/crossbow", function ( o )
{
	o.m.Name = "Kusza";
	o.m.Description = "Kusza z lewarem, która potrafi miotać bełtami na średnie odległości. Skuteczna nawet w rękach prostego chłopa, choć wymaga niemal całej tury, by ją przeładować.";
	o.m.Categories = crossbow_2h;
	o.getTooltip = tooltip;
});
::mods_hookNewObject("items/weapons/heavy_crossbow", function ( o )
{
	o.m.Name = "Ciężka Kusza";
	o.m.Description = "Ciężka kusza z korbą, która może miotać bełtami na średnie odległości i jest skuteczna nawet przeciwko ciężko opancerzonym celom. Wymaga niemal całej tury, by ją przeładować.";
	o.m.Categories = crossbow_2h;
	o.getTooltip = tooltip;
});
::mods_hookNewObject("items/weapons/oriental/handgonne", function ( o )
{
	o.m.Name = "Rusznica";
	o.m.Description = "Żelazna lufa z długim drewnianym trzonem. Wypluwa z siebie odłamki po stożku i trafia wiele celów za jednym strzałem. Nie można używać, gdy wróg zbliżył się na odległość walki wręcz.";
	o.m.Categories = "Broń palna, Dwuręczna";
	o.getTooltip = tooltip;
});
::mods_hookNewObject("items/weapons/greenskins/goblin_crossbow", function ( o )
{
	o.m.Name = "Kolczasty Palownik";
	o.m.Description = "Sporych rozmiarów ciężka kusza z groźnie wyglądającymi kolcami z przodu. Niczym miniaturowa balista wystrzeliwuje kołki z taką siłą, że odrzuca cel w tył.";
	o.m.Categories = crossbow_2h;
	o.getTooltip = tooltip;
});

