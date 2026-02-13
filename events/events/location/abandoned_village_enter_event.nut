this.abandoned_village_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.abandoned_village_enter";
		this.m.Title = "Gdy sie zblizasz...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_178.png[/img]{Niedawno zniszczona wioska... bez cial. Tylko wiatr wiruje, unoszac popiol i syczac nim wsrod ruin. Ale zostal jeden element: ogromny kamienny posag, mistrzowsko wyrzezony na podobizne mezczyzny. A przynajmniej tak ci sie wydaje. Jego twarz zostala usunieta z dokladnoscia, ktora sugeruje rozmysl, a nie zwykly wandalizm.\n\nNagle z kazdej strony zblizaja sie mlaskajace w blocie kroki. Bulwiaste sylwetki kuleja w swiatlo: przygarbione garbusy zlozone z najbardziej nieuczciwych szwow, torsy zszyte na chybil trafil, z organami ledwie zakratowanymi za pasmami miesa, dodatkowe ramiona z doczepionymi dlonmi, ktore machaja na wszystkie strony, a na szczycie tych zapastowanych potwornosci jecza liczne glowy niczym miesny totem, ktory zna samego siebie, pyski rozwarte i bulgoczace w obliczu ujawnionej grozy, oczu bez liku i wytrzeszczonych, patrzacych na ciebie i na ziemie, i na siebie nawzajem. Twoi ludzie sapna i siegaja po bron. Potwory warcza i zaczynaja zbierac z ziemi narzedzia oraz bron. Jeden potwor schyla sie i podnosi dwa tasaki. Czlapie naprzod, a twarze rozmazane na jego skorze kieruja swoje znieksztalcone spojrzenia na ciebie i otwieraja usta do krzyku, a wrzaski wsysaja sie i wylatuja z jednego pyska do drugiego, powietrze wyje w ich wewnetrznych komorach, gdy twarze zmieniaja sie oddechem, by kolejna mogla krzyczec.\n\nWciaz masz szanse uciec - raczej te rzeczy nie dotrzymaja kroku zadnemu czlowiekowi, ale co zostawisz za soba, poza godnoscia i duma?}",
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
					Text = "Wynosimy sie stad!",
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
					this.Text = "[img]gfx/ui/events/event_178.png[/img]{Jak mozna sie bylo spodziewac, Golemy z Ciala wciaz kreca sie wokol bezimiennego posagu wiesni. Sadzac po stopniu swiezosci i rozkladu, wyglada na to, ze przybyli nowi, a starsi zaczynaja sie rozpadac. Ale wszyscy sa jednomyslni, gdy ich lepkie oczy padaja na ciebie i kompanie. Dobytasz miecza i wydajesz rozkaz ustawienia. Jesli to miasto skrywa sekret, zamierzasz go znalezc!}";
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
			Text = "[img]gfx/ui/events/event_178.png[/img]{Stoisz nad jedna z...rzeczy, z ktorymi wlasnie walczyles. %randombrother% podsuwa ostrze pod gluty i unosi je. Wielka bryla miesa wydluza sie w zszytych segmentach, ramiona rozchodza sie jak galezie drzewa, a tluste kawalki zsuwaja sie po konczynach jak zywica. Reszta to same niezgodnosci: tu stopa zwisajaca z tulowia jak klamka, tam twarz rozplywajaca sie, jakby topniala w rzeke sciegien i wiazadel. Gdy twoj najemnik pozwala temu zsuwac sie z ostrza, worek miesa pluska o ziemie, a kosci grzechocza jak zawalajaca sie drabina linowa. %randombrother2% podchodzi z kolczanem strzal i mala ksiazka.%SPEECH_ON%Zdobilem ten kolczan z, eee, ciekawymi strzalami. Wyglada na to, ze na dole jest jakis zbiornik do maczania grotow. Starzy bogowie wiedza, co to za material. Znalazlem tez ta ksiazke, przytwierdzona do jednej z ich glow. Wyglada na wazna.%SPEECH_OFF%Otwierasz ksiazke i znajdujesz listy wiosek, jedna po drugiej przekreslane, a obok kazdej prosta liczba. Piecdziesiat. Szesdziesiat. Siedemdziesiat. Na koncu ksiazki jest mapa do innego miejsca, wyglada na jakas posiadlosc.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Pospieszajcie sie.",
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
			Text = "[img]gfx/ui/events/event_178.png[/img]{Walke da sie przegrac. Wiesz, ze te potwornosci musza byc po czesci zrobione z tych, ktorzy polegli przed nimi. Nie chcac podzielic takiego losu, rozkazujesz odwrot. Golemy z Ciala nie sa dosc szybkie, by gonic, wiec ciezko odrywaja sie od tylnej oslonny i znikaja.\n\nWciaz mozesz wrocic do tego miejsca, bo czemu w ogole te rzeczy tu sa?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wrocimy.",
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

