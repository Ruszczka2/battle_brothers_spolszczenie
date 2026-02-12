this.graverobber_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.graverobber";
		this.m.Name = "Hiena Cmentarna";
		this.m.Icon = "ui/backgrounds/background_25.png";
		this.m.BackgroundDescription = "Rabusie okradający groby zwykle nie są osobami o słabych nerwach.";
		this.m.GoodEnding = "Graverobbers like %name% aren\'t exactly the most well liked men in this world, but all you needed from him was to be a great mercenary and he came through in spades. After you left the business, you learned that the graverobber stayed for the long haul. From what you know, he\'s now the company\'s trainer, helping green recruits get up to speed.";
		this.m.BadEnding = "A man like %name% the graverobber came to the company to help escape from his most unlawful and immoral errors, and what better way to do that than killing people for money? Unfortunately, the %companyname% slowly began to fall apart. You learned that %name% eventually left the company and joined with a similar, competing outfit. You\'re not sure where he is now, and you\'re not sure whether to be insulted by his betrayal or understand the reasoning behind it. Business is only business, after all.";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.night_blind",
			"trait.cocky",
			"trait.craven",
			"trait.fainthearted",
			"trait.loyal",
			"trait.optimist",
			"trait.superstitious",
			"trait.determined",
			"trait.deathwish"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
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
			}
		];
	}

	function onBuildDescription()
	{
		return "{Co skłania człowieka do niepokojenia tych, którzy już odeszli? | W obliczu plotek o martwych wstających z grobów, być może rozkopywanie tych grobów jest zatem myśleniem czysto przyszłościowym. | Będąc wrogami wszelkich norm moralnych i wrażliwości, ludzie, którzy z łopatami idą na świeże groby, niewielu mają sojuszników. | Tylko tchórz atakuje leżącego człowieka, a cmentarne hieny atakują ludzi, którzy polegli na dobre. | Gdy chodzi o śmierć, robaki zajmują się ciałem, czas kośćmi, a hieny cmentarne kosztownościami.} {Wychowany przez matkę-tyrana, %name% odnalazł szczęśliwsze towarzystwo wśród zmarłych niż wśród żywych. | Po wielu samotnych nocach w swej pustelni, %name%, jak głosi plotka, zaczął tańcować ze zmarłymi. | %name% romansował pod niebem pełnym gwiazd, jednak blady i zimny był nie tylko ich blask. | Aby nieco urozmaicić swe nudne życie, %name% znany jest z tego, że lubi zwiedzać mroczne zakamarki cmentarzy. | Po tym, jak został oszukany przez domokrążcę, %name% zaczął rozkopywać groby, by zdobyć łupy i mieć za co żyć. Taka przynajmniej jest oficjalna wersja. | Dawniej świetny jubiler, %name% został zmuszony przez demencję do tworzenia nieco innego rodzaju biżuterii. Gdy ci to tłumaczy, jego zębaty naszyjnik szyderczo szczerzy do ciebie swe kły.} {Dewiacje takiego człowieka mogą nie mieć granic, ale może przyda się chociaż na mięso armatnie. | Ma nie po kolei w głowie, ale może chociaż umie machać mieczem. Oby. | Choć niepokojąca to postać, desperackie czasy wymagają desperackich rekrutów. | Nosi prosty naszyjnik w subtelnym, białym kolorze, który najlepiej można opisać jako \'kościsty\'. | Przegnany przez wyjątkowo wściekły tłum, %name% jest jednym z wielu wyrzutków, którzy zawędrowali do świata najemników. | Zazwyczaj jest cichy, ale w pobliżu cmentarzysk gęba mu się nie zamyka. | Miejmy nadzieję, że lubi składać zimne trupy w grobach równie mocno, co je wykopywać.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				8,
				5
			],
			Stamina = [
				5,
				5
			],
			MeleeSkill = [
				3,
				0
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				0,
				1
			],
			RangedDefense = [
				0,
				1
			],
			Initiative = [
				0,
				4
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/dagger"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/ancient/broken_ancient_sword"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/open_leather_cap"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/headscarf"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/ancient/ancient_household_helmet"));
		}
	}

});

