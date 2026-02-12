this.serpent_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.serpent_potion";
		this.m.Name = "Ulepszony Oportunizm";
		this.m.Icon = "skills/status_effect_142.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_142";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Oczy tej postaci uległy zmianom, dzięki którym łatwiej jest dostrzegać słabe punkty w obronie przeciwnika. Postać wydaje się też lekko syczeć podczas wymawiania głoski \'s\'.";
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Zyskuje [color=" + this.Const.UI.Color.PositiveValue + "]+3%[/color] do szansy trafienia w walce wręcz za każdego sojusznika przyległego do atakowanego celu"
			},
			{
				id = 12,
				type = "hint",
				icon = "ui/tooltips/warning.png",
				text = "Dalsze mutacje spowodują dłuższy okres trwania choroby"
			}
		];
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.SurroundedBonus += 3;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isSerpentPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isSerpentPotionAcquired", false);
	}

});

