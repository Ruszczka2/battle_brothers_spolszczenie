this.abandoned_village_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.abandoned_village_enter";
		this.m.Title = "Gdy się zbliżasz...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_178.png[/img]{Niedawno zniszczona wioska... bez ciał. Tylko wiatr wiruje, unosząc popioł i sycząc nim wśród ruin. Ale został jeden element: ogromny kamienny posąg, mistrzowsko wyrzeźbiony na podobieństwo mężczyzny. A przynajmniej tak ci się wydaje. Jego twarz została usunięta z dokładnością, która sugeruje rozmyśl, a nie zwykły wandalizm.\n\nNagle z każdej strony zbliżają się mlaskające w błocie kroki. Bulwiaste sylwetki kuleja w światło: przygarbione garbusy złożone z najbardziej nieuczciwych szwów, torsy zszyty na chybił trafił, z organami ledwie zakratowanymi za pasmami mięsa, dodatkowe ramiona z doczepionymi dłońmi, które machają na wszystkie strony, a na szczycie tych zapastowanych potwórności jęczą liczne głowy niczym mięsny totem, który zna samego siebie, pyski rozwarte i bulgoczące w obliczu ujawnionej grozy, oczu bez liku i wytrzeszczonych, patrzących na ciebie i na ziemię, i na siebie nawzajem. Twoi ludzie sapną i sięgają po broń. Potwory warczą i zaczynają zbierać z ziemi narzędzia oraz broń. Jeden potwór schyla się i podnosi dwa tasaki. Człapie naprzód, a twarze rozmazane na jego skórze kierują swoje zniekształcone spojrzenia na ciebie i otwierają usta do krzyku, a wrzaski wessają się i wylatują z jednego pyska do drugiego, powietrze wyje w ich wewnętrznych komorach, gdy twarze zmieniają się oddechem, by kolejna mogła krzyczeć.\n\nWciąż masz szansę uciec - raczej te rzeczy nie dotrzymają kroku żadnemu człowiekowi, ale co zostawisz za sobą, poza godnością i duma?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Do boju!",
					function getResult( _event )
					{
						local location = this.World.State.getLastLocation();

						if (location != null)
						{
							location.setVisited(false);
							location.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
							_event.registerToShowAfterCombat("Victory", "Defeat");
							this.World.State.startScriptedCombat(_event.buildEventCombatProperties(_event, location), false, false, false);
						}

						return 0;
					}

				},
				{
					Text = "Wynosimy się stąd!",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						return 0;
					}

				}
			],
			function start( _event )
			{
				if (this.World.Statistics.getFlags().get("AbandonedVillageFightDefeated"))
				{
				this.Text = "[img]gfx/ui/events/event_178.png[/img]{Jak można się było spodziewać, Golemy z Ciała wciąż kręcą się wokół bezimiennego posągu wiosni. Sądząc po stopniu świeżości i rozkładu, wygląda na to, że przybyli nowi, a starsi zaczynają się rozkładać. Ale wszyscy są jednomyślni, gdy ich lepkie oczy padają na ciebie i kompanię. Dobywasz miecza i wydajesz rozkaz ustawienia. Jeśli to miasto skrywa sekret, zamierzasz go znaleźć!}";
					this.Options = [
						{
							Text = "To battle!",
							function getResult( _event )
							{
								local location = this.World.State.getLastLocation();

								if (location != null)
								{
									location.setVisited(false);
									location.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
									_event.registerToShowAfterCombat("Victory", "Defeat");
									this.World.State.startScriptedCombat(_event.buildEventCombatProperties(_event, location), false, false, false);
								}
							}

						}
					];
				}
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Text = "[img]gfx/ui/events/event_178.png[/img]{Stoisz nad jedno z...rzeczy, z którymi właśnie walczyłeś. %randombrother% podsuwa ostrze pod głuty i unosi je. Wielka bryła mięsa wydłuża się w zszytych segmentach, ramiona rozchodzą się jak gałęzie drzewa, a tłuste kawałki zsuwają się po kończynach jak żywica. Reszta to same niezgodności: tu stopa zwisająca z tułowia jak klamka, tam twarz rozpływająca się, jakby topniała w rzekę ścięgien i więzadeł. Gdy twój najemnik pozwala temu zsuwać się z ostrza, worek mięsa płuska o ziemię, a kości grzechoczą jak zawalająca się drabina linowa. %randombrother2% podchodzi z kolczanem strzał i małą książką.%SPEECH_ON%Zdobyłem ten kolczan z, eee, ciekawymi strzałami. Wygląda na to, że na dole jest jakiś zbiornik do maczania grotów. Starzy bogowie wiedzą, co to za materiał. Znalazłem też tą książkę, przytwierdzoną do jednej z ich głów. Wygląda na ważną.%SPEECH_OFF%Otwierasz książkę i znajdujesz listy wiosek, jedna po drugiej przekreślane, a obok każdej prosta liczba. Pięćdziesiąt. Sześćdziesiąt. Siedemdziesiąt. Na końcu książki jest mapa do innego miejsca, wygląda na jakąś posiadłość.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Pospieszajcie się.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "Po bitwie...";
				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/ammo/legendary/quiver_of_coated_arrows");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				local locations = this.World.EntityManager.getLocations();

				foreach( location in locations )
				{
					if (location.getTypeID() == "location.artifact_reliquary")
					{
						location.setVisibilityMult(1.0);
						this.World.uncoverFogOfWar(location.getTile().Pos, 700.0);
						location.setDiscovered(true);
						this.World.getCamera().moveTo(location);
						location.onUpdate();
						break;
					}
				}

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().die();
				}
			}

		});
		this.m.Screens.push({
			ID = "Defeat",
		Text = "[img]gfx/ui/events/event_178.png[/img]{Walkę da się przegrać. Wiesz, że te potworności muszą być po części zrobione z tych, którzy polegli przed nimi. Nie chcąc podzielić takiego losu, rozkazujesz odwrot. Golemy z Ciała nie są dosyć szybkie, by gonić, więc ciężko odrywają się od tylnej osłony i znikają.\n\nWciąż możesz wrócić do tego miejsca, bo czemu w ogóle te rzeczy tu są?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wrócimy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "Po bitwie...";
				this.World.Statistics.getFlags().set("AbandonedVillageFightDefeated", true);
			}

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

	function buildEventCombatProperties( _event, _location )
	{
		local properties = this.Const.Tactical.CombatInfo.getClone();
		properties.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[_location.getTile().TacticalType];
		properties.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
		properties.CombatID = "AbandonedVillage";
		properties.Music = this.Const.Music.UndeadTracks;
		properties.LocationTemplate.Template[0] = "tactical.golems_village";
		properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineCenter;
		properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Center;
		properties.IsWithoutAmbience = true;
		properties.Parties.push(_location);
		local weather = this.Tactical.getWeather();
		local time = this.World.getTime().TimeOfDay;
		weather.setAmbientLightingColor(this.createColor(this.Const.Tactical.AmbientLightingColor.Time[time]));
		weather.setAmbientLightingSaturation(this.Const.Tactical.AmbientLightingSaturation.Time[time]);
		local clouds = weather.createCloudSettings();
		clouds.Type = this.getconsttable().CloudType.Fog;
		clouds.MinClouds = 20;
		clouds.MaxClouds = 20;
		clouds.MinVelocity = 10.0;
		clouds.MaxVelocity = 30.0;
		clouds.MinAlpha = 0.35;
		clouds.MaxAlpha = 0.45;
		clouds.MinScale = 2.0;
		clouds.MaxScale = 3.0;
		weather.buildCloudCover(clouds);
		properties.Entities = [];
		local f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID();
		properties.BeforeDeploymentCallback = function ()
		{
			_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/fault_finder", f, 7, 8, 7, 8, true);

			for( local i = 0; i < 2; i = ++i )
			{
				_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem", f, 6, 9, 6, 9, false);
			}

			_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem_unarmed", f, 6, 9, 6, 9, false);
			_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/fault_finder", f, 7, 8, 25, 26, true);

			for( local i = 0; i < 2; i = ++i )
			{
				_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem", f, 6, 9, 24, 27, false);
			}

			_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem_unarmed", f, 6, 9, 24, 27, false);
			_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/fault_finder", f, 24, 25, 15, 16, true);

			for( local i = 0; i < 2; i = ++i )
			{
				_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem", f, 23, 26, 14, 17, false);
			}

			_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem_unarmed", f, 23, 26, 14, 17, false);
			_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem_unarmed", f, 13, 15, 3, 5, false);
			_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem_unarmed", f, 13, 15, 26, 28, false);
		};
		properties.AfterDeploymentCallback = function ()
		{
			this.Tactical.getWeather().setAmbientLightingPreset(5);
			this.Tactical.getWeather().setAmbientLightingSaturation(0.9);
		};
		return properties;
	}

	function spawnEntityWithinBounds( _entity, _faction, _xLower, _xUpper, _yLower, _yUpper, _raiseTile, _maxAttempts = 200 )
	{
		local attempts = 0;
		local spawned = false;

		do
		{
			attempts++;
			local x = this.Math.rand(_xLower, _xUpper);
			local y = this.Math.rand(_yLower, _yUpper);
			local tile = this.Tactical.getTileSquare(x, y);

			if (!tile.IsEmpty)
			{
			}
			else
			{
				if (_raiseTile)
				{
					tile.Level = 1;

					for( local i = 0; i != 6; i = ++i )
					{
						if (!tile.hasNextTile(i))
						{
						}
						else
						{
							local next = tile.getNextTile(i);

							if (next.Level == 1)
							{
								tile.Level = 2;
								break;
							}
						}
					}
				}

				local e = this.Tactical.spawnEntity(_entity, tile.Coords);
				e.setFaction(_faction);
				e.assignRandomEquipment();
				spawned = true;
			}
		}
		while (!spawned && attempts <= _maxAttempts);

		return spawned;
	}

});

