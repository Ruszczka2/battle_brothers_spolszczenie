this.peddler_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.peddler";
		this.m.Name = "Handlarz";
		this.m.Icon = "ui/backgrounds/background_19.png";
		this.m.BackgroundDescription = "Handlarze nie są przyzwyczajeni do ciężkiej pracy fizycznej i wojaczki, ale doskonale sobie radzą z targowaniem się o niższe ceny.";
		this.m.GoodEnding = "Człowiek od handlu, %name% nie mógł długo walczyć. W końcu opuścił %companyname%, by założyć własny interes. Niedawno dotarła do ciebie wieść, że sprzedaje bibeloty z sygnetem kompanii. Wyraźnie powiedziałeś mu, że może robić wszystko poza tą jedną rzeczą, ale najwyraźniej ostrzeżenie tylko go zachęciło. Gdy poszedłeś kazać mu przestać, trzasnął na swoim dość ozdobnym stole sakiewką wypchaną koronami, mówiąc, że to twoja 'działka'. Sprzedaje te bibeloty do dziś.";
		this.m.BadEnding = "Gdy %companyname% dopadły ciężkie czasy, wielu braci uznało, że pora wrócić do dawnego życia. %name% nie był wyjątkiem. Ostatnio słyszałeś, że porządnie go obito, gdy próbował sprzedać kradzione towary, które 'spadły z wozu', dokładnie temu kupcowi, do którego pierwotnie należały.";
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

