this.sellsword_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.sellsword";
		this.m.Name = "Najemnik";
		this.m.Icon = "ui/backgrounds/background_10.png";
		this.m.BackgroundDescription = "Najemnicy są kosztowni, lecz życie pełne wojaczki przekuło ich w zdolnych wojowników.";
		this.m.GoodEnding = "%name% opuścił %companyname% i założył własną kompanię najemników. Z tego co wiesz, to bardzo udany interes i często łączy siły z ludźmi z %companyname%.";
		this.m.BadEnding = "%name% opuścił %companyname% i założył konkurencyjną kompanię. Obie firmy starły się po przeciwnych stronach bitwy między możnymi. Najemnik zginął, gdy człowiek z %companyname% roztrzaskał mu głowę hełmem rycerza z ostępów.";
		this.m.HiringCost = 100;
		this.m.DailyCost = 35;
		this.m.Excluded = [
			"trait.weasel",
			"trait.night_blind",
			"trait.ailing",
			"trait.asthmatic",
			"trait.clubfooted",
			"trait.irrational",
			"trait.hesitant",
			"trait.loyal",
			"trait.tiny",
			"trait.fragile",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.dastard",
			"trait.insecure"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(2, 4);
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
		return "{%fullname% pracuje jako najemnik od czasu, gdy ojciec przekazał mu swój rynsztunek. | Nie pamięta czasu, gdy %fullname% nie był mieczem do wynajęcia. | Jako najemnik %fullname% nigdy nie musiał długo szukać pracy. | Uczeni mówią o spuszczaniu psów wojny. %fullname% jest jednym z nich. | Na wojnie jest śmierć i zysk. %fullname% powoduje pierwsze, by zarabiać drugie. | Nigdy nie było lepszego czasu dla najemników takich jak %name%, by zarobić parę koron. | Po tym, jak żona uciekła z dziećmi, rozgniewany %name% zrobił stałą karierę jako bezwzględny najemnik. | Dekadę temu %name% stracił wszystko w pożarze. Od tego czasu pracuje jako najemnik. | %name% zawsze miał skłonność do przemocy i obrał długą karierę najemnika. | Dawniej skrajnie biedny, %name% przez lata zarobił jako najemnik całkiem pokaźną sumę. | %fullname% woli zachować dla siebie, skąd pochodzi, ale jego reputacja miecza do wynajęcia mówi sama za siebie.} {Doświadczony, przez lata wędrował w wielu kompaniach. | Kampanie wojskowe to tylko nacięcia na jego pasie. | Od ochroniarza lorda po egzekutora szemranego kupca, %name% widział już wszystko. | Kiedyś zarabiał na zabijaniu dzikich bestii, które napierają na ludzkie osady. | Z ponurym uśmiechem chełpi się, że zabił wszelkie żywe stworzenia. | Dzięki wieloletniej praktyce najemnik poznał broń, o której nie miałeś nawet pojęcia. | Najemnik liczy, ilu już zabił, i wygląda na to, że nie zamierza wkrótce przestać. | Z mieczem i tarczą w dłoni najemnik robi to, co potrafi najlepiej.} {Ten człowiek nie jest obcy polom bitew. | Ten człowiek nie jest obcy okrucieństwom wojny. | Przywykł do brutalnej rzeczywistości życia najemnika. | Mówi się, że jest niezawodnym trybem w każdym murze tarcz. | Niektórzy mówią, że potrafi utrzymać linię równie dobrze jak dąb. | Krążą plotki, że lubi widok krwi. | Bez wstydu czerpie niepokojącą przyjemność z nieszczęść innych na polu bitwy. | Dziwnie, rzadko przysiada przy ognisku z innymi, trzyma się na uboczu. | Lubi opowiadać, jak zabił to czy tamto. | Daj mu okazję, a szybko pokaże szeroki wachlarz stylów walki.} {Dopóki masz monety, %name% jest do twojej dyspozycji. | Prawdziwy najemnik, %name% będzie walczył z każdym za odpowiednią cenę. | Prezentując niezłą szermierkę, %name% twierdzi, że może przebić każdego. | Jednym skinieniem %name% zgadza się dołączyć, jeśli masz korony. | %name% stuka kuflem o stół, ciesząc się na okazję zarobku.}";
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");

		if (this.Math.rand(1, 100) <= 25)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
			tattoo_body.Visible = true;
		}

		if (this.Math.rand(1, 100) <= 30)
		{
			tattoo_head.setBrush("scar_02_head");
			tattoo_head.Visible = true;
		}
	}

	function updateAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");

		if (tattoo_body.HasBrush)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
		}
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				5,
				5
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				13,
				10
			],
			RangedSkill = [
				12,
				10
			],
			MeleeDefense = [
				5,
				8
			],
			RangedDefense = [
				5,
				8
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

		if (this.Math.rand(0, 3) == 3)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.SellswordTitles[this.Math.rand(0, this.Const.Strings.SellswordTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 9);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/falchion"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/flail"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/hand_axe"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/greataxe"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/weapons/longsword"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/weapons/billhook"));
		}
		else if (r == 6)
		{
			items.equip(this.new("scripts/items/weapons/winged_mace"));
		}
		else if (r == 7)
		{
			items.equip(this.new("scripts/items/weapons/warhammer"));
		}
		else if (r == 8)
		{
			items.equip(this.new("scripts/items/weapons/boar_spear"));
		}
		else if (r == 9)
		{
			items.equip(this.new("scripts/items/weapons/crossbow"));
			items.equip(this.new("scripts/items/ammo/quiver_of_bolts"));
		}

		r = this.Math.rand(0, 5);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/patched_mail_shirt"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/padded_leather"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/basic_mail_shirt"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/worn_mail_shirt"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/armor/leather_lamellar"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/armor/mail_shirt"));
		}

		r = this.Math.rand(0, 9);

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
			items.equip(this.new("scripts/items/helmets/mail_coif"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/closed_mail_coif"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/helmets/reinforced_mail_coif"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/helmets/kettle_hat"));
		}
		else if (r == 6)
		{
			items.equip(this.new("scripts/items/helmets/padded_kettle_hat"));
		}
		else if (r == 7)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
	}

});

