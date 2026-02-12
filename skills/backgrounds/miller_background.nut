this.miller_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.miller";
		this.m.Name = "Młynarz";
		this.m.Icon = "ui/backgrounds/background_05.png";
		this.m.BackgroundDescription = "Młynarze są przyzwyczajeni do pracy fizycznej.";
		this.m.GoodEnding = "%name% the once-miller stayed with the %companyname% for a time, collecting enough crowns to start his own bakery. Last you heard, his sword-shaped desserts have been a hit with the nobility and he makes more money selling to them than he ever did with the company.";
		this.m.BadEnding = "As the %companyname% fell on hard times, %name% the miller saw fit to go ahead and leave while he could still walk. He helped a nobleman test out a new way of grinding grains with mules and waterwheels working in tandem. Unfortunately, by \'helping\' he managed to fall into the contraption and was brutally crushed to death.";
		this.m.HiringCost = 65;
		this.m.DailyCost = 7;
		this.m.Excluded = [
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.bright",
			"trait.cocky",
			"trait.quick",
			"trait.fragile",
			"trait.greedy",
			"trait.sure_footing",
			"trait.deathwish",
			"trait.dexterous",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"Młynarz"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
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
		return "{%name% od zawsze czuł, że w życiu młynarza czegoś mu brakuje, jednak ciężka praca skutecznie powstrzymywała go od snucia dalekosiężnych i ambitnych planów. | Kontynuują rodzinne tradycje, %name% nauczył się młynarskiego rzemiosła od swego ojca. | Choć był prostym młynarzem, %name% zawsze marzył o wyruszeniu w świat, aby potem wrócić do domu z garścią dobrych historii i kabzami pełnymi koron. | Będąc prostym chłopem, %name% nie miał nic przeciwko codziennej harówce w młynie. | %name% zawsze był ambitniejszy, niż większość ludzi. Podczas gdy jego brata zadowalało prowadzenie rodzinnego młyna, on nie mógł pozbyć się wrażenia, że jest przeznaczony do czegoś więcej.} {Pewnej nocy przebudziły go głośne gromy. Wybiegając na zewnątrz, %name% zdał sobie sprawę, że jego młyn zapalił się od uderzenia pioruna. | Kiedy nakrył swą narzeczoną w łóżku z innym, wpadł w furię, zasypując ich oboje morderczym gradem ciosów. Miał pokaleczone dłonie, ludzie na niego wrzeszczeli, jednak jedyne co wtedy czuł, to całkowita pustka w miejscu, gdzie dawniej miał serce. Poruszając się jakby we śnie, szybko spakował swój dobytek i ruszył przed siebie, nie zamierzając nigdy wrócić. | Kiedy jego młodą i uroczą żonę znaleziono martwą w lesie, rozerwaną na strzępy przez dzikie bestie, nie powiedział ani słowa. W ciszy spakował swój dobytek i wyruszył w świat, aby zacząć nowe życie w jakimś odległym miejscu. | Po tym, jak usłyszał trochę niesamowitych opowieści od błędnego rycerza w gospodzie w mieście %townname%, jego wyobraźnia oszalała i nie mógł powstrzymać się od myślenia, jakież to wspaniałości czekają na niego tam, we wielkim świecie. | Nastała susza, a jego interes słabo prządł. Kiedy %name% już nie był w stanie spłacić swych długów, bezwzględni wierzyciele zaczęli grozić mu śmiercią. Musiał zniknąć.} {Pamiętając o swoim kuzynie, który zwał się %randomname% i nieźle dorobił się na karierze najemnika, %name% postanowił ruszyć w jego ślady. | Szukając okazji natknął się na człowieka, który szukał chętnych do kompanii najemników, obiecując sławę i bogactwa. | Choć niewiele się zna na walce, %name%, zwabiony obietnicą przygody, chętny jest dołączyć do kompanii najemników. | Czy to z braku alternatyw, czy z własnej nieprzymuszonej woli, %name% stoi tu teraz przed tobą, gotowy by ślubować ci posłuszeństwo.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				3,
				0
			],
			Bravery = [
				0,
				0
			],
			Stamina = [
				8,
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
		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			local item = this.new("scripts/items/armor/linen_tunic");
			item.setVariant(this.Math.rand(6, 7));
			items.equip(item);
		}
	}

});

