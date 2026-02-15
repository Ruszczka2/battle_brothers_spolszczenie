this.historian_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.historian";
		this.m.Name = "Historyk";
		this.m.Icon = "ui/backgrounds/background_47.png";
		this.m.BackgroundDescription = "Historycy to uczone indywidua ze sporym zasobem wiedzy, całkowicie bezużytecznej na polu bitwy.";
		this.m.GoodEnding = "Nie spodziewałeś się, że historyk %name% zostanie w kompanii na zawsze. W końcu odszedł i mówi się, że zabrał ze sobą wielkie zapasy zwojów. Okazało się, że spisywał osiągnięcia %companyname%. Stworzył kodeks wszystkich dokonań, wpisując imiona najemników do ksiąg historii dla przyszłych pokoleń. Masz nadzieję, że czegoś się z waszych czynów nauczą.";
		this.m.BadEnding = "%companyname% nadal chyliło się ku upadkowi, a wielu nie-wojowników, takich jak historyk %name%, uznało to za dobry moment, by odejść. Próbowałeś śledzić losy tych ludzi, ale historyka łatwo było odnaleźć: zostawiał papierowy ślad. Odszukałeś go, pytając skrybów, czy o nim słyszeli. Odpowiedzieli, że to tylko drobny człowiek, który pisze tom o tym, jak mroczne, brutalne i bezsensowne jest życie najemnika.";
		this.m.HiringCost = 100;
		this.m.DailyCost = 8;
		this.m.Excluded = [
			"trait.huge",
			"trait.hate_beasts",
			"trait.paranoid",
			"trait.impatient",
			"trait.iron_jaw",
			"trait.dumb",
			"trait.athletic",
			"trait.brute",
			"trait.bloodthirsty",
			"trait.iron_lungs",
			"trait.irrational",
			"trait.cocky",
			"trait.dexterous",
			"trait.sure_footing",
			"trait.strong",
			"trait.tough",
			"trait.superstitious",
			"trait.spartan"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Fatigue
		];
		this.m.Titles = [
			"Sowa",
			"Pilny",
			"Historyk"
		];
		this.m.Faces = this.Const.Faces.SmartMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsOffendedByViolence = true;
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15%[/color] do zdobywanego doświadczenia"
			}
		];
	}

	function onBuildDescription()
	{
		return "{Zawsze był zachłannym czytelnikiem, a wczesne lata %name% to długie noce w bibliotece %randomcity%. | Gnębiony przez silniejszych rówieśników, młody %name% uciekł do świata książek. | Szukając prawdziwego źródła ludzkiej przeszłości, %name% czytał księgi i badał naturę człowieka. | Przy tak wielu zmianach na świecie %name% postanowił je zapisywać. | Szybko uczący się i spragniony dobrych lektur, %name% chciał zobaczyć świat na papierze dla innych. | Uczony z małego kolegium w %randomcity%, %name% spisuje dzieje świata dla przyszłych pokoleń. | Zmrożony mrocznymi wydarzeniami, %name% przestał badać rośliny i zaczął spisywać historię ludzi.} {Porządny historyk szuka najbliższych źródeł, jakie może znaleźć, co przywiodło go do kompanii najemników. | Po tym, jak zbójcy zniszczyli jego pisma, zapiął buty i ruszył po nowe badania - osobiście. | Gdy profesor stwierdził, że jego badania to śmieci, historyk ruszył w świat, by mu udowodnić, że się myli. | Oskarżony o plagiat, został wyrzucony z akademii. Szuka odkupienia w świecie tego, co badał: wojny. | Wykorzystując pozycję w akademii do uwodzenia kobiet, w końcu skandale i kontrowersje wypchnęły historyka z jego dziedziny, pozostawiając go bez grosza i gotowego podjąć każdą pracę. | Znudziło go czytanie o poszukiwaczach przygód, więc uznał, że sam założy rynsztunek i zobaczy wszystko z bliska. | Przy tylu bandach najemników krążących po świecie, historyk chciał się do kogoś przyłączyć, by prowadzić badania w terenie.} {%name% ma niewiele wspólnego z prawdziwymi żołnierzami, ale jego wyobraźnia i tak tęskni za dobrą bitwą. | Choć %name% całe życie pisał, dokładnie ani chwili nie spędził na walce. Do teraz. | %name% czuje potrzebę spisania waszych wędrówek. Może pomóc, chwytając za miecz i zakładając zbroję. | Na ramieniu %name% wisi torba pełna książek. Sugerujesz zamianę na cep - podobny, tylko bardziej kłujący i tnący. | %name% często bazgrze notatki, wciąż patrząc na świat oczami badacza. | %name% nosi kieszeń pełną piór. Ich lotki byłyby całkiem niezłymi strzałami. | Możesz zaufać szczerej chęci badawczej %name%, ale niekoniecznie jego umiejętnościom machania mieczem. | Czas %name% w kompanii ma służyć opracowaniu teorii, ale czy przetrwa eksperymenty? | Obiecujesz %name%, że jeśli zginie, znajdziesz sposób, by spisać jego życie. Dziękuje ci i wręcza swój testament. Jest napisany w obcym języku i niczego z niego nie rozumiesz. Uśmiechasz się mimo to.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-2,
				-5
			],
			Bravery = [
				0,
				0
			],
			Stamina = [
				-5,
				-5
			],
			MeleeSkill = [
				-5,
				-5
			],
			RangedSkill = [
				-3,
				-2
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
		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/feathered_hat"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.XPGainMult *= 1.15;
	}

});

