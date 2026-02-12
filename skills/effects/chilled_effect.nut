this.chilled_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 2
	},
	function create()
	{
		this.m.ID = "effects.chilled";
		this.m.Name = "Przemarznięcie";
		this.m.Icon = "skills/status_effect_109.png";
		this.m.IconMini = "status_effect_109_mini";
		this.m.Overlay = "status_effect_109";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Ta postać przemarzła do samych kości. Lodowato chłodne i skostniałe kończyny utrudniają wykonanie jakiejkolwiek czynności. Efekt powoli ustąpi po [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] " + (this.m.TurnsLeft > 1 ? "turach" : "turze") + ".";
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
				id = 10,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + (1 + this.m.TurnsLeft) + "[/color] do Punktów Akcji"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + (10 + 20 * this.m.TurnsLeft) + "[/color] do Inicjatywy"
			}
		];
	}

	function resetTime()
	{
		this.m.TurnsLeft = this.Math.max(1, 2 + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);
	}

	function onAdded()
	{
		if (this.getContainer().getActor().getCurrentProperties().IsResistantToAnyStatuses && this.Math.rand(1, 100) <= 50)
		{
			if (!this.getContainer().getActor().isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " nie odczuwa skutków zimna dzięki swej niezwykłej fizjologii");
			}

			this.removeSelf();
		}
		else
		{
			this.m.TurnsLeft = this.Math.max(1, 2 + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);

			if (this.getContainer().getActor().hasSprite("dirt"))
			{
				local chilled = this.getContainer().getActor().getSprite("dirt");
				chilled.setBrush("bust_frozen");
				chilled.Visible = true;
			}
		}
	}

	function onRemoved()
	{
		if (this.getContainer().getActor().hasSprite("dirt"))
		{
			local chilled = this.getContainer().getActor().getSprite("dirt");
			chilled.resetBrush();
			chilled.Visible = false;
		}
	}

	function onUpdate( _properties )
	{
		_properties.ActionPoints -= 1 + this.m.TurnsLeft;
		_properties.Initiative -= 10 + 20 * this.m.TurnsLeft;
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

});

