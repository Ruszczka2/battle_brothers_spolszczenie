this.minstrel_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.minstrel";
		this.m.Name = "Minstrel";
		this.m.Icon = "ui/backgrounds/background_42.png";
		this.m.BackgroundDescription = "Dobry minstrel zaśpiewa sagę, by natchnąć ludzi, zagra na flecie, aby ich uspokoić, albo zabawi ich poezją przy obozowym ognisku. Lutnia nie jest jednak bronią, a grajkowie zazwyczaj nie są przyzwyczajenie do pracy fizycznej i przelewu krwi.";
		this.m.GoodEnding = "Ach, %name%. Cóż za wzmocnienie dla %companyname%! Minstrel nie tylko stał się świetnym wojownikiem, ale i kluczową osobą w podtrzymywaniu ducha ludzi w najtrudniejszych chwilach. Z natury poeta i aktor, w końcu odszedł z kompanii i założył trupę teatralną. Obecnie wystawia sztuki zarówno dla szlachty, jak i pospólstwa. Minstrel jeszcze tego nie wie, ale jego figlarny dowcip i celne komentarze powoli zbliżają te stany.";
		this.m.BadEnding = "Nie będąc wojownikiem z serca, %name% szybko opuścił podupadającą %companyname%. On i grupa muzyków oraz błaznów spędzają wieczory, występując dla pijanych szlachciców. Udało ci się zobaczyć jeden z tych występów. %name% większość czasu był obrzucany obelgami przez pijanych i obrywał półzjedzonymi kośćmi z kurczaka. Jeden z możnych uznał nawet, że zabawnie będzie poszczuć psa na jednego z błaznów. Widziałeś, jak w oczach minstrela gasły marzenia, lecz przedstawienie trwało.";
		this.m.HiringCost = 65;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.huge",
			"trait.iron_jaw",
			"trait.athletic",
			"trait.craven",
			"trait.dumb",
			"trait.strong",
			"trait.tough",
			"trait.dumb",
			"trait.brute",
			"trait.clubfooted",
			"trait.dastard",
			"trait.insecure",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"Minstrel",
			"Skald",
			"Poeta",
			"Skowronek",
			"Trubadur",
			"Rybałt",
			"Kochanek",
			"Bard"
		];
		this.m.Faces = this.Const.Faces.SmartMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
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
		return "\"{Mogę machać mieczem, rąbać toporem, | Zleć mi zdanie, do akcji\'m wszak skory, | Z Bogiem w sercu, kuflem w dłoni i wywieszonym jęzorem,} {rzeczem: \'Zdolny\'m, piękny\'m i nie brak mi pokory.\'. | poruszam się szybko, choć z lekkim oporem,} {Patrzyły na mnie groźnie niedźwiedzie wypchane, | Wciskałem swe klejnoty w pantalony zszarpane, | Po błotnistych drogach ślizgały się me buty zdeptane,} {i tak wiele rzeczy zostało przez mnie pożegnane. | zaiste! Moim wstydliwym talentem jest – zaciekłe! – dzierganie.} {Więc weź mnie ze sobą w tę piękną przygodę, | Weź mnie do swej kompanii, z nowymi braćmi pójdę noga w nogę, | Daj mi tarczę i to coś, co kształtem przypomina moją środkową odnogę,} {wspólnie pożegnajmy strach i ruszajmy razem, w drogę! | a teraz – o, aj! Drzazga! Wbiła mi się w nogę! | i wspólnie zwyciężymy, ręczyć za to mogę!}\". {Ten człowiek bełkocze. | Rymuje się!}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-5,
				-3
			],
			Bravery = [
				5,
				10
			],
			Stamina = [
				-10,
				-10
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
				5
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local armor = this.new("scripts/items/armor/linen_tunic");
		armor.setVariant(this.Math.rand(3, 4));
		items.equip(armor);
		local r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/feathered_hat"));
		}

		if (this.Math.rand(1, 100) <= 60)
		{
			items.equip(this.new("scripts/items/weapons/lute"));
		}
	}

});

