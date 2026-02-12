this.adrenaline_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 1
	},
	function create()
	{
		this.m.ID = "effects.adrenaline";
		this.m.Name = "Adrenalina";
		this.m.Icon = "ui/perks/perk_37.png";
		this.m.IconMini = "perk_37_mini";
		this.m.Overlay = "perk_37";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Dawaj, dawaj, dawaj! Ta postać dostała przypływ adrenaliny i w następnej rundzie będzie wykonywała ruch przed swymi przeciwnikami.";
	}

	function onUpdate( _properties )
	{
		if (this.m.TurnsLeft != 0)
		{
			_properties.InitiativeForTurnOrderAdditional += 2000;
		}
	}

	function onTurnStart()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

});

