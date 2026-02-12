this.squire_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.squire";
		this.m.Name = "Giermek";
		this.m.Icon = "ui/backgrounds/background_03.png";
		this.m.BackgroundDescription = "Giermkowie zwykle są szkoleni w wojaczce, a często wyróżniają się też wysoką stanowczością w tym, co robią.";
		this.m.GoodEnding = "%name% the squire eventually left the %companyname%. You\'ve heard that he\'s since been knighted. No doubt he is sitting happy as a plum wherever he is.";
		this.m.BadEnding = "The squire, %name%, eventually departed the %companyname%. He intended to return home and become knighted, fulfilling his lifelong dream. Cruel politics got in the way and not only was he not knighted, he was stripped of his squire duties. Word has it he hanged himself from a barn\'s rafters.";
		this.m.HiringCost = 160;
		this.m.DailyCost = 20;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.clubfooted",
			"trait.irrational",
			"trait.disloyal",
			"trait.fat",
			"trait.fainthearted",
			"trait.craven",
			"trait.dastard",
			"trait.fragile",
			"trait.insecure",
			"trait.asthmatic",
			"trait.clumsy",
			"trait.pessimist",
			"trait.greedy",
			"trait.bleeder"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.YoungMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Muscular;
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
		return "{Jako młody giermek, %name% wiernie towarzyszył swojemu rycerzowi w wielu bitwach. | Będąc giermkiem dość surowego rycerza, %name% spędzał większość czasu na wykonywaniu poleceń swojego pana. | Chociaż był giermkiem, %name% głównie pilnował jeńców wojennych, co bardzo go irytowało. | %name% niby był giermkiem rycerza, jasne, ale przeważnie czyścił latryny, karmił psy i zbyt często korzystał z pudełka do polerowania.} {Pewnej nocy, sylwetki dziwnych, powłóczących nogami ludzi zamajaczyły na księżycowym horyzoncie. Rozległy się dzwony alarmowe, które przytłumiły ich przerażające jęki i pomrukiwania, a godzinę później połowa miasta %townname% leżała już w gruzach. | Podczas podróży, zbóje zaatakowali zaatakowali konwój jego pana. Dobyto mieczy, polała się krew, potoczyły się głowy. Kiedy kurz bitewny już opadł, było jasne, że giermek zawiódł: wszyscy, których miał chronić, leżeli martwi. | Pewnego wieczoru horda dzikich, futrzastych stworzeń napadła na zamek jego pana. W rozpaczy, %name% uwolnił grupę więźniów, mając nadzieję, że ci pomogą mu w walce. Zamiast tego, zabili jego pana i uciekli w czarną noc. Giermek odważnie walczył dalej, zdołał przeżyć, a u jego stóp leżał tuzin potężnych trupów. Po bitwie został jednak sam jeden i bez celu. | Wzburzony okropną zbrodnią w %townname%, wziął sprawy w swoje ręce, osobiście zabijając przestępcę. Był to czyn sprawiedliwy, ale też i niegodny. Młody giermek został wygnany za swoje nieposłuszeństwo. | Kiedy diaboliczny czerwony rycerz przybył do %townname% na pojedynek, rycerz, któremu %name% giermkował, okazał się zbyt chory, aby móc stoczyć walkę. Po wypiciu kufla dodającego odwagi trunku w pobliskiej gospodzie, %name% założył zbroję swojego pana i osobiście stanął do walki z czerwonym rycerzem. Cięciem miecza tak szybkim, że aż powietrze od niego zadrżało, %name% zabił swojego przeciwnika.} {Teraz pozostało mu tylko jedno zadanie - zdobycie tytułu rycerza. | Teraz giermek szuka towarzystwa porządnych ludzi, aby ponownie udowodnić, że godzien jest zostać rycerzem. | Jako że wojna pustoszy krainę, mnóstwo jest teraz okazji, aby mógł wykorzystać swoje umiejętności. | Choć może i jest trochę zbyt poważny, to nie ma wątpliwości, że świat potrzebuje takich ludzi jak %name%. Zwłaszcza w obecnych czasach.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				12,
				12
			],
			Stamina = [
				7,
				5
			],
			MeleeSkill = [
				7,
				5
			],
			RangedSkill = [
				7,
				8
			],
			MeleeDefense = [
				1,
				3
			],
			RangedDefense = [
				1,
				3
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
		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/shortsword"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/hatchet"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/winged_mace"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/boar_spear"));
		}

		r = this.Math.rand(0, 2);

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
			items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/gambeson"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/nasal_helmet"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/full_aketon_cap"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/aketon_cap"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/open_leather_cap"));
		}
	}

});

