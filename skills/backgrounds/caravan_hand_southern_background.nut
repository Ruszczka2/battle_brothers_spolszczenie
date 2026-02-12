this.caravan_hand_southern_background <- this.inherit("scripts/skills/backgrounds/caravan_hand_background", {
	m = {},
	function create()
	{
		this.caravan_hand_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernSkinny;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.BeardChance = 90;
		this.m.Ethnicity = 1;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.tiny",
			"trait.clubfooted",
			"trait.gluttonous",
			"trait.bright",
			"trait.asthmatic",
			"trait.fat"
		];
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "Zawsze żądny przygód, %name% łatwo dał się wciągnąć w życie pomocnika karawany. | Osierocony przez wojnę i zarazę, %name% dorastał pod skrzydłami podróżującego kupca. | Życie karawaniarza jest ciężkie, ale %name% nigdy nie potrafił znieść zbyt długiego przebywania w jednym miejscu. | Choć praca jest niebezpieczna, dzięki byciu pomocnikiem karawany %name% miał możliwość poznać świat. | Kiedy jego rodzina i obowiązki zostały strawione przez pożar, %name% nie widział żadnego powodu, dla którego nie miałby dołączyć do akurat przejeżdżającej tamtędy karawany. | Twardy i stanowczy %name% był pierwszym z wybranych przez kupca pracowników, których zadaniem była ochrona zapasów w karawanie. | %name% uciekł z domu i nie minęło wiele czasu, gdy dołączył do karawany kupieckiej i zaczął w niej pracować.} {Jednak handlarz, dla którego pracował, okazał się być zwyrodnialcem, którego od poganiacza niewolników dzieliło jedno strzelenie batem. Po ostrej kłótni z kobietą, %name% uznał, że lepiej będzie odejść, zanim zrobi coś strasznego. | Pewnego dnia towar zaginął, a winą za to obarczono pomocnika, co natychmiast zakończyło jego pobyt w karawanie. | Jednakże karawana nie bez powodu potrzebuje ochrony, co udowodniła zasadzka pustynnych bandytów. %name% ledwo uszedł wtedy z życiem. | Lata na szlaku przebiegały dość spokojnie, dopóki nowy pan karawany nie odmówił zapłaty pomocnikom. %name% jedną ręką strzelił swego szefa w pysk i odebrał należne mu wynagrodzenie. Do ucieczki użył jednak obu nóg. | W karawanach sytuacja często bywa napięta. Pewnego fatalnego wieczoru, podczas sporu o długi hazardowe, wetknął w ognisko głowę innego podróżnika. W obawie przed zemstą, %name% zwiał jeszcze przed świtem. | Niestety, wraz z rozszerzającą się wojną zyski karawaniarzy malały. %name% został zwolniony, gdy kolejni z kupców wycofali swoje wozy. | Po zobaczeniu tego, co bestie zrobiły z inną karawaną, %name% szybko zorientował się, że jego zarobki nie do końca odpowiadały poziomowi zagrożeń, z jakimi ta praca się wiązała. | Wojna pozbawiła karawanę zapasów i wkrótce jej mistrz zajął się sprzedażą niewolników. Oburzony, %name% uwolnił tylu, ilu zdołał, zanim odszedł na dobre. | Niestety, jego karawana zaczęła parać się handlem ludźmi. Choć zyski były ogromne, zwróciło to uwagę miejscowej milicji - oraz jej wideł. Wystarczyła jedna zasadzka i już %name% uciekał co sił w nogach, by ratować swoje życie.} {Teraz, nie będąc pewnym, co robić dalej, szuka każdej okazji, która może się nadarzyć. | Człowiekowi takiemu jak %name% nie jest obce niebezpieczeństwo, co czyni go dobrym kandydatem do każdej grupy najemników. | Gdy miał już za sobą czasy karawan, praca jako najemnik była innym sposobem na zysk i przygody. | %name% sądzi, że bycie najemnikiem jest dość podobne do bycia karawaniarzem. Tyle, że lepiej płatne. | Dobrze obeznany z podróżowaniem, %name% wydaje się naturalnie pasować do zadań, które stoją przed najemnikiem. | %name% całkiem nieźle zahartował się przez te wszystkie lata podróżowania po szlakach. Każdej grupie najemników przydałoby się więcej takich ludzi jak on.}";
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
			items.equip(this.new("scripts/items/weapons/bludgeon"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/oriental/light_southern_mace"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/oriental/saif"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/oriental/cloth_sash"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/oriental/padded_vest"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/oriental/nomad_robe"));
		}
		else
		{
			items.equip(this.new("scripts/items/armor/oriental/thick_nomad_robe"));
		}

		r = this.Math.rand(0, 3);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/oriental/southern_head_wrap"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/oriental/nomad_head_wrap"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/oriental/nomad_leather_cap"));
		}
	}

});

