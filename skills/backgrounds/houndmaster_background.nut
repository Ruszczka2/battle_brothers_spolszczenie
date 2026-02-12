this.houndmaster_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.houndmaster";
		this.m.Name = "Psiarz";
		this.m.Icon = "ui/backgrounds/background_50.png";
		this.m.BackgroundDescription = "Psiarze przywykli do zajmowania się psami wojennymi.";
		this.m.GoodEnding = "Dogs were not simply \'hounds\' to %name%, despite his title as \'houndmaster.\' To him, they were the most loyal friends of his life. After leaving the company, he discovered an ingenious way to breed the animals specifically tailored to the desires of the nobility. Wanted a brutish beast for a guard dog? He could do it. Wanted something small and cuddly for the children? He could do that, too. The former mercenary now earns an incredible earning doing what he loves - working with dogs.";
		this.m.BadEnding = "What\'s merely a hound to one man is a loyal beast to %name%. After leaving the company, the houndmaster went out to work for the nobility. Unfortunately, he refused to let hundreds of his dogs be used as a battle vanguard to be thrown away for some short-lived tactical advantage. He was hanged for his \'traitorous ideals\'.";
		this.m.HiringCost = 80;
		this.m.DailyCost = 7;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_beasts",
			"trait.hate_beasts",
			"trait.hate_undead",
			"trait.bleeder",
			"trait.bright",
			"trait.asthmatic",
			"trait.fainthearted",
			"trait.tiny"
		];
		this.m.Titles = [
			"Psiarz",
			"Hycel",
			"Smycznik"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
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
			},
			{
				id = 14,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "Psy wypuszczone przez tę postać rozpoczną z wysokimi morale."
			}
		];
	}

	function onBuildDescription()
	{
		return "{%name% swą przygodę z psami rozpoczął w dniu, gdy jego ojciec wygrał szczeniaka w konkursie strzeleckim. | Kiedy to właśnie pies ocalił go przed niedźwiedziem, %name% uznał, że poświeci swoje życie tym szczekającym czworonogom. | Widząc, jak pies powstrzymuje niedoszłego rabusia, sympatia %name% do kundli tylko wzrosła. | Młody, polujący na ptaki %name% szybko dostrzegł honor, lojalność i pracowitość, jaką przejawiają psy. | Będąc kiedyś ugryzionym przez zdziczałego psa, %name% stawił czoło swemu strachu przed psowatymi ucząc się, jak je wytresować.} {Ów psiarz spędził wiele lat pracując dal miejscowego lorda. Zrzekł się stanowiska po tym, jak pewnego dnia jego pan zastrzelił psa dla samej tylko rozrywki. | QBył szybki w szkoleniu swoich kundli i wysłał je na lukratywne, wędrowne targi. | Zarobił mnóstwo pieniędzy na wędrownych pokazach walk psów. Jego kundle słynęły z łatwej do ukierunkowania - i wyzwolenia - zaciekłości. | Zatrudniony przez stróżów prawa, często używał swoich psów o niesamowitym węchu do tropienia i polowania na przestępców. | Wiele z jego ogarów wykorzystywanych było przez m,miejscowego lorda do wspierania żołdaków na polach bitew. | Przez wiele lat treser wykorzystywał swe psy, aby nieco podnieść na duchu osierocone dzieci oraz kalekich.} {Teraz jednak %name% szuka jakiegoś innego zawodu. | Kiedy usłyszał ile płaci się najemnikom, %name% postanowił spróbować swoich sił w tej profesji. | Gdy najemnik zwrócił się do niego z prośbą o kupno jednego z jego psów, %name% zaczął nieco bardziej interesować się perspektywą samemu zostania najemnikiem. | Znudzony szkoleniem psów w takim czy innym celu, %name% pragnie teraz wyszkolić siebie w... cóż, w takim czy innym celu. | Pozostaje mieć nadzieję, że %name% będzie równie lojalny, co psy, którymi kiedyś dowodził.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				5,
				0
			],
			Bravery = [
				5,
				5
			],
			Stamina = [
				5,
				0
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
				3,
				3
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				5,
				0
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;

		if (this.Math.rand(1, 100) >= 50)
		{
			items.equip(this.new("scripts/items/tools/throwing_net"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/open_leather_cap"));
		}
	}

});

