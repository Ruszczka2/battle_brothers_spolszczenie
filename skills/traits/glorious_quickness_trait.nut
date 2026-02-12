this.glorious_quickness_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.glorious";
		this.m.Name = "Sławetna Szybkość";
		this.m.Icon = "ui/traits/trait_icon_71.png";
		this.m.Description = "Ten gladiator stoczył liczne bitwy na arenach południa i jest mistrzem w likwidowaniu wielu wrogów z rzędu. Jego bajeczny styl życia wymaga wysokiego żołdu, lecz nigdy nie zdezerteruje i nie można go zwolnić. Jeśli wszyscy trzej początkowi członkowie zginą, twoja kampania się zakończy.";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
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
				text = "Zabijając wroga w swojej turze, ta postać natychmiast odzyskuje [color=" + this.Const.UI.Color.PositiveValue + "]1[/color] Punkt Akcji"
			}
		];
		return ret;
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		local actor = this.getContainer().getActor();

		if (actor.isAlliedWith(_targetEntity))
		{
			return;
		}

		if (actor.getActionPoints() == actor.getActionPointsMax())
		{
			return;
		}

		if (this.Tactical.TurnSequenceBar.getActiveEntity() != null && this.Tactical.TurnSequenceBar.getActiveEntity().getID() == actor.getID())
		{
			actor.setActionPoints(this.Math.min(actor.getActionPointsMax(), actor.getActionPoints() + 1));
			actor.setDirty(true);
			this.spawnIcon("trait_icon_71", this.m.Container.getActor().getTile());
		}
	}

});

