this.brute_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.brute";
		this.m.Name = "Brutal";
		this.m.Icon = "ui/traits/trait_icon_01.png";
		this.m.Description = "Ta postać się nie patyczkuje i użyje pełnej siły dla zadania dodatkowych obrażeń, gdy uderza w głowę przeciwnika, co jednak odbija się na precyzji ciosów.";
		this.m.Titles = [
			"Byk",
			"Wół",
			"Młot"
		];
		this.m.Excluded = [
			"trait.tiny",
			"trait.fragile",
			"trait.insecure",
			"trait.hesitant"
		];
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
				icon = "ui/icons/chance_to_hit_head.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15%[/color] do zadawanych obrażeń przy trafieniu w głowę"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] do Ataku w zwarciu"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.MeleeSkill += -5;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill.isAttack() && !_skill.isRanged())
		{
			_properties.DamageAgainstMult[this.Const.BodyPart.Head] += 0.15;
		}
	}

});

