this.dodge_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.dodge";
		this.m.Name = "Unik";
		this.m.Description = "Szybki refleks pozwala tej postaci dodać część swojej inicjatywy do zdolności obronnych w zwarciu i przeciwko broni dystansowej.";
		this.m.Icon = "ui/perks/perk_01.png";
		this.m.IconMini = "perk_01_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local initiative = this.Math.max(0, this.Math.floor(this.getContainer().getActor().getInitiative() * 0.15));
		return [
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
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + initiative + "[/color] do Obrony w zwarciu"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + initiative + "[/color] do Obrony dystansowej"
			}
		];
	}

	function onAfterUpdate( _properties )
	{
		local initiative = this.Math.floor(this.getContainer().getActor().getInitiative() * 0.15);
		_properties.MeleeDefense += this.Math.max(0, initiative);
		_properties.RangedDefense += this.Math.max(0, initiative);
	}

});

