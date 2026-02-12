this.daytaler_southern_background <- this.inherit("scripts/skills/backgrounds/daytaler_background", {
	m = {},
	function create()
	{
		this.daytaler_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernSkinny;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.SouthernUntidy;
		this.m.Ethnicity = 1;
		this.m.BeardChance = 90;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.fear_undead",
			"trait.hate_beasts",
			"trait.hate_undead",
			"trait.hate_greenskins"
		];
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{Pracując to tu, to tam | Nie posiadając stałej pracy | Raz pracując, a raz nie | Robiąc to i tamto | Nie wyuczywszy się żadnego konkretnego zawodu}, %name% zarabia na życie jako robotnik, czyli ktoś, kogo szuka się, gdy potrzeba dodatkowych rąk do pracy. {Od jakiegoś czasu z pracą jest krucho, więc | W ostatnich tygodniach niewiele jest pracy, więc | %name% chciał zacząć robić coś, czego nigdy wcześniej nie robił, więc | Pomimo braku doświadczenia w bitwach, zaglądanie w kufel sprawiło, że uwierzył, iż | %name% uważał profesję wojownika za taką, w której ostatnimi czasy nie brak zajęcia, więc | %name% utracił ukochaną z powodu zarazy, co ostatnio często się zdarza, i po tym się załamał. Po wielu tygodniach przepijania swoich smutków} wędrowna kompania najemników wydawała się dobrą okazją, {by na jakiś czas się wyrwać | aby zarobić nieco grosza | aby zobaczyć nieco świata | aby oczyścić umysł | aby dostać się do kolejnej wioski i przy okazji napełnić kieszenie}.";
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
			local item = this.new("scripts/items/armor/oriental/cloth_sash");
			items.equip(item);
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/oriental/southern_head_wrap"));
		}
	}

});

