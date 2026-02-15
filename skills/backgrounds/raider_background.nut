this.raider_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.raider";
		this.m.Name = "Najeźdźca";
		this.m.Icon = "ui/backgrounds/background_49.png";
		this.m.BackgroundDescription = "Każdy najeźdźca, który nadal żyje, bez wątpienia ma nieco doświadczenia w walce.";
		this.m.GoodEnding = "%name%, dawny najeźdźca, dobrze wpasował się w %companyname% i udowodnił, że jest znakomitym wojownikiem. Odkładając prawdziwą górę koron, odszedł z kompanii i wrócił skąd przybył. Ostatnio widziano go, jak płynął łodzią rzeczną w stronę małej wioski.";
		this.m.BadEnding = "Gdy %companyname% szybko podupadła, %name% odszedł z kompanii i znów poszedł własną drogą. Wrócił do grabieży, niosąc swoją zachłanną przemoc wzdłuż brzegów nadrzecznych wiosek. Nie wiesz, czy to prawda, ale mówi się, że został nadziany na widły przez parobka stajennego. Krążą też wieści, że miasteczko zawiesiło części jego ciała na zewnętrznych murach jako przestrogę dla przyszłych najeźdźców.";
		this.m.HiringCost = 160;
		this.m.DailyCost = 28;
		this.m.Excluded = [
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
			"Najeźdźca",
			"Maruder",
			"Straszny",
			"Bandyta",
			"Czteropalcy",
			"Kruczoczarny",
			"Wrona",
			"Krnąbrny",
			"Grabieżca",
			"Groźny"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Raider;
		this.m.Bodies = this.Const.Bodies.Muscular;
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
		return "{Żyjąc nad brzegiem, życie %name% było przyprawiane pieprzem morskich najeźdźców. Jako dorosły dołączył do nich w grabieżach. | Gdy jego rodzinę wyrżnięto, nowo narodzony %name% został przygarnięty przez tych samych najeźdźców, którzy to zrobili. | Urodzony w odległych stronach, %name% przybył do tych ziem, szukając miast do złupienia. | Silny mężczyzna z odległych rubieży, obecność %name% stała się przekleństwem dla miejscowych. | Najeźdźca z mocnym wiosłowym ramieniem i jeszcze silniejszym toporowym, %name% jest częścią folkloru, który trzyma dzieci w łóżkach nocą. | Po części wojownik, po części rzezimieszek, %name% ułożył sobie niezłe życie jako najeźdźca. | %name% dawno temu postanowił brać siłą od słabych wszystko, czego zapragnie, i od tamtej pory daje o sobie znać napadami na karawany i wsie. | Dorastając biedny i głodny, %name% z desperacji dołączył do rabusiów i rzezimieszków. Po raz pierwszy nie czuł głodu co noc, więc nadal brał siłą od innych to, czego potrzebował. Nauczył się walczyć i zabijać bez wyrzutów sumienia, a wkrótce stał się prawdziwym potworem człowieka. | Nosząc buty lorda i podartą suknię królowej jako narzutę, strój %name% dobrze odzwierciedla jego lata grabieży. | Zagrożenie, które budzi lordów ze snu i pędzi gospodynie pod łóżka, %name% jest groźnym najeźdźcą. | Silni biorą od słabych - taką zasadą żyje %name%.} {On i jego towarzysze napadali na karawany i łupili odległe farmy, aż pewnego dnia sami padli ofiarą ataku. Niewielka banda orków dostrzegła obóz %name% i zmiotła go jak siła natury, rozpraszając ocalałych we wszystkich kierunkach. %name% uciekł i nie oglądał się za siebie. | Po wielu latach niegodziwych zysków porzucił to życie, gdy napad na sierociniec zakończył się niekontrolowanym pożarem i śmiercią tych, którzy byli w środku. | Oddany wyznawca starych zwyczajów, %name% pragnie umrzeć chwalebną śmiercią wojownika, by zasiąść obok bogów. Ale rżnięcie wieśniaków jak bydła nie zwraca uwagi bogów, więc teraz szuka większego wyzwania. | Ale podczas gwałtów i grabieży zauważono, że %name% woli mężów bardziej niż żony. Jego upodobanie wykluczyło go z reszty drużyny. | Zaczęło się od udanego napadu na kupiecką karawanę. Nielicznych strażników szybko położono, a uciekający kupiec nie biegł dość szybko - oszczep w plecy był tego dowodem. Łupy były bogate, ale wkrótce wybuchła kłótnia o podział. Do wieczora większość najeźdźców pozabijała się nawzajem. %name% ledwo uszedł z życiem i nie miał nic poza utykającą nogą. | Ale zawsze miał słabość do kobiet i ciągłe gwałty oraz mordy jego towarzyszy odepchnęły go od tego stylu życia. | Schwytany przez strażników lorda, najeźdźca ledwo uciekł, patrząc z pobliskiego wzgórza, jak jego towarzyszy stracono. | Ale pewna wieś urządziła zasadzkę na jego bandę podczas napadu, wycinając wszystkich poza nim, gdy ukradł konia ze stajni i uciekł przed pewną zgubą. | Podczas zasadzki w lesie banda najeźdźców została zaatakowana przez wściekłe bestie. Nakarmił jednego z towarzyszy tymi paskudztwami tylko po to, by ratować własną skórę. | Ale gdy wojna rozdziera świat, najeźdźca zrozumiał, że coraz mniej jest do zrabowania. | Ale gdy konflikty się zaostrzają, każda wioska, do której trafiał, była albo skrajnie biedna, albo już uzbrojona przeciw innym potworom świata.} {Teraz %name% po prostu chce nowego początku, nawet w ponurym fachu najemników. | %name% nie jest w pełni godny zaufania jako najemnik, ale samo to, że działał wśród bandytów i najeźdźców, czyni go przynajmniej zdatnym do tej roboty. | Człowiek nie jest ani trochę braterski, ale potrafi władać bronią jakby była jednym z jego brakujących palców. | Choć przeszłość %name% zostawia gorzki posmak, są jeszcze gorsi. | %name% jest biegły w zabijaniu i rabowaniu, tylko dopilnuj, by te umiejętności były skierowane przeciw twoim wrogom. | Choć jest dobrym wojownikiem, %name% przede wszystkim jest wierny łupom. | %name% jest tu, by zabijać i zabierać. Dla ciebie to dobra rzecz. | %name% nosi na szyi naszyjnik z uszu, a na drugim naszyjniku wiszą kolczyki z tych uszu. Stylowo. | %name% to silny wojownik, ale ma spore szanse zostać najmniej lubianą osobą w całej twojej drużynie. | Wieś i pola to kuszące, zielone płótno, na którym można zbudować życie. Może najeźdźca po prostu chce się ustatkować. | W ubraniach naznaczonych krwią poprzedniego właściciela, %name% wygląda uderzająco gotowo do służby. | Masz wrażenie, że %name% nosi ubrania, w których kogoś prawdopodobnie zamordowano.}";
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");

		if (this.Math.rand(1, 100) <= 25)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
			tattoo_body.Visible = true;
		}

		if (this.Math.rand(1, 100) <= 40)
		{
			tattoo_head.setBrush("scar_02_head");
			tattoo_head.Visible = true;
		}
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
		r = this.Math.rand(0, 5);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/falchion"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/flail"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/hand_axe"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/morning_star"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/weapons/military_pick"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/weapons/boar_spear"));
		}

		r = this.Math.rand(0, 0);

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
			items.equip(this.new("scripts/items/armor/patched_mail_shirt"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/worn_mail_shirt"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/leather_lamellar"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/dented_nasal_helmet"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/nasal_helmet_with_rusty_mail"));
		}
	}

});

