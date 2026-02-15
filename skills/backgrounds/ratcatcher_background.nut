this.ratcatcher_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.ratcatcher";
		this.m.Name = "Szczurołap";
		this.m.Icon = "ui/backgrounds/background_41.png";
		this.m.BackgroundDescription = "Szczurołapy muszą mieć dobry refleks, aby móc schwytać swą zwierzynę.";
		this.m.GoodEnding = "%name%, szczurołap z dziwacznych stron, wrócił do jeszcze dziwniejszych. Po odejściu z %companyname% założył firmę zajmującą się łapaniem szczurów. Interes szedł znakomicie, aż wyszło na jaw, że nie zabijał żadnego z gryzoni, tylko składował tysiące w magazynie tuż za miastem. Ostatnio słyszałeś, że był całkiem zadowolony ze swoich nowych, licznych przyjaciół.";
		this.m.BadEnding = "Nie sądziłeś, że %name% odnajdzie się u najemników, ale udowodnił, że potrafi. Niestety, %companyname% rozpadła się i wrócił do łapania szczurów. Dotarła do ciebie wieść, że jego ciało znaleziono w kanałach, całe pokryte obgryzającymi je szczurami. Mówi się, że na jego twarzy widniał uśmiech.";
		this.m.HiringCost = 40;
		this.m.DailyCost = 4;
		this.m.Excluded = [
			"trait.huge",
			"trait.hate_undead",
			"trait.hate_beasts",
			"trait.clubfooted",
			"trait.brute",
			"trait.tough",
			"trait.strong",
			"trait.cocky",
			"trait.fat",
			"trait.hesitant",
			"trait.bright",
			"trait.fearless",
			"trait.brave",
			"trait.determined",
			"trait.deathwish",
			"trait.greedy",
			"trait.sure_footing",
			"trait.clumsy",
			"trait.short_sighted"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
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
		return "{Łapacz szczurów, taki właśnie tytuł %name% dawniej preferował. | Z być może niezbyt zasadną dumą, %name% uważa siebie za człowieka kanałów. | Wychudzony i krzywonogi %name% życie poświecił polowaniu na szczury i teraz sam wygląda niemalże jak jeden z nich.} Dorastał w %townname% i {żył w bocznych, śmierdzących uliczkach | żywił się szczurami, owocami rynsztoków | żył wśród futrzastych i obrzydliwych kreatur, a także wśród szczurów}. {W ramach zabawy, ojciec nauczył go jak zastawiać sidła na małe gryzonie | Zwłoki jego zmarłego brata zostały pożarte przez szczury, co wywołało późniejszą krwawą wendetę wobec wszelkich gryzoni | Jego matka żądała najlepszego mięsa, jakie zdołał znaleźć. I nie miała na myśli tego z targu}. Jednak miasto %townname% odciskało swe piętno na ludziach, a %name% odczuł to szczególnie. {Usłyszawszy o większych szczurach w innych partiach świata | Czując, że życie ma do zaoferowania coś więcej, niż tylko szczury | Ufając swym szczurzym podszeptom}, %name% szuka teraz okazji, aby {lepiej wykorzystać swój pomarszczony nos, dziwne nawyki gryzienia i szybkie, ale dość obrzydliwe ręce. | zmiażdżyć każdego szczura, patrzyć, jak przed nim pierzchają i usłyszeć przerażone piski ich pobratymców. Widzisz wyraźnie jego nieobecny wzrok i zaciśnięcie pięści, gdy ci o tym opowiada. | być może rozwinąć swą specjalizację ze szczurów na psy, a nawet ludzi. Chyba nie zdaje sobie sprawy, na co się właściwie pisze, ale może lepiej go nie uświadamiać. | zrobić trochę szczurzej zupy, szczurzej sałatki, szczurzego kebaba, szczurzego chleba, szczurzej pieczeni, szczurzych udek, szczurzego wina... po krótkiej chwili przestałeś już słuchać.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-5,
				-5
			],
			Bravery = [
				0,
				0
			],
			Stamina = [
				0,
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
				0,
				0
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				18,
				15
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(0, 3) == 3)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.RatcatcherTitles[this.Math.rand(0, this.Const.Strings.RatcatcherTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/tools/throwing_net"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
	}

});

