this.mask_of_davkul <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.mask_of_davkul";
		this.m.Name = "Spojrzenie Davkula";
		this.m.Description = "Spojrzenie Davkula jest darem zesłanym ludziom przez starożytne i mroczne moce, hełmem scalonym z ludzką skórą i kośćmi poprzez najbardziej niesamowite rytuały. Przelotne spojrzenie na przyszłość, kiedy to ludzie staną się jednym z tworami z królestwa zaświatów. Nigdy nie ulegnie on zniszczeniu, gdyż od uszkodzona część niezwłocznie odrasta.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.HideCharacterHead = true;
		this.m.HideCorpseHead = true;
		this.m.IsIndestructible = true;
		this.m.Variant = 85;
		this.updateVariant();
		this.m.ImpactSound = [
			"sounds/combat/cleave_hit_hitpoints_01.wav",
			"sounds/combat/cleave_hit_hitpoints_02.wav",
			"sounds/combat/cleave_hit_hitpoints_03.wav"
		];
		this.m.Value = 20000;
		this.m.Condition = 270.0;
		this.m.ConditionMax = 270.0;
		this.m.StaminaModifier = -10;
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
	}

	function getTooltip()
	{
		local result = this.helmet.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Regeneruje [color=" + this.Const.UI.Color.PositiveValue + "]90[/color] punktów swojej wytrzymałości na każdą turę."
		});
		return result;
	}

	function onTurnStart()
	{
		this.m.Condition = this.Math.minf(this.m.ConditionMax, this.m.Condition + 90.0);
		this.updateAppearance();
	}

	function onCombatFinished()
	{
		this.m.Condition = this.m.ConditionMax;
		this.updateAppearance();
	}

});

