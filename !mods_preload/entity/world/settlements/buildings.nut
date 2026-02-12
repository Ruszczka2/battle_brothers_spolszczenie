::mods_hookClass("entity/world/settlements/buildings/alchemist_building", function ( o )
{
	while (!("getDescription" in o))
	{
		o = o[o.SuperName];
	}

	o.getName = function ()
	{
		return "Alchemik";
	};
	o.getDescription = function ()
	{
		return "Można tu zakupić egzotyczne i niebezpieczne alchemiczne mikstury";
	};
});
::mods_hookClass("entity/world/settlements/buildings/armorsmith_building", function ( o )
{
	while (!("getDescription" in o))
	{
		o = o[o.SuperName];
	}

	o.getName = function ()
	{
		return "Płatnerz";
	};
	o.getDescription = function ()
	{
		return "Warsztat tego płatnerza jest właściwym miejscem, aby poszukać dobrze wykonanej i wytrzymałej ochrony";
	};
});
::mods_hookClass("entity/world/settlements/buildings/barber_building", function ( o )
{
	while (!("getDescription" in o))
	{
		o = o[o.SuperName];
	}

	o.getName = function ()
	{
		return "Golibroda";
	};
	o.getDescription = function ()
	{
		return "Zmień wygląd swoich ludzi u golibrody";
	};
});
::mods_hookClass("entity/world/settlements/buildings/fletcher_building", function ( o )
{
	while (!("getDescription" in o))
	{
		o = o[o.SuperName];
	}

	o.getName = function ()
	{
		return "Łuczarz";
	};
	o.getDescription = function ()
	{
		return "Można znaleźć tu wszelkiego rodzaju fachowo wykonaną broń dystansową";
	};
});
::mods_hookClass("entity/world/settlements/buildings/kennel_building", function ( o )
{
	while (!("getDescription" in o))
	{
		o = o[o.SuperName];
	}

	o.getName = function ()
	{
		return "Psiarnia";
	};
	o.getDescription = function ()
	{
		return "W tej psiarni hodowane są silne i szybkie ogary wojenne";
	};
});
::mods_hookClass("entity/world/settlements/buildings/marketplace_building", function ( o )
{
	while (!("getDescription" in o))
	{
		o = o[o.SuperName];
	}

	o.getName = function ()
	{
		return "Targ";
	};
	o.getDescription = function ()
	{
		return "Pełen życia targ oferujący wszelakie towary typowe dla tego regionu";
	};
});
::mods_hookClass("entity/world/settlements/buildings/taxidermist_building", function ( o )
{
	while (!("getDescription" in o))
	{
		o = o[o.SuperName];
	}

	o.getName = function ()
	{
		return "Taksydermista";
	};
	o.getDescription = function ()
	{
		return "Taksydermista potrafi wytworzyć użyteczne przedmioty z posiadanych przez ciebie różnych trofeów";
	};
});
::mods_hookClass("entity/world/settlements/buildings/temple_building", function ( o )
{
	while (!("getDescription" in o))
	{
		o = o[o.SuperName];
	}

	o.getName = function ()
	{
		return "Świątynia";
	};
	o.getDescription = function ()
	{
		return "Pozwól, aby kapłani opatrzyli rany twych ludzi";
	};
});
::mods_hookClass("entity/world/settlements/buildings/training_hall_building", function ( o )
{
	while (!("getDescription" in o))
	{
		o = o[o.SuperName];
	}

	o.getName = function ()
	{
		return "Sala Szkoleniowa";
	};
	o.getDescription = function ()
	{
		return "Nakaż swym ludziom przećwiczyć walkę i uczyć się od weteranów";
	};
});
::mods_hookClass("entity/world/settlements/buildings/weaponsmith_building", function ( o )
{
	while (!("getDescription" in o))
	{
		o = o[o.SuperName];
	}

	o.getName = function ()
	{
		return "Zbrojmistrz";
	};
	o.getDescription = function ()
	{
		return "W kuźni tego zbrojmistrza można znaleźć różnego rodzaju dobrze wykonaną broń";
	};
});
::mods_hookClass("entity/world/settlements/buildings/port_building", function ( o )
{
	while (!("getRandomDescription" in o))
	{
		o = o[o.SuperName];
	}

	o.getName = function ()
	{
		return "Przystań";
	};
	o.getDescription = function ()
	{
		return "Przystań, która służy zagranicznym okrętom kupieckim oraz miejscowym rybakom";
	};
	o.getRandomDescription = function ( _destinationName )
	{
		local desc = "{Szybki okręt zwany | Wytrzymały okręt zwany | Koga zwana | Langskip zwany | Mały statek zwany | Statek kupiecki zwany | Knara zwana | Miejscowa łódź rybacka zwana | Stary, skrzypiący statek zwany} \'%shipname%\' {zbierze twoją kompanię na pokład i do %destname% | właśnie wybiera się do %destname% i zabierze twoją kompanię na pokład | niedługo wypłynie i może być sposobem na bezpieczną i szybką podróż do %destname% | może cię zabrać do %destname% znacznie szybciej, niż dostałbyś się tam drogą lądową | może podrzucić cię do %destname% za sakiewkę pełną koron}.";
		local vars = [
			[
				"shipname",
				this.Const.Strings.ShipNames[this.Math.rand(0, this.Const.Strings.ShipNames.len() - 1)]
			],
			[
				"destname",
				_destinationName
			]
		];
		return this.buildTextFromTemplate(desc, vars);
	};
	o.getUITravelRoster = function ()
	{
		local data = {
			Title = "Przystań",
			SubTitle = "Przystań pozwala ci wykupić przedostanie się okrętem na inne części kontynentu",
			HeaderImage = null,
			Roster = []
		};
		local settlements = this.World.EntityManager.getSettlements();

		foreach( s in settlements )
		{
			if (!s.isCoastal())
			{
				continue;
			}

			if (s.getID() == this.m.Settlement.getID())
			{
				continue;
			}

			if (!s.isAlliedWithPlayer() || !this.m.Settlement.getOwner().isAlliedWith(s.getFaction()))
			{
				continue;
			}

			local dest = {
				ID = s.getID(),
				EntryID = data.Roster.len(),
				ListName = "Płyń do: " + s.getName(),
				Name = s.getName(),
				Cost = this.getCostTo(s),
				ImagePath = s.getImagePath(),
				ListImagePath = s.getImagePath(),
				FactionImagePath = s.getOwner().getUIBannerSmall(),
				BackgroundText = s.getDescription() + "<br><br>" + this.getRandomDescription(s.getName())
			};
			data.Roster.push(dest);
		}

		return data;
	};
});

