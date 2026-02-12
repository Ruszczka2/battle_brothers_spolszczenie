this.orc_young_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.orc_young_potion";
		this.m.Name = "Kinetyczne Ciosy";
		this.m.Icon = "skills/status_effect_127.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_127";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Nadgarstki tej postaci uległy mutacji w taki sposób, że tłumią wstępny wstrząs sił przeciwstawnych. Mówiąc bardziej praktycznie, w przypadku trafienia zmniejszają one właściwości ochronne pancerza wroga. Można też z ich pomocą robić niesamowite kształty z cieni na ścianie.";
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
				icon = "ui/icons/armor_damage.png",
				text = "Ataki mają [color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] do efektywności przeciwko pancerzowi"
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
		_properties.DamageArmorMult += 0.1;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isOrcYoungPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isOrcYoungPotionAcquired", false);
	}

});

