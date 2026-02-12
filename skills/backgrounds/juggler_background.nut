this.juggler_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.juggler";
		this.m.Name = "Kuglarz";
		this.m.Icon = "ui/backgrounds/background_14.png";
		this.m.BackgroundDescription = "Kuglarze muszą mieć dobry refleks i koordynację wzrokowo-ruchową, by móc pracować w swoim zawodzie.";
		this.m.GoodEnding = "%name% kuglarz zabrał wszystkie swe zarobione w kompanii najemnej pieniądze i założył wędrowną trupę artystów. Ostatnio doszły cię słuchy, że założył cały teatr i co miesiąc wystawia nową sztukę!";
		this.m.BadEnding = "%name% kuglarz odstawił wojaczkę. Występował dla eleganckiego szlachcica na {południu | północy | wschodzie | zachodzie}, lecz jego występ poszedł fatalnie. Wieść głosi, że za swój błąd został zrzucony z wieży, ale wolisz w to nie wierzyć.";
		this.m.HiringCost = 75;
		this.m.DailyCost = 7;
		this.m.Excluded = [
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.clubfooted",
			"trait.brute",
			"trait.clumsy",
			"trait.tough",
			"trait.strong",
			"trait.short_sighted",
			"trait.dumb",
			"trait.hesitant",
			"trait.deathwish",
			"trait.insecure",
			"trait.asthmatic",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"Kuglarz",
			"Błazen",
			"Głupiec"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Skinny;
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
			},
			{
				id = 15,
				type = "text",
				icon = "ui/icons/chance_to_hit_head.png",
				text = "Wyższa szansa na trafienie w głowę"
			}
		];
	}

	function onBuildDescription()
	{
		return "{Nauczany przez swojego przyrodniego brata, %name% zabrał się do żonglerki, jak żeglarz do wioseł.| Choć wyśmiewany przez rówieśników, %name% zawsze kochał żonglerkę. | Gdy w okolicy pojawiła trupa błaznów, %name% został zauroczony - i ostatecznie wyszkolony - przez jednego szczególnie interesującego człowieka: kuglarza. | %name% był synem miejscowego lorda, ale z powodu swej żenującej obsesji na punkcie żonglowania i rozrywki, został wygnany z rodu. | Nie żonglował dla samego żonglowania, ale rozbawić publiczność i zdobyć jej aplauz.} {Niestety, niewielu jest ludzi do zabawiania, gdy wojna pustoszy kraj. | Jednak tłumy i korony są rzadkością w krainie nędzy i cierpienia. | Jednak żonglerski wypadek z udziałem toporka i królewskiego niemowlęcia zmusił artystę do ucieczki. | Był tak dobry w podrzucaniu mieczy i sztyletów, że wkrótce został oskarżony o czary i odsunięty od swojej pasji. | Niestety, jego umiejętności żonglerskie wzbudzały zazdrość u kolegów po fachu. Uknuli więc spisek przeciw niemu - i jego nieszczęsnym nadgarstkom. | Kiedy skrytobójca zabił lorda, którego on zabawiał, kuglarz został głównym podejrzanym. Ledwo uszedł z życiem.} {Teraz %name% szuka nowej ścieżki życia, nawet jeśli to sama śmierć zostałaby jego widownią. | Teraz %name% znajduje wytchnienie w towarzystwie równie pechowych mężczyzn. | Dzięki szybkim dłoniom i błyskawicznym reakcjom, %name% nie powinien mieć problemów z trafieniem w swój cel. | Żonglując nożami z zamkniętymi oczami, %name% wie dokładnie, gdzie rzucić każde ostrze. | Znacznie więcej można zarobić zabijając, niż żonglując - to smutna rzeczywistość, z którą %name% musi się pogodzić.}";
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
				3,
				3
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
				12,
				10
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
			items.equip(this.new("scripts/items/weapons/dagger"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/hatchet"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/jesters_hat"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.HitChance[this.Const.BodyPart.Head] += 5;
	}

});

