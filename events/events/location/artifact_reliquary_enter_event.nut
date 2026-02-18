this.artifact_reliquary_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.artifact_reliquary_enter";
		this.m.Title = "Gdy się zbliżasz...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_182.png[/img]{Posiadłość wyrasta nad okolicę z czystych ciętych kamiennych bloków i kolorowych dachówek. Ma coś, na co większości królewskich nie stać: wyczucie smaku. Przycięta trawa sprawia, że trawnik wygląda niemal jak odcisk stopy na zaniedbanej ziemi. Posągi ludzi rozsiane po okolicy uchwycili pozy wzniosłe i żałosne. Wśród rzeźb są żywoploty przyciete w kształty zwierząt i fontanny z przejrzystą wodą. Kompania stoi przy czarnym ogrodzeniu, bezczynnie wpatrując się przez kraty jak zwierzęta gospodarskie. %randombrother% kreci główą i pluje.%SPEECH_ON%No, ładne to wszystko, ale żaden bogacz z głębokimi kiesami nie zostawi tak otwartej bramy bez powodu, wiesz? Myślę, że albo ktoś już tu wszystko przelecialem, albo w środku jest coś paskudnego i nie przeszkadza mu przypadkowy przechodzeń.%SPEECH_OFF%Zgadzasz się. Gdy patrzysz dalej, widzisz, że ścieżka prowadzi do wyżłobionego zagłębienia, jakby bogowie uderzyli knykciami w samą ziemię, zostawiając nawisy i skarpy otaczające teren. Jeśli masz zwiedzać takie miejsce, wiesz w sercu, że możesz już nie wrócić. Wciąż możesz odejść i wrócić później...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Naprzód, ludzie.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Wróćmy tu później.",
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
				this.Text = "[img]gfx/ui/events/event_182.png[/img]{Wchodzisz w wyżłobione zagłębienie, a golemy z ciała, przewidywalnie, traktują to 'miejsce' jak arenę i rozsiadają się na krawędzi skarp. Wielki Wróżbita stoi po środku z niezwykłą laską w dłoni i uśmiechem na twarzy.%SPEECH_ON%Witajcie znowu. Niech macierzenie trwa.%SPEECH_OFF%}";
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
			Text = "[img]gfx/ui/events/event_182.png[/img]{Wydajesz rozkaz, by kompania weszła do księżycowatej kotliny. Nagle mężczyzna w wysokim czarnym helmie wychyla się zza posągu. Dzierży niezwykłą laską, a za jej szklistym wierzchołkiem snuje się smuga zielonej mgły.%SPEECH_ON%Witajcie! Czy przyszliście zrozumieć moje dzieło? To w cieple macierzenia odnajduje się pierwotne instynkty, błyski rozumu, które wszelkie stworzenie, od najlichszych robaków po najwyżej szybujące ptaki, pojmuje, a bez których człowiek nigdy nie zapanuje nad wszystkim. Ja, mężczyzna, jestem teraz matką. Ja, mężczyzna, złamałem porządek, i na tym instynkcie, właściwym wszystkim stworzeniom, wznioszę się, bez łona, ponad architekturę samej natury i stanę się opiekunem wszystkich! Ja, Wielki Wróżbita, ten, który nawilży tę suchą ziemię manifestacjami...%SPEECH_OFF%Monologujący szaleniec z dziwną laską rzadko ma dobre intencje. Dobywasz miecza i, widząc ostrze, Wielki Wróżbita milknie. Kiwa główą i szeroko rozkłada ramiona, a z jego laski strzela błysk zieleni. Stworzenia takie jak te, które widziałeś wcześniej - żelatynowe, bulwiaste zlepki niejasnych kończyn - zaczynają wygramalać się zza posągów. Kolejne okrążają całą kompanię, zajmując miejsca wysoko, siadając na krawędziach skarp niczym widzowie w koloseum, gotowi obejrzeć dobrą walkę. Wielki Wróżbita uśmiecha się i wskazuje na ciebie laską.%SPEECH_ON%Uśmiechnij się, najemniku, bo gdy umrzesz, odrodzę cię z powrotem w tym świecie, a ty znajdziesz opiekę w łonie mojej mocy!%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_182.png[/img]{Wróżbita leży w grzęzawisku swoich stworzeń, ranny człowiek rozrzucony po poporodziu własnych manifestacji. Jego ciężki helm chroni szyję, ale po prostu kucasz i podważasz go końcem miecza, jakby podnosił wiadro sztyletem. Zakrztuszy się i mówi.%SPEECH_ON%Nie możesz mnie prawdziwie zabić bardziej, niż możesz zabić matkę naturę.%SPEECH_OFF%Kiwasz główę i wbijasz stal w jego podbródek, aż słyszysz, jak koniec dotyka szczytu hełmu. Krew tryska po ochraniacz szyi. Wstajesz i mówisz,%SPEECH_ON%Jestem matką naturę.%SPEECH_OFF%%randombrother% śmieje się.%SPEECH_ON%Niezła kwestia, kapitanie. Trochę głupia, jak się nad tym zastanowić, ale-%SPEECH_OFF%Ucinasz najemnika i każesz jemu oraz reszcie ludzi splądrować miejsce. Gotycka posiadłość z pewnością skrywa jakieś kosztowności, które sprawiają, że ta wyprawa była warta zachodu. A co do dziwnej laski Wróżbity, wciąż wirującej słabą zieloną poświatą, każesz zabrać ją do ekwipunku. Gdy szykujesz się do odejścia, przychodzi meldunek, że część 'golemów z ciała' wybiegła z gotyckiej posiadłości i uciekła w dziczy. Ich protoplasta nie żyje, ale wygląda na to, że wciąż możesz natrafić na jego tworów.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
				Text = "Przynajmniej najbardziej potworny z nich nie żyje.",
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
		Text = "[img]gfx/ui/events/event_182.png[/img]{Przegrywacie walkę i wolisz nie tracić więcej - wygląda na to, że przeciwko Wielkiemu Wróżbicie śmierć może nie być twoim końcem. Odcinając straty, zarządzasz odwrot i przebijasz się z okrążenia. 'Czujne' golemy z ciała pomrukują szyderczo jak niezadowolona widownia w koloseum.\n\nKrztuszy się śmiechem, Wielki Wróżbita trwa na miejscu i znika w tle. Smuga zielonej mgły sięga po ciebie, układa się w kształt ust, które się uśmiechają, po czym wszystko znika i znowu jesteś poza tym miejscem. Powrót to spore wyzwanie, ale teraz czujesz determinację, by zobaczyć tego szaleńca martwego.}"
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Pewnie i tak trzeba go zabić, żeby przestał nawiedzać nam sny.",
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

