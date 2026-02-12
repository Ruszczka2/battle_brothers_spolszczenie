this.gravedigger_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.gravedigger";
		this.m.Name = "Grabarz";
		this.m.Icon = "ui/backgrounds/background_28.png";
		this.m.BackgroundDescription = "Gabarze przyzwyczajeni są do pracy fizycznej i zadawania się ze zmarłymi.";
		this.m.GoodEnding = "With the great successes of the %companyname%, %name% the gravedigger got continued practice in his trade. As the crowns began to stack, he eventually left the company and returned to the graveyards. Last you heard, he had retired to digging holes again and was happily raising a family of sextons.";
		this.m.BadEnding = "The way you heard things, %name% the gravedigger was one of the last men to leave the %companyname%. With hardly a crown to his name, he slipped hard into drinking and last you heard his body was found in a muddied gully.";
		this.m.HiringCost = 50;
		this.m.DailyCost = 5;
		this.m.Excluded = [
			"trait.weasel",
			"trait.teamplayer",
			"trait.fear_undead",
			"trait.night_blind",
			"trait.swift",
			"trait.cocky",
			"trait.craven",
			"trait.fainthearted",
			"trait.dexterous",
			"trait.quick",
			"trait.iron_lungs",
			"trait.optimist"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsLowborn = true;
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

	function onBuildDescription()
	{
		return "{%name% miał swój debiut jako grabarz grzebiąc swego małego braciszka. | Poderżnąwszy gardło swemu ojcu, %name% miał dość paskudny start w profesji grabarza. Pierwej pogrzebał dowody swej zbrodni, a następnie stróżów prawa, którzy zbyt intensywnie węszyli po okolicy. | Po tym, jak przez %townname% przetoczyła się zaraza, %name% został ostatnim ocalałym. Musiał porzucić swe rzemiosło i zająć się jedynym tym, co mu zostało: kopaniem grobów.} Mawiają, że w oczach zmarłych coś jest. Jest też coś w oczach żywych, którzy zmarłych widzieli. %name% spędził całe życie {przyglądając się zwłokom | składając ciała w dołach | kopiąc groby, duże i małe}. Dla tego grabarza {śmierć to tylko kolejna dziedzina nauki | martwi byli lepszym towarzystwem, niźli żywi | zarabianie na chowaniu zmarłych to tylko sposób na zarobek}. {Pracując przy taborze, %name% przemierzał ziemie, a także w niej kopał. Lecz pewnego dnia jego praca została rozkopana. Nie przez padlinożerców czy szczury. O nie. Przez samego umarlaka. Widząc coś takiego i musząc truposza pochować ponownie, człowiek nabiera ochoty na jak najszybszą zmianę swej ścieżki zawodowej. | Na każdego grabarza patrzy się podejrzliwie i spode łba.  Nie minęło wiele czasu, gdy jego pracodawcy zaczęli go oskarżać o różne plugawe zbrodnie namiętności wobec nieumarłych, co ostatecznie pozbawiło go pracy. Oskarżenia oczywiście były absurdalne, choć niewiele da się wyczytać z jego bladej twarzy. To jak gra w karty z księżycem. | Teraz wygląda, jakby przydała mu się zmiana otoczenia. Tylko nie proś go o grzebanie poległych.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				4
			],
			Bravery = [
				7,
				5
			],
			Stamina = [
				5,
				7
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
				0,
				0
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				-5,
				0
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
	}

});

