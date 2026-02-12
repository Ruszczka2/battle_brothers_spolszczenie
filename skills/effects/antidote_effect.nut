this.antidote_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 3
	},
	function create()
	{
		this.m.ID = "effects.immune_to_poison";
		this.m.Name = "Niewrażliwość na Truciznę";
		this.m.Icon = "skills/status_effect_118.png";
		this.m.IconMini = "status_effect_118_mini";
		this.m.Overlay = "status_effect_118";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Ta postać zażyła antidotum i jest niewrażliwa na wszelkiego rodzaju trucizny i jady przez kolejne [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] " + (this.m.TurnsLeft > 1 ? "tury" : "turę") + ".";
	}

	function onAdded()
	{
		this.m.TurnsLeft = 3;
	}

	function onRefresh()
	{
		this.m.TurnsLeft = 3;
		this.spawnIcon("status_effect_118", this.getContainer().getActor().getTile());
	}

	function onUpdate( _properties )
	{
		_properties.IsImmuneToPoison = true;
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

});

