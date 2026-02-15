this.thief_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.thief";
		this.m.Name = "Złodziej";
		this.m.Icon = "ui/backgrounds/background_11.png";
		this.m.BackgroundDescription = "Dobry złodziej będzie miał szybki refleks i zdolność czmychnięcia swoim wrogom.";
		this.m.GoodEnding = "%name% złodziej porzucił walkę i zniknął z map. Od tamtej pory nic o nim nie słyszałeś, ale krążą plotki, że pewien szlachcic miał jeden ze swoich skarbców całkowicie wyczyszczony w perfekcyjnie przeprowadzonym skoku.";
		this.m.BadEnding = "%name% złodziej wyczuł, skąd wieje wiatr, i opuścił %companyname%, póki jeszcze mógł. Zabrał zarobione pieniądze i skrzyknął ekipę złodziei i bandytów. Ostatnio słyszałeś, że przeprowadził idealny skok, po czym jeden ze wspólników wbił mu nóż w plecy i uciekł ze wszystkim.";
		this.m.HiringCost = 95;
		this.m.DailyCost = 10;
		this.m.Excluded = [
			"trait.huge",
			"trait.teamplayer",
			"trait.hate_undead",
			"trait.hate_greenskins",
			"trait.hate_beasts",
			"trait.paranoid",
			"trait.night_blind",
			"trait.clubfooted",
			"trait.brute",
			"trait.dumb",
			"trait.loyal",
			"trait.clumsy",
			"trait.fat",
			"trait.strong",
			"trait.hesitant",
			"trait.insecure",
			"trait.clubfooted",
			"trait.short_sighted",
			"trait.brute",
			"trait.strong",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"Cień",
			"Kieszonkowiec",
			"Wąż",
			"Kruk",
			"Włamywacz",
			"Porywacz",
			"Czarny Kocur",
			"Książę",
			"Szybkopalcy",
			"Złodziejaszek"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsLowborn = true;
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
		return "{Wychowany przez złodziei na diecie z miodowego mleka i kradzionego złota, %name% zaczął życie z niewłaściwej strony. | Wychowany przez pijanego ojca i chorą matkę, %name% został wychowany prosto do życia złodzieja. | Urodzony jako szóste dziecko już biednej rodziny, młody złodziej %name% poznał fach, kradnąc ostatnie kęsy kolacji. | Dorastając w rodzinie służącej bogatemu szlachcicowi, przyszły złodziej %name% przez lata wpatrywał się w królewskie przepychy - i je okradał. | Przygarnął go miejscowy sierociniec; szybko zaczął dostawać baty od byle jakich sierot. Ratował się kradzieżą. | Osierocony %name% dorastał jako uliczny urwis, a jego dni wyznaczało podcinanie sakiewek i kieszonkarstwo. | Choć nigdy szczególnie nie potrzebował pieniędzy, zazdrość o dobra materialne pchnęła %name% do kradzieży. | Rozrzutność bogatych wśród tłumów biednych zawsze działała %name% na nerwy. Okradał więc jednych i drugich, oddając sobie. | Ojciec %name% nauczył go wszystkiego o kradzieży, niestety także jak wbijać nóż w plecy. | Kościół kradnie srebrną tacą. Lordowie robią to poborcą. %name% uznał, że czemu on nie może robić tego własnymi rękami? | Dorastając w biedzie, %name% kradł chleb. Kiedy się nażarł, zaczął kraść korony.} {Po latach udanych kradzieży jeden błąd wsadził %name% do lochu. Na szczęście lata kradzieży to też lata wytrychów i nie zabawił tam długo. | Gdy złapano go na kradzieży kielicha ze świątyni, rozmowa z księdzem przekonała %name%, by wybrać inną drogę. | Niestety, szybki skok na lokalny sklep zakończył się złapaniem go na gorącym uczynku. Wkrótce wizerunek trafił na plakaty, utrudniając mu robotę. | Odwaga, by podciąć sakiewkę grubego kupca, skończyła się tym, że %name% opatrywał dłoń bez kilku palców. Bardzo je lubił. | Kradzieże wyniosły %name% na czoło całej gildii. Po tuzinie nieudanych zamachów zrozumiał jednak, że w tym fachu nikomu nie można ufać. | Współpracując z piękną kobietą, %name% okradał wszystkich. Szkoda, że ona okradła jego. | Gdy próbował sprzedać towar, zaufany paser okazał się zdrajcą. Jedno nieprzyjemne spotkanie z pręgierzem później, złodziej został wygnany z %randomtown%. | To był idealny skok. Tyle się o nim mówi. Teraz %name% musi się ukryć. | Torturowany przez konkurencyjny gang, stracił sporo zębów, paznokci i chęci do powrotu do kradzieży. | Jego czas jako złodzieja skończył się, gdy po aresztowaniu spędził pięć dni w pręgierzu w sezonie pomidorowym. | Naturalnie niedługo potem trafił do więzienia. Nie mówi o tym czasie, ale widać, że nie chce tam wracać. | Pewnego dnia zrozumiał, że są lepsze sposoby na kręcenie ostrzem za monetę niż drobne kradzieże. | Ale jego przyrodni brat został pojmany przez lokalny gang, zmuszając złodzieja do szukania nowych sposobów na zapłacenie wysokiego okupu. | Życie bandyty nie jest łatwe. Aresztowany za zjedzenie cudzej kury, stracił dwa palce i chęć do dalszych kradzieży. | Gdy skok poszedł źle, wydał wszystkich dawnych wspólników, by ratować własną skórę. Teraz nie może wrócić do kradzieży.} {Możliwe, że %name% tylko chowa się za najemnikami. Niezależnie od powodu, musi zapracować na żołd. | Rozpoznajesz %name% z plakatów. Cóż, człowiek, który zaszedł tak daleko bez złapania, musi mieć wartość. | Jedną ręką %name% kręci ostrzem między palcami. Drugą podbiera twoją sakiewkę. Imponujące. Teraz oddaj. | Lata kradzieży uczyniły %name% mistrzem ucieczek z kłopotów. | %name% ma umiejętności dobrego najemnika, tylko pilnuj sakiewki, gdy jest obok. | Nie można ufać komuś takiemu jak %name%, ale to nie jest tu niczym wyjątkowym. | Podobno ktoś raz strzelił do %name% z łuku. Spudłował, ale złodziej zachował pióra. | Niech próba dołączenia %name% do najemników nie okaże się planem okradzenia twojej sakiewki. | Plakaty gończe mówią, że %name% jest 'uzbrojony i niebezpieczny'. Idealnie. | Wielu stróżów prawa szuka %name%. Może ich też zaciągniesz.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				5,
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
				0,
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
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/dagger"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/headscarf"));
		}
	}

});

