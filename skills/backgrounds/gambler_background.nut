this.gambler_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.gambler";
		this.m.Name = "Hazardzista";
		this.m.Icon = "ui/backgrounds/background_20.png";
		this.m.BackgroundDescription = "Hazardziści zwykle mają dobry refleks i wyższą stanowczość od swoich przeciwników przy stole karcianym.";
		this.m.GoodEnding = "It was perhaps a risk to take a gambler like %name% into your ranks. Now, many days later it\'s obvious you made the right choice. Last you heard, he was still with the company and uses his earnings to enrich his habits. Rumor has it that, through all his winnings, he\'s secretly become one of the richest men in all the land. You think it\'s a bunch of hogwash, but a surprising number of mayors have become suddenly lax on gaming...";
		this.m.BadEnding = "%name% the gambler retired from the declining company and returned to his gambling ways. He quickly acquired great debts he could not pay. You saw him begging on a street corner with one of his hands missing and gaps in his teeth. You dropped a few crowns into his tin and said a few words, but he did not recognize you.";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.huge",
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.hate_beasts",
			"trait.paranoid",
			"trait.brute",
			"trait.athletic",
			"trait.dumb",
			"trait.clumsy",
			"trait.loyal",
			"trait.craven",
			"trait.dastard",
			"trait.deathwish",
			"trait.short_sighted",
			"trait.spartan",
			"trait.insecure",
			"trait.hesitant",
			"trait.strong",
			"trait.tough",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"Licho",
			"Dzika Karta",
			"Farciarz",
			"Szczęściarz",
			"Ryzykant",
			"Hazardzista"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Thick;
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
		return "{Mawiają, że łut szczęścia to sam diabeł, więc jakże długo ktoś taki jak %name% mógłby z nim igrać? | Każdy w jakiś sposób igra z losem, więc %name% uznał, że dlaczego miałby nie robić tego dla pieniędzy? | Kości, karty, kulki - wiele jest sposobów, aby zarobić, a %name% zna je wszystkie. | %name% ma oczy pustynnego węża - a grzechot kości w ręku to jego muzyka jego duszy. | W świecie, gdzie igra się z życiem i śmiercią, podejmowanie ryzyka to coś, w czym %name% został zawodowcem. | Ktoś taki jak %name% potrafi wyczuć skąd wiatr wieje... i jaka jest następna karta w talii.} {Utrzymywał się z gry w karty, wędrując od miasta do miasta i przenosząc się do następnej osady, gdy już całkiem opróżnił sakiewki mieszkańców. | Zagadką jest jednak, jak można wybrać grę w karty jako sposób na życie. | Wciąż przybywający i odchodzący najemnicy stanowili łatwy cel - do czasu aż jeden taki żałosny przegrany przegonił go swym dwuręcznym mieczem. | Osierocony już w czasie własnych narodzin, od zawsze zarabiał jakieś marne grosze na życie grając z innymi. | Gdy był dzieckiem, gra w kubki uzmysłowiła mu, jak ważny w życiu jest spryt i kombinatorstwo. | Gdy jego ojciec popadł w długi karciane, uznał, że najlepszym sposobem na ich spłacenie będzie samemu zostać cwanym kombinatorem. | Po tym, jak okoliczne miasta w ramach \'religijnego nawrócenia\' zakazały hazardu i skonfiskowały wszystkie pieniądze z tego typu praktyk i szwindli, %name% został w zasadzie bez zajęcia.} {Teraz ów hazardzista gotów jest rzucić swe kości na wiatr - a także w błoto, zaciągając się do każdej bandy, która coś płaci. | Zastanawiające jest dlaczego taki gracz dalej nie gra w karty. Jednakże, może to i dobrze, że widzi twą kompanię jako coś, na co warto postawić. | Być może lata oszukiwania najemników dały mu przekonanie, że sam z łatwością mógłby najemnikiem zostać. | Cwany i o szybko myślący karciarz, aby przeżyć wykonuje swe ruchy, zanim zrobią to inni. W tym świecie jest to zdolność równie użyteczna, co każda inna. | O ironio, przez kiepską partię wpadł w ogromny dług u barona. Teraz szuka innego sposobu, aby go spłacić. | Wojny przegnały w inne miejsca większość grubych ryb z jego karcianego biznesu. Zamiast siedzieć na miejscu i czekać, uznał, że zbierze tyłek w troki i podąży za nimi.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-2,
				-2
			],
			Bravery = [
				12,
				12
			],
			Stamina = [
				-6,
				-5
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
				2
			],
			RangedDefense = [
				2,
				8
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
			items.equip(this.new("scripts/items/armor/noble_tunic"));
		}
		else
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/feathered_hat"));
		}
	}

});

