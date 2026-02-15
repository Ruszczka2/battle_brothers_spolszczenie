this.thief_southern_background <- this.inherit("scripts/skills/backgrounds/thief_background", {
	m = {},
	function create()
	{
		this.thief_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernSkinny;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.SouthernYoung;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.Ethnicity = 1;
		this.m.Excluded = [
			"trait.superstitious",
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
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{Wychowany przez złodziei na diecie z miodowego mleka i kradzionego złota, %name% zaczął życie z niewłaściwej strony. | Wychowany przez pijanego ojca i chorą matkę, %name% został wychowany prosto do życia złodzieja. | Urodzony jako szóste dziecko już biednej rodziny, młody złodziej %name% poznał fach, kradnąc ostatnie kęsy kolacji. | Dorastając w rodzinie służącej bogatemu kupcowi, przyszły złodziej %name% przez lata wpatrywał się w dekadencki przepych - i go okradał. | Przygarnął go miejscowy sierociniec; szybko zaczął dostawać baty od byle jakich sierot. Ratował się kradzieżą. | Osierocony %name% dorastał jako uliczny urwis, a jego dni wyznaczało podcinanie sakiewek i kieszonkarstwo. | Choć nigdy szczególnie nie potrzebował pieniędzy, zazdrość o dobra materialne pchnęła %name% do kradzieży. | Rozrzutność bogatych wśród tłumów biednych zawsze działała %name% na nerwy. Okradał więc jednych i drugich, oddając sobie. | Ojciec %name% nauczył go wszystkiego o kradzieży, niestety także jak wbijać nóż w plecy. | Kościół kradnie srebrną tacą. Lordowie robią to poborcą. %name% uznał, że czemu on nie może robić tego własnymi rękami? | Dorastając w biedzie, %name% kradł chleb. Kiedy się nażarł, zaczął kraść korony.} {Po latach udanych kradzieży jeden błąd wsadził %name% do lochu. Na szczęście lata kradzieży to też lata wytrychów i nie zabawił tam długo. | Gdy złapano go na kradzieży kielicha ze świątyni, rozmowa z mnichem przekonała %name%, by wybrać inną drogę. | Niestety, szybki skok na lokalny sklep zakończył się złapaniem go na gorącym uczynku. Wkrótce wizerunek trafił na plakaty, utrudniając mu robotę. | Odwaga, by podciąć sakiewkę grubego kupca, skończyła się tym, że %name% opatrywał dłoń bez kilku palców. Bardzo je lubił. | Kradzieże wyniosły %name% na czoło całej gildii. Po tuzinie nieudanych zamachów zrozumiał jednak, że w tym fachu nikomu nie można ufać. | Współpracując z piękną kobietą, %name% okradał wszystkich. Szkoda, że ona okradła jego. | Gdy próbował sprzedać towar, zaufany paser okazał się zdrajcą. Jedno nieprzyjemne spotkanie z pręgierzem później, złodziej został wygnany z %randomtown%. | To był idealny skok. Tyle się o nim mówi. Teraz %name% musi się ukryć. | Torturowany przez konkurencyjny gang, stracił sporo zębów, paznokci i chęci do powrotu do kradzieży. | Jego czas jako złodzieja skończył się, gdy po aresztowaniu spędził pięć dni w pręgierzu w sezonie pomidorowym. | Naturalnie niedługo potem trafił do więzienia. Nie mówi o tym czasie, ale widać, że nie chce tam wracać. | Pewnego dnia zrozumiał, że są lepsze sposoby na kręcenie ostrzem za monetę niż drobne kradzieże. | Ale jego przyrodni brat został pojmany przez lokalny gang, zmuszając złodzieja do szukania nowych sposobów na zapłacenie wysokiego okupu. | Życie bandyty nie jest łatwe. Aresztowany za zjedzenie cudzej kury, stracił dwa palce i chęć do dalszych kradzieży. | Gdy skok poszedł źle, wydał wszystkich dawnych wspólników, by ratować własną skórę. Teraz nie może wrócić do kradzieży.} {Możliwe, że %name% tylko chowa się za najemnikami. Niezależnie od powodu, musi zapracować na żołd. | Rozpoznajesz %name% z plakatów. Cóż, człowiek, który zaszedł tak daleko bez złapania, musi mieć wartość. | Jedną ręką %name% kręci ostrzem między palcami. Drugą podbiera twoją sakiewkę. Imponujące. Teraz oddaj. | Lata kradzieży uczyniły %name% mistrzem ucieczek z kłopotów. | %name% ma umiejętności dobrego najemnika, tylko pilnuj sakiewki, gdy jest obok. | Nie można ufać komuś takiemu jak %name%, ale to nie jest tu niczym wyjątkowym. | Podobno ktoś raz strzelił do %name% z łuku. Spudłował, ale złodziej zachował pióra. | Niech próba dołączenia %name% do najemników nie okaże się planem okradzenia twojej sakiewki. | Plakaty gończe mówią, że %name% jest 'uzbrojony i niebezpieczny'. Idealnie. | Wielu stróżów prawa szuka %name%. Może ich też zaciągniesz.}";
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		items.equip(this.new("scripts/items/weapons/knife"));
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/oriental/cloth_sash"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/oriental/nomad_robe"));
		}

		items.equip(this.new("scripts/items/helmets/oriental/nomad_head_wrap"));
	}

});

