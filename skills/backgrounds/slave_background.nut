this.slave_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.slave";
		this.m.Name = "Zadłużony";
		this.m.Icon = "ui/backgrounds/background_60.png";
		this.m.BackgroundDescription = "Zadłużeni są de-facto kastą niewolników w państwach-miastach, a jako tacy są nie tyle zatrudniani, co kupowani i nie otrzymują dziennego żołdu.";
		this.m.GoodEnding = "%name% the indebted has had a rough life and you\'ve both contributed to that and helped alleviate it in some way. You found him as a slave in the south, far from family and home. You \'hired\' him essentially for free and worked him as an enslaved sellsword. After you left the %companyname%, his name was removed from the ledger of indebted and he was for all intents and purposes a free man. He stayed with the company and has been rising through its ranks ever since. You stand at an odd relation to the man. He\'s never thanked you, nor has he expressed ill.";
		this.m.BadEnding = "With your retiring from the unsuccessful %companyname%, %name% the indebted from the north carried on with the company for a time. You got wind that the mercenary band ran into financial troubles and was selling off \'man and material\' to make ends meet. It seems %name%\'s time with the company presumably ended sometime there, and his time as a slave started again.";
		this.m.HiringCost = this.Math.rand(19, 22) * 10;
		this.m.DailyCost = 0;
		this.m.Titles = [
			"Zniewolony",
			"z Północy",
			"Jeniec",
			"Blady",
			"Więzień",
			"Porwany",
			"Pechowy",
			"Zadłużony",
			"Sprzedany",
			"Nie-wolny",
			"Poskromiony",
			"Zakuty",
			"Skrępowany"
		];
		this.m.Excluded = [
			"trait.survivor",
			"trait.iron_jaw",
			"trait.tough",
			"trait.strong",
			"trait.spartan",
			"trait.gluttonous",
			"trait.lucky",
			"trait.loyal",
			"trait.cocky",
			"trait.fat",
			"trait.fearless",
			"trait.brave",
			"trait.drunkard",
			"trait.determined",
			"trait.greedy",
			"trait.athletic",
			"trait.hate_beasts",
			"trait.hate_undead",
			"trait.hate_greenskins"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Bravery
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
		local ret = [
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
		ret.push({
			id = 19,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Brak testu morale dla nie-zadłużonych sojuszników, gdy postać ginie"
		});
		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Nigdy nie przeszkadza mu bycie w rezerwie"
		});
		return ret;
	}

	function onBuildDescription()
	{
		return "{Po wyglądzie można poznać, że %name% pochodzi z północy. Jego służba na południu wynikała z długu wobec Złotnika, w oczach którego zgrzeszył przez swoją wiarę w heretyckich starych bogów. | %name% ma rysy człowieka z północy, dzięki czemu z łatwością przyciąga wzrok przechodzących mężczyzn i kobiet. Zdarzyło się również, że przyciągnął on uwagę kapłana, który stwierdził, że ów mieszkaniec północy jest dłużnikiem Złotnika i szybko sprzedał intruza w niewolę. | Mieszkaniec północy, %name%, był kiedyś żołnierzem wysłanym na patrol na południe. Jego oddział zgubił się na pustyni i powoli się zmniejszał swą liczebność, aż %name% został ostatnim ocalałym. Łowcy głów pojmali go, ratując tym samym od niechybnej śmierci... no i oczywiście sprzedali go w niewolę, gdy tylko jego wyleczone ciało było już coś warte. | Pomimo tego, że pochodził z północy i łatwo go było zauważyć, %name% nierozsądnie wdawał się w działalność przestępczą i w końcu został przyłapany na kradzieży granatów z ogrodu Wezyra. Ma szczęście, że zachował głowę, ale teraz służy jako towar na targach niewolników.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-10,
				-10
			],
			Bravery = [
				-5,
				0
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
				-5,
				-5
			]
		};
		return c;
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local dirt = actor.getSprite("dirt");
		dirt.Visible = true;

		if (this.Math.rand(1, 100) <= 66)
		{
			local body = actor.getSprite("body");
			local tattoo_body = actor.getSprite("tattoo_body");
			tattoo_body.setBrush("scar_01_" + body.getBrush().Name);
			tattoo_body.Color = body.Color;
			tattoo_body.Saturation = body.Saturation;
			tattoo_body.Visible = true;
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.IsContentWithBeingInReserve = true;

		if (("State" in this.World) && this.World.State != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.manhunters")
		{
			_properties.XPGainMult *= 1.1;
			_properties.SurviveWithInjuryChanceMult = 0.0;
		}
	}

});

