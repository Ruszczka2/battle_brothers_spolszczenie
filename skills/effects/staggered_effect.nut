this.staggered_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 2
	},
	function create()
	{
		this.m.ID = "effects.staggered";
		this.m.Name = "Zachwiany";
		this.m.Icon = "skills/status_effect_65.png";
		this.m.IconMini = "status_effect_65_mini";
		this.m.Overlay = "status_effect_65";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Ta postać otrzymała potężny cios, który zachwiał jej równowagą, przez co nieprędko podejmie następną akcję. Efekt minie za [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] " + (this.m.TurnsLeft > 1 ? "tury" : "turę") + ".";
	}

	function getTooltip()
	{
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
				id = 12,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50%[/color] do Inicjatywy"
			}
		];
	}

	function getTurns()
	{
		return this.m.TurnsLeft;
	}

	function getEffectDurationString()
	{
		local ret = "";

		if (this.m.TurnsLeft == 2)
		{
			ret = "dwie tury";
		}
		else
		{
			ret = "jedną turę";
		}

		return ret;
	}

	function getLogEntryOnAdded( _user, _victim )
	{
		return _user + " wytrąca z równowagi: " + _victim + " na " + this.getEffectDurationString();
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		local statusResisted = actor.getCurrentProperties().IsResistantToAnyStatuses ? this.Math.rand(1, 100) <= 50 : false;
		statusResisted = statusResisted || actor.getCurrentProperties().IsResistantToPhysicalStatuses ? this.Math.rand(1, 100) <= 33 : false;

		if (statusResisted)
		{
			if (!actor.isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " nie daje się wytrącić z równowagi dzięki swej niezwykłej fizjologii");
			}

			this.removeSelf();
		}
		else
		{
			this.m.TurnsLeft = this.Math.max(1, 2 + actor.getCurrentProperties().NegativeStatusEffectDuration);
			this.Tactical.TurnSequenceBar.pushEntityBack(actor.getID());
		}
	}

	function onRefresh()
	{
		this.m.TurnsLeft = this.Math.max(1, 2 + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);
		this.Tactical.TurnSequenceBar.pushEntityBack(this.getContainer().getActor().getID());
		this.spawnIcon("status_effect_65", this.getContainer().getActor().getTile());
	}

	function onUpdate( _properties )
	{
		_properties.InitiativeMult *= 0.5;
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

});

