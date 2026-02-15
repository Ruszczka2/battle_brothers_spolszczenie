this.companion_2h_background <- this.inherit("scripts/skills/backgrounds/character_background", {
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
			"trait.hate_undead",
			"trait.hate_beasts",
			"trait.hate_greenskins",
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
			"trait.insecure",
			"trait.dexterous"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.RangedSkill,
			this.Const.Attributes.RangedDefense
		];
		this.m.GoodEnding = "Był z tobą od początku, %name%, i był z tobą na emeryturze, opuszczając kompanię niedługo po tobie. Lecz wciąż nie miał dość walk i zaczął bić się dla innej kompanii - własnej. Nauczywszy się tak wiele od twojego dowodzenia, sprawia, że jesteś niemal tak dumny, jak mógłbyś być z syna. Ironicznie, on nienawidzi myśli, że jesteś dla niego jak ojciec, a ty zawsze mówisz mu, że i tak nigdy nie spłodziłbyś syna tak brzydkiego. Do dziś utrzymujecie kontakt.";
		this.m.BadEnding = "%name% był z tobą od początku i był równie lojalny, co utalentowany. Został w kompanii przez jakiś czas, po czym odszedł, by wykuć własną ścieżkę. Pewnego dnia dostałeś list od najemnika, w którym pisał, że założył własną kompanię i pilnie potrzebuje pomocy. Niestety wiadomość była datowana niemal na rok wstecz. Gdy zbadałeś losy jego kompanii, dowiedziałeś się, że została doszczętnie zniszczona w bitwie między możnymi.";
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Raider;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.IsUntalented = true;
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
		return "%name% jest złowieszczy, a czasem wręcz samobójczy, więc nie dziwne, że często rzuca się w wir walki z samym tylko wielkim dwuręczniakiem. {Raz widziałeś, jak w morderczym szale rozciął człowieka na pół - z góry na dół. | Mówi się, że pewnego razu rozrąbał wojownika orków na dwie części, a nogi zielonoskórego nadal stały w miejscu. | Jest znany z tego, że ignoruje kruchość swej śmiertelności, by tylko zakończyć żywot kogoś innego. | Czuje się jak ryba w wodzie podczas bitew, gdzie może beztrosko machać swoją bronią, nie przejmując się bezpieczeństwem, czy precyzją. | Podobno wygrał kiedyś pojedynek na kopie, jednak musiał czmychnąć, bo wychędożył żonę jednego z oglądających turniej szlachciców. | Nie jest mordercą, choć doskonale by się na niego nadawał. | Czasami wydaje się nie do powstrzymania, więc cieszysz się, że jest po twojej stronie. | Niegdyś, wpadając w krwiożerczy szał, nadział dwóch goblinów na jedną pikę. | Kiedyś widziałeś, jak %name%, potężny brutal, zabił wroga przypadkowo, biorąc zamach do zadania ciosu.} Użyje każdej broni, jaką mu dasz, ale %name% ma upodobanie takich narzędzi mordu, które robią z ludzkiego ciała prawdziwą sieczkę.";
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
				10,
				5
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
				0,
				0
			],
			MeleeDefense = [
				2,
				0
			],
			RangedDefense = [
				2,
				0
			],
			Initiative = [
				-5,
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
		talents[this.Const.Attributes.MeleeSkill] = 2;
		talents[this.Const.Attributes.MeleeDefense] = 1;
		talents[this.Const.Attributes.Bravery] = 1;
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/woodcutters_axe"));
		}

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

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/headscarf"));
		}
	}

});

