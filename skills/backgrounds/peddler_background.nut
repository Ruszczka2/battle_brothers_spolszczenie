this.peddler_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.peddler";
		this.m.Name = "Handlarz";
		this.m.Icon = "ui/backgrounds/background_19.png";
		this.m.BackgroundDescription = "Handlarze nie są przyzwyczajeni do ciężkiej pracy fizycznej i wojaczki, ale doskonale sobie radzą z targowaniem się o niższe ceny.";
		this.m.GoodEnding = "A man of the sale, %name% the peddler couldn\'t stay fighting for long. He eventually left the %companyname% to go out and start his own business. Recently, you got word that he was selling trinkets with the company\'s sigil on them. You specifically told him he can do whatever he wants except just this one thing, but apparently your warning merely fostered the idea in him. When you went to tell him to stop, he slammed a crown-bulging satchel on his rather ornate table, saying it was your \'cut.\' He sells those trinkets to this day.";
		this.m.BadEnding = "With hard times hitting the %companyname%, many brothers saw fit to return to their old lives. %name% the peddler was no different. Last you heard he got the tar beaten out of him trying to sell stolen wares that \'fell off the wagon\' to the very merchant which they originally belonged.";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.huge",
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.hate_beasts",
			"trait.iron_jaw",
			"trait.clubfooted",
			"trait.brute",
			"trait.athletic",
			"trait.iron_lungs",
			"trait.strong",
			"trait.tough",
			"trait.cocky",
			"trait.dexterous",
			"trait.dumb",
			"trait.deathwish",
			"trait.bloodthirsty"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Thick;
		this.m.IsLowborn = true;
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
		return "%name% {krąży od domu do domu i jest | był kiedyś dumnym kupcem, teraz jest | irytuje większość ludzi, wszak jest | starając poradzić sobie jakoś w tych trudnych czasach, został | zbyt wielu talentów nie miał, toteż został} zwykłym handlarzem. {Będzie tańczył, będzie śpiewał, będzie się nadymał i przejdzie samego siebie, byle tylko coś sprzedać. | Jest natarczywy i nieugięty, a jego wytrwałość jest godna podziwu. | Opchnie nawet zardzewiałe wiadro jako hełm noszony niegdyś przez królów. Ten człowiek sprzeda wszystko. | Ten człowiek sprawi, że zapałasz nieodpartą żądzą posiadania rzeczy, które do tej pory zupełnie cię nie interesowały. Zwrotów jednak nie przyjmuje. | Kiedyś przyzwoicie zarabiał, sprzedając {używane wozy | garnki, patelnie i słoiki}, dopóki zaciekła konkurencja nie wypchnęła go z interesu - łamiąc mu rękę.} {Reklama samego siebie jest tym, co ów wątły mężczyzna robi najlepiej, choć niewielu wierzy w jego zapewnienia o \'niesamowitych zdolnościach szermierczych i niebywałej odwadze.\' | Podobno rozdawał \'kupony\' na swoje usługi, czymkolwiek one są. Jednak w dzisiejszych czasach każdej kompanii przyda się świeże mięsko do postawienia w pierwszym szeregu, bez względu na jego rzeczywistą wartość. | Obiecuje, że jeśli zostanie zatrudniony, dostaniesz specjalną zniżkę na eliksir powiększający męskość. | Zniża głos i mówi, że ma dla ciebie świetną ofertę na zardzewiałe groty strzał. Wygląda na rozczarowanego twoim brakiem zainteresowania. | Twierdzi, że zna gościa, który zna gościa, który zna gościa. Wszyscy ci trzej nieznajomi są zapewne lepsi w walce od niego. | Szkoda, że w dzisiejszych czasach człowiek nie może walczyć słowami. %name% byłby niepokonanym.}";
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
				0
			],
			MeleeSkill = [
				-10,
				-9
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				2,
				7
			],
			RangedDefense = [
				2,
				7
			],
			Initiative = [
				0,
				7
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
			actor.setTitle(this.Const.Strings.PeddlerTitles[this.Math.rand(0, this.Const.Strings.PeddlerTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/dagger"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/feathered_hat"));
		}
	}

});

