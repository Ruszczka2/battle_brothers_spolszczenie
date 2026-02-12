this.vagabond_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.vagabond";
		this.m.Name = "Włóczęga";
		this.m.Icon = "ui/backgrounds/background_32.png";
		this.m.BackgroundDescription = "Włóczędzy przyzwyczajeni są do długich podróży, choć w niczym szczególnie się nie wyróżniają.";
		this.m.GoodEnding = "Niektórzy ludzie są po prostu stworzeni do wędrowania. Chociaż czas spędzony z kompanią %companyname% był okresem dobrym, %name% włóczęga ostatecznie opuścił swych kompanów i ponownie wyruszył w drogę. Nie masz pojęcia, dokąd się udał, wiesz tylko, że jedyne, co go interesuje, to podróż.";
		this.m.BadEnding = "Kiedy kompania się rozpadła, nikogo nie powinno zdziwić, że taki włóczęga jak %name% postanowił o niej zapomnieć i wrócić na szlak. Jednak przy tak tragicznym stanie świata nie trzeba było długo czekać, by znalazł się w tarapatach. Jego zwłoki znaleziono przed małą wioską rolniczą, zwisające z drzewa. Na jego piersi przybita była tabliczka z napisem: \'Żadnych Włóczęgów\'.";
		this.m.HiringCost = 70;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.hate_beasts",
			"trait.hate_undead",
			"trait.hate_greenskins",
			"trait.clubfooted",
			"trait.fat",
			"trait.loyal",
			"trait.gluttonous",
			"trait.asthmatic"
		];
		this.m.Titles = [
			"Włóczęga",
			"Wędrowiec",
			"Trójstopy",
			"Tułacz",
			"Obdartus",
			"Bezdomny",
			"Włóczykij",
			"Podróżnik",
			"Kruk"
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
		return "{Przegnany ze swojego miasta przez wojnę, %name% wędruje po świecie jako włóczęga. | Leniwy i pozbawiony motywacji, %name% pewnego dnia spakował cały swój dobytek do plecaka i wyruszył w drogę. | %name% nigdy nie był pojętnym uczniem, więc porzucił szkołę, aby wędrować po świecie. | %name% nie miał wystarczającej smykałki do interesów, aby ochronić swój spadek przed wierzycielami, stróżami prawa i innymi złymi ludźmi. Teraz wędruje po krainie, w kieszeni mając ostatnie kilka koron. | Dzięki życiu na szlaku %name% nauczył się być specjalista od wszystkiego i mistrzem od niczego - za wyjątkiem chodzenia, oczywiście. | Nie potrafiąc odnaleźć się ani to w mieście, ani też w dziczy, %name% spędza swoje bezcelowe dni podróżując między nimi. | %name% zdołał roztrwonić niemałą fortunę, chlając na umór w karczmach. Teraz jest bezdomny i po prostu wędruje. | Kiedy jego żona została zamordowana, gdy jego nie było w domu, %name% przysiągł sobie, że więcej w domu nie zaśnie. Wędruje więc po świecie, próbując zapomnieć o swych gorzkich wspomnieniach. | Jego syn zamordował pięć osób. Ze wstydu %name% porzucił swoje rodzinne miasto, aby wędrować po szlakach i zapomnieć o swoich porażkach jako ojca.}. {Kiedy jednak banda złodziei zabrała mu wszystko, co miał - w tym buty - wiedział, że potrzebuje kolejnej zmiany. | Jednak kiedy dotarł do dosłownego rozdroża, zdał sobie sprawę, że od dłuższego czasu nie miał nic w ustach. Jego żołądek domagał się zmiany scenerii - i diety. | Niestety, świat nie jest przyjemnym miejscem dla tych, za którymi nikt by nie tęsknił. Każdego dnia był dręczony i poniżany. | Po jednym szczególnie ciężkim dniu, kiedy wycieńczony brnął mozolnie przez błoto, zdał sobie sprawę, że taka wędrówka to nie życie. | O dziwo, pewnego dnia natknął się na pewnego przyjaznego człowieka, który powiedział mu, że jako najemnik sporo się nachodzi - i jeszcze mu za to zapłacą! | Jak każdy dobry, impulsywny człowiek, rzucił monetą, czy spróbować swoich sił w pracy najemnika.} {%name% nie jest w niczym szczególnie dobry, ale wiele widział i wiele zrobił, a to musi być warte przynajmniej odrobinę. | Przemierzanie tej pełnej przemocy krainy i zachowanie przy tym wszystkich swych kończyn to już jest coś, czym można się pochwalić. | Kompania najemników byłaby niczym inny, niż kolejną przygodą dla takiego włóczęgi jak %name%. Pozostaje mieć nadzieję, że przeżyje wystarczająco długo, aby o tym napisać. | W trakcie podróży jego jedyną bronią była laska. Zobaczmy, jak poradzi sobie z czymś nieco ostrzejszym. | Złodziej, łajdak, piekarz, krawiec - %name% robił wszystko, czego wymagała sytuacja. Szkoda, że nigdy w niczym nie był dobry. Może jednak tym razem będzie inaczej. | %name% nie miał zbyt wiele szczęścia i od wielu lat świat go nie oszczędza. To się raczej nie zmieni, ale przynajmniej teraz ma towarzystwo.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-3,
				0
			],
			Bravery = [
				-5,
				-7
			],
			Stamina = [
				10,
				15
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
		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/straw_hat"));
		}
	}

});

