this.artifact_reliquary_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.artifact_reliquary_enter";
		this.m.Title = "Gdy sie zblizasz...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_182.png[/img]{Posiadlosc wyrasta nad okolica z czystych cietych kamiennych blokow i kolorowych dachowek. Ma cos, na co wiekszosci krolewskich nie stac: wyczucie smaku. Przystrzyzona trawa sprawia, ze trawnik wyglada niemal jak odcisk stopy na zaniedbanej ziemi. Posagi ludzi rozsiane po okolicy uchwycily pozy wzniosle i zalosne. Wsrod rzezb sa zywoploty przyciete w ksztalty zwierzat i fontanny z przejrzysta woda. Kompania stoi przy czarnym ogrodzeniu, bezczynnie wpatrujac sie przez kraty jak zwierzeta gospodarskie. %randombrother% kreci glowa i spluwa.%SPEECH_ON%No, ladne to wszystko, ale zaden bogacz z glebokimi kiesami nie zostawi tak otwartej bramy bez powodu, wiesz? Mysle, ze albo ktos juz tu wszystko przelecial, albo w srodku jest cos paskudnego i nie przeszkadza mu przypadkowy przechodzien.%SPEECH_OFF%Zgadzasz sie. Gdy patrzysz dalej, widzisz, ze sciezka prowadzi do wyzlobionego zaglebienia, jakby bogowie uderzyli knykciami w sama ziemie, zostawiajac nawisy i skarpy otaczajace teren. Jesli masz zwiedzac takie miejsce, wiesz w sercu, ze mozesz juz nie wrocic. Wciaz mozesz odejsc i wrocic pozniej...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Naprzod, ludzie.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Wrocmy tu pozniej.",
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
				if (this.World.Statistics.getFlags().get("ReliquaryFightDefeated"))
				{
					this.Text = "[img]gfx/ui/events/event_182.png[/img]{Wchodzisz w wyzlobione zaglebienie, a golemy z ciala, przewidywalnie, traktuja to \'miejsce\' jak arene i rozsiadaja sie na krawedzi skarp. Wielki Wrozbita stoi po srodku z niezwykla laska w dloni i usmiechem na twarzy.%SPEECH_ON%Witajcie znowu. Niech macierzenie trwa.%SPEECH_OFF%}";
					this.Options = [
						{
							Text = "Ten matkojebca...",
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
			ID = "B",
			Text = "[img]gfx/ui/events/event_182.png[/img]{Wydajesz rozkaz, by kompania weszla do ksiezycowatej kotliny. Nagle mezczyzna w wysokim czarnym helmie wychyla sie zza posagu. Dzierzy niezwykla laske, a za jej szklistym wierzcholkiem snuje sie smuga zielonej mgly.%SPEECH_ON%Witajcie! Czy przyszliscie zrozumiec moje dzielo? To w cieple macierzenia odnajduje sie pierwotne instynkty, blyski rozumu, ktore wszelkie stworzenie, od najlichszych robakow po najwyzej szybujace ptaki, pojmuje, a bez ktorych czlowiek nigdy nie zapanuje nad wszystkim. Ja, mezczyzna, jestem teraz matka. Ja, mezczyzna, zlamalem porzadek, i na tym instynkcie, wlasciwym wszystkim stworzeniom, wzniose sie, bez lona, ponad architekture samej natury i stane sie opiekunem wszystkich! Ja, Wielki Wrozbita, ten, ktory nawilzy ta sucha ziemie manifestacjami...%SPEECH_OFF%Monologujacy szaleniec z dziwna laska rzadko ma dobre intencje. Dobytasz miecza i, widzac ostrze, Wielki Wrozbita milkne. Kiwa glowa i szeroko rozklada ramiona, a z jego laski strzela blysk zieleni. Stworzenia takie jak te, ktore widziales wczesniej - zelatynowe, bulwiaste zlepki niejasnych konczyn - zaczynaja wygramalac sie zza posagow. Kolejne okrazaja cala kompanie, zajmujac miejsca wysoko, siadajac na krawedziach skarp niczym widzowie w koloseum, gotowi obejrzec dobra walke. Wielki Wrozbita usmiecha sie i wskazuje na ciebie laska.%SPEECH_ON%Usmiechnij sie, najemniku, bo gdy umrzesz, odrodze cie z powrotem w tym swiecie, a ty znajdziesz opieke w lonie mojej mocy!%SPEECH_OFF%}",
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

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Text = "[img]gfx/ui/events/event_182.png[/img]{Wrozbita lezy w grzeszawisku swoich stworzen, ranny czlowiek rozrzucony po poporodziu wlasnych manifestacji. Jego ciezki helm chroni szyje, ale po prostu kucasz i podwazasz go koncem miecza, jakby podnosil wiadro sztyletem. Zakrztusza sie i mowi.%SPEECH_ON%Nie mozesz mnie prawdziwie zabic bardziej, niz mozesz zabic matke nature.%SPEECH_OFF%Kiwacz glowa i wbijasz stal w jego podbrodek, az slyszysz, jak koniec dotyka szczytu helmu. Krew tryska po ochraniaczu szyi. Wstajesz i mowisz,%SPEECH_ON%Jestem matka natura.%SPEECH_OFF%%randombrother% smieje sie.%SPEECH_ON%Niezla kwestia, kapitanie. Troche glupia, jak sie nad tym zastanowic, ale-%SPEECH_OFF%Ucinasz najemnika i kazesz jemu oraz reszcie ludzi spladrowac miejsce. Gotycka posiadlosc z pewnoscia skrywa jakies kosztownosci, ktore sprawia, ze ta wyprawa byla warta zachodu. A co do dziwnej laski Wrozbity, wciaz wirujacej slaba zielona poswiata, kazesz zabrac ja do ekwipunku. Gdy szykujesz sie do odejscia, przychodzi meldunek, ze czesc \'golemow z ciala\' wybiegla z gotyckiej posiadlosci i uciekla w dzicz. Ich protoplasta nie zyje, ale wyglada na to, ze wciaz mozesz natrafiac na jego tworow.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Przynajmniej najbardziej potworny z nich nie zyje.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "Po bitwie...";

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().die();
				}

				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/weapons/legendary/miasma_flail");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Defeat",
			Text = "[img]gfx/ui/events/event_182.png[/img]{Przegrywacie walke i wolisz nie tracic wiecej - wyglada na to, ze przeciwko Wielkiemu Wrozbicie smierc moze nie byc twoim koncem. Odcinajac straty, zarzadzasz odwrot i przebijasz sie z okrazenia. \'Czujne\' golemy z ciala pomrukuja szyderczo jak niezadowolona widownia w koloseum.\n\nKrztuszac sie smiechem, Wielki Wrozbita trwa na miejscu i znika w tle. Smuga zielonej mgly siega po ciebie, uklada sie w ksztalt ust, ktore sie usmiechaja, po czym wszystko znika i znowu jestes poza tym miejscem. Powrot to spore wyzwanie, ale teraz czujesz determinacje, by zobaczyc tego szalenca martwego.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Pewnie i tak trzeba go zabic, zeby przestal nawiedzac nam sny.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "Po bitwie...";
				this.World.Statistics.getFlags().set("ReliquaryFightDefeated", true);

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}
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
		properties.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
		properties.CombatID = "ArtifactReliquary";
		properties.TerrainTemplate = "tactical.golems";
		properties.LocationTemplate.Template[0] = "tactical.golems_lair";
		properties.Music = this.Const.Music.UndeadTracks;
		properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Arena;
		properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Center;
		properties.IsFleeingProhibited = true;
		properties.IsWithoutAmbience = true;
		properties.IsFogOfWarVisible = false;
		properties.Parties.push(_location);
		local weather = this.Tactical.getWeather();
		local time = this.World.getTime().TimeOfDay;
		weather.setAmbientLightingColor(this.createColor(this.Const.Tactical.AmbientLightingColor.Time[time]));
		weather.setAmbientLightingSaturation(this.Const.Tactical.AmbientLightingSaturation.Time[time]);
		local clouds = weather.createCloudSettings();
		clouds.Type = this.getconsttable().CloudType.Fog;
		clouds.MinClouds = 20;
		clouds.MaxClouds = 20;
		clouds.MinVelocity = 3.0;
		clouds.MaxVelocity = 9.0;
		clouds.MinAlpha = 0.15;
		clouds.MaxAlpha = 0.25;
		clouds.MinScale = 2.0;
		clouds.MaxScale = 3.0;
		weather.buildCloudCover(clouds);
		properties.Entities = [];
		local f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID();
		properties.BeforeDeploymentCallback = function ()
		{
			local sorcerers = [];
			local greaterGolems = [];
			local entity;
			entity = _event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/grand_diviner", f, 16, 18, 10, 14, 0, true, sorcerers);

			if (entity != null)
			{
				sorcerers.push(entity);
			}

			for( local i = 0; i < 4; i = ++i )
			{
				entity = _event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/fault_finder", f, 18, 21, 6, 24, 0, true, sorcerers);

				if (entity != null)
				{
					sorcerers.push(entity);
				}
			}

			for( local i = 0; i < 4; i = ++i )
			{
				_event.spawnGuardEntity("scripts/entity/tactical/enemies/lesser_flesh_golem_unarmed_bodyguard", f, sorcerers);
			}

			for( local i = 0; i < 3; i = ++i )
			{
				entity = _event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/greater_flesh_golem", f, 15, 17, 6, 24, i + 1, true, greaterGolems);

				if (entity != null)
				{
					greaterGolems.push(entity);
				}
			}
		};
		properties.AfterDeploymentCallback = function ()
		{
			local playersAndFleshCradles = [];
			local brothers = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);

			foreach( bro in brothers )
			{
				playersAndFleshCradles.push(bro);
			}

			local entity;

			for( local i = 0; i < 10; i = ++i )
			{
				entity = _event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/flesh_cradle", f, 4, 24, 4, 24, 0, true, playersAndFleshCradles);

				if (entity != null)
				{
					playersAndFleshCradles.push(entity);
				}
			}

			this.Tactical.getWeather().setAmbientLightingPreset(5);
			this.Tactical.getWeather().setAmbientLightingSaturation(0.9);
		};
		return properties;
	}

	function spawnEntityWithinBounds( _entity, _faction, _xLower, _xUpper, _yLower, _yUpper, _useVariant = 0, _avoidEntities = false, _entitiesToAvoid = [], _maxAttempts = 500 )
	{
		local attempts = 0;
		local entity;

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
				if (_avoidEntities)
				{
					local scrapTile = false;

					foreach( entityToAvoid in _entitiesToAvoid )
					{
						if (tile.getDistanceTo(entityToAvoid.getTile()) < 3)
						{
							scrapTile = true;
							break;
						}
					}

					if (scrapTile)
					{
						  // [050]  OP_JMP            0     21    0    0
					}
				}

				entity = this.Tactical.spawnEntity(_entity, tile.Coords);
				entity.setFaction(_faction);
				entity.assignRandomEquipment();

				if (_useVariant > 0)
				{
					entity.setVariant(_useVariant);
				}
			}
		}
		while (entity == null && attempts <= _maxAttempts);

		return entity;
	}

	function spawnGuardEntity( _guardEntity, _guardFaction, _wards, _maxAttempts = 500 )
	{
		local attempts = 0;
		local entity;

		do
		{
			attempts++;
			local entityToProtect;
			local tile;

			foreach( ward in _wards )
			{
				if (ward.getType() != this.Const.EntityType.FaultFinder)
				{
					continue;
				}

				local alreadyHasGuard = false;

				for( local i = 0; i < this.Const.Direction.COUNT; i = ++i )
				{
					if (!ward.getTile().hasNextTile(i))
					{
					}
					else
					{
						local nextTile = ward.getTile().getNextTile(i);

						if (nextTile.IsEmpty)
						{
						}
						else if (nextTile.IsOccupiedByActor && nextTile.getEntity().getType() == this.Const.EntityType.LesserFleshGolem)
						{
							alreadyHasGuard = true;
							break;
						}
					}
				}

				if (alreadyHasGuard)
				{
					continue;
				}

				entityToProtect = ward;
			}

			if (entityToProtect == null)
			{
			}
			else
			{
				for( local i = this.Const.Direction.COUNT - 1; i >= 0; i = --i )
				{
					if (!entityToProtect.getTile().hasNextTile(i))
					{
					}
					else
					{
						local nextTile = entityToProtect.getTile().getNextTile(i);

						if (nextTile.IsEmpty)
						{
							tile = nextTile;
							break;
						}
					}
				}

				entity = this.Tactical.spawnEntity(_guardEntity, tile.Coords);
				entity.setFaction(_guardFaction);
				entity.assignRandomEquipment();
			}
		}
		while (entity == null && attempts <= _maxAttempts);

		return entity;
	}

});

