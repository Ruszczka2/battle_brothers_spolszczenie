this.man_in_forest_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.man_in_forest";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_76.png[/img]Gdy przedzierasz się między drzewami, nagle z jednego z krzaków wyłania się mężczyzna. Gałązki i zarośla plączą mu się we włosach, zlepionych potem. Na twój widok cofa się gwałtownie.%SPEECH_ON%Proszę, już dość.%SPEECH_OFF%Podnosisz rękę, by go uspokoić, i pytasz, co się dzieje. Nieznajomy cofa się o krok.%SPEECH_ON%Proszę, już dość!%SPEECH_OFF%Odwraca się i ucieka, przebijając się z powrotem tam, skąd przyszedł. %randombrother% podbiega do ciebie.%SPEECH_ON%Mamy za nim iść?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Za nim, szybko!",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 45)
						{
							return "B";
						}
						else if (r <= 90)
						{
							return "C";
						}
						else
						{
							return "D";
						}
					}

				},
				{
					Text = "To nie nasza sprawa. Puść go.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_50.png[/img]Podążasz za mężczyzną w gęstwinę. Jego błotniste ślady nie są trudne do tropienia, a niezdarne wycofanie zostawia wiele śladów. Ale nagle znikają. Mężczyzna wyszedł na polanę, a potem jego ślad się urywa. Słyszysz gwizd ponad sobą. Kiedy spoglądasz w górę, widzisz mężczyznę siedzącego na gałęzi. Macha.%SPEECH_ON%Witajcie, obcy.%SPEECH_OFF%Zerka przez polanę. Zbliżają się ludzie i są dobrze uzbrojeni. Mężczyzna na drzewie prycha.%SPEECH_ON%Żegnajcie, obcy.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.BanditTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.BanditDefenders, this.Math.rand(90, 110) * _event.getReputationToDifficultyLightMult(), this.Const.Faction.Enemy);
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_25.png[/img]Ślady mężczyzny prowadzą dalej w pośpiechu, który tak przerażająco wyrwał go z twojego pola widzenia. Przerażonego człowieka takiego jak on nie jest trudno znaleźć, niestety już się nie boi, bo znajdujesz jedynie dokładnie wypatroszone zwłoki.\n\nDelikatne warczenie wibruje w pobliskich krzakach. Spoglądasz i widzisz lśniące, czarne futro powoli wychodzące zza drzewa. Krzyczysz do ludzi, by chwycili za broń.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.BeastsTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Direwolves, this.Math.rand(90, 110) * _event.getReputationToDifficultyLightMult(), this.Const.Faction.Enemy);
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_25.png[/img]Przerażonego mężczyzny nie było trudno znaleźć. Dostrzegasz go skulonego u podstawy drzewa. Ściska coś na piersi, jakby szukał w tym ciepła podczas zimnej nocy. Sam mężczyzna jednak nie żyje. Wydzierasz przedmiot z jego kurczowego uścisku.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Co to jest?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/weapons/named/named_dagger");
				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.SnowyForest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		this.m.Score = 7;
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

});

