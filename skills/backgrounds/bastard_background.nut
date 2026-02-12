this.bastard_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.bastard";
		this.m.Name = "Bękart";
		this.m.Icon = "ui/backgrounds/background_37.png";
		this.m.BackgroundDescription = "Bękarci często mają nieco umiejętności w walce wręcz.";
		this.m.GoodEnding = "{%name%, the bastard son of a familially inconsiderate nobleman, departed the %companyname% to try to carve out his own family lineage. The last you heard, he\'d managed to acquire himself a good plot of land and a modest stone castle rests on it. While successful, he still harbors resentment for his family. | A bastard son of a nobleman, %name% couldn\'t help but always have that lingering feeling he just didn\'t belong in this world. But the %companyname% gave him a brotherhood to call family. As far as you know, he still fights with the company to this day.}";
		this.m.BadEnding = "Bastards like %name% usually don\'t get far in this world. They\'re too hated in the highborn world in which they live, and hated by the lowborn because they don\'t understand the politics that would make a bastard more common to them than any nobleman. Not long after you left the company, you got wind of %name%\'s passing. Apparently, a young and cruel lord took over his noble house and saw the bastard as a threat to his throne. Despite the bastard wanting nothing to do with that life anymore, it managed to catch up with him anyway. He was assassinated in a tavern bed, his throat cut as he slept.";
		this.m.HiringCost = 110;
		this.m.DailyCost = 14;
		this.m.Excluded = [
			"trait.teamplayer",
			"trait.ailing",
			"trait.clumsy",
			"trait.fat",
			"trait.tiny",
			"trait.hesitant",
			"trait.bleeder",
			"trait.dastard",
			"trait.asthmatic"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(1, 3);
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
		return "{%name% urodził się podczas zaciekłej kampanii wojskowej daleko od domu swojego ojca. | %name% twierdzi, że jego matka pochodzi z oberży w %randomtown%. Co jest dość dziwne, ponieważ jego ojciec jest żonatym członkiem rodziny królewskiej w %townname%. | Pewien arystokrata, mając żonę przeklętą przez wiedźmę, postanowił kontynuować swój rodowód z inną kobietą. Tak narodził się %name%. | %name% narodził się jako owoc zbyt długiej nieobecności króla. Królowa dzielnie, acz niezbyt skutecznie, opierała się pokusom miejscowego służącego. | %name% urodził się dziewięć miesięcy po tym, jak najeźdźcy splądrowali zamek jego rodziców.} {Życie bękarta nie było łatwe: był nieustannie prześladowany przez zazdrosnych przyrodnich braci. | Niczym jakiś królewski trędowaty, był trzymany z dala od oczu innych ludzi. | Na szczęście przez większość swojego życia %name% nie zdawał sobie sprawy, że jest bękartem. | Kontrowersyjny od urodzenia, %name% nie został porzucony jedynie dzięki wróżbom lokalnej wyroczni. | Bycie królewskim bękartem zapewniło mu dobre życie, o ile się nie wychylał i nie ujawniał ze swym pochodzeniem. | Nienawiść zarówno ze strony obcych, jak i rodziny, przygotowała bękarta na ewentualne trudności poza królewskim wychowaniem.} {Rozgniewany swoją rolą w życiu, %name% podjął próbę przejęcia tronu. Nie zaszedł daleko. Został wygnany z każdego dworu w kraju. | Kiedy przyrodni brat obrzucił go kamieniami, %name% nie poczuł zbyt wielkich wyrzutów sumienia, przebijając go mieczem. Winę zrzucił na służącego, ale szybko opuścił swoje królewskie lokum. | Jego ojciec próbował uznać go za prawowitego, ale gdy królewskie małżeństwo nie doszło do skutku, skandal związany z niestosownością okazał się zbyt wielki. Teraz bękart wędruje po krainie, wolny od kajdan kontrowersji. | Bycie najstarszym synem w linii sprawiło, że %name% stał się celem dla swoich młodszych braci z prawowitego łoża. Najprostszym wyborem było porzucenie życia pełnego polityki i podstępów. | Kiedy nakryto go w łożu z przyrodnią siostrą, miarka się przebrała i skandale w jego życiu stały się zbyt wyraziste, aby mógł dłużej pozostać na królewskim dworze. | Zmęczony błahostkami królewskich procesji, %name% pragnął jedynie dołączyć do grupy ludzi, których nie obchodzą więzy krwi i prawowitość łoża. | Kiedy zabójca zatruł wino jego ojca, %name% został szybko obciążony winą za morderstwo. Ucieczka przed rozwścieczonym tłumem była tylko początkiem ekscytującego, nowego życia. | Choć ojciec kochał go bardzo mocno, wiedział też, że dwór królewski nie jest bezpieczny. Odesłał go więc, by ułożył sobie życie na własnych warunkach.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				-5,
				-5
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				5,
				10
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				-5,
				5
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

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(0, 4) == 4)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.BastardTitles[this.Math.rand(0, this.Const.Strings.BastardTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/falchion"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/shortsword"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/hand_axe"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/shields/wooden_shield"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/padded_leather"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/basic_mail_shirt"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}

		r = this.Math.rand(0, 3);

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
			items.equip(this.new("scripts/items/helmets/hood"));
		}
	}

});

