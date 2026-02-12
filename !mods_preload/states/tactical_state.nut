::mods_hookNewObject("states/tactical_state", function ( o )
{
	o.main_menu_module_onQuitPressed = function ()
	{
		this.m.IsShowingFleeScreen = true;
		this.m.MenuStack.pop();
		this.setPause(true);
		this.Tooltip.hide();
		this.m.TacticalScreen.hide();

		if (!this.World.Assets.isIronman())
		{
			this.showDialogPopup("Wyjdź do Menu Głównego", "Czy na pewno chcesz opuścić tę bitwę i wyjść do menu głównego?\n\nWszelkie postępy poczynione w bitwie zostaną utracone, jednak przed rozpoczęciem bitwy utworzono zapis automatyczny.", this.onQuitToMainMenu.bindenv(this), this.onCancelQuitToMainMenu.bindenv(this));
		}
		else
		{
			this.showDialogPopup("Wyjdź i Zrezygnuj", "Czy na pewno chcesz opuścić tę bitwę i tym samym zakończyć rozgrywkę i opuścić kompanię?\n\nTwój zapisany stan gry zostanie usunięty i nie będziesz mieć możliwości kontynuowania tej rozgrywki.", this.onQuitToMainMenu.bindenv(this), this.onCancelQuitToMainMenu.bindenv(this));
		}

		this.Cursor.setCursor(this.Const.UI.Cursor.Hand);
	};
	o.onBattleEnded = function ()
	{
		if (this.m.IsExitingToMenu)
		{
			return;
		}

		this.m.IsBattleEnded = true;
		local isVictory = this.Tactical.Entities.getCombatResult() == this.Const.Tactical.CombatResult.EnemyDestroyed || this.Tactical.Entities.getCombatResult() == this.Const.Tactical.CombatResult.EnemyRetreated;
		this.m.IsFogOfWarVisible = false;
		this.Tactical.fillVisibility(this.Const.Faction.Player, true);
		this.Tactical.getCamera().zoomTo(2.0, 1.0);
		this.Tooltip.hide();
		this.m.TacticalScreen.hide();
		this.Tactical.OrientationOverlay.removeOverlays();

		if (isVictory)
		{
			this.Music.setTrackList(this.Const.Music.VictoryTracks, this.Const.Music.CrossFadeTime);

			if (!this.isScenarioMode())
			{
				if (this.m.StrategicProperties != null && this.m.StrategicProperties.IsAttackingLocation)
				{
					this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnVictoryVSLocation);
				}
				else
				{
					this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnVictory);
				}

				this.World.Contracts.onCombatVictory(this.m.StrategicProperties != null ? this.m.StrategicProperties.CombatID : "");
				this.World.Events.onCombatVictory(this.m.StrategicProperties != null ? this.m.StrategicProperties.CombatID : "");
				this.World.Statistics.getFlags().set("LastPlayersAtBattleStartCount", this.m.MaxPlayers);
				this.World.Statistics.getFlags().set("LastEnemiesDefeatedCount", this.m.MaxHostiles);
				this.World.Statistics.getFlags().set("LastCombatResult", 1);

				if (this.World.Statistics.getFlags().getAsInt("LastCombatFaction") == this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID())
				{
					this.World.Statistics.getFlags().increment("BeastsDefeated");
				}

				this.World.Assets.getOrigin().onBattleWon(this.m.CombatResultLoot);
				local playerRoster = this.World.getPlayerRoster().getAll();

				foreach( bro in playerRoster )
				{
					if (bro.getPlaceInFormation() <= 17 && !bro.isPlacedOnMap() && bro.getFlags().get("Devoured") == true)
					{
						bro.getSkills().onDeath(this.Const.FatalityType.Devoured);
						bro.onDeath(null, null, null, this.Const.FatalityType.Devoured);
						this.World.getPlayerRoster().remove(bro);
					}
					else if (this.m.StrategicProperties.IsUsingSetPlayers && bro.isPlacedOnMap())
					{
						bro.getLifetimeStats().BattlesWithoutMe = 0;

						if (this.m.StrategicProperties.IsArenaMode)
						{
							bro.improveMood(this.Const.MoodChange.BattleWon, "Zwyciężył na arenie");
						}
						else
						{
							bro.improveMood(this.Const.MoodChange.BattleWon, "Zwyciężył w bitwie");
						}
					}
					else if (!this.m.StrategicProperties.IsUsingSetPlayers)
					{
						if (bro.getPlaceInFormation() <= 17)
						{
							bro.getLifetimeStats().BattlesWithoutMe = 0;
							bro.improveMood(this.Const.MoodChange.BattleWon, "Zwyciężył w bitwie");
						}
						else if (bro.getMoodState() > this.Const.MoodState.Concerned && !bro.getCurrentProperties().IsContentWithBeingInReserve && !this.World.Assets.m.IsDisciplined)
						{
							++bro.getLifetimeStats().BattlesWithoutMe;

							if (bro.getLifetimeStats().BattlesWithoutMe > this.Math.max(2, 6 - bro.getLevel()))
							{
								bro.worsenMood(this.Const.MoodChange.BattleWithoutMe, "Czuł się bezużyteczny w rezerwie");
							}
						}
					}
				}
			}
		}
		else
		{
			this.Music.setTrackList(this.Const.Music.DefeatTracks, this.Const.Music.CrossFadeTime);

			if (!this.isScenarioMode())
			{
				local playerRoster = this.World.getPlayerRoster().getAll();

				foreach( bro in playerRoster )
				{
					if (bro.getPlaceInFormation() <= 17 && !bro.isPlacedOnMap() && bro.getFlags().get("Devoured") == true)
					{
						if (bro.isAlive())
						{
							bro.getSkills().onDeath(this.Const.FatalityType.Devoured);
							bro.onDeath(null, null, null, this.Const.FatalityType.Devoured);
							this.World.getPlayerRoster().remove(bro);
						}
					}
					else if (bro.getPlaceInFormation() <= 17 && bro.isPlacedOnMap() && (bro.getFlags().get("Charmed") == true || bro.getFlags().get("Sleeping") == true || bro.getFlags().get("Nightmare") == true))
					{
						if (bro.isAlive())
						{
							bro.kill(null, null, this.Const.FatalityType.Suicide);
						}
					}
					else if (bro.getPlaceInFormation() <= 17)
					{
						bro.getLifetimeStats().BattlesWithoutMe = 0;

						if (this.Tactical.getCasualtyRoster().getSize() != 0)
						{
							bro.worsenMood(this.Const.MoodChange.BattleLost, "Przegrał bitwę");
						}
						else if (this.World.Assets.getOrigin().getID() != "scenario.deserters")
						{
							bro.worsenMood(this.Const.MoodChange.BattleRetreat, "Wycofał się z bitwy");
						}
					}
					else if (bro.getMoodState() > this.Const.MoodState.Concerned && !bro.getCurrentProperties().IsContentWithBeingInReserve && !this.World.Assets.m.IsDisciplined)
					{
						++bro.getLifetimeStats().BattlesWithoutMe;

						if (bro.getLifetimeStats().BattlesWithoutMe > this.Math.max(2, 6 - bro.getLevel()))
						{
							bro.worsenMood(this.Const.MoodChange.BattleWithoutMe, "Czuł się bezużyteczny w rezerwie");
						}
					}
				}

				if (this.World.getPlayerRoster().getSize() != 0)
				{
					this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnLoss);
					this.World.Contracts.onRetreatedFromCombat(this.m.StrategicProperties != null ? this.m.StrategicProperties.CombatID : "");
					this.World.Events.onRetreatedFromCombat(this.m.StrategicProperties != null ? this.m.StrategicProperties.CombatID : "");
					this.World.Statistics.getFlags().set("LastEnemiesDefeatedCount", 0);
					this.World.Statistics.getFlags().set("LastCombatResult", 2);
				}
			}
		}

		if (this.m.StrategicProperties != null && this.m.StrategicProperties.IsArenaMode)
		{
			this.Sound.play(this.Const.Sound.ArenaEnd[this.Math.rand(0, this.Const.Sound.ArenaEnd.len() - 1)], this.Const.Sound.Volume.Tactical);
			this.Time.scheduleEvent(this.TimeUnit.Real, 4500, function ( _t )
			{
				this.Sound.play(this.Const.Sound.ArenaOutro[this.Math.rand(0, this.Const.Sound.ArenaOutro.len() - 1)], this.Const.Sound.Volume.Tactical);
			}, null);
		}

		this.gatherBrothers(isVictory);
		this.gatherLoot();
		this.Time.scheduleEvent(this.TimeUnit.Real, 800, this.onBattleEndedDelayed.bindenv(this), isVictory);
	};
	o.tactical_combat_result_screen_onQueryCombatInformation = function ()
	{
		local rounds = this.Tactical.TurnSequenceBar.getCurrentRound();
		local isWin = this.Tactical.Entities.getCombatResult() == this.Const.Tactical.CombatResult.EnemyDestroyed || this.Tactical.Entities.getCombatResult() == this.Const.Tactical.CombatResult.EnemyRetreated;
		local isArena = this.m.StrategicProperties != null && this.m.StrategicProperties.IsArenaMode;
		local isLooting = isWin && (this.m.StrategicProperties == null || !this.m.StrategicProperties.IsLootingProhibited) || isArena && !this.m.CombatResultLoot.isEmpty();
		local result = {
			result = isWin ? "win" : "loose",
			loot = isLooting,
			arena = isArena,
			title = "",
			subTitle = ""
		};

		switch(this.Tactical.Entities.getCombatResult())
		{
		case this.Const.Tactical.CombatResult.EnemyDestroyed:
			result.title = "Zwycięstwo";
			result.subTitle = "Wróg został pokonany w ciągu " + rounds + " rund" + (rounds > 1 ? "" : "y");
			break;

		case this.Const.Tactical.CombatResult.EnemyRetreated:
			result.title = "Zwycięstwo";
			result.subTitle = "Wróg się wycofał po " + rounds + " rund" + (rounds > 1 ? "ach" : "zie");
			break;

		case this.Const.Tactical.CombatResult.PlayerDestroyed:
			result.title = "Porażka";
			result.subTitle = "Przegrałeś po " + rounds + " rund" + (rounds > 1 ? "ach" : "zie");
			break;

		case this.Const.Tactical.CombatResult.PlayerRetreated:
			result.title = "Ucieczka";
			result.subTitle = "Wycofałeś się po " + rounds + " rund" + (rounds > 1 ? "ach" : "zie");

			if (!this.isScenarioMode())
			{
				this.updateAchievement("ToFightAnotherDay", 1, 1);
			}

			break;
		}

		return result;
	};
	o.showFleeScreen = function ( _tag = null )
	{
		this.setPause(true);
		this.Tooltip.hide();
		this.m.TacticalScreen.hide();
		this.m.TacticalDialogScreen.show("Wycofanie się z walki", "Czy na pewno chcesz się wycofać?", this.Const.Strings.UI.FleeDialogueConsequences, "Odwrót!", "Anuluj", this.tactical_flee_screen_onFleePressed.bindenv(this), this.tactical_flee_screen_onCancelPressed.bindenv(this));
		this.Cursor.setCursor(this.Const.UI.Cursor.Hand);
		this.m.MenuStack.push(function ()
		{
			this.Cursor.setCursor(this.Const.UI.Cursor.Hand);
			this.setPause(this.m.IsFleeing);
			this.m.IsShowingFleeScreen = false;

			if (!this.m.IsFleeing)
			{
				this.m.TacticalDialogScreen.hide();
				this.m.TacticalScreen.show();
			}
		}, function ()
		{
			return !this.m.TacticalDialogScreen.isAnimating();
		});
		return true;
	};
	o.showRetreatScreen = function ( _tag = null )
	{
		this.setPause(true);
		this.Tooltip.hide();
		this.m.TacticalScreen.hide();
		this.m.TacticalDialogScreen.show("Wróg się wycofuje", "", this.Const.Strings.UI.RetreatDialogueConsequences, "Wystarczy tego", "Dobić ich!", this.tactical_retreat_screen_onYesPressed.bindenv(this), this.tactical_retreat_screen_onNoPressed.bindenv(this));
		this.Cursor.setCursor(this.Const.UI.Cursor.Hand);
		this.m.MenuStack.push(function ()
		{
			this.Cursor.setCursor(this.Const.UI.Cursor.Hand);
			this.m.IsShowingFleeScreen = false;
			this.setPause(false);
			this.Tactical.TurnSequenceBar.setBusy(false);
		}, function ()
		{
			return !this.m.TacticalDialogScreen.isAnimating();
		});
		return true;
	};
	o.toggleMenuScreen = function ()
	{
		if (this.m.IsFleeing)
		{
			return;
		}

		local hasBacksteps = this.m.MenuStack.hasBacksteps();

		if (!hasBacksteps)
		{
			if (this.cancelCurrentAction())
			{
				return true;
			}

			local allowRetreat = this.m.StrategicProperties == null || !this.m.StrategicProperties.IsFleeingProhibited;
			local allowQuit = !this.isScenarioMode();
			this.setPause(true);
			this.Tooltip.hide();
			this.m.TacticalScreen.hide();
			this.m.TacticalMenuScreen.show(allowRetreat, allowQuit, !this.isScenarioMode() && this.World.Assets.isIronman() ? "Wyjdź i Zrezygnuj" : "Wyjdź");
			this.Cursor.setCursor(this.Const.UI.Cursor.Hand);
			this.m.MenuStack.push(function ()
			{
				this.m.TacticalMenuScreen.hide();

				if (!this.m.IsShowingFleeScreen)
				{
					this.m.TacticalScreen.show();
				}

				this.Cursor.setCursor(this.Const.UI.Cursor.Hand);
				this.setPause(false);
			}, function ()
			{
				return !this.m.TacticalMenuScreen.isAnimating();
			});
			return true;
		}
		else
		{
			this.m.MenuStack.pop();
			return true;
		}
	};
});

