this.fisherman_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.fisherman";
		this.m.Name = "Rybak";
		this.m.Icon = "ui/backgrounds/background_15.png";
		this.m.BackgroundDescription = "Rybacy przyzwyczajeni są do pracy fizycznej.";
		this.m.GoodEnding = "%name% odstawił wojaczkę i powrócił do swoich rybackich wypraw. Potężny sztorm przetoczył się po wybrzeżu, niszcząc każdą rybacką łódź  - poza łajbą tegoż skromnego rybaka! Przy braku konkurencji, %name% rozwinął swój interes. Toczy teraz wygodne życie w dużym domu nad brzegiem, codziennie budząc się z pięknym widokiem na morze.";
		this.m.BadEnding = "Jako że kariera wojaka szła mu kiepsko, %name% postanowił odstawić broń i wrócić do rybołówstwa. Zaginął na morzu po tym, jak potężny sztorm spustoszył wybrzeże.";
		this.m.HiringCost = 65;
		this.m.DailyCost = 7;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.paranoid",
			"trait.night_blind",
			"trait.tiny",
			"trait.fat"
		];
		this.m.Titles = [
			"Rybak",
			"Rybołów"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsLowborn = true;
	}

	function onBuildDescription()
	{
		return "{%name% uwielbiał morze i spokój związany z samotnymi połowami na wodzie | Jak na ironię, %name% zawsze nienawidził wody, lecz został rybakiem, tak jak jego ojciec i ojciec jego ojca | %name% był silnym i zdolnym rybakiem | %name% był zadowolony z bycia rybakiem | %name% zawsze miał szczęście do znajdywania najlepszych łowisk i łapania największych ryb}. O ile nie było sztormu, był tam na głębinach, łowiąc całymi dniami. {Niestety jego rybacka chata spłonęła doszczętnie, gdy był na morzu. | Jednak wydarzyła się tragedia i stracił najlepszego przyjaciela podczas niespodziewanego sztormu, który zniszczył jego łódź i sprawił, że nie miał już z kim wypływać. | Jednak wydarzyła się tragedia, gdy jego żona zmarła w trakcie porodu, co zniszczyło wszystko to, na czym mu zależało. | Jednak jako że przez jakiś czas nie był w stanie spłacić swoich długów, bezwzględny lichwiarz odebrał mu jego łódź. | Po uduszeniu własnej żony w nagłym ataku gniewu stracił wszelką chęć do rybołówstwa. | Ku jego przerażeniu, niemal przez całe lato większość wyłowionych przez niego ryb była już śnięta i zgniła w środku. | Zaczął rozglądać się za innym zawodem po tym, jak pewien kapłan dawnych bogów powiedział mu, że życie rybaka nie jest tym, czego bogowie od niego oczekują i że żądają od niego, by przelewał krew w jego imieniu.} Odwiedzając pewnego wieczoru gospodę, trafił na nową okazję, obiecującą sporo monet za niebezpieczną pracę.";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				5,
				0
			],
			Bravery = [
				5,
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
				5
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

		items.equip(this.new("scripts/items/tools/throwing_net"));
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
			local item = this.new("scripts/items/armor/linen_tunic");
			item.setVariant(this.Math.rand(6, 7));
			items.equip(item);
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/straw_hat"));
		}
	}

});

