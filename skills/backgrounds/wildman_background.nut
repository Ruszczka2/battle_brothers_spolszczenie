this.wildman_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {
		Tattoo = 0
	},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.wildman";
		this.m.Name = "Dzikus";
		this.m.Icon = "ui/backgrounds/background_31.png";
		this.m.BackgroundDescription = "Dzicy ludzie są przyzwyczajeni do trudnego życia w dziczy, gdzie tylko silni są w stanie przetrwać. Mniej obeznani są z życiem w wielkich miastach, gdzie rządzi podstęp i przebiegłość.";
		this.m.GoodEnding = "Podczas gdy kompania %companyname% odwiedziła miasto, aby nieco odpocząć i zregenerować siły, dzikus %name% wpadł w oko miejscowej księżniczki. Został więc \'wykupiony\' za dużą sumę złota i podarowany szlachciance. Niedawno wpadłeś, by go odwiedzić i zobaczyć jak się ma. Podczas kolacji siedział przy królewskim stole, uśmiechając się głupkowato i naśladując otaczających go szlachciców najlepiej, jak potrafił. Jego nowa żona w niewytłumaczalny wręcz sposób uwielbiała go, a on uwielbiał ją. Kiedy się żegnaliście, podarował wam ciężką złotą koronę, którą zdjął ze swej głowy. Była ciężka, nosiła w sobie bowiem długie lata tradycji i wiele pradawnych historii. Powiedziałeś, że najlepiej będzie, jeśli ją zatrzyma. Dzikus wzruszył ramionami i odszedł, okręcając tę złotą obręcz wokół swego palca.";
		this.m.BadEnding = "Dzikus %name% trwał wiernie przy swej kompanii i z bólem patrzył, jak  %companyname% powoli się rozpada, aż któregoś dnia, tak po prostu, zniknął. Kompania wyruszyła do lasu, by go odszukać i w końcu znalazła coś w rodzaju prymitywnej notatki: ogromny stos koron obok narysowanej na ziemi kompanii %companyname% i kilku jej członków, wszyscy przytulani przez wielką, dosłownie patykowatą postać z głupkowatym uśmiechem na twarzy. Była też ofiara z martwego, na wpół zjedzonego królika.";
		this.m.HiringCost = 100;
		this.m.DailyCost = 12;
		this.m.Excluded = [
			"trait.weasel",
			"trait.teamplayer",
			"trait.fear_beasts",
			"trait.hate_undead",
			"trait.paranoid",
			"trait.night_blind",
			"trait.ailing",
			"trait.clubfooted",
			"trait.fat",
			"trait.tiny",
			"trait.gluttonous",
			"trait.pessimist",
			"trait.optimist",
			"trait.short_sighted",
			"trait.dexterous",
			"trait.insecure",
			"trait.hesitant",
			"trait.asthmatic",
			"trait.greedy",
			"trait.fragile",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.bright",
			"trait.cocky",
			"trait.dastard",
			"trait.drunkard"
		];
		this.m.Titles = [
			"Brutalny",
			"Wyrzutek",
			"Dzikus",
			"Zdziczały",
			"Dziki",
			"Barbarzyńca"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.WildMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.Wild;
		this.m.BeardChance = 100;
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
			},
			{
				id = 15,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15%[/color] do zdobywanego doświadczenia"
			}
		];
	}

	function onBuildDescription()
	{
		return "{Dla niektórych dzicz jest schronieniem. | Mówi się, że człowiek rodzi się z dziczą w sobie i że robi źle, odwracając się do niej plecami. | Cywilizacja jest plamą na karcie historii ludzkości - jednym wielkim przedłużającym się uzbrajaniem każdego kolejnego pokolenia, aby lepiej walczyć z ostatecznym wrogiem: samą Matką Naturą. | W czasach wojny nie jest zaskakujące, że wielu ponownie szuka schronienia w dziczy. | Niektórzy ludzie, szukając schronienia, uciekają z miasta do miasta. Inni zatrzymują się gdzieś pomiędzy nimi, znikając w spokojnych lasach.} {%name% kiedyś znalazł bezpieczne schronienie wśród drzew, ale ten czas już minął. | Niegdyś tajemnicza postać dla myśliwych - słynny \'sotoje\' - %name% powraca teraz do cywilizacji z nieznanych powodów. | %name% ma ręce kowala, ale higienę chlewu. | Może to z powodu odrzuconej miłości, a może po prostu wojny, ale %name% spędził ostatnią dekadę z dala od reszty ludzkości. | %name% żył wśród drzew przez niezliczone lata, aż jakiś kłusownik osiedlił się na terenach, na których zwykle polował. | Zręcznie zszyte ubranie, które %name% na sobie nosi, oraz jego ogólny atawistyczny wygląd może sugerować, że w przeszłości był krawcem lub garbarzem}. {Istnieje oczywista bariera językowa z dzikusem, ale z jakiegoś powodu wydaje się on bardzo chętny do walki. Miejmy nadzieję, że jego nowo odkryte \'powołanie\' nie ma jakiejś swojej ciemnej strony. | Kolorowe i trwałe rytualne tatuaże zdobią całe jego ciało. Zapytany, dlaczego chce dołączyć do bandy najemników, chrząknął i krzywym palcem narysował na niebie jedną ze swoich cielesnych ozdób. | Blizny, zarówno stare, jak i całkiem świeże, zdobią jego wytatuowane ciało. I nie są one powierzchowne - ten człowiek walczył w dziczy z nie byle czym. | Można się zastanawiać, czy nieszczęścia, które wcześniej wygoniły go do lasu, nie powróciły, aby przegonić go z powrotem w las. | Sądząc po jego dzikim odburkiwaniu, wątpliwe jest, aby przybył tutaj, aby powrócić do cywilizacji. | Lata spędzone w odosobnieniu wcale nie sprawiły, że zapomniał on, co można kupić za kilka koron. Pytanie brzmi, dlaczego wrócił? | Krzepy ma tyle, że mógłby siłować się z dzikiem - a jego liczne blizny sprawiają, że można się zastanawiać, czy czasem faktycznie tego nie robił.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				12,
				10
			],
			Bravery = [
				12,
				10
			],
			Stamina = [
				18,
				23
			],
			MeleeSkill = [
				6,
				0
			],
			RangedSkill = [
				-5,
				0
			],
			MeleeDefense = [
				-5,
				0
			],
			RangedDefense = [
				-5,
				-5
			],
			Initiative = [
				-5,
				-5
			]
		};
		return c;
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local dirt = actor.getSprite("dirt");
		dirt.Visible = true;
		this.m.Tattoo = this.Math.rand(0, 1);
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");
		local body = actor.getSprite("body");
		tattoo_body.setBrush((this.m.Tattoo == 0 ? "warpaint_01_" : "scar_02_") + body.getBrush().Name);
		tattoo_body.Visible = true;
		tattoo_head.setBrush(this.m.Tattoo == 0 ? "warpaint_01_head" : "scar_02_head");
		tattoo_head.Visible = true;
	}

	function updateAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");

		if (tattoo_body.HasBrush)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush((this.m.Tattoo == 0 ? "warpaint_01_" : "scar_02_") + body.getBrush().Name);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;

		if (this.Const.DLC.Unhold)
		{
			r = this.Math.rand(0, 7);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/weapons/hatchet"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/wooden_stick"));
			}
			else if (r == 2)
			{
				items.equip(this.new("scripts/items/weapons/greenskins/orc_metal_club"));
			}
			else if (r == 3)
			{
				items.equip(this.new("scripts/items/weapons/greenskins/orc_wooden_club"));
			}
			else if (r == 4)
			{
				items.equip(this.new("scripts/items/weapons/boar_spear"));
			}
			else if (r == 5)
			{
				items.equip(this.new("scripts/items/weapons/woodcutters_axe"));
			}
			else if (r == 6)
			{
				items.equip(this.new("scripts/items/weapons/two_handed_wooden_hammer"));
			}
			else if (r == 7)
			{
				items.equip(this.new("scripts/items/weapons/two_handed_wooden_flail"));
			}
		}
		else
		{
			r = this.Math.rand(0, 6);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/weapons/hatchet"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/wooden_stick"));
			}
			else if (r == 2)
			{
				items.equip(this.new("scripts/items/weapons/greenskins/orc_metal_club"));
			}
			else if (r == 3)
			{
				items.equip(this.new("scripts/items/weapons/greenskins/orc_wooden_club"));
			}
			else if (r == 4)
			{
				items.equip(this.new("scripts/items/weapons/boar_spear"));
			}
			else if (r == 5)
			{
				items.equip(this.new("scripts/items/weapons/woodcutters_axe"));
			}
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.XPGainMult *= 0.85;
	}

	function onSerialize( _out )
	{
		this.character_background.onSerialize(_out);
		_out.writeU8(this.m.Tattoo);
	}

	function onDeserialize( _in )
	{
		this.character_background.onDeserialize(_in);
		this.m.Tattoo = _in.readU8();
	}

});

