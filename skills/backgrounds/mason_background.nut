this.mason_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.mason";
		this.m.Name = "Murarz";
		this.m.Icon = "ui/backgrounds/background_17.png";
		this.m.BackgroundDescription = "Dobry murarz przyzwyczajony jest do pracy fizycznej i uczenia się, aby udoskonalić swoje rzemiosło.";
		this.m.GoodEnding = "Masonry has its own call, notably a call perfectly cut stones and impossible towers that defy the eye\'s ability to even shape them against the skies. %name% the mason returned to his old trade and, with all the money he\'d made with the %companyname%, he started a reputable business renowned for its ability to construct stone rooms that held the heat during winters and the cool during summers.";
		this.m.BadEnding = "The %companyname% continued to suffer losses long after you\'d left. More and more of the brothers departed the company, a good lot of them returning to old trades. %name% the mason was no different. Sadly, all the time spent fighting had destroyed any steadiness he had left. With hands that wouldn\'t stop shaking, he could no longer shape stones like he used to. Last you heard, he was hauling rocks as a daytaler instead of shaping them as a mason.";
		this.m.HiringCost = 90;
		this.m.DailyCost = 8;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.athletic",
			"trait.asthmatic",
			"trait.dumb",
			"trait.clumsy",
			"trait.bloodthirsty"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
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
				id = 13,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5%[/color] do zdobywanego doświadczenia"
			}
		];
	}

	function onBuildDescription()
	{
		return "{Dorastając w %townname%, %name% spędził młodość studiując z zapałem księgi budowlane. | \x200b\x200bWychowany przez cech rzemieślników, %name% szybko wspinał się po szczeblach kariery w dziedzinie murarstwa, co nie było zaskoczeniem. | Jako uczeń szanowanego uniwersytetu w %randomtown%, %name% ukończył szkołę z wielkimi oczekiwaniami i jeszcze większymi rzeczami, które miał później zbudować. | %name% za ojca miał murarza, więc sam też murarstwem zaczął się parać. |              Zadziwiony królewskimi strukturami kościoła i państwa, %name% zakochał się w murarstwie. | Kiedy %randomtown% rozpaczliwie potrzebowało murów obronnych, %name% zajął się murarstwem i wyszło, że ma do tego wrodzony talent.} {Niestety, niedługo dane mu było pracować jako murarz. Wybudowany przez niego kościół zawalił się, a z jego ruin wyłonił się morderczy tłum szukający zemsty. | Pięć budynków wybudowanych, pięć zburzonych. Niekończące się wojny sprawiły, że ów człek nie był w stanie wypełnić swego powołania. | Zdradzony przez innego architekta, murarz zamurował rywala w ścianach swojego kolejnego projektu. Nie minęło dużo czasu, gdy ludzie zaczęli zadawać pytania. | Podczas krycia dachu popełnił jednak błąd i spadł. Przez odniesione obrażenia musiał opuścić swą profesję. | Jednak gdy lord zażądał, aby zbudował mu przerażające lochy, ten odmówił. Ma teraz dożywotni zakaz wykonywania swego fachu. | Przez nieszczęsny plan budowy, który gdzieś się zapodział, omyłkowo zbudował świątynię Davkulianów, zamiast świątyni Davkuliadów. Teraz twierdzi, że ścigają go sami bogowie.} {Odkładając młotek i dłuto na rzecz młota i naostrzonego dłuta zwanego mieczem, %name% przerzucił się na zawód najemnika. | Pewnego dnia plakat przedstawiający oddział najemników przykuł jego uwagę. Podobnie jak w przypadku jego dawnych budowli, reszta jest już historią. | Lata murarstwa uczyniły go gotowym na życie pełne krwi i błota. | %name% znajduje wadę lub słaby punkt w każdym mijanym budynku. Miejmy nadzieję, że uda mu się wykorzystać tę irytującą spostrzegawczość na polach bitew.}";
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
				0
			],
			Stamina = [
				5,
				5
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

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(0, 3) == 3)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.MasonTitles[this.Math.rand(0, this.Const.Strings.MasonTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		items.equip(this.new("scripts/items/armor/linen_tunic"));
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.XPGainMult *= 1.05;
	}

});

