this.retired_soldier_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.retired_soldier";
		this.m.Name = "Wysłużony Żołnierz";
		this.m.Icon = "ui/backgrounds/background_24.png";
		this.m.BackgroundDescription = "Wysłużeni żołnierze zazwyczaj mają przyzwoite doświadczenie w wojaczce, a ich stanowczość niełatwo złamać. Jednakże ich wiek odbił się na ich atrybutach fizycznych.";
		this.m.GoodEnding = "%name% znów przeszedł na emeryturę, tym razem z najemnictwa zamiast z wojska. Zostawiwszy %companyname%, zbudował chatę w lesie i cieszy się ciszą, trzymając się jak najdalej od walk.";
		this.m.BadEnding = "Zmęczony walką, %name% opuścił szybko podupadającą %companyname% i zbudował sobie chatę w lesie. Niestety, napadli włóczędzy. Mówi się, że znaleziono go wykrwawiającego się na podłodze, otoczonego sześcioma trupami i ostatnim ocalałym - nerwowym, złamanym chłopakiem, który drżącą ręką wymachiwał mieczem nad umierającym starcem.";
		this.m.HiringCost = 140;
		this.m.DailyCost = 15;
		this.m.Excluded = [
			"trait.weasel",
			"trait.swift",
			"trait.clubfooted",
			"trait.irrational",
			"trait.gluttonous",
			"trait.disloyal",
			"trait.clumsy",
			"trait.tiny",
			"trait.insecure",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.dastard",
			"trait.hesitant",
			"trait.fragile",
			"trait.iron_lungs",
			"trait.tough",
			"trait.strong",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"Stary Gwardzista",
			"Stary",
			"Sierżant",
			"Weteran",
			"Żołnierz"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.Old;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(2, 3);
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
		return "Dawniej {sierżantem | gwardzistą królewskim | oddanym żołnierzem | szanowanym zbrojnym | pierwszoliniowym | żołnierzem | piechurem} w armii lokalnego lorda, %fullname% {odszedł ze służby po strzale w kolano | został zastąpiony przez ambitnego młokosa | został wyrzucony za zaśnięcie na warcie | przeszedł na emeryturę po długiej i wzorowej służbie | został ranny w boju i zmuszony do odejścia | zmęczył się bitwami i rzeziami, kończąc służbę, zanim zniszczyła mu umysł | walczył z zaciekłymi hordami orków, a kampanie w końcu zmusiły go do emerytury}. {Zamknął swój ekwipunek w skrzyni wraz ze wspomnieniami służby, chcąc już nigdy po nie nie sięgać | Odłożył miecz i tarczę w swojej izbie jako same relikty wojskowej przeszłości | Powiesił broń nad kominkiem jako ciche przypomnienie człowieka, którym kiedyś był | Lecz czekał na niego nowy rozdział życia, w którym nie potrzebował miecza na co dzień | Mając za sobą wiele lat służby, mógł wreszcie zaznać ciszy i spokoju | Bez wrzasku wojskowej musztry jego życie nigdy nie było tak ciche}. {Przez wiele lat żył szczęśliwie z ukochaną żoną, aż zmarła ze starości. Nie mając się czego uchwycić | Dopiero gdy dowiedział się, że jego dawnych towarzyszy brutalnie wybito w zasadzce | Dopiero gdy usłyszał pogłoski o wielkiej inwazji, która ma zniszczyć jego ojczyznę, | Przez jakiś czas próbował żyć jak rolnik, ale każdego dnia brakowało mu dobrego miecza w dłoni i stania w murze tarcz. W końcu | Lecz życie poza armią okazało się nie dla niego, czuł się bezczynny i bezużyteczny. W końcu | Przez pewien czas czuł spokój. Ale gdy ziemię pochłonęła wojna, | Czas spędzony z dala od wojny był krótki, bo wojna szybko przyszła do niego. Niedługo potem | Żyjąc na farmie, nuda wpełzła w myśli %name% aż w końcu} sięgnął po broń raz jeszcze. Chociaż {jego najlepsze dni dawno minęły | nie jest już tak sprawny fizycznie jak kiedyś | jego kondycja nie jest już kondycją młodzieńca | nie jest już zadziornym młodym wojownikiem | czas z dala od służby stępił jego umiejętności}, {jego umiejętności szermiercze wciąż wystarczą, by pokonać każdego młodego pyszałka | wciąż wie, jak toczy się walka na polu bitwy | jego doświadczenie ustępuje nielicznym | może polegać na całym życiowym doświadczeniu bojowym | pragnie stanąć znów wśród braci | pragnie znów znaleźć bitwę | jego swędzenie do bitki idzie w parze z realnymi umiejętnościami | wciąż wie co nieco o utrzymaniu muru tarcz}.";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-10,
				-15
			],
			Bravery = [
				13,
				10
			],
			Stamina = [
				-10,
				-10
			],
			MeleeSkill = [
				13,
				10
			],
			RangedSkill = [
				5,
				0
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
				-5,
				-10
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
			items.equip(this.new("scripts/items/weapons/hand_axe"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/boar_spear"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/falchion"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/shields/wooden_shield"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/basic_mail_shirt"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/padded_leather"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/patched_mail_shirt"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/worn_mail_shirt"));
		}

		r = this.Math.rand(0, 8);

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
			items.equip(this.new("scripts/items/helmets/rusty_mail_coif"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/helmets/aketon_cap"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/helmets/full_aketon_cap"));
		}
	}

});

