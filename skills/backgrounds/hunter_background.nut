this.hunter_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hunter";
		this.m.Name = "Myśliwy";
		this.m.Icon = "ui/backgrounds/background_22.png";
		this.m.BackgroundDescription = "Myśliwi zawodowo zajmują się polowaniem na dziką zwierzynę przy pomocy łuku i strzał, często przemierzając lasy na własną rękę.";
		this.m.GoodEnding = "Choć kompania %companyname% kontynuowała swe pasmo sukcesów, myśliwy %name% ostatecznie zdecydował się zostawić to wszystko za sobą. Wrócił do lasów i łąk, polując na jelenie i mniejszą zwierzynę. Najwidoczniej dość miał już smutnej szarej rzeczywistości i konieczności polowania na innych ludzi, więc całkowicie zamknął ten rozdział. O ile wiesz, ostatnio wiedzie mu się dobrze. Kupił kawałek ziemi i pomaga prowadzić szlachtę w kosztownych wyprawach myśliwskich.";
		this.m.BadEnding = "Gdy rozpad kompanii %companyname% był już oczywisty, %name% odszedł i wrócił do polowań na zwierzynę. Niestety, łowy z pewnym szlachcicem poszły wyjątkowo tragicznie, gdyż dzik przebił kłami twarz lorda. Myśliwy, spodziewając się, że to jego obarczą winą, wycofał się i przemknął niepostrzeżenie obok lorda i jego straży, uciekając w las i znikając samotnie w jego gęstwinie. Od tamtego czasu go nie widziano.";
		this.m.HiringCost = 120;
		this.m.DailyCost = 20;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.hate_beasts",
			"trait.night_blind",
			"trait.clubfooted",
			"trait.brute",
			"trait.short_sighted",
			"trait.fat",
			"trait.clumsy",
			"trait.gluttonous",
			"trait.asthmatic",
			"trait.craven",
			"trait.dastard",
			"trait.drunkard"
		];
		this.m.Titles = [
			"Łowca Jeleni",
			"z Kniei",
			"Leśnik",
			"Myśliwy",
			"Celny Strzał",
			"Jednostrzał",
			"Sokole Oko"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(1, 2);
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
		return "{ %name% dorastał bez ojca i to matka nauczyła go jak strzelać z łuku oraz wyżywić resztę rodziny. | %name% urodził się na obrzeżach miasteczka %randomtown% i spędził większość swego czasu obserwując bestie spomiędzy drzew. | %name% kiedyś przyjął zakład, że zestrzeli jabłko ze łba świni. Chybił. Z brzuchem pełnym boczku postanowił, że już nigdy więcej nie spudłuje – no chyba że oznaczałoby to więcej boczku, oczywiście. | We swym wczesnym dzieciństwie, %name% lubił włóczyć się po lasach. Kiedy zaatakował go wściekły lis, nauczył się, by zabierać ze sobą łuk. Kiedy jakiś diabelski orzeł przeorał mu twarz szponami, nauczył się, jak z łuku strzelać.} {Kiedyś wynajęła jego usługi lokalna szlachta, a tragiczne w skutkach polowanie na dzika zakończyło się zadźganym baronem. Oczywiście to %name% został obarczony całą winą i hańbą. | Myśliwy ukrywał tę myśl dość dobrze, ale przez dłuższy czas zastanawiał się, jak by to było zapolować na najcenniejszą zwierzynę: człowieka. | Niestety, pechowa partia w chłopskiej ruletce zmusiła łowcę jeleni do szukania innych źródeł dochodu. | Na nieszczęście, przyrządzanie jeleni szło mu znacznie gorzej, niż polowanie na nie. Obiadem złożonym z niedogotowanej dziczyzny zatruła się cała jego rodzina. Jego desperacja, by zacząć nowe życie, jest zatem zrozumiała. | Po żmudnej wyprawie do miasta, aby sprzedać mięso i skóry, podążył za pokusą pracy najemnej. | Wojna wypłoszyła wszelką zwierzynę z lasów, a %name% pozostał bez zajęcia. Teraz szuka innej pracy. | Kiedy jego żona zachorowała, nie zdołał uzdrowić jej upolowanym mięsem. Potrzebując koron, aby zapłacić za leczenie ukochanej, podjął się fachu najemnika.} {Każdej grupie przydałby się tak wyborowy strzelec, jak ten człowiek. | Choć nie brak mu wad, %name% tak czy siak jest zawodowym łucznikiem. | W ramach szybkiej prezentacji, %name% wystrzeliwuje jedną strzałę wysoko w powietrze, a drugą strzałą ją strąca. Imponujące. | %name% zdaje się mieć coś do udowodnienia – upewnij się tylko, by zrobił to na strzelnicy, bo gdy po raz pierwszy podano mu miecz, chwycił go za niewłaściwy koniec. Tak, za TEN koniec. | Myśliwy włada łukiem z taką wprawą, jakby to była jego dodatkowa kończyna, a strzałami miota, jak wzburzony kaznodzieja słowami podczas gorliwego kazania.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				0,
				5
			],
			Stamina = [
				7,
				5
			],
			MeleeSkill = [
				0,
				0
			],
			RangedSkill = [
				20,
				17
			],
			MeleeDefense = [
				0,
				0
			],
			RangedDefense = [
				0,
				3
			],
			Initiative = [
				0,
				5
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		items.equip(this.new("scripts/items/weapons/hunting_bow"));
		items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.addToBag(this.new("scripts/items/weapons/knife"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/thick_tunic"));
		}
		else
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
		else
		{
			items.equip(this.new("scripts/items/helmets/hunters_hat"));
		}
	}

});

