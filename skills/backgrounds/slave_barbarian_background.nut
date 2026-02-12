this.slave_barbarian_background <- this.inherit("scripts/skills/backgrounds/slave_background", {
	m = {},
	function create()
	{
		this.slave_background.create();
		this.m.GoodEnding = null;
		this.m.BadEnding = null;
		this.m.Faces = this.Const.Faces.WildMale;
		this.m.Hairs = this.Const.Hair.WildMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.WildExtended;
		this.m.Bodies = this.Const.Bodies.AllMale;
		this.m.Names = this.Const.Strings.BarbarianNames;
		this.m.Titles = [
			"Barbarzyńca",
			"z Północy",
			"Blady",
			"Więzień",
			"Pechowiec",
			"Zniewolony",
			"Najeźdźca",
			"Jeniec",
			"Nie-wolny",
			"Niesforny",
			"Poskromiony",
			"Zakuty",
			"Skrępowany"
		];
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				-10,
				-5
			],
			Stamina = [
				5,
				5
			],
			MeleeSkill = [
				0,
				0
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				-2,
				-1
			],
			RangedDefense = [
				-2,
				-1
			],
			Initiative = [
				-5,
				-5
			]
		};
		return c;
	}

});

