this.lucky_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.lucky";
		this.m.Name = "Szczęściarz";
		this.m.Icon = "ui/traits/trait_icon_54.png";
		this.m.Description = "Ta postać ma naturalny talent do unikania krzywdy w ostatniej sekundzie.";
		this.m.Titles = [
			"Farciarz",
			"Szczęściarz"
		];
		this.m.Excluded = [
			"trait.pessimist",
			"trait.clumsy",
			"trait.ailing",
			"trait.clubfooted"
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
				text = "Ma [color=" + this.Const.UI.Color.PositiveValue + "]10%[/color] szansy, że atakujący będzie musiał wykonać dwa pomyślne rzuty na trafienie, by cios trafił"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.RerollDefenseChance += 10;
	}

});

