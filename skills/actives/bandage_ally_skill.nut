this.bandage_ally_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.bandage_ally";
		this.m.Name = "Użyj Bandaży";
		this.m.Description = "Ocal siebie lub inną postać przed wykrwawieniem się na śmierć, uciskając i prowizorycznie bandażując ranę. Nie leczy punktów zdrowia. Ani postać używająca tej umiejętności, ani też osoba bandażowana, nie mogą sąsiadować z wrogiem walczącym wręcz.";
		this.m.Icon = "skills/active_105.png";
		this.m.IconDisabled = "skills/active_105_sw.png";
		this.m.Overlay = "active_105";
		this.m.SoundOnUse = [
			"sounds/combat/first_aid_01.wav",
			"sounds/combat/first_aid_02.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 5;
		this.m.MinRange = 0;
		this.m.MaxRange = 1;
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
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Tamuje krwawienie"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Usuwa świeże rany Przecięta Tętnica, Przecięta Żyła Szyjna i Rozcięta Szyja"
			}
		];

		if (this.Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Nie można użyć, gdyż wróg zbliżył się na odległość walki wręcz[/color]"
			});
		}

		return ret;
	}

	function getCursorForTile( _tile )
	{
		return this.Const.UI.Cursor.Bandage;
	}

	function isUsable()
	{
		if (!this.Tactical.isActive())
		{
			return false;
		}

		local tile = this.getContainer().getActor().getTile();
		return this.skill.isUsable() && !tile.hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local target = _targetTile.getEntity();

		if (!this.m.Container.getActor().isAlliedWith(target))
		{
			return false;
		}

		if (_targetTile.hasZoneOfControlOtherThan(this.m.Container.getActor().getAlliedFactions()))
		{
			return false;
		}

		if (target.getSkills().hasSkill("effects.bleeding"))
		{
			return true;
		}

		local skill;
		skill = target.getSkills().getSkillByID("injury.cut_artery");

		if (skill != null && skill.isFresh())
		{
			return true;
		}

		skill = target.getSkills().getSkillByID("injury.cut_throat");

		if (skill != null && skill.isFresh())
		{
			return true;
		}

		skill = target.getSkills().getSkillByID("injury.grazed_neck");

		if (skill != null && skill.isFresh())
		{
			return true;
		}

		return false;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		this.spawnIcon("perk_55", _targetTile);

		while (target.getSkills().hasSkill("effects.bleeding"))
		{
			target.getSkills().removeByID("effects.bleeding");
		}

		local skill;
		skill = target.getSkills().getSkillByID("injury.cut_artery");

		if (skill != null && skill.isFresh())
		{
			target.getSkills().remove(skill);
		}

		skill = target.getSkills().getSkillByID("injury.cut_throat");

		if (skill != null && skill.isFresh())
		{
			target.getSkills().remove(skill);
		}

		skill = target.getSkills().getSkillByID("injury.grazed_neck");

		if (skill != null && skill.isFresh())
		{
			target.getSkills().remove(skill);
		}

		if (this.m.Item != null && !this.m.Item.isNull())
		{
			this.m.Item.removeSelf();
		}

		this.updateAchievement("FirstAid", 1, 1);
		return true;
	}

});

