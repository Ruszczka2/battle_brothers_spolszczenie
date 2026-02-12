this.fallen_hero_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.fallen_hero_potion";
		this.m.Name = "Reaktywna Tkanka Mięśniowa";
		this.m.Icon = "skills/status_effect_136.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_136";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Ciało tej postaci reaguje na urazy fizyczne wydzielając substancję zawierającą wapń, która powoduje, że mięśnie odruchowo zaciskają się i kurczą w miejscach uderzenia, co pomaga zminimalizować uszkodzenia tkanek i mięśni.";
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
				text = "U tej postaci ataki wrogów nie akumulują Zmęczenia, nie ważne czy trafią, czy chybią"
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
		_properties.FatigueLossOnAnyAttackMult = 0.0;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isFallenHeroPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isFallenHeroPotionAcquired", false);
	}

});

