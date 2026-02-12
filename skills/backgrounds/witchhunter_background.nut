this.witchhunter_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.witchhunter";
		this.m.Name = "Łowca Czarownic";
		this.m.Icon = "ui/backgrounds/background_23.png";
		this.m.BackgroundDescription = "Łowcy czarownic często mają jakieś doświadczenie w walce, a ich stanowczość jest zwykle niewzruszona nawet w obliczu nieopisanej zgrozy.";
		this.m.GoodEnding = "%name%, łowca czarownic, odszedł na wieść o złu szerzącym po wioskach północnych rubieży. Opuścił kompanię i od tamtego czasu pali te przeklęte wiedźmy na stosach.";
		this.m.BadEnding = "%name%, łowca czarownic, odszedł z kompanii na wieść o wielkim złu szerzącym się na północy krainy. Wyruszył więc, zabierając swoje osikowe kołki, fiolki pełne dziwnych płynów oraz sporą ilość podpałki. Miesiąc później jakiś wieśniak natknął się na niego, błąkającego się po północnych pustkowiach... z wydłubanymi oczami i zaszytymi ustami. Na jego piersi wyryty był dziwny symbol, a gdy chłop go dotknął, obaj mężczyźni eksplodowali.";
		this.m.HiringCost = 100;
		this.m.DailyCost = 13;
		this.m.Excluded = [
			"trait.weasel",
			"trait.teamplayer",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.hate_beasts",
			"trait.clubfooted",
			"trait.short_sighted",
			"trait.insecure",
			"trait.hesitant",
			"trait.craven",
			"trait.fainthearted",
			"trait.dumb",
			"trait.superstitious",
			"trait.drunkard"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(1, 3);
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
			},
			{
				id = 14,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] do Stanowczości podczas testów morale na strach, panikę i kontrolę umysłu"
			}
		];
	}

	function onBuildDescription()
	{
		return "{%name% pojawił się pewnego dnia w %townname%. Niektórzy twierdzą, że na prośbę {miejscowej rady | miejscowego księdza}. | %name% ma reputację osoby, która pojawia się tam, gdzie dzieją się rzeczy niezwykłe i błąkającej się po okolicy o najmroczniejszych porach nocy. | Będąc cichym i ponurym człowiekiem, %name% ma tendencję do sprawiania, że inni ludzie czują się przy nim nieswojo, a nawet, że się go lękają. | Imię %name% jest znane w wielu wioskach, ponieważ nieraz przemierzał krainę i był wszędzie tam, gdzie jego talenty były najbardziej potrzebne.} {Nazywa siebie Łowcą Czarownic. Dzięki swojemu bogatemu asortymentowi egzotycznych narzędzi ma duże doświadczenie w nakłanianiu ludzi do wyznawania ich grzesznych związków z demonami i diabłami. - zwykle robią to w agonii, podczas straszliwych tortur. | Mówi o sobie jako o Łowcy Czarownic, ale tylko przesądni głupcy w takie rzeczy wierzą i dają się nabrać na jego niedorzeczne opowieści. | Nazywa siebie Łowcą Czarownic i twierdzi, że widział  różne potworności nie z tego świata, które doprowadziłyby do obłędu zwykłego człowieka. | Po jego przybyciu do %townname% rozeszły się plotki, że polował na czcicieli diabła i stworzenia nocy, ale nikt nie wiedział, jaki był prawdziwy cel jego wizyty. | W %townname% zabił starszą kobietę i został wtrącony do lochu. Jak się okazało, kobieta była odpowiedzialna za porwanie i śmierć trójki niemowląt, więc został uwolniony. | Całymi nocami przesiadywał w pubie w %townname%, w milczeniu przyglądając się każdemu klientowi niczym drapieżny ptak krążący nad okolicą, a jego kusza była zawsze pod ręką. Nie podobało się to mieszkańcom, jednak nie odważyli się do niego podejść i zwrócić mu uwagi.} {Przez to większość miejscowych chciała, aby %name% zniknął z okolicy jak najwcześniej i z ulgą przywitałaby wiadomość, że dołączył na przykład do jakiejś wędrownej kompanii najemników. | Wygląda jednak na to, że jego misja została zakończona, jakakolwiek ona była, więc %name% zaczął oferować swoje usługi jako najemnik. | Widać, że %name% nie jest typem, którego łatwo przestraszyć i wie, jak posługiwać się kuszą. Nikt nie był więc zaskoczony, gdy rozpoczął rozmowy z kompanią najemników, która szukała nowych ludzi. | Kompania najemników byłaby więc dla niego idealnym narzędziem do wypełnienia jego osobistej misji przeciwko złu nie z tego świata. | Większość ludzi chętnie by się go pozbyła.}";
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
				0,
				0
			],
			Bravery = [
				12,
				10
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				0,
				0
			],
			RangedSkill = [
				15,
				8
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

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(0, 3) == 3)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.WitchhunterTitles[this.Math.rand(0, this.Const.Strings.WitchhunterTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/light_crossbow"));
		}
		else
		{
			items.equip(this.new("scripts/items/weapons/crossbow"));
		}

		items.equip(this.new("scripts/items/ammo/quiver_of_bolts"));
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.addToBag(this.new("scripts/items/weapons/knife"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/witchhunter_hat"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.MoraleCheckBravery[1] += 20;
	}

});

