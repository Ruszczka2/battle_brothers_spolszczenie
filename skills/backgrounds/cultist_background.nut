this.cultist_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.cultist";
		this.m.Name = "Kultysta";
		this.m.Icon = "ui/backgrounds/background_34.png";
		this.m.BackgroundDescription = "Kultyści są niezwykle stanowczy w szerzeniu dalej swojego kultu.";
		this.m.GoodEnding = "Kultysta, %name%, opuścił kompanię z bandą zakapturzonych neofitów. Nie wiesz, co się z nim stało, ale od czasu do czasu śnisz, że się pojawia. Często stoi samotnie w wielkiej pustce, a w czerni poza nią zawsze czai się ktoś lub coś. Każdej nocy ten obraz staje się odrobinę wyraźniejszy i każdej nocy siedzisz coraz dłużej, byle tylko w ogóle nie zasnąć.";
		this.m.BadEnding = "Słyszałeś, że %name%, kultysta, w pewnym momencie opuścił kompanię i ruszył szerzyć swoją wiarę. Nie wiadomo, co się z nim stało, ale niedawno odbyła się inkwizycja przeciw bezbożnym kultom i setki \"mężczyzn w ciemnych płaszczach z jeszcze mroczniejszymi zamiarami\" spalono na stosie w całym królestwie.";
		this.m.HiringCost = 50;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.teamplayer",
			"trait.fear_undead",
			"trait.hate_beasts",
			"trait.hate_undead",
			"trait.hate_greenskins",
			"trait.night_blind",
			"trait.lucky",
			"trait.athletic",
			"trait.bright",
			"trait.drunkard",
			"trait.dastard",
			"trait.gluttonous",
			"trait.insecure",
			"trait.disloyal",
			"trait.hesitant",
			"trait.fat",
			"trait.bright",
			"trait.greedy",
			"trait.craven",
			"trait.fainthearted"
		];
		this.m.Titles = [
			"Kultysta",
			"Szalony",
			"Wierzący",
			"Okultysta",
			"Obłąkany",
			"Czciciel",
			"Zatracony",
			"dziwaczny",
			"Nawiedzony",
			"Fanatyk",
			"Gorliwy"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
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
		return "Mężczyzna stoi z tabliczką zawieszoną na szyi. | Twarz mężczyzny jest ozdobiona jaskrawymi tatuażami. Nosi notatkę. | Mężczyzna skrywa twarz pod głębokim kapturem, w ciemności widać tylko czubek nosa. Na szyi nosi tabliczkę. | Odziany jedynie w łachmany, aż dziwne jest, że ten człowiek nie poci się w upale ani nie trzęsie na zimnie. Ściska zwój, jakby to on chronił go przed żywiołami. | Na jego ramieniu widać rzędy blizn, które formują się w pismo, kodę obłąkania. | Nieznajomy bazgra patykiem w ziemi tak szybko, jakby robił to już tysiące razy. Jego przesłanie jest oczywiste. | Mężczyzna stoi z grymuarem schowanym za wykrzywioną ręką. Podaje ci go. Gdy go otwierasz, czujesz, że jest oprawiony w skórę, jakiej nigdy dotąd nie czułeś swym dotykiem. W środku jest tylko jeden, w kółko powtarzający się fragment.} Brzmi: \"Ph\'nglui mglw\'nafh Davkul R\'lyeh wgah\'nagl fhtagn. Nn\'nilgh\'ri, nn\'nglui. Sgn\'wahl sll\'ha ep\'shogg.\"  Hmm... osobliwe.";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-5,
				5
			],
			Bravery = [
				15,
				10
			],
			Stamina = [
				3,
				3
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

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");

		if (this.Math.rand(1, 100) <= 50)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("tattoo_01_" + body.getBrush().Name);
			tattoo_body.Visible = true;
		}

		if (this.Math.rand(1, 100) <= 50)
		{
			tattoo_head.setBrush("tattoo_01_head");
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
			tattoo_body.setBrush("tattoo_01_" + body.getBrush().Name);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/dagger"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/monk_robe"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/cultist_leather_robe"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/cultist_hood"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/cultist_leather_hood"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
	}

});

