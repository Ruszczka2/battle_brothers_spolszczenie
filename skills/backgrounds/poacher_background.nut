this.poacher_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.poacher";
		this.m.Name = "Kłusownik";
		this.m.Icon = "ui/backgrounds/background_21.png";
		this.m.BackgroundDescription = "Kłusownicy zazwyczaj dość umiejętnie posługują się łukiem i strzałami, aby móc polować na zające i inną drobną zwierzynę.";
		this.m.GoodEnding = "%name%, były kłusownik, w końcu zaoszczędził wystarczająco dużo pieniędzy, aby opuścić kompanię %companyname%. Dowiedziałeś się, że znalazł gdzieś w górach skrawek ziemi i dogląda jej dla miejscowego szlachcica. O ironio, jego zadaniem jest polowanie na kłusowników.";
		this.m.BadEnding = "Nie widząc już sensu w narażaniu życia dla tak niewielu koron, %name%, były kłusownik, położył kres życiu najemnika i powrócił do nielegalnego polowania na jelenie po lasach. Pewien szlachcic zaoferował ci kiedyś sporą sakiewkę koron, żebyś zapolował właśnie na niego. Odrzuciłeś ofertę, ale wyrok już zapadł: jego dni są policzone.";
		this.m.HiringCost = 65;
		this.m.DailyCost = 8;
		this.m.Excluded = [
			"trait.hate_undead",
			"trait.night_blind",
			"trait.clubfooted",
			"trait.short_sighted",
			"trait.loyal",
			"trait.fat",
			"trait.fearless",
			"trait.brave",
			"trait.bright"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
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
		return "{Szukając dreszczyku emocji związanego z myślistwem, | Szukający wsparcia dla swojej rodziny, | Czując wciąż wyniszczający organizm głód, | Po długiej i ciężkiej zimie, która pozostawiła go bez zapasów jedzenia, } %name% {wyruszył do lasu w pogoni za jeleniami | polował na dziką zwierzynę, czy miał do niej prawo, czy też nie | polował na wszelkiego rodzaju leśne stworzenia, a mocno wyeksploatowany łuk, przewieszony przez ramiona, był jego nieodłącznym druhem | wyruszył do lasu, aby polować na zwierzynę z łukiem i włócznią}. Pochodzący z %nazwa_miasta%, %name% {był, jako kłusownik, zarazem myśliwym, jak i zwierzyną | musiał jakoś wykarmić żonę i dzieci, które zostały w domu | próbował jakoś zapewnić sobie utrzymanie i zapełnić chociaż w części wiecznie pusty żołądek | kłusownictwo było aktem buntu przeciwko porządkowi rzeczy, tak samo jak sposobem na napełnienie brzucha}. {W obawie, że jego czyny zwrócą jednak w końcu uwagę łowców nagród lub stróżów prawa, uznał, że lepiej zostać łucznikiem do wynajęcia. | Zmęczony był jednak pracowaniem tak ciężko, by tylko zapewnić sobie wyżywienie i wizja kupna posiłku za żołd najemniczy wydała mu się o wiele łatwiejsza. | Po tym, jak nieudane polowanie zakończył długim pobytem w lordowskich lochach, woli nadstawiać karku na pierwszej linii jako najemnik, niż pod katowski stryczek jako kłusownik. | Lata łowów w pojedynkę i na odludziu odbiły na nim swe piętno. Mimo iż żywot najemnika do zbyt bezpiecznych nie należy, wolałby umrzeć w towarzystwie, niż w samotności. | Żona długo błagała go, aby zmienił swoje postępowanie, inaczej cała rodzina może w końcu drogo zapłacić za jego zbrodnie. I oto stoi tu przed tobą, jako żywy dowód tego, kto wygrał tamten spór.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				-5,
				5
			],
			Stamina = [
				3,
				0
			],
			MeleeSkill = [
				2,
				0
			],
			RangedSkill = [
				15,
				7
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
				4
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;

		if (this.Const.DLC.Wildmen)
		{
			r = this.Math.rand(1, 100);

			if (r <= 50)
			{
				items.equip(this.new("scripts/items/weapons/short_bow"));
				items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
			}
			else if (r <= 80)
			{
				items.equip(this.new("scripts/items/weapons/staff_sling"));
			}
			else
			{
				items.equip(this.new("scripts/items/weapons/wonky_bow"));
				items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
			}
		}
		else
		{
			if (this.Math.rand(1, 100) <= 75)
			{
				items.equip(this.new("scripts/items/weapons/short_bow"));
			}
			else
			{
				items.equip(this.new("scripts/items/weapons/wonky_bow"));
			}

			items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.addToBag(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.addToBag(this.new("scripts/items/weapons/militia_spear"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
	}

});

