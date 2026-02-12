this.militia_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.militia";
		this.m.Name = "Milicjant";
		this.m.Icon = "ui/backgrounds/background_35.png";
		this.m.BackgroundDescription = "Każdy, kto był w milicji, otrzymał przynajmniej podstawowe szkolenie w zakresie walki.";
		this.m.GoodEnding = "A former militiaman such as %name% eventually left the %companyname%. He traveled the lands, visiting villages and helping them establish credible militias with which to defend themselves. Finding success in an increasingly dangerous world, %name% eventually came to be a known name, called upon as a sort of \'fixer\' to come and ensure these villages would remain safe. Last you heard, he\'s purchased a plot of land and was raising a family far from the strife of the world.";
		this.m.BadEnding = "%name% left the collapsing company and returned to his village. Back in the militia, it wasn\'t long until {greenskins | raiders} attacked and he was called to action. It\'s said that he stood tall, rallying the defense as he slew through countless enemies before succumbing to mortal wounds. When you visited the village, you found children playfighting beneath a statue made in the militiaman\'s image.";
		this.m.HiringCost = 100;
		this.m.DailyCost = 10;
		this.m.Excluded = [
			"trait.hate_undead",
			"trait.clubfooted",
			"trait.fat",
			"trait.insecure",
			"trait.dastard",
			"trait.craven",
			"trait.asthmatic"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.Level = this.Math.rand(1, 2);
		this.m.IsCombatBackground = true;
		this.m.IsLowborn = true;
	}

	function onBuildDescription()
	{
		return "{Milicjantów takich jak %name% szkoli się tylko w czasach potrzeby. | Bez pracy i złamanej korony przy duszy, %name% dołączył do swej miejscowej milicji. | Będąc złapanym na kradzieży jabłka, %name% został w ramach kary wcielony do szeregów milicji. | Choć był przedstawicielem chłopstwa, %name% zawsze ochoczo mówił o dołączeniu do milicji i bronieniu swego domostwa. | Wojna to nienażarta bestia - poborowi milicji, tacy jak %name%, rzucani są jej na pożarcie.} {Chociaż przeszedł odpowiednie szkolenie, rzadko kiedy było wystarczająco dużo jedzenia dla \'żołnierzy drugiej kategorii\'. | Mimo że walczył równie ciężko co zawodowcy, nie zdołał zdobyć żadnego szacunku za swą pracę. | Będąc żołnierzem najniższego szczebla, szybko zdał sobie sprawę z tego, co to w praktyce oznacza. Czyli, że jego życie spisane jest na straty. | Broń miał zardzewiałą, a zbroi nie miał wcale. Niestety, wrogowie nie byli tak łaskawie niedoposażeni.} {Po roku włóczenia się w byle jakim rynsztunku, postanowił poszukać czegoś bardziej odpowiadającego jego upodobaniom: najemników. | Kiedy lord wysłał całą swoją milicję na niemal pewną śmierć, %name% zrozumiał w końcu, że jeśli mu życie miłe, lepiej będzie, jeśli poszuka czegoś lepszego. Odszedł więc i postanowił, że spróbuje wykorzystać swoje skromne umiejętności w fachu najemnika. | Lata w oddziale, w którym nie mógł w najmniejszym stopniu polegać na swych towarzyszach broni, zmusiły go do poszukania czegoś lepszego.  %name% może i nie jest najlepszym żołnierzem, jakiego kiedykolwiek widziałeś, ale przynajmniej jest szczery. | Gdy jego milicja została rozwiązana, wrócił do domu i okazało się, że jego miasto zostało spalone do gołej ziemi. Skoro stał już jedną nogą za drzwiami, to dość logicznym wydawało się dołączyć do jednej z wielu band najemników włóczących się po kraju. | Skromny strój wojskowy zdradza, że \x200b\x200b%name% jest człowiekiem, który ma już za sobą niejedną musztrę i walkę.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				3,
				5
			],
			Stamina = [
				3,
				5
			],
			MeleeSkill = [
				5,
				5
			],
			RangedSkill = [
				6,
				5
			],
			MeleeDefense = [
				2,
				2
			],
			RangedDefense = [
				2,
				2
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

		if (this.Math.rand(0, 4) == 4)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.MilitiaTitles[this.Math.rand(0, this.Const.Strings.MilitiaTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		local weapons = [
			"weapons/hooked_blade",
			"weapons/bludgeon",
			"weapons/hand_axe",
			"weapons/militia_spear",
			"weapons/shortsword"
		];

		if (this.Const.DLC.Wildmen)
		{
			weapons.extend([
				"weapons/warfork"
			]);
		}

		items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));

		if (items.getItemAtSlot(this.Const.ItemSlot.Offhand) == null && this.Math.rand(1, 100) <= 50)
		{
			items.equip(this.new("scripts/items/shields/buckler_shield"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_lamellar"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/gambeson"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}

		r = this.Math.rand(0, 6);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/aketon_cap"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/full_aketon_cap"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/open_leather_cap"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/full_leather_cap"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/helmets/straw_hat"));
		}
	}

});

