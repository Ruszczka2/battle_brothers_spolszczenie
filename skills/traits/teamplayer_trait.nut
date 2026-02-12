this.teamplayer_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.teamplayer";
		this.m.Name = "Gracz Zespołowy";
		this.m.Icon = "ui/traits/trait_icon_58.png";
		this.m.Description = "Ta postać zawsze upewnia się, by powiadomić swych towarzyszy broni o swoich zamiarach. Właściwie to nigdy nie zamyka tej swojej gęby. Ale przynajmniej zmniejsza to szansę na nieszczęśliwy wypadek.";
		this.m.Titles = [];
		this.m.Excluded = [
			"trait.cocky",
			"trait.bloodthirsty",
			"trait.drunkard",
			"trait.dumb",
			"trait.impatient"
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
				icon = "ui/icons/special.png",
				text = "Ma o [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] niższą szansę na trafienie sojuszników"
			}
		];
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill.isAttack() && _targetEntity != null && _targetEntity.getID() != this.getContainer().getActor().getID() && _targetEntity.getFaction() == this.getContainer().getActor().getFaction())
		{
			_properties.MeleeSkillMult *= 0.5;
			_properties.RangedSkillMult *= 0.5;
		}
	}

});

