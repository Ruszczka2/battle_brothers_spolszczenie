this.fisherman_southern_background <- this.inherit("scripts/skills/backgrounds/fisherman_background", {
	m = {},
	function create()
	{
		this.fisherman_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernSkinny;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.BeardChance = 90;
		this.m.Ethnicity = 1;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.weasel",
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.paranoid",
			"trait.night_blind",
			"trait.tiny",
			"trait.fat"
		];
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{%name% uwielbiał morze i spokój związany z samotnymi połowami na wodzie | Jak na ironię, %name% zawsze nienawidził wody, lecz został rybakiem, tak jak jego ojciec i ojciec jego ojca | %name% był silnym i zdolnym rybakiem | %name% był zadowolony z bycia rybakiem | %name% zawsze miał szczęście do znajdywania najlepszych łowisk i łapania największych ryb}. O ile nie było sztormu, był tam na głębinach, łowiąc całymi dniami. {Niestety jego rybacka chata spłonęła doszczętnie, gdy był na morzu. | Jednak wydarzyła się tragedia i stracił najlepszego przyjaciela podczas niespodziewanego sztormu, który zniszczył jego łódź i sprawił, że nie miał już z kim wypływać. | Jednak wydarzyła się tragedia, gdy jego żona zmarła w trakcie porodu, co zniszczyło wszystko to, na czym mu zależało. | Jednak jako że przez jakiś czas nie był w stanie spłacić swoich długów, bezwzględny lichwiarz odebrał mu jego łódź. | Po uduszeniu własnej żony w nagłym ataku gniewu stracił wszelką chęć do rybołówstwa. | Ku jego przerażeniu, niemal przez całe lato większość wyłowionych przez niego ryb była już śnięta i zgniła w środku. | Zaczął rozglądać się za innym zawodem po tym, jak pewien kapłan dawnych bogów powiedział mu, że życie rybaka nie jest tym, czego bogowie od niego oczekują i że żądają od niego, by przelewał krew w jego imieniu.} Odwiedzając pewnego wieczoru gospodę, trafił na nową okazję, obiecującą sporo monet za niebezpieczną pracę.";
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
		r = this.Math.rand(1, 2);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/oriental/cloth_sash"));
		}

		items.equip(this.new("scripts/items/helmets/oriental/southern_head_wrap"));
	}

});

