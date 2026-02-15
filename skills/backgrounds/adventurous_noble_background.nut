this.adventurous_noble_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.adventurous_noble";
		this.m.Name = "Żądny Przygód Szlachcic";
		this.m.Icon = "ui/backgrounds/background_06.png";
		this.m.BackgroundDescription = "Wędrujący, żądni przygód szlachcice są zwykle bardzo stanowczy i umiejętnie władają bronią białą, choć często słabo sobie radzą z obroną przed bronią dystansową.";
		this.m.GoodEnding = "Pragnienie przygód nigdy nie opuszcza duszy człowieka takiego jak %name%. {Zamiast wrócić do szlacheckiej rodziny, opuścił %companyname% i ruszył na wschód w poszukiwaniu rzadkich bestii. Mówi się, że wrócił do miasta z głową czegoś na kształt ogromnej jaszczurki, lecz nie wierzysz w takie fantastyczne brednie. | Opuścił %companyname% i pociągnął na zachód, przeprawiając się przez oceany do nieznanych krain. Nie wiadomo, gdzie dziś jest, ale masz niewielkie wątpliwości, że wróci z opowieściami. | Odszedł z %companyname% i zamiast wrócić do swej rodziny, ruszył na południe. Mówi się, że walczył w wielkiej szlacheckiej wojnie domowej, zabił orczego watażkę, zdobył najwyższą górę krainy i teraz spisuje epos o swych podróżach. | Szlachcic opuścił %companyname% i, przedkładając życie przygody nad szlachecką nudę, ruszył na północ. Mówi się, że obecnie prowadzi oddział odkrywców ku najdalszym rubieżom świata.}";
		this.m.BadEnding = "%name% opuścił %companyname% i kontynuował swoje przygody gdzie indziej. {Ruszył na wschód, mając nadzieję odkryć źródło zielonoskórych, lecz od tamtej pory nikt o nim nie słyszał. | Ruszył na północ w śnieżne pustkowia. Mówi się, że widziano go tydzień temu, gdy tym razem maszerował na południe, blady i bardziej człapiący niż idący. | Ruszył na południe w okrutne mokradła. Mówi się, że w mgle pojawił się tajemniczy płomień, a on poszedł ku niemu. Ludzie, którzy to widzieli, twierdzą, że zniknął w oparach i już nie wrócił. | Ruszył na zachód i wypłynął na otwarte morze. Choć nie miał żadnego morskiego doświadczenia, uznał się za kapitana łodzi. Mówią, że przez tygodnie fale wyrzucały na brzeg szczątki jego statku i martwych marynarzy.}";
		this.m.HiringCost = 150;
		this.m.DailyCost = 25;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_beasts",
			"trait.clubfooted",
			"trait.irrational",
			"trait.hesitant",
			"trait.drunkard",
			"trait.fainthearted",
			"trait.craven",
			"trait.dastard",
			"trait.fragile",
			"trait.insecure",
			"trait.asthmatic",
			"trait.spartan"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Names = this.Const.Strings.KnightNames;
		this.m.Level = this.Math.rand(1, 3);
		this.m.IsCombatBackground = true;
		this.m.IsNoble = true;
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
		return "{Jako pomniejszy szlachcic | Jako trzeci w kolejce do dziedziczenia | Jako młody i arogancki szlachcic | Jako zdolny szermierz}, %name% uznał, że życie na dworze {stało się dla niego nudne | jest dla niego zbyt mało ekscytujące, z ciągłym tym uczeniem się dworskiej etykiety i genealogii rodu | nie jest tym, czego mógłby oczekiwać i że marnuje swoje najlepsze lata | nie jest nawet w połowie tak ekscytujące, jak opowieści o przygodach, bitwach, straszliwych bestiach do ubicia i pięknolicych dziewicach do zdobycia}. {Dumnie nosząc barwy rodowe | Po namowie ze strony swego brata | Ku strapieniu własnej matki | Podejmując wreszcie decyzję, by zmienić postać rzeczy}, %name% wyjechał, by {dowieść swej wartości | osławić swe imię | zdobyć sławę na polu bitwy | sprawdzić swe umiejętności w bitwie} i {żyć pełnią życia, jak to sobie wyobrażał gnijąc za murami zamku | zobaczyć wszystkie te cudy i egzotyczne miejsca na świecie | zapracować na swą pozycję w świecie | zostań pasowanym na rycerza za swe męstwo | stać się wielbionym i kochanym w całym znanym świecie | stać się osobą, której lęka się cały znany świat}.";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				15,
				20
			],
			Stamina = [
				0,
				5
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
				-10,
				-5
			],
			Initiative = [
				0,
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
			items.equip(this.new("scripts/items/weapons/arming_sword"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/winged_mace"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/hand_axe"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/shields/heater_shield"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/shields/kite_shield"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/mail_shirt"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/basic_mail_shirt"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/mail_hauberk"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/nasal_helmet"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/padded_nasal_helmet"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/nasal_helmet_with_mail"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/mail_coif"));
		}
	}

});

