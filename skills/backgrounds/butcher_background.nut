this.butcher_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.butcher";
		this.m.Name = "Rzeźnik";
		this.m.Icon = "ui/backgrounds/background_43.png";
		this.m.BackgroundDescription = "Rzeźnicy przyzwyczajeni są do rozlewu krwi.";
		this.m.GoodEnding = "Mercenary work is a bloody business, which is probably why a butcher like %name% felt right at home in it. While an outstanding fighter, you hear that he still has problems with the war dogs in the party and has been repeatedly caught trying to slaughter them. Eventually, if not desperately, the company gave the man an adorable puppy to raise as his own. From what you know of, the little runt\'s glowy doe eyes converted the dog hater into a lover. Now he goes into an insatiable bloodlust whenever a wardog is harmed and his little mongrel grew up to be the fiercest beast in the company!";
		this.m.BadEnding = "%name% the butcher eventually left the declining company. He joined up with another outfit, but was caught slaughtering one of their war dogs. Apparently, he had been feeding the mercenaries dogmeat from all their mongrels that had gone \'missing\'. They did not take this news kindly, stripped the butcher, and fed him to the beasts.";
		this.m.HiringCost = 80;
		this.m.DailyCost = 7;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.swift",
			"trait.bleeder",
			"trait.bright",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.spartan",
			"trait.iron_lungs",
			"trait.tiny",
			"trait.optimist"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.RangedSkill
		];
		this.m.Titles = [
			"Rzeźnik",
			"Tasak",
			"Szkarłatny",
			"Oprawca",
			"Krwawy"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Thick;
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
		return "{Po śmierci ojca %name% przejął rodzinną masarnię w %randomtown%. | Dorastając w biedzie, %name% szybko nauczył się zabijać i rozbierać zwierzęta, ostatecznie zakładając masarnię. | Jako że w %randomtown% nawracające susze ciągle niszczyły pola uprawne, %name% postanowił spróbować szczęścia z masarnią. | %name% od zawsze był nieco dziwny i podjął fach rzeźnika nie tylko dla zysku, ale też i dla przyjemności. | %name% nigdy nie wyglądał na aż tak szczęśliwego, szczerzącego zęby od ucha do ucha, jak wtedy, gdy otwarł swoją masarnię i do magazynu dotarła pierwsza dostawa żywych świń. | Jako rzeźnik %name% spędził długie lata na wyciskaniu wnętrzności z martwych królików i odcinaniu głów nie-zawsze-martwym rybom.} {Jednakże pogłoski o bestialskich torturach wobec zwierząt w końcu zmusiły rzeźnika do zwinięcia interesu. | Kiedy po okolicy zaczęły krążyć plotki o czarnej magii i mrocznych rytuałach, minęło dużo czasu, zanim ludzie zaczęli kwestionować źródło pochodzenia jego mięsa i wygnali go z osady.| Jednak zabijanie zwierząt, z tego czy innego powodu, przestało go ekscytować. Szukał czegoś nowego. | Po tym, jak w jednym z jego pakunków z dziczyzną odnaleziono ludzki palec, został wypędzony z miasta. | Niektórzy twierdzą, że najbardziej podobało mu się jednak zarzynanie dla żołnierzy podczas inwazji orków i że chciałby wrócić do tamtego zajęcia. | Niestety, wojna przetoczyła się przez jego zakład, zostawiając po sobie stosy ciał, których nie odważyłby się rozebrać. | Żyjąc w oblężonym mieście zapewniał mięso głodującym mieszkańcom. Kiedy odkryto, skąd mięso pochodzi, oddano go w ręce oblegających, którzy, nieświadomi tamtych zajść, pozwolili mu żyć. | Kiedy na jaw wyszły jego powiązania z kłusownikami, musiał dać nogę, a na ogonie cały czas siedziała mu rzesza ludzi miejscowych lordów. | Pewnego dnia zaszlachtował maleńką świnię, która, jak się później okazało, była pupilem lokalnego szlachcica. Musiał uciekać z miasta, by ratować własny tuszę.} {%name% ma w sobie coś takiego, że krew i flaki do niego pasują. Cóż, w takim razie witamy na polu bitwy. | %name% patrzy na wszystko jak na potencjalne mięso na sprzedaż, tyle że w oddychającym, ruchomym opakowaniu. | %name% u wielu wzbudza niepokój samą swą obecnością oraz swoimi nazbyt szeroko otwartymi oczami. | %name% znany jest też z tego, że czasami gryzie się w język, aby posmakować krwi. | Uszy %name% zdają się ożywiać za każdym razem, gdy w pobliżu słychać pisk świni. To samo ma miejsce z wrzaskami człowieka. Osobliwe. | %name% jest rzeźnikiem, ale najwyraźniej nie zbyt zainteresowany wpasowywaniem się w kanon.}";
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
				0,
				4
			],
			MeleeSkill = [
				3,
				2
			],
			RangedSkill = [
				-3,
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

		if (r <= 1)
		{
			items.equip(this.new("scripts/items/weapons/butchers_cleaver"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/butcher_apron"));
		}
	}

});

