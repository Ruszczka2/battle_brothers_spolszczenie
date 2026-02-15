this.belly_dancer_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.belly_dancer";
		this.m.Name = "Tancerz Brzucha";
		this.m.Icon = "ui/backgrounds/background_64.png";
		this.m.BackgroundDescription = "";
		this.m.GoodEnding = "%name%, południowy tancerz brzucha, opuścił kompanię w porę. Choć jego... osobliwości czyniły go znakomitym żołnierzem, nie była to pasja jego życia. Chciał bawić, rytmicznymi, osobliwie zmysłowymi ruchami, oto czego pragnął. Ostatnio słyszałeś, że przebywa na dworze wezyra, gdzie służy nie tylko jako artysta, lecz dzięki czasowi spędzonemu w %companyname% także jako doradca w sprawach małżeńskich.";
		this.m.BadEnding = "Ponieważ kompania nie osiągnęła sukcesu, na jaki liczyłeś, wielu odeszło z jej szeregów. Południowy tancerz brzucha %name% do nich dołączył. Niestety, postanowił wykonywać swój fach na północy, sądząc, że zdoła tam szerzyć własną kulturę. Miejscowi szybko oskarżyli go o \"nieuregulowaną magię ciała\" i spalili na stosie.";
		this.m.HiringCost = 0;
		this.m.DailyCost = 20;
		this.m.Excluded = [
			"trait.huge",
			"trait.clubfooted",
			"trait.clumsy",
			"trait.fat",
			"trait.strong",
			"trait.hesitant",
			"trait.insecure",
			"trait.clubfooted",
			"trait.short_sighted",
			"trait.brute",
			"trait.strong",
			"trait.bloodthirsty",
			"trait.deathwish"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Fatigue,
			this.Const.Attributes.RangedDefense,
			this.Const.Attributes.Bravery
		];
		this.m.Bodies = this.Const.Bodies.SouthernSkinny;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.SouthernYoung;
		this.m.BeardChance = 0;
		this.m.Ethnicity = 1;
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
		this.m.IsCombatBackground = false;
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
				-5,
				-5
			],
			Stamina = [
				-5,
				-5
			],
			MeleeSkill = [
				10,
				10
			],
			RangedSkill = [
				5,
				5
			],
			MeleeDefense = [
				0,
				0
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				10,
				10
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();
		local actor = this.getContainer().getActor();
		actor.setTitle("Tancerz Brzucha");
	}

	function onAddEquipment()
	{
	}

});

