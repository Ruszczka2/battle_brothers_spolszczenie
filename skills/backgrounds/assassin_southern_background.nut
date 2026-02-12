this.assassin_southern_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.assassin_southern";
		this.m.Name = "Asasyn";
		this.m.Icon = "ui/backgrounds/background_53.png";
		this.m.BackgroundDescription = "Asasyni muszą być szybcy i umiejętnie posługiwać się bronią.";
		this.m.GoodEnding = "%name% the assassin departed the %companyname% with a large chest of gold and traveled far away. From what rumors you\'ve heard, he built a castle in the mountains east of the southern kingdoms. You\'re not sure if it\'s true, but there\'s been a steady increase in dead viziers and lords alike as of late.";
		this.m.BadEnding = "%name% disappeared not long after your retirement from the %companyname%. The assassin presumably does not want to be found and there\'s no telling where he is. In moments of honesty, you tell others you wished you never hired him at all. You just can\'t shake the terror that it is you he is stalking and hunting, and you spend many nights with one eye open, looking for the man in black with the crooked dagger.";
		this.m.HiringCost = 800;
		this.m.DailyCost = 25;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.huge",
			"trait.weasel",
			"trait.teamplayer",
			"trait.night_blind",
			"trait.clubfooted",
			"trait.brute",
			"trait.dumb",
			"trait.loyal",
			"trait.clumsy",
			"trait.fat",
			"trait.strong",
			"trait.hesitant",
			"trait.insecure",
			"trait.short_sighted",
			"trait.bloodthirsty"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Fatigue
		];
		this.m.Titles = [
			"Cień",
			"Skrytobójca",
			"Zdradliwy",
			"Asasyn",
			"Niewidoczny",
			"Morderca",
			"Sztylet",
			"Nieuchwytny"
		];
		this.m.Bodies = this.Const.Bodies.SouthernSkinny;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.SouthernYoung;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.Ethnicity = 1;
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
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

	function onBuildDescription()
	{
		return "{Na początku byś nie pomyślał, ale %name% jest jak każdy inny. Zwyczajny. Po prostu zwykły, przeciętny mężczyzna. | %name% wygląda niemal jak forma, z której powstał każdy mężczyzna, jakiego dane ci było kiedykolwiek spotkać. Ma twarz, której nie sposób zapamiętać. | %name% ma łagodny uśmiech i usposobienie. Rozmawia z innymi jak równy z równym, ważąc opinie bogatych i biednych, aby wpasować się między nich. | %name% nie prezentuje sobą nic, co zdołałoby przyciągnąć drugie spojrzenie. Jest zupełnie zwyczajny i zupełnie przeznaczony do tego, by być częścią tego świata.} {Oczywiście, jest to zamierzone. Jest asasynem wysłanym przez gildię wyszkolonych zabójców. Zwój, który ma przy sobie, delikatnie sugeruje, abyś przyjął go do pracy. | Ta skromna egzystencja to wyćwiczona twarz człowieka, który w rzeczywistości jest wyszkolonym zabójcą, noszącym jedyny w swoim rodzaju sztylet Qatal, atrybut gildii asasynów. | Jednak to nijakie oblicze ma morderczą przeszłość, gdyż mężczyzna nosi sztylet Qatal, który otrzymują tylko najlepsi zabójcy jednej z południowych gildii asasynów. | Ta \'znajoma twarz nieznajomego\' to tylko pozory, które mają przykryć fakt, że jest to człowiek z gildii zabójców wysłany z powodów, których nigdy nie dane ci będzie poznać.} {%name% może stać tuż obok ciebie, a jednak czujesz się tak, jakby zniknął gdzieś w tym dwuosobowym tłumie. | Pomimo świadomości, że ty i %name% nigdy wcześniej się nie spotkaliście, nie możesz oprzeć się wrażeniu, że już go gdzieś widziałeś. | %name% zachowuje się tak, że w naturalny sposób czujesz się w jego pobliżu swobodnie. Wydaje się to jednak aż nad wyraz naturalne, więc zamiast tego zmuszasz się do zachowania zwiększonej czujności, gdy jest w pobliżu.}";
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
				10,
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

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/oriental/qatal_dagger"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/dagger"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/tools/smoke_bomb_item"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/tools/daze_bomb_item"));
		}

		r = this.Math.rand(1, 2);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/oriental/thick_nomad_robe"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/oriental/assassin_robe"));
		}

		items.equip(this.new("scripts/items/helmets/oriental/assassin_head_wrap"));
	}

});

