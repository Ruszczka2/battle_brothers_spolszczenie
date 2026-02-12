this.flagellant_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.flagellant";
		this.m.Name = "Biczownik";
		this.m.Icon = "ui/backgrounds/background_26.png";
		this.m.BackgroundDescription = "Biczownicy są bardzo stanowczy w tym, co robią, maja też wysoką tolerancję na ból, choć przez ich zajęcie często ich ciało jest długotrwale okaleczone.";
		this.m.GoodEnding = "One of the more disturbing members of the group, %name% the flagellant at least put aside the whip long enough to bring blades to your enemies. Although he was a capable if not unsettlingly diligent mercenary, it became increasingly obvious that his habits would be the end of him. After another night of harsh personal repudiation, the company found the man unconscious and nearly bleeding out yet again. Hoping to save %name% from himself, they dropped the flagellant off at a monastery where he eventually woke to painful confusion. A kind monk nursed him to health and taught him the ways of peaceful religiosity. To this day, %name% walks the cloisters, giving tempered talks to the young and sparing them from notions of savage spirituality.";
		this.m.BadEnding = "With the company rapidly declining, many mercenaries turned to desperate measures. %name% the flagellant was one such measure. Due to chaos and confusion, some men came to believe %name% could lead them to honor and salvation. A handful of survivors broke off from the %companyname% and went mad, joining his cult of savage spirituality. A howling %name% at their helm, the converts wander aimlessly, sulking half-bent across the earth, rinds of raw hides for backs.";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.weasel",
			"trait.clubfooted",
			"trait.tough",
			"trait.strong",
			"trait.disloyal",
			"trait.insecure",
			"trait.cocky",
			"trait.fat",
			"trait.fainthearted",
			"trait.bright",
			"trait.craven",
			"trait.greedy",
			"trait.gluttonous"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsOffendedByViolence = true;
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
		return "{Bogowie czasem litują się nad ludźmi, co skłania wielu - a %name% jest jednym z nich - do poszukiwania ich łaski. | Będąc analfabetą i urodzonym w ubóstwie, %name% znalazł swój azyl w opowieściach o bogach. | Będąc człowiekiem, który księgi wręcz chłonął, %name% dość szybko natknął się na teksty bogów. | Mówi się, że bogowie do nas przemawiają i jeśli jest to prawda, to z pewnością %name% jest jedną z osób, z którymi mieli okazję porozmawiać. | Podczas gdy na odludziach wyrastały coraz to nowsze kulty, %name% powrócił do wiary w znanych bogów. | Wychowany przez swojego porywczego ojca, %name% spędził większość swoich młodzieńczych lat na opatrywaniu ran po solidnych chłostach. Bogowie by to pochwalili.} {Kiedy wojna dotarła do kraju, bogowie powiedzieli mu, aby wziął w niej udział ku większemu dobru. | Kiedy obrzydliwe słowa kultystów rozprzestrzeniały się po świecie niczym zaraza na szczurze, %name% uznał za stosowne chwycić za broń i walczyć z herezją. | Odchodząc od swojej wiary, popełnił okropną zbrodnię w %randomtown% - bratał się z innym mężczyzną. Teraz szuka odkpupienia, biczując się co noc. | Słysząc zaledwie pogłoski o świętym miejscu, ów pielgrzym wziął swą laskę i nieco zapasów, po czym wyruszył, aby go odszukać. | Teraz, gdy wojna powróciła do kraju, wyznawca bogów poprzez modlitwę i środki cielesne pragnął dowiedzieć się, dlaczego tak się stało. | Podczas nocy spędzonej w jaskini bogowie objawili mu, że łakną krwi. A %name% nie był typem człowieka, który odrzuciłby ich wezwanie. | Po tym, jak rabusie splądrowali skarbce jego kościoła, %name% otrzymał misję, aby opróżnione sakiewki na powrót zapełnić.} {Ponieważ prawa wszechświata uginają się pod ciężarem wojny pochłaniającej cały świat, przydatną rzeczą może być posiadanie przy sobie takiego cudotwórcy jak %name%. | Nosi skórzany bicz, upstrzony szklanymi kolcami. Nie jest on na wrogów, jak sam twierdzi, ale dla zachowania czystości. Interesujące. | Twierdzi, że nienawidzi zła, ale za kilka koron %name% daje się przekonać, aby uznać coś lub kogoś za \'zło\'. | Ten człowiek szuka trudnej ścieżki życiowej, bez wątpienia dlatego uznał za stosowne dołączyć do bandy najemników. | Gdyby tylko %name% miał ku temu moc, wierzysz, że oczyściłby cały świat. Na szczęście jest tylko człowiekiem. | Rozmowy o bogach mogą być odrobinę irytujące, ale płomienna pasja, jaką okazuje %name%, przydaje się na polu bitwy. | Jest tak zauroczony światem bogów, że nikogo już nie dziwi, iż na tym świecie niemal na każdego patrzy, jak na wroga.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-10,
				-5
			],
			Bravery = [
				12,
				12
			],
			Stamina = [
				5,
				10
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

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		this.updateAppearance();
	}

	function updateAppearance()
	{
		local actor = this.getContainer().getActor();
		local body = actor.getSprite("body");
		local tattoo_body = actor.getSprite("tattoo_body");
		tattoo_body.setBrush("scar_01_" + body.getBrush().Name);
		tattoo_body.Color = body.Color;
		tattoo_body.Saturation = body.Saturation;
		tattoo_body.Visible = true;
	}

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(0, 3) == 3)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.PilgrimTitles[this.Math.rand(0, this.Const.Strings.PilgrimTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 2);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/wooden_flail"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/reinforced_wooden_flail"));
		}

		r = this.Math.rand(1, 4);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}

		if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}

		if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}

		if (r == 4)
		{
			items.equip(this.new("scripts/items/armor/monk_robe"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
	}

});

