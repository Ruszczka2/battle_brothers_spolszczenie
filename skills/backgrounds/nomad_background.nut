this.nomad_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.nomad";
		this.m.Name = "Koczownik";
		this.m.Icon = "ui/backgrounds/background_63.png";
		this.m.BackgroundDescription = "Każdy koczownik, który jest w stanie przeżyć na pustyni, musi mieć nieco doświadczenia w walce.";
		this.m.GoodEnding = "The nomad %name% left the %companyname% a few months after yourself. He apparently traveled south and now leads what they\'re calling the \'City on Legs,\' a huge band of peoples that roam the deserts. It is apparently so rich and successful a society that the Viziers worry their own people will flock to it.";
		this.m.BadEnding = "You learned that %name% the nomad departed the company with the hope of finding new plains to roam. Apparently, he got the idea in his head that he would travel far to the north and land cozily with the barbarians there. To his credit, the barbarians and nomads share a similar lifestyle, culture, language, religion, laws, struggles, conflicts, and general appearances aside. The nomad was butchered almost instantly upon entrance to a barbarian encampment and his remains eaten in a warrior ritual.";
		this.m.HiringCost = 200;
		this.m.DailyCost = 28;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.weasel",
			"trait.hate_undead",
			"trait.night_blind",
			"trait.ailing",
			"trait.asthmatic",
			"trait.clubfooted",
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
		this.m.Titles = [
			"Pustynny Najeźdźca",
			"z Pustyni",
			"Syn Pustyni",
			"Bicz Pustyni",
			"Skorpion",
			"Koczownik",
			"Czerwone Piaski",
			"Hiena",
			"Jastrząb",
			"Wąż",
			"Wolny",
			"Wędrowiec",
			"Przyczajony"
		];
		this.m.Bodies = this.Const.Bodies.SouthernMuscular;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.BeardChance = 90;
		this.m.Ethnicity = 1;
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
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
		return "{Jak wielu południowców, %name% to ktoś, kto dorastał na pustyni, przemierzając wydmy i napadając na karawany oraz zagubionych podróżników. | Urodzony w jednym z wielu pustynnych plemion Południa, %name% nauczył się zwyczajów piasków, zanim nauczył się czegokolwiek innego. | Nomadzi zamieszkują południowe pustynie i to właśnie w jednym z tych wędrownych plemion urodził się %name%. | Prawdziwi nomadzi są rzadkością w miastach południa i %name% niczym się od nich nie różni. | Nieczęsto widuje się koczownika poza jego żywiołem na wydmach południowych piasków, ale oto %name% stoi tu przed tobą, z ciemną opalenizną i szelmowskim uśmiechem}. {Jednakże polityka nomadów jest dość skomplikowana. Pewne wydarzenie, z którego koczownik-najemnik nie chce się wytłumaczyć, zaprowadziło go do miast w poszukiwaniu pracy. | Zasadą jego plemienia jest to, że co trzeci syn musi wyruszyć w podróż, aby zobaczyć świat i, jeśli zechce, dopiero wtedy może powrócić. Zatem oto %name% stoi tu teraz przed tobą. | Oskarżony o delikatną niestosowność seksualną z kobietą, która nie została mu formalnie podarowana, %name% stanął w obliczu egzekucji lub wygnania z plemienia. To, że wciąż oddycha i stoi tu teraz przed tobą, wskazuje, którą z tych dwóch opcji wybrał. | Po zamordowaniu jednego ze swoich współplemieńców z powodu długu hazardowego, koczownik został wygnany ze rodzinnego plemienia. | Ale katastrofalna w skutkach zasadzka, za której zaplanowanie był odpowiedzialny, spowodowała, że został wydalony ze swojego plemienia. | Ale koczownik chciał zobaczyć więcej z tego, co rozległy świat ma do zaoferowania, opuścił więc swoje plemię i wyruszył do miast w poszukiwaniu przygód}. {Koczownik stoi przed tobą w każdym calu swojego jestestwa: ciemna karnacja, czarne oczy, dłonie zeszlifowane piaskiem. O ile jeszcze nie jest wojownikiem, to z czasem można by go na takiego wyszkolić. | Jako człowiek z bezlitosnych piasków południa, nie dziwi, że koczownik jest fizycznie gotowy do podjęcia się zadań związanych z żywotem najemnika. To, czy posiada odpowiednie umiejętności, jest już zupełnie inną sprawą. | Ludzie, którzy zapuszczają się na pustynne pustkowia, są twardzi i %name% nie tutaj wyjątkiem. | Nomadzi tacy jak %name% zdobywają większość swojego doświadczenia bojowego w zasadzkach na karawany. Może się to przydać w grupie najemników, choć walka w pierwszym szeregu różni się nieco od napadania na biednych kupców. | %name% jest w każdym calu Południowcem, jakiego się spodziewasz: zniszczony przez piaski, a jednak z krzepą człowieka gotowego stawić czoła trudom dnia obecnego i wszystkich, które nadejdą. | %name% raczej nie jest jeszcze wyszkolonym i zdolnym wojownikiem, ale jako człowiek z południowych pustkowi z pewnością ma serce i ducha wojownika}.";
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
				0,
				-3
			],
			Stamina = [
				2,
				0
			],
			MeleeSkill = [
				12,
				10
			],
			RangedSkill = [
				5,
				0
			],
			MeleeDefense = [
				6,
				5
			],
			RangedDefense = [
				6,
				5
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
			items.equip(this.new("scripts/items/weapons/falchion"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/oriental/saif"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/oriental/nomad_mace"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/oriental/light_southern_mace"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/weapons/militia_spear"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/shields/oriental/southern_light_shield"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/oriental/nomad_robe"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/oriental/thick_nomad_robe"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/oriental/stitched_nomad_armor"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/oriental/leather_nomad_robe"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/oriental/nomad_head_wrap"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/oriental/nomad_leather_cap"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/oriental/nomad_light_helmet"));
		}
	}

});

