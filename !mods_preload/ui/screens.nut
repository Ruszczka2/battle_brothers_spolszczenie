::mods_hookNewObject("ui/global/data_helper", function ( o )
{
	o.convertCampaignStorageToUIData = function ( _meta )
	{
		local d;
		d = " (" + this.Const.Strings.Difficulty[_meta.getInt("difficulty2")] + "/" + this.Const.Strings.Difficulty[_meta.getInt("difficulty")];

		if (_meta.getInt("ironman") == 1)
		{
			d = d + " Ironman";
		}

		d = d + ")";
		return {
			fileName = _meta.getFileName(),
			name = _meta.getName(),
			groupName = _meta.getString("groupname"),
			banner = _meta.getString("banner"),
			dayName = "Dzień " + _meta.getInt("days") + d,
			creationDate = _meta.getCreationDate(),
			isIncompatibleVersion = _meta.getVersion() < 33 || _meta.getVersion() > this.Const.Serialization.Version || !this.Const.DLC.isCompatible(_meta),
			isIronman = _meta.getInt("ironman") == 1
		};
	};
	o.convertContractToUIData = function ( _contract )
	{
		if (_contract != null)
		{
			local result = {
				id = _contract.getEmployerUIIndex(),
				title = _contract.getName(),
				headerImagePath = _contract.getHeaderImage(),
				content = [
					{
						id = 1,
						type = "image",
						imagePath = _contract.getEmployerImage()
					},
					{
						id = 2,
						type = "description",
						text = _contract.getDescription()
					}
				],
				buttons = _contract.getButtons()
			};

			if (_contract.getBulletpoints().len() != 0)
			{
				result.content.push({
					id = 3,
					type = "list",
					title = "Cele",
					items = _contract.getBulletpoints()
				});
			}

			return result;
		}
		else
		{
		}
	};
});
::mods_hookNewObject("ui/screens/character/character_screen", function ( o )
{
	o.onDismissCharacter = function ( _data )
	{
		local bro = this.Tactical.getEntityByID(_data[0]);
		local payCompensation = _data[1];

		if (bro != null)
		{
			bro.getSkills().onDismiss();
			this.World.Statistics.getFlags().increment("BrosDismissed");

			if (bro.getSkills().hasSkillOfType(this.Const.SkillType.PermanentInjury) && bro.getBackground().getID() != "background.slave")
			{
				this.World.Statistics.getFlags().increment("BrosWithPermanentInjuryDismissed");
			}

			if (payCompensation)
			{
				this.World.Assets.addMoney(-10 * this.Math.max(1, bro.getDaysWithCompany()));

				if (bro.getBackground().getID() == "background.slave")
				{
					local playerRoster = this.World.getPlayerRoster().getAll();

					foreach( other in playerRoster )
					{
						if (bro.getID() == other.getID())
						{
							continue;
						}

						if (other.getBackground().getID() == "background.slave")
						{
							other.improveMood(this.Const.MoodChange.SlaveCompensated, "Cieszy się, że " + bro.getName() + " otrzymał zadośćuczynienie za swą służbę");
						}
					}
				}
			}
			else if (bro.getBackground().getID() == "background.slave")
			{
			}
			else if (bro.getLevel() >= 11 && !this.World.Statistics.hasNews("dismiss_legend") && this.World.getPlayerRoster().getSize() > 1)
			{
				local news = this.World.Statistics.createNews();
				news.set("Name", bro.getName());
				this.World.Statistics.addNews("dismiss_legend", news);
			}
			else if (bro.getDaysWithCompany() >= 50 && !this.World.Statistics.hasNews("dismiss_veteran") && this.World.getPlayerRoster().getSize() > 1 && this.Math.rand(1, 100) <= 33)
			{
				local news = this.World.Statistics.createNews();
				news.set("Name", bro.getName());
				this.World.Statistics.addNews("dismiss_veteran", news);
			}
			else if (bro.getLevel() >= 3 && bro.getSkills().hasSkillOfType(this.Const.SkillType.PermanentInjury) && !this.World.Statistics.hasNews("dismiss_injured") && this.World.getPlayerRoster().getSize() > 1 && this.Math.rand(1, 100) <= 33)
			{
				local news = this.World.Statistics.createNews();
				news.set("Name", bro.getName());
				this.World.Statistics.addNews("dismiss_injured", news);
			}
			else if (bro.getDaysWithCompany() >= 7)
			{
				local playerRoster = this.World.getPlayerRoster().getAll();

				foreach( other in playerRoster )
				{
					if (bro.getID() == other.getID())
					{
						continue;
					}

					if (bro.getDaysWithCompany() >= 50)
					{
						other.worsenMood(this.Const.MoodChange.VeteranDismissed, bro.getName() + " został zwolniony");
					}
					else
					{
						other.worsenMood(this.Const.MoodChange.BrotherDismissed, bro.getName() + " został zwolniony");
					}
				}
			}

			if (("State" in this.World) && this.World.State != null && this.World.Assets.getOrigin().getID() == "scenario.manhunters")
			{
				local playerRoster = this.World.getPlayerRoster().getAll();
				local indebted = 0;
				local nonIndebted = [];

				foreach( bro in playerRoster )
				{
					if (bro.getBackground().getID() == "background.slave")
					{
						indebted++;
					}
					else
					{
						nonIndebted.push(bro);
					}
				}

				this.World.Statistics.getFlags().set("ManhunterIndebted", indebted);
				this.World.Statistics.getFlags().set("ManhunterNonIndebted", nonIndebted.len());
			}

			bro.getItems().transferToStash(this.World.Assets.getStash());
			this.World.getPlayerRoster().remove(bro);
			this.loadData();
			this.World.State.updateTopbarAssets();
		}
	};
});
::mods_hookNewObject("ui/screens/menu/main_menu_screen", function ( o )
{
	o.connect = function ()
	{
		this.m.JSHandle = this.UI.connect("MainMenuScreen", this);
		this.m.MainMenuModule.connectUI(this.m.JSHandle);
		this.m.LoadCampaignModule.connectUI(this.m.JSHandle);
		this.m.NewCampaignModule.connectUI(this.m.JSHandle);
		this.m.ScenarioMenuModule.connectUI(this.m.JSHandle);
		this.m.OptionsMenuModule.connectUI(this.m.JSHandle);
		this.m.CreditsModule.connectUI(this.m.JSHandle);
		this.m.JSHandle.asyncCall("setVersion", this.GameInfo.getVersionNumber() + " " + this.GameInfo.getVersionName());
		local dlc = [];

		for( local i = 0; i < 32; i = i )
		{
			if (this.Const.DLC.Info[i] != null && this.Const.DLC.Info[i].Announce == true)
			{
				local hasDLC = (this.Const.DLC.Mask & 1 << i) != 0;
				dlc.push({
					Image = hasDLC ? this.Const.DLC.Info[i].Icon : this.Const.DLC.Info[i].IconDisabled,
					Tooltip = "dlc_" + i,
					URL = this.Const.DLC.Info[i].URL
				});
			}

			i = ++i;
		}

		local pl = [];
		pl.push({
			Image = "ui/polska_wersja.png",
			Tooltip = "polska_wersja",
			URL = "http://daedalus.pl"
		});
		this.m.JSHandle.asyncCall("setPL", pl);
		this.m.JSHandle.asyncCall("setDLC", dlc);
		this.m.JSHandle.asyncCall("setMOTD", "Battle Brothers to wymagająca gra. Straty oraz odbudowa kompanii stanowią cześć rozgrywki.\n\nZaleca się rozpoczęcie gry na \'Początkującym\' poz. trudn. i wybranie historii z tutorialem!");
	};
});
::mods_hookNewObject("ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar", function ( o )
{
	o.flashProgressbars = function ( _flashActionPointsProgressbar, _flashFatigueProgressbar )
	{
		local activeEntity = this.getActiveEntity();

		if (activeEntity != null)
		{
			local flashBars;

			if (_flashActionPointsProgressbar)
			{
				flashBars = {
					attackPoints = true
				};
				this.Tactical.EventLog.log("[color=" + this.Const.UI.Color.NegativeValue + "]Zbyt mało Punktów Akcji![/color]");
			}

			if (_flashFatigueProgressbar)
			{
				if (flashBars == null)
				{
					flashBars = {
						fatigue = true
					};
				}
				else
				{
					flashBars.fatigue <- true;
				}

				this.Tactical.EventLog.log("[color=" + this.Const.UI.Color.NegativeValue + "]Postać jest zbyt zmęczona![/color]");
			}

			if (flashBars != null)
			{
				this.m.JSHandle.asyncCall("flashProgressbars", flashBars);
			}
		}
	};
	o.onEndTurnAllButtonPressed = function ()
	{
		if (this.m.IsSkippingRound || this.getActiveEntity() == null || !this.getActiveEntity().isPlayerControlled())
		{
			return;
		}

		this.Tactical.State.showDialogPopup("Zakończ Rundę", "Czy pominąć ruch wszystkich twoich postaci, aż do rozpoczęcia kolejnej rundy?", function ()
		{
			this.m.IsSkippingRound = true;
			this.m.JSHandle.call("setEndTurnAllButtonVisible", false);

			foreach( e in this.m.CurrentEntities )
			{
				if (e.isPlayerControlled())
				{
					e.setSkipTurn(true);
				}
			}

			this.initNextTurn();
		}.bindenv(this), null);
	};
});

