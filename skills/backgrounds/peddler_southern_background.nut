this.peddler_southern_background <- this.inherit("scripts/skills/backgrounds/peddler_background", {
	m = {},
	function create()
	{
		this.peddler_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernMale;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.BeardChance = 90;
		this.m.Ethnicity = 1;
		this.m.Excluded = [
			"trait.superstitious",
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
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "%name% {krąży od domu do domu i jest | był kiedyś dumnym kupcem, teraz jest | irytuje większość ludzi, wszak jest | starając poradzić sobie jakoś w tych trudnych czasach, został | zbyt wielu talentów nie miał, toteż został} zwykłym handlarzem. {Będzie tańczył, będzie śpiewał, będzie się nadymał i przejdzie samego siebie, byle tylko coś sprzedać. | Jest natarczywy i nieugięty, a jego wytrwałość jest godna podziwu. | Opchnie nawet zardzewiałe wiadro jako hełm noszony niegdyś przez królów. Ten człowiek sprzeda wszystko. | Ten człowiek sprawi, że zapałasz nieodpartą żądzą posiadania rzeczy, które do tej pory zupełnie cię nie interesowały. Zwrotów jednak nie przyjmuje. | Kiedyś przyzwoicie zarabiał, sprzedając {używane wozy | garnki, patelnie i słoiki}, dopóki zaciekła konkurencja nie wypchnęła go z interesu - łamiąc mu rękę.} {Reklama samego siebie jest tym, co ów wątły mężczyzna robi najlepiej, choć niewielu wierzy w jego zapewnienia o \'niesamowitych zdolnościach szermierczych i niebywałej odwadze.\' | Podobno rozdawał \'kupony\' na swoje usługi, czymkolwiek one są. Jednak w dzisiejszych czasach każdej kompanii przyda się świeże mięsko do postawienia w pierwszym szeregu, bez względu na jego rzeczywistą wartość. | Obiecuje, że jeśli zostanie zatrudniony, dostaniesz specjalną zniżkę na eliksir powiększający męskość. | Zniża głos i mówi, że ma dla ciebie świetną ofertę na zardzewiałe groty strzał. Wygląda na rozczarowanego twoim brakiem zainteresowania. | Twierdzi, że zna gościa, który zna gościa, który zna gościa. Wszyscy ci trzej nieznajomi są zapewne lepsi w walce od niego. | Szkoda, że w dzisiejszych czasach człowiek nie może walczyć słowami. %name% byłby niepokonanym.}";
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
			items.equip(this.new("scripts/items/armor/oriental/cloth_sash"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/oriental/southern_head_wrap"));
		}
	}

});

