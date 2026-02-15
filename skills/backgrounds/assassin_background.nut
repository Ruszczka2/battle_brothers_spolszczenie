this.assassin_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.assassin";
		this.m.Name = "Skrytobójca";
		this.m.Icon = "ui/backgrounds/background_53.png";
		this.m.BackgroundDescription = "";
		this.m.GoodEnding = "%name% dołączył do kompanii w miejsce bękarta, którego miał zabić. Tak dziwne było to porozumienie, że przez wiele dni uważnie obserwowałeś skrytobójcę. Ale on tylko walczył dla %companyname% i walczył dobrze. Ostatnio słyszałeś, że skrytobójca opuścił kompanię i od tamtej pory nikt go nie widział ani o nim nie słyszał. Sprawdziłeś, co z samym bękartem, czy aby skrytobójca nie dokończył zadania, ale człowiek miał się dobrze. Dziwne spotkanie, jak na koniec.";
		this.m.BadEnding = "%name% dołączył do kompanii w miejsce bękarta, którego miał zabić. Tak dziwne było to porozumienie, że przez wiele dni uważnie obserwowałeś skrytobójcę. Ale on tylko walczył dla %companyname% i walczył dobrze. Ostatnio słyszałeś, że skrytobójca opuścił kompanię wkrótce po twoim pospiesznym odejściu na emeryturę. Postanowiłeś sprawdzić, co z jego celem, bękartem, i dowiedziałeś się, że został zabity przez nieznanego skrytobójcę. Wygląda na to, że %name% dokończył robotę.";
		this.m.HiringCost = 800;
		this.m.DailyCost = 25;
		this.m.Excluded = [
			"trait.huge",
			"trait.weasel",
			"trait.teamplayer",
			"trait.night_blind",
			"trait.clubfooted",
			"trait.dumb",
			"trait.loyal",
			"trait.clumsy",
			"trait.fat",
			"trait.strong",
			"trait.hesitant",
			"trait.insecure",
			"trait.clubfooted",
			"trait.short_sighted",
			"trait.brute",
			"trait.strong",
			"trait.bloodthirsty"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Fatigue,
			this.Const.Attributes.RangedDefense,
			this.Const.Attributes.Bravery
		];
		this.m.Titles = [
			"Skrytobójca"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.Level = 4;
		this.m.IsCombatBackground = true;
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
			}
		];
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-5,
				-5
			],
			Bravery = [
				10,
				10
			],
			Stamina = [
				-5,
				-5
			],
			MeleeSkill = [
				12,
				10
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				5,
				8
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				20,
				15
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();
		local actor = this.getContainer().getActor();
		actor.setTitle("Skrytobójca");
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		items.equip(this.new("scripts/items/weapons/rondel_dagger"));
		items.equip(this.new("scripts/items/armor/thick_dark_tunic"));
		items.equip(this.new("scripts/items/helmets/hood"));
	}

});

