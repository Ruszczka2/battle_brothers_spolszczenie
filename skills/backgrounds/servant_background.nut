this.servant_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.servant";
		this.m.Name = "Sługa";
		this.m.Icon = "ui/backgrounds/background_16.png";
		this.m.BackgroundDescription = "Służący często nie są przyzwyczajeni do ciężkiej pracy fizycznej.";
		this.m.GoodEnding = "As it turns out, %name% the servant had been stowing away every last crown he had earned with the %companyname%. When he had enough, he retired and bought himself some land and slowly worked his way up the social ladder. He died in a comfortable bed, surrounded by friends, family, and loyal servants.";
		this.m.BadEnding = "%name% the servant grew tired of the sellsword life and left the company. He returned to serving nobility. When raiders attacked his liege\'s castle, the nobleman pushed the servant out the door with only a kitchen knife to defend himself with. He was found headless in a pile of broken chairs, a few dead raiders littered around him.";
		this.m.HiringCost = 45;
		this.m.DailyCost = 4;
		this.m.Excluded = [
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
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.Old;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsOffendedByViolence = true;
	}

	function onBuildDescription()
	{
		return "{Życie jest ciężkie. Zwłaszcza dla niektórych. | Jakże nisko potrafią upaść niektórzy. Inni nie mają nawet z czego upadać, bo urodzili się na samym dnie. | Życie jest jak rzut kością, nie wiadomo co się komu trafi.} %name% {był sługą dekadenckiego lorda. | służył rodowi zwyrodnialców, którego dzieci igrały z ogniem. | został porwany przez bandytów i był zmuszony zaspokajać ich pragnienia. Zawsze. Każde. | pracował w pocie czoła dla szaleńców, którzy zbyt długo wpatrywali się w gwiazdy.}  Rzadko mylił się co do swojego miejsca na tym świecie. Jednakże któregoś dnia, jego panowie {pobili go do nieprzytomności. Gdy się ocknął, leżał w łóżku u pewnego dobrotliwego medyka, który nie chciał go zwrócić jego poprzednim \'pracodawcom\'. Zamiast tego, %name% został puszczony wolno, a jego panom powiedziano, że zmarł. | uwolnili go, tak po prostu. Nie czekając, aż się rozmyślą, %name% odszedł w pośpiechu. | zaprosili go na przyjęcie. Myśląc, że idzie tam jako gość, pokazał się w swym najlepszym odzieniu - koszuli z obszytymi rękawami i zwiewnych pantalonach, które dobrze skrywały jego kościste nogi. Niestety, miał być tylko rozrywką na przyjęciu - dano mu drewnianą tarczę i miecz, a następnie wrzucono na arenę z rozszalałym dzikiem, robiąc zakłady podczas oglądania tego makabrycznego spektaklu. Ledwie uszedł z życiem z tych \'uroczystości\'.} {%name% poprzysiągł wtedy, że już więcej \'służył\' nikomu nie będzie. | Nadal, pomimo tego, że jest już wolny od swych obowiązków, widać na nim piętno poniżenia i głębokiego cierpienia, odciśniętego przez długie, ciężkie życie.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-5,
				-5
			],
			Bravery = [
				-5,
				-5
			],
			Stamina = [
				-5,
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
				0
			],
			RangedDefense = [
				2,
				0
			],
			Initiative = [
				5,
				0
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
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}
	}

});

