this.caravan_hand_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.caravan_hand";
		this.m.Name = "Pomocnik Karawany";
		this.m.Icon = "ui/backgrounds/background_12.png";
		this.m.BackgroundDescription = "Pomocnicy karawany przyzwyczajeni są do długich i wyczerpujących podróży.";
		this.m.GoodEnding = "%name%, dawniej pomocnik karawany, odszedł z walk. Za najemnicze pieniądze założył interes ochrony handlu, specjalizujący się w przewożeniu towarów przez niebezpieczne ziemie.";
		this.m.BadEnding = "%name%, pomocnik karawany, wrócił do pilnowania wozów handlowych. Zginął, broniąc się przed zasadzką zbójców. Zabrali mu koszulę i zostawili ciało w rowie.";
		this.m.HiringCost = 75;
		this.m.DailyCost = 8;
		this.m.Excluded = [
			"trait.tiny",
			"trait.clubfooted",
			"trait.gluttonous",
			"trait.bright",
			"trait.asthmatic",
			"trait.fat"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
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
		return "{Zawsze żądny przygód, %name% łatwo dał się wciągnąć w życie pomocnika karawany. | Osierocony przez wojnę i zarazę, %name% dorastał pod skrzydłami podróżującego kupca. | Życie karawaniarza jest ciężkie, ale %name% nigdy nie potrafił znieść zbyt długiego przebywania w jednym miejscu. | Choć praca jest niebezpieczna, dzięki byciu pomocnikiem karawany %name% miał możliwość poznać świat. | Kiedy jego rodzina i obowiązki zostały strawione przez pożar, %name% nie widział żadnego powodu, dla którego nie miałby dołączyć do akurat przejeżdżającej tamtędy karawany. | Twardy i stanowczy %name% był pierwszym z wybranych przez kupca pracowników, których zadaniem była ochrona zapasów w karawanie. | %name% uciekł z domu i nie minęło wiele czasu, gdy dołączył do karawany kupieckiej i zaczął w niej pracować.} {Jednak handlarz, dla którego pracował, okazał się być zwyrodnialcem, którego od poganiacza niewolników dzieliło jedno strzelenie batem. Po ostrej kłótni z kobietą, %name% uznał, że lepiej będzie odejść, zanim zrobi coś strasznego. | Pewnego dnia towar zaginął, a winą za to obarczono pomocnika, co natychmiast zakończyło jego pobyt w karawanie. | Jednakże karawana nie bez powodu potrzebuje ochrony, co udowodniła zasadzka bandytów. %name% ledwo uszedł wtedy z życiem. | Lata na szlaku przebiegały dość spokojnie, dopóki nowy pan karawany nie odmówił zapłaty pomocnikom. %name% jedną ręką strzelił swego szefa w pysk i odebrał należne mu wynagrodzenie. Do ucieczki użył jednak obu nóg. | W karawanach sytuacja często bywa napięta. Pewnego fatalnego wieczoru, podczas sporu o długi hazardowe, wetknął w ognisko głowę innego podróżnika. W obawie przed zemstą, %name% zwiał jeszcze przed świtem. | Niestety, wraz z rozszerzającą się wojną zyski karawaniarzy malały. %name% został zwolniony, gdy kolejni z kupców wycofali swoje wozy. | Po zobaczeniu tego, co bestie zrobiły z inną karawaną, %name% szybko zorientował się, że jego zarobki nie do końca odpowiadały poziomowi zagrożeń, z jakimi ta praca się wiązała. | Wojna pozbawiła karawanę zapasów i wkrótce jej mistrz zajął się sprzedażą niewolników. Oburzony, %name% uwolnił tylu, ilu zdołał, zanim odszedł na dobre. | Niestety, jego karawana zaczęła parać się handlem ludźmi. Choć zyski były ogromne, zwróciło to uwagę miejscowej milicji - oraz jej wideł. Wystarczyła jedna zasadzka i już %name% uciekał co sił w nogach, by ratować swoje życie.} {Teraz, nie będąc pewnym, co robić dalej, szuka każdej okazji, która może się nadarzyć. | Człowiekowi takiemu jak %name% nie jest obce niebezpieczeństwo, co czyni go dobrym kandydatem do każdej grupy najemników. | Gdy miał już za sobą czasy karawan, praca jako najemnik była innym sposobem na zysk i przygody. | %name% sądzi, że bycie najemnikiem jest dość podobne do bycia karawaniarzem. Tyle, że lepiej płatne. | Dobrze obeznany z podróżowaniem, %name% wydaje się naturalnie pasować do zadań, które stoją przed najemnikiem. | %name% całkiem nieźle zahartował się przez te wszystkie lata podróżowania po szlakach. Każdej grupie najemników przydałoby się więcej takich ludzi jak on.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				3,
				5
			],
			Bravery = [
				3,
				3
			],
			Stamina = [
				5,
				7
			],
			MeleeSkill = [
				4,
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
			items.equip(this.new("scripts/items/weapons/dagger"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/bludgeon"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/hatchet"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/weapons/shortsword"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/gambeson"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/padded_leather"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/thick_tunic"));
		}
		else
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}

		r = this.Math.rand(0, 2);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/headscarf"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/open_leather_cap"));
		}
	}

});

