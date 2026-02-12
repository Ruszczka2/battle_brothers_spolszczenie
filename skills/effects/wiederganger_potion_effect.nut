this.wiederganger_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.wiederganger_potion";
		this.m.Name = "Reaktywność Podskórna";
		this.m.Icon = "skills/status_effect_135.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_135";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "To tylko powierzchowna rana! Podskórne tkanki tej postaci uległy mutacji i automatycznie reagują na nagłe urazy, obniżając ryzyko odniesienia kontuzji w bitwie.";
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
				text = "Próg odniesienia ran i kontuzji po otrzymaniu obrażeń zostaje podwyższony o [color=" + this.Const.UI.Color.PositiveValue + "]33%[/color]"
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
		_properties.ThresholdToReceiveInjuryMult *= 1.33;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isWiedergangerPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isWiedergangerPotionAcquired", false);
	}

});

