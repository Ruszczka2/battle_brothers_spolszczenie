this.monk_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.monk";
		this.m.Name = "Mnich";
		this.m.Icon = "ui/backgrounds/background_13.png";
		this.m.BackgroundDescription = "Mnisi odznaczają się zwykle wysoką stanowczością w tym co robią, choć nie przywykli do pracy fizycznej czy wojaczki.";
		this.m.GoodEnding = "%name% wrócił do spokojniejszych obowiązków duchowych. Obecnie przebywa w górskim klasztorze, ciesząc się ciszą i rozmyślając o czasie spędzonym w kompanii najemników. Inni mnisi nienawidzą go za walkę i zabijanie, ale on spisuje przełomowe dzieło o równowadze między pokojem a przemocą.";
		this.m.BadEnding = "Po duchowym załamaniu %name% porzucił walkę i znalazł dom w klasztorze. Wszyscy współbracia i opaci ostracyzowali go za udział w tak brutalnym przedsięwzięciu. Wieść niesie, że ostatecznie został wygnany, gdy kościelny przyłapał go na kradzieży z ofiary.";
		this.m.HiringCost = 60;
		this.m.DailyCost = 5;
		this.m.Excluded = [
			"trait.weasel",
			"trait.hate_beasts",
			"trait.swift",
			"trait.impatient",
			"trait.clubfooted",
			"trait.brute",
			"trait.gluttonous",
			"trait.disloyal",
			"trait.cocky",
			"trait.quick",
			"trait.dumb",
			"trait.superstitious",
			"trait.iron_lungs",
			"trait.craven",
			"trait.greedy",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"Świętobliwy",
			"Mnich",
			"Uczony",
			"Kaznodzieja",
			"Pobożny",
			"Cichy",
			"Spokojny",
			"Wierzący"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.Monk;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Monk;
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
			}
		];
	}

	function onBuildDescription()
	{
		return "{Po tym, jak najeźdźcy zamordowali jego rodzinę, %name% schronił się w religii i został mnichem w pobliskim klasztorze. | Często oddalając się od swojego kościoła i współbraci, %name% przez lata nauczał chłopów w odległych wsiach. | %name%, cichy mnich, spędził niezliczone dni na czczeniu starych bogów w klasztorze w %townname%. | Jeden z wielu mnichów, %name% zwykł wędrować po strzelistych świątyniach %randomtown%. | Porzucony na schodach klasztoru, %name% dorastał wśród mnichów i szybko przywykł do ich trybu życia. | Próbując odnaleźć spokój w spustoszonej krainie, %name% został mnichem. | Zawsze niesforne dziecko, %name% został oddany przez rodziców do miejscowego klasztoru, gdzie szybko go utemperowano.} {Niestety, upodobanie jego opata do młodzieży i cielesnych uciech doprowadziło do strasznego skandalu. %name% uciekł, by ocalić życie i wiarę. | Lecz jego wiara została nieodwracalnie nadwyrężona, gdy piekielny atak najeźdźców pozostawił mężczyzn wykastrowanych, kobiety zgwałcone, a dzieci nabite na pal. | Choć wierzył w starych bogów, mnich nie mógł znieść okrucieństw, jakich jego arcykapłan dopuszczał się w ich imieniu. W końcu odszedł, by szukać duchowości na własnych warunkach. | Gdy cierpienie świata narastało, opat %name% poprosił, by wyruszył leczyć ludzi - lub zabijać tych, którzy ich krzywdzą. | Kulty śmierci, koszmarne bestie i ludzie okrucieństwa. %name% opuścił mury świątyni, by ich wszystkich oczyścić. | Lecz gdy dziecko zadało mu pytanie kruszące wiarę, %name% porzucił ją, szukając duchowości inną drogą. | Niestety, modlitwy nie uchroniły jego braci przed rzezią. %name% zrozumiał, że lepiej zainwestować wiarę w dbanie o siebie niż w mamrotanie do jakiegoś rzekomego boga. | Zawsze porywczy, %name% opuścił bezpieczeństwo klasztorów, by wyruszyć i 'naprawić' świat. | Jeden z nielicznych piśmiennych ludzi, %name% porzucił ascetyczne życie, by poznać świat i, miejmy nadzieję, uleczyć to, co go trawi. | Lecz pewnej nocy ułożył się do łoża z kobietą. Obudził się z wiarą rozbitą w pogniecionych prześcieradłach wokół. Zawstydzony, nigdy nie wrócił do klasztoru. | Wykorzystał jednak zaufaną pozycję do niegodziwych zysków, kradnąc ze skarbca świątyni. Skandal szybko go stamtąd wypchnął. | Niestety, dziecko oskarżyło go o zachowanie niegodne mnicha. Nikt nie zna prawdy, ale %name% nie zabawił długo w kościele. | Pewnej nocy odkrył straszną prawdę w starym tomie. Niedługo potem %name% szybko opuścił kościół, nigdy do końca nie mówiąc, co odkrył.} {Ten człowiek niewiele wie o walce, ale ma hart ducha niczym góra opierająca się burzy. | Lata samotności i modlitw pozostawiły %name% bez kondycji, ale to jego zahartowany umysł ma największą wartość. | Być może nigdy naprawdę zadowolony z życia, trudno zrozumieć, czemu ktoś taki jak %name% miałby dołączyć do bandy najemników. | Może na świecie jest zbyt wiele diabłów, a może zbyt wiele w nim samym, ale nie pytasz, czemu %name% chce dołączyć do bandy najemników. | Wiara nie rozłupie zielonoskórego, ale też nie każe człowiekowi takiemu jak %name% przed nim uciekać. | Deklarowana przez %name% chęć oczyszczenia świata z 'niewiernych' jest niemal przerażająco stanowcza. | Choć duchowość %name% jest godna pochwały, nieustanne pomruki do starych bogów są trochę irytujące. | Choć dłonie %name% lepiej składają się do modlitwy niż na rękojeści miecza, mało który najemnik ma taką determinację. | Ze świętą księgą niemal przykutą do nadgarstka, %name% szuka towarzystwa najemników. | Święta księga, którą nosi, jest tak gruba, że mogłaby służyć za tarczę, ale %name% wygląda na przerażonego, gdy mówisz to na głos. | Być może z romantyczną wizją najemników potrzebujących duchowego oczyszczenia, %name% pragnie im towarzyszyć. | Gdy kiedyś czytał o kapłanach-wojownikach, %name% zapragnął naśladować tych odważnych, niezłomnych żołnierzy wiary. | Masz wrażenie, że %name% pragnie uwolnienia od tego grzesznego świata. Jeśli to prawda, trafił we właściwe miejsce.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				11,
				11
			],
			Stamina = [
				-10,
				0
			],
			MeleeSkill = [
				-5,
				-5
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

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		items.equip(this.new("scripts/items/armor/monk_robe"));
	}

});

