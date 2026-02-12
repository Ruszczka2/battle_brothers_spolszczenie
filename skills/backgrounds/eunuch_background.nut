this.eunuch_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.eunuch";
		this.m.Name = "Rzezaniec";
		this.m.Icon = "ui/backgrounds/background_52.png";
		this.m.BackgroundDescription = "Fakt, że rzezańcy nie mogą płodzić dzieci jest raczej drugorzędną sprawą dla kompanii najemników.";
		this.m.GoodEnding = "For %name%, some things would just always come up a little short. But that didn\'t stop the eunuch from enjoying himself. Retiring from the %companyname% with a large pile of crowns, and completely devoid of the allures of women, the man went on to live a wonderful, extremely focused life.";
		this.m.BadEnding = "It\'s said that %name% the eunuch departed from the company shortly after you did. He traveled the lands, broke and broken, wasting his scant crowns on ale and wenches. Insulted by a whore for his cockless nature, the drunken and enraged eunuch stabbed the woman in the eye with a goat horn. Still inebriated when the constable found him, the confused and bewildered eunuch was stripped, hanged, and mutilated by the townspeople before having his body fed to pigs.";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.weasel",
			"trait.lucky",
			"trait.cocky",
			"trait.athletic",
			"trait.brute",
			"trait.bloodthirsty",
			"trait.deathwish",
			"trait.impatient"
		];
		this.m.Titles = [
			"Eunuch",
			"Wałach"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.YoungMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = null;
		this.m.Bodies = this.Const.Bodies.Muscular;
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
		return "{Kiedy %name% był zaledwie małym chłopcem, miejscowy duchowny wykastrował go, aby jego głos mógł osiągnąć wyższą tonację w miejscowym chórze. | Kiedy bandyci najechali jego wioskę, %name% walczył dzielnie, lecz po porażce w ramach kary oderżnięto mu kutasa i jaja. | Oskarżony o dokonanie ohydnej zbrodni w łożnicy z kobietą, która swej chęci na swawole nie wyraziła, %name% miał do wyboru albo śmierć, albo życie jako eunuch. Nie potrzeba fizycznych dowodów, by dociec, którą z tych opcji wybrał. | Powiada się, że %name%, niegdyś mnich w trakcie nauk, przespał się z innowierczynią. Wyrzucono go z zakonu, a w swej rozpaczliwej próbie odzyskania przychylności u braci w wierze i odkupienia win, usunął swe plugawe \'narzędzia zbrodni\'. Wygląda jednak na to, że wierni niezbyt chętni byli do przyjęcia go z powrotem. | Gdy %name% był jeszcze dzieckiem, jego pijan{a matka ucięła | y ojciec uciął | a starsza siostra ucięła | y starszy brat uciął} mu jego kutasa {tępawym toporkiem | zardzewiałym nożem}, {gdy spał | w ramach okrutnych tortur}. | Kiedy %name% przemierzał lasy nieopodal %townname%, zaatakował go {dzik | niedźwiedź | zdziczały pies | ogromny jastrząb}, który pozbawił go sporych połaci ciała. Uszedł z życiem, choć niewiele brakowało. Dopiero po dłuższej chwili zorientował się, że bestia pozbawiła go także genitaliów. | %name% wywodzi się z burdeli miasta %randomtown%, gdzie okaleczenia jego ciała dokonano, aby zadowolić żądania pewnego dość wybrednego klienta.} {Był wrakiem, kiedy się na niego natknąłeś. Teraz wydaje się, że chce jedynie uciec od świata, nawet jeśli oznacza to dołączenie do grupy najemników. Choć nie życzyłbyś nikomu losu, jaki go spotkał, jest raczej spokojnym człowiekiem. | Natknąłeś się na niego w chwili, gdy dokuczała i wyśmiewała go grupka dzieciaków. Widząc twój miecz, grzecznie poprosił, czy może dołączyć do twej kompanii, w której czyjaś przeszłość, ani też fizyczne deformacje, nie mają znaczenia. Przywykł już do ciężkich życiowych wyzwań, i to zapewne w sposób, w jaki niewielu by potrafiło. | O dziwo, stoi bardziej dumy i wyprostowany, niż większość ludzi. Wygląda na bardzo spokojnego i opanowanego, jak na kogoś, kto utracił tak cenną dla siebie rzecz. | Choć przerażająca przeszłość tego człowieka jeży ci włosy na karku, a pewne części ciała poniżej pasa aż na samą myśl się kurczą, eunuch wydaje się niewzruszony tym, co go spotkało. Jest spokojną, niemalże pasywną osobą. | Ten człowiek ma w swoich ruchach więcej stoicyzmu, niż większość mnichów, których widziałeś. Wygląda, że pogodził się ze swą tragiczną przeszłością. | Nie będąc już w stanie zaspokoić swoich cielesnych pragnień, wydaje się raczej łagodny i spokojny. Można by wręcz rzec, że jest wyjątkowo pewny siebie i opanowany, widząc w świecie więcej, niż jego fizyczność początkowo zdawał się oferować.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				-5,
				-5
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
				0,
				0
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				-5,
				-5
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
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}
	}

});

