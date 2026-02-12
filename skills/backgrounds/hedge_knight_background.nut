this.hedge_knight_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hedge_knight";
		this.m.Name = "Błędny Rycerz";
		this.m.Icon = "ui/backgrounds/background_33.png";
		this.m.BackgroundDescription = "Błędni rycerze są rywalizującymi ze sobą osobnikami, którzy osiągnęli doskonałość w zbrojnej walce człowiek przeciwko człowiekowi w ciężkim pancerzu, choć gorzej im idzie we współpracy i zwinności.";
		this.m.GoodEnding = "A man like %name% would always find a way. The hedge knight eventually, if not inevitably, left the company and set out on his own. Unlike many other brothers, he did not spend his crowns on land or ladders with which to climb the noble life. Instead, he bought himself the finest war horses and the talents of armorers. The behemoth of a man rode from one jousting tournament to the next, winning them all with ease. He\'s still at it to this day, and you think he won\'t stop until he\'s dead. The hedge knight simply knows no other life.";
		this.m.BadEnding = "%name% the hedge knight eventually left the company. He traveled the lands, returning to his favorite past time of jousting, which was really a cover for his real favorite past time of lancing men off horses in a shower of splinters and glory. At some point, he was ordered to \'throw\' a match against a pitiful and gangly prince to earn the nobleman some prestige. Instead, the hedge knight drove his lance through the man\'s skull. Furious, the lord of the land ordered the hedge knight killed. They say over a hundred soldiers took to his home and only half returned alive.";
		this.m.HiringCost = 100;
		this.m.DailyCost = 35;
		this.m.Excluded = [
			"trait.weasel",
			"trait.teamplayer",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.ailing",
			"trait.swift",
			"trait.clubfooted",
			"trait.irrational",
			"trait.hesitant",
			"trait.loyal",
			"trait.tiny",
			"trait.fragile",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.dastard",
			"trait.insecure",
			"trait.asthmatic"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Initiative,
			this.Const.Attributes.RangedSkill
		];
		this.m.Titles = [
			"Samotny Wilk",
			"Wilk",
			"Ogar",
			"Stalodzierżca",
			"Pogromca",
			"Kopijnik",
			"Olbrzym",
			"Góra",
			"Stalowe Oblicze",
			"Skaziciel",
			"Rycerzobójca",
			"Błędny Rycerz"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(2, 5);
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
		return "{Niektórzy rodzą się po to, aby się ich lękać. %name%, mierzący ponad sześć stóp wzrostu, samą swą posturą wzbudza grozę. | %name% swą posturą rzuca cień, który pada na mniejszych ludzi - którzy dodatkowo zdają się kurczyć, gdy przechodzi obok. | Stojąc w szeregu z innymi i wyglądając przy nich niczym potężny niedźwiedź w zbroi, %name% przyciąga wiele niedowierzających spojrzeń. | Lata brutalnej walki z równie wielkimi braćmi sprawiły, że %name% jest obliźnioną i przerażającą postacią.} {Ów błędny rycerz spędził wiele pór roku, zabierając swojego cennego konia na turnieje rycerskie i pojedynki na kopie. Niestety, przez pechowe trafienie drzewcem został bez wierzchowca. | Będąc najemnikiem w swej własnej, jednoosobowej kompanii, ów błędny rycerz wędrował przez lata, walcząc dla tych, którzy oferowali najwięcej koron. | Po tym, jak jednym zamachem rozpłatał pięciu ludzi, z których na nieszczęście trzech było po jego stronie, ów błędny rycerz został wydalony ze służby i odmawiano mu pracy w każdej armii w kraju. | Mając rozkaz zabicia wrogów lorda, wyważył drzwi domu i zabił całą rodzinę gołymi rękami. Kiedy lord odmówił zapłaty, %name% zabił również jego. | Ten błędny rycerz spędził wiele nocy śpiąc spokojnie w blasku księżyca - i równie wiele dni mordując bezlitośnie w blasku słońca.} {Jako że zawsze szukał okazji na zarobienie kolejnych koron, kompania najemników wydawała się dobrym wyborem. | Będąc zbyt przerażającym, by być zatrudnionym na dłużej, %name% szuka towarzystwa ludzi, którzy nie poszczają się ze strachu, gdy chwyta za broń. | Zmęczony zabijaniem uczestników turniejów i lordów, a także kobiet i dzieci, %name% postrzega pracę najemnika jako coś w rodzaju wakacji. | Wojna najwyraźniej przeszkodziła mu jego karierze turniejowej, więc %name% stara się jakoś rozwiązać ten problem.}";
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");

		if (this.Math.rand(1, 100) <= 25)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
			tattoo_body.Visible = true;
		}

		if (this.Math.rand(1, 100) <= 25)
		{
			tattoo_head.setBrush("scar_02_head");
			tattoo_head.Visible = true;
		}
	}

	function updateAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");

		if (tattoo_body.HasBrush)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
		}
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				12,
				13
			],
			Bravery = [
				9,
				4
			],
			Stamina = [
				15,
				10
			],
			MeleeSkill = [
				11,
				10
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				6,
				5
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				-14,
				-7
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(0, 2) == 2)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.HedgeKnightTitles[this.Math.rand(0, this.Const.Strings.HedgeKnightTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;

		if (this.Const.DLC.Unhold)
		{
			r = this.Math.rand(0, 2);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/weapons/greataxe"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/greatsword"));
			}
			else if (r == 2)
			{
				items.equip(this.new("scripts/items/weapons/two_handed_flanged_mace"));
			}
		}
		else
		{
			r = this.Math.rand(0, 1);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/weapons/greataxe"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/greatsword"));
			}
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/mail_hauberk"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/basic_mail_shirt"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/scale_armor"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/reinforced_mail_hauberk"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/armor/worn_mail_shirt"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/nasal_helmet"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/nasal_helmet_with_mail"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/mail_coif"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/bascinet_with_mail"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/helmets/closed_flat_top_helmet"));
		}
	}

});

