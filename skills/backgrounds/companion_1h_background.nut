this.companion_1h_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.companion";
		this.m.Name = "Towarzysz";
		this.m.Icon = "ui/traits/trait_icon_32.png";
		this.m.HiringCost = 0;
		this.m.DailyCost = 14;
		this.m.DailyCostMult = 1.0;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.hate_undead",
			"trait.hate_beasts",
			"trait.hate_greenskins",
			"trait.huge",
			"trait.weasel",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.paranoid",
			"trait.night_blind",
			"trait.ailing",
			"trait.impatient",
			"trait.asthmatic",
			"trait.greedy",
			"trait.dumb",
			"trait.clubfooted",
			"trait.drunkard",
			"trait.disloyal",
			"trait.tiny",
			"trait.fragile",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.dastard",
			"trait.insecure"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.RangedSkill
		];
		this.m.GoodEnding = "Był z tobą od początku, %name%, i był z tobą na emeryturze, opuszczając kompanię niedługo po tobie. Lecz wciąż nie miał dość walk i zaczął bić się dla innej kompanii - własnej. Nauczywszy się tak wiele od twojego dowodzenia, sprawia, że jesteś niemal tak dumny, jak mógłbyś być z syna. Ironicznie, on nienawidzi myśli, że jesteś dla niego jak ojciec, a ty zawsze mówisz mu, że i tak nigdy nie spłodziłbyś syna tak brzydkiego. Do dziś utrzymujecie kontakt.";
		this.m.BadEnding = "%name% był z tobą od początku i był równie lojalny, co utalentowany. Został w kompanii przez jakiś czas, po czym odszedł, by wykuć własną ścieżkę. Pewnego dnia dostałeś list od najemnika, w którym pisał, że założył własną kompanię i pilnie potrzebuje pomocy. Niestety wiadomość była datowana niemal na rok wstecz. Gdy zbadałeś losy jego kompanii, dowiedziałeś się, że została doszczętnie zniszczona w bitwie między możnymi.";
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.IsCombatBackground = true;
		this.m.IsUntalented = true;
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
		return "%name% znany jest z tego, że niewiele mówi, choć miałby o czym opowiadać. {Zarówno %2h%, jak i %ranged% zawdzięczają mu życie. | Kiedyś ocalił cię przed potwornym łańcuchem orka. | Skrytobójca zabiłby cię w w gospodzie, gdyby nie on. | Przypadkowy wystrzał z kuszy pozbawiłby cię oka, gdyby %name% nie zatrzymał bełtu swoją tarczą. | Kiedyś zepchnął dwóch ludzi ze skarpy, używając wyłącznie swojej tarczy i siły swych nóg. | Walczyć nauczył się od swego ojca, członka straży przedniej w Bitwie o Wielu Nazwach. | Poświęcając swą pamiątkę rodową - starą tarczę z drewna i ćwiekowanego żelaza - ocalił twoje życie. | Jest człowiekiem o niebywałym heroizmie, wszak %2h% został przez niego kiedyś wyciągnięty z płonącej gospody. | W starciu z hordą goblinów użył swej tarczy, aby zrobić wyłom w ich szeregach, dzięki czemu %2h% oraz %ranged% mogli wybić ich wszystkich.} Szybkimi zwrotami i wywijasami swej tarczy, odbijał wszelakie śmiertelne zagrożenia. Pomimo swej małomówności i wycofania, %name% wielokrotnie pokazał, że jest kluczową osobą w twoim murze tarcz.";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		_vars.push([
			"1h",
			brothers.len() >= 1 ? brothers[0].getName() : ""
		]);
		_vars.push([
			"2h",
			brothers.len() >= 2 ? brothers[1].getName() : ""
		]);
		_vars.push([
			"ranged",
			brothers.len() >= 3 ? brothers[2].getName() : ""
		]);
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				10,
				5
			],
			Stamina = [
				5,
				5
			],
			MeleeSkill = [
				10,
				5
			],
			RangedSkill = [
				5,
				5
			],
			MeleeDefense = [
				5,
				5
			],
			RangedDefense = [
				5,
				5
			],
			Initiative = [
				0,
				0
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(0, 3) == 3)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.SellswordTitles[this.Math.rand(0, this.Const.Strings.SellswordTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local talents = this.getContainer().getActor().getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.Hitpoints] = 2;
		talents[this.Const.Attributes.Fatigue] = 1;
		talents[this.Const.Attributes.Bravery] = 1;
		local items = this.getContainer().getActor().getItems();
		local r;
		items.equip(this.new("scripts/items/weapons/militia_spear"));
		items.equip(this.new("scripts/items/shields/wooden_shield"));
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/gambeson"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/aketon_cap"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/open_leather_cap"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/full_aketon_cap"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/full_leather_cap"));
		}
	}

});

