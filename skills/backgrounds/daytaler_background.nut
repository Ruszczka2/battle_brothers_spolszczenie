this.daytaler_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.daytaler";
		this.m.Name = "Robotnik";
		this.m.Icon = "ui/backgrounds/background_36.png";
		this.m.BackgroundDescription = "Robotnicy są używani do wszelakiej pracy fizycznej, choć w niczym się nie wyróżniają.";
		this.m.GoodEnding = "%name% the daytaler retired from fighting and, well, he keeps working with his hands. Now he\'s back to laying bricks and carrying hay instead of slaying beasts and crushing heads. He took all his mercenary money to purchase a bit of land and settle down. While not the richest man, word has it that there is hardly a happier man in the realm.";
		this.m.BadEnding = "%name% retired from fighting while he still had most of his fingers and toes intact. He went back to working for the nobility. Last you heard he was out {south | north | east | west} building a great tower for some nobleman. Sadly, you also heard that tower collapsed halfway through its construction with many workers going down with it.";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.fear_undead",
			"trait.hate_beasts",
			"trait.hate_undead",
			"trait.hate_greenskins"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsLowborn = true;
	}

	function onBuildDescription()
	{
		return "{Pracując to tu, to tam | Nie posiadając stałej pracy | Raz pracując, a raz nie | Robiąc to i tamto | Nie wyuczywszy się żadnego konkretnego zawodu}, %name% zarabia na życie jako robotnik, czyli ktoś, kogo szuka się, gdy potrzeba dodatkowych rąk do pracy. {Od jakiegoś czasu z pracą jest krucho, więc | W ostatnich tygodniach niewiele jest pracy, więc | %name% chciał zacząć robić coś, czego nigdy wcześniej nie robił, więc | Pomimo braku doświadczenia w bitwach, zaglądanie w kufel sprawiło, że uwierzył, iż | %name% uważał profesję wojownika za taką, w której ostatnimi czasy nie brak zajęcia, więc | %name% utracił ukochaną z powodu zarazy, co ostatnio często się zdarza, i po tym się załamał. Po wielu tygodniach przepijania swoich smutków} wędrowna kompania najemników wydawała się dobrą okazją, {by na jakiś czas się wyrwać | aby zarobić nieco grosza | aby zobaczyć nieco świata | aby oczyścić umysł | aby dostać się do kolejnej wioski i przy okazji napełnić kieszenie}.";
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
				0
			],
			Stamina = [
				0,
				3
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
				0
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else
		{
			local item = this.new("scripts/items/armor/linen_tunic");
			item.setVariant(this.Math.rand(6, 7));
			items.equip(item);
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/headscarf"));
		}
	}

});

