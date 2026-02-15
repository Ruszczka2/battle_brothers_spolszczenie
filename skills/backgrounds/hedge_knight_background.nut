this.hedge_knight_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hedge_knight";
		this.m.Name = "Błędny Rycerz";
		this.m.Icon = "ui/backgrounds/background_33.png";
		this.m.BackgroundDescription = "Błędni rycerze są rywalizującymi ze sobą osobnikami, którzy osiągnęli doskonałość w zbrojnej walce człowiek przeciwko człowiekowi w ciężkim pancerzu, choć gorzej im idzie we współpracy i zwinności.";
		this.m.GoodEnding = "Człowiek taki jak %name% zawsze znajdzie wyjście. Błędny rycerz w końcu, jeśli nie nieuchronnie, opuścił kompanię i ruszył na własną rękę. W przeciwieństwie do wielu innych braci, nie wydał koron na ziemię ani drabiny do wspinania się po szczeblach szlacheckiego życia. Zamiast tego kupił najlepsze rumaki bojowe i opłacił zdolnych płatnerzy. Ten kolos jeździł od turnieju do turnieju, wygrywając je wszystkie z łatwością. Do dziś tak żyje i sądzisz, że nie przestanie, dopóki nie umrze. Błędny rycerz po prostu nie zna innego życia.";
		this.m.BadEnding = "%name%, błędny rycerz, w końcu opuścił kompanię. Podróżował po krainach, wracając do ulubionego zajęcia - turniejów kopijniczych, które były w istocie przykrywką dla jego prawdziwej pasji: strącania ludzi z koni w deszczu drzazg i chwały. W pewnym momencie kazano mu \"oddać\" walkę przeciw nędznemu i chudemu księciu, by przynieść możnemu prestiż. Zamiast tego błędny rycerz przebił mu czaszkę kopią. Rozwścieczony lord wydał rozkaz zabicia rycerza. Mówią, że ponad setka żołnierzy ruszyła na jego siedzibę, a żywa wróciła tylko połowa.";
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

