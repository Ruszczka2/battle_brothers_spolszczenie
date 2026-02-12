this.servant_southern_background <- this.inherit("scripts/skills/backgrounds/servant_background", {
	m = {},
	function create()
	{
		this.servant_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernThick;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.Ethnicity = 1;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.huge",
			"trait.hate_undead",
			"trait.hate_greenskins",
			"trait.hate_beasts",
			"trait.impatient",
			"trait.iron_jaw",
			"trait.brute",
			"trait.athletic",
			"trait.strong",
			"trait.disloyal",
			"trait.fat",
			"trait.brave",
			"trait.fearless",
			"trait.optimist",
			"trait.cocky",
			"trait.bright",
			"trait.determined",
			"trait.greedy",
			"trait.sure_footing",
			"trait.bloodthirsty"
		];
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{Życie jest ciężkie. Zwłaszcza dla niektórych. | Jakże nisko potrafią upaść niektórzy. Inni nie mają nawet z czego upadać, bo urodzili się na samym dnie. | Życie jest jak rzut kością, nie wiadomo co się komu trafi.} %name% {był sługą dekadenckiego wezyra. | służył rodowi zwyrodnialców, którego dzieci igrały z ogniem. | został porwany przez koczowników i był zmuszony zaspokajać ich pragnienia. Zawsze. Każde. | pracował w pocie czoła dla szaleńców, którzy zbyt długo wpatrywali się w gwiazdy.}  Rzadko mylił się co do swojego miejsca na tym świecie. Jednakże któregoś dnia, jego panowie {pobili go do nieprzytomności. Gdy się ocknął, leżał w łóżku u pewnego dobrotliwego medyka, który nie chciał go zwrócić jego poprzednim \'pracodawcom\'. Zamiast tego, %name% został puszczony wolno, a jego panom powiedziano, że zmarł. | uwolnili go, tak po prostu. Nie czekając, aż się rozmyślą, %name% odszedł w pośpiechu. | zaprosili go na przyjęcie. Myśląc, że idzie tam jako gość, pokazał się w swym najlepszym odzieniu - koszuli z obszytymi rękawami i zwiewnych pantalonach, które dobrze skrywały jego kościste nogi. Niestety, miał być tylko rozrywką na przyjęciu - dano mu drewnianą tarczę i miecz, a następnie wrzucono na arenę z rozszalałą hieną, robiąc zakłady podczas oglądania tego makabrycznego spektaklu. Ledwie uszedł z życiem z tych \'uroczystości\'.} {%name% poprzysiągł wtedy, że już więcej \'służył\' nikomu nie będzie. | Nadal, pomimo tego, że jest już wolny od swych obowiązków, widać na nim piętno poniżenia i głębokiego cierpienia, odciśniętego przez długie, ciężkie życie.}";
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/oriental/cloth_sash"));
		}
	}

});

