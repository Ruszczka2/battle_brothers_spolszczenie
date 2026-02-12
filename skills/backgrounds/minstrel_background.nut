this.minstrel_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.minstrel";
		this.m.Name = "Minstrel";
		this.m.Icon = "ui/backgrounds/background_42.png";
		this.m.BackgroundDescription = "Dobry minstrel zaśpiewa sagę, by natchnąć ludzi, zagra na flecie, aby ich uspokoić, albo zabawi ich poezją przy obozowym ognisku. Lutnia nie jest jednak bronią, a grajkowie zazwyczaj nie są przyzwyczajenie do pracy fizycznej i przelewu krwi.";
		this.m.GoodEnding = "Ah, %name%. What an addition to the %companyname%! The minstrel not only became an excellent fighter, but was crucial in keeping the men\'s spirits high in the toughest of times. A poet and actor at heart, he eventually retired from the company and started up a theater company. He current performs plays for both the nobility and laymen. The minstrel does not yet realize it, but his playful wit and sharp commentary are slowly bringing the classes together.";
		this.m.BadEnding = "Never a fighter at heart, %name% the minstrel quickly left the declining %companyname%. He and a group of musicians and jesters spend their evenings performing for drunken noblemen. You managed to see one of these performances for yourself. %name% spent much of the time being berated by the inebriated and having half-eaten chicken bones thrown at him. One of the nobles even thought it\'d be funny to set a dog loose on one of the jesters. You could see the minstrel\'s dreams dying in his eyes, but the show went on.";
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

