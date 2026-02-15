this.bowyer_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.bowyer";
		this.m.Name = "Łuczarz";
		this.m.Icon = "ui/backgrounds/background_29.png";
		this.m.BackgroundDescription = "Łuczarze zwykle mają nieco wiedzy na temat tego, jak posługiwać się bronią, którą wytwarzają.";
		this.m.GoodEnding = "Podczas turnieju rycerskiego pewien chłopiec używał dziwnie ukształtowanego, lecz perfekcyjnie wykonanego łuku. Ręka, którą celował, drżała, a jednak strzały nie chwiały się po wypuszczeniu. Kiedy wygrał zawody, spytałeś, skąd ma tak niezwykły łuk. Odpowiedział, że wykonał go łuczarz imieniem %name%. Podobno jest znany z najlepszych łuków w całej krainie!";
		this.m.BadEnding = "Po twoim odejściu z %companyname% wysłałeś list, pytając o los %name%, łuczarza. Dotarła do ciebie wieść, że odkrył sposób na wyrabianie najdoskonalszego łuku i zamiast zdradzić sekret kompanii, odszedł, by założyć własny interes. Nie zaszedł daleko: to, czego się nauczył o swym fachu, zginęło wraz z nim na błotnistej drodze {na północ | na południe | na zachód | na wschód} stąd, a jego ciało, ironicznie, przebito tym, co rzekomo było tuzinem strzał.";
		this.m.HiringCost = 80;
		this.m.DailyCost = 8;
		this.m.Excluded = [
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.iron_jaw",
			"trait.athletic",
			"trait.clumsy",
			"trait.short_sighted",
			"trait.fearless",
			"trait.brave",
			"trait.iron_lungs",
			"trait.strong",
			"trait.tough",
			"trait.cocky",
			"trait.dumb",
			"trait.brute",
			"trait.bloodthirsty"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.MeleeSkill
		];
		this.m.Titles = [
			"Łuczarz",
			"Grotnik",
			"Strzałorób",
			"Cierpliwy"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.All;
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
		return "%name% jest szypnikiem i łuczarzem{ z dłoniami pełnymi odgniotów i okiem do cienkich nici | , choć co ciekawe, urodził się w rodzinie kowali | , kontynuując tym samym wielopokoleniową tradycję rzemieślniczą swego rodu}. {Wykonywał swe usługi dla rodziny królewskiej, jednak jego kariera skończyła się w wraz z zerwaną cięciwą, która odcięła palec dobrze zapowiadającemu się dziedzicowi. | Niestety, wojna zniszczyła lasy, z których pozyskiwał najlepsze drewno na swoje wyroby. | Na nieszczęście, sprzedał łuk pewnemu młodemu chłopcu, co doprowadziło do tragicznego, związanego ze strzałą wypadku. Po długich dyskusjach uznano, że nie jest już mile widziany w mieście. | Jednak po wielu latach tworzenia broni dla innych zaczął się zastanawiać, co jeszcze życie ma do zaoferowania poza drewnem i cięciwami.} {Teraz szuka innej ścieżki życia. Skoro sprzedaż łuków już nie jest dla niego opcją, to może sam zacznie ich używać. | Teraz wylądował w towarzystwie tych samych osób, które niegdyś zaopatrywał. | Skoro jego zainteresowanie strugania łuków minęło, to czy były łuczarz może szyć strzałami równie dobrze, jak szło mu ich wytwarzanie?}";
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
				0
			],
			Stamina = [
				-5,
				0
			],
			MeleeSkill = [
				0,
				0
			],
			RangedSkill = [
				10,
				10
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
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/hunting_bow"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/short_bow"));
		}

		items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/apron"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/feathered_hat"));
		}
	}

});

