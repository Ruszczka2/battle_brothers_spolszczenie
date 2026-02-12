this.negative_falling_apart_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.negative_falling_apart";
		this.m.Name = "Rozpadająca Się";
		this.m.Description = "";
		this.m.ArmorDescription = "Ta zbroja jest bliska rozpadnięcia się na kawałki. Niedbalstwo i długie użytkowanie sprawiły, że nie ma tu już czego naprawiać.";
		this.m.Icon = null;
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_downgrade_01.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_downgrade_01.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "downgrade_01_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "downgrade_01_back";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "downgrade_01_back_dead";
		this.m.Value = -200;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/warning.png",
			text = "Brak miejsca na dodatek"
		});
	}

	function onAdded()
	{
		this.m.Armor.m.Condition += -20;
		this.m.Armor.m.ConditionMax += -20;
	}

});

