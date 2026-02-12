::mods_hookNewObject("states/world_state", function ( o )
{
	o.setPause = function ( _f )
	{
		if (_f != this.m.IsGamePaused)
		{
			this.m.IsGamePaused = _f;

			if (!_f)
			{
				if (this.World.Assets.isCamping())
				{
					this.World.TopbarDayTimeModule.showMessage("- OBÓZ -", "");
				}
				else
				{
					this.World.TopbarDayTimeModule.hideMessage();
				}
			}
			else
			{
				this.World.TopbarDayTimeModule.showMessage("-PAUZA-", "(Naciśnij Spację)");
			}
		}

		if (_f || this.m.IsGameAutoPaused)
		{
			this.m.LastWorldSpeedMult = this.World.getSpeedMult() != 0 ? this.World.getSpeedMult() : this.m.LastWorldSpeedMult;
			this.World.setSpeedMult(0.0);
			this.m.IsAIPaused = true;
		}
		else
		{
			this.World.setSpeedMult(this.m.LastWorldSpeedMult != 0 ? this.m.LastWorldSpeedMult : 1.0);
			this.m.IsAIPaused = false;
		}

		if (("TopbarDayTimeModule" in this.World) && this.World.TopbarDayTimeModule != null)
		{
			if (this.m.IsGamePaused)
			{
				this.World.TopbarDayTimeModule.updateTimeButtons(0);
			}
			else if (this.World.getSpeedMult() == 1.0)
			{
				this.World.TopbarDayTimeModule.updateTimeButtons(1);
			}
			else
			{
				this.World.TopbarDayTimeModule.updateTimeButtons(2);
			}
		}
	};
	o.onCamp = function ()
	{
		if (!this.isCampingAllowed())
		{
			return;
		}

		this.World.Assets.setCamping(!this.World.Assets.isCamping());

		if (this.World.Assets.isCamping())
		{
			this.m.Player.setDestination(null);
			this.m.Player.setPath(null);
			this.m.AutoEnterLocation = null;
			this.m.AutoAttack = null;
		}

		if (this.World.Assets.isCamping())
		{
			this.m.LastWorldSpeedMult = this.Const.World.SpeedSettings.CampMult;
			this.World.TopbarDayTimeModule.enableNormalTimeButton(false);

			if (!this.isPaused())
			{
				this.World.setSpeedMult(this.Const.World.SpeedSettings.CampMult);
				this.World.TopbarDayTimeModule.updateTimeButtons(2);
			}
			else
			{
				this.World.TopbarDayTimeModule.updateTimeButtons(0);
			}
		}
		else
		{
			this.m.LastWorldSpeedMult = 1.0;
			this.World.TopbarDayTimeModule.enableNormalTimeButton(true);

			if (!this.isPaused())
			{
				this.World.setSpeedMult(1.0);
				this.World.TopbarDayTimeModule.updateTimeButtons(1);
			}
			else
			{
				this.World.TopbarDayTimeModule.updateTimeButtons(0);
			}
		}

		if (!this.isPaused())
		{
			if (this.World.Assets.isCamping())
			{
				this.World.TopbarDayTimeModule.showMessage("- OBÓZ -", "");
			}
			else
			{
				this.World.TopbarDayTimeModule.hideMessage();
			}
		}
		else
		{
			this.World.TopbarDayTimeModule.showMessage("-PAUZA-", "(Naciśnij Spację)");
		}
	};
	o.showCombatDialog = function ( _isPlayerInitiated = true, _isCombatantsVisible = true, _allowFormationPicking = true, _properties = null, _pos = null )
	{
		local entities = [];
		local allyBanners = [];
		local enemyBanners = [];
		local hasOpponents = false;
		local listEntities = _isCombatantsVisible && (_isPlayerInitiated || this.World.Assets.getOrigin().getID() == "scenario.rangers" || this.Const.World.TerrainTypeLineBattle[this.m.Player.getTile().Type] && this.World.getTime().IsDaytime);

		if (_pos == null)
		{
			_pos = this.m.Player.getPos();
		}

		if (_properties != null)
		{
			allyBanners = _properties.AllyBanners;
			enemyBanners = _properties.EnemyBanners;
		}

		if (allyBanners.len() == 0)
		{
			allyBanners.push(this.World.Assets.getBanner());
		}

		if (!_isPlayerInitiated && this.World.Assets.isCamping())
		{
			_allowFormationPicking = false;
		}

		if (!_isPlayerInitiated && !this.Const.World.TerrainTypeLineBattle[this.m.Player.getTile().Type])
		{
			_allowFormationPicking = false;
		}

		local champions = [];
		local entityTypes = [];
		entityTypes.resize(this.Const.EntityType.len(), 0);

		if (_properties != null)
		{
			_properties.IsPlayerInitiated = _isPlayerInitiated;
		}

		if (_properties == null)
		{
			local parties = this.World.getAllEntitiesAtPos(_pos, this.Const.World.CombatSettings.CombatPlayerDistance);
			local isAtUniqueLocation = false;

			if (parties.len() <= 1)
			{
				this.m.EngageCombatPos = null;
				return;
			}

			foreach( party in parties )
			{
				if (!party.isAlive() || party.isPlayerControlled())
				{
					continue;
				}

				if (!party.isAttackable() || party.getFaction() == 0 || party.getVisibilityMult() == 0)
				{
					continue;
				}

				if (party.isLocation() && party.isShowingDefenders() && party.getCombatLocation().Template[0] != null && party.getCombatLocation().Fortification != 0 && !party.getCombatLocation().ForceLineBattle)
				{
					entities.push({
						Name = "Fortyfikacje",
						Icon = "palisade_01_orientation",
						Overlay = null
					});
				}

				if (party.isLocation() && party.isLocationType(this.Const.World.LocationType.Unique))
				{
					isAtUniqueLocation = true;
					break;
				}

				if (party.isInCombat())
				{
					parties = this.World.getAllEntitiesAtPos(_pos, this.Const.World.CombatSettings.CombatPlayerDistance * 2.0);
					break;
				}
			}

			foreach( party in parties )
			{
				if (!party.isAlive() || party.isPlayerControlled())
				{
					continue;
				}

				if (!party.isAttackable() || party.getFaction() == 0 || party.getVisibilityMult() == 0)
				{
					continue;
				}

				if (isAtUniqueLocation && (!party.isLocation() || !party.isLocationType(this.Const.World.LocationType.Unique)))
				{
					continue;
				}

				if (party.isAlliedWithPlayer())
				{
					if (party.getTroops().len() != 0 && allyBanners.find(party.getBanner()) == null)
					{
						allyBanners.push(party.getBanner());
					}

					continue;
				}
				else
				{
					hasOpponents = true;

					if (!party.isLocation() || party.isShowingDefenders())
					{
						if (party.getTroops().len() != 0 && enemyBanners.find(party.getBanner()) == null)
						{
							enemyBanners.push(party.getBanner());
						}
					}
				}

				if (party.isLocation() && !party.isShowingDefenders())
				{
					entityTypes.resize(this.Const.EntityType.len(), 0);
					break;
				}

				party.onBeforeCombatStarted();
				local troops = party.getTroops();

				foreach( t in troops )
				{
					if (t.Script.len() != "")
					{
						if (t.Variant != 0 && this.Const.DLC.Wildmen)
						{
							champions.push(t);
						}
						else
						{
							++entityTypes[t.ID];
						}
					}
				}
			}
		}
		else
		{
			foreach( t in _properties.Entities )
			{
				if (!hasOpponents && (!this.World.FactionManager.isAlliedWithPlayer(t.Faction) || _properties.TemporaryEnemies.find(t.Faction) != null))
				{
					hasOpponents = true;
				}

				if (t.Variant != 0 && this.Const.DLC.Wildmen)
				{
					champions.push(t);
				}
				else
				{
					++entityTypes[t.ID];
				}
			}
		}

		foreach( c in champions )
		{
			entities.push({
				Name = c.Name,
				Icon = this.Const.EntityIcon[c.ID],
				Overlay = "icons/miniboss.png"
			});
		}

		for( local i = 0; i < entityTypes.len(); i = i )
		{
			if (entityTypes[i] > 0)
			{
				if (entityTypes[i] == 1)
				{
					entities.push({
						Name = this.Const.Strings.EntityName[i],
						Icon = this.Const.EntityIcon[i],
						Overlay = null
					});
				}
				else
				{
					local num = this.Const.Strings.EngageEnemyNumbers[this.Math.max(0, this.Math.floor(this.Math.minf(1.0, entityTypes[i] / 14.0) * (this.Const.Strings.EngageEnemyNumbers.len() - 1)))];
					entities.push({
						Name = num + " " + this.Const.Strings.EntityNamePlural[i],
						Icon = this.Const.EntityIcon[i],
						Overlay = null
					});
				}
			}

			i = ++i;
		}

		if (!hasOpponents)
		{
			this.m.EngageCombatPos = null;
			return;
		}

		local text = "";

		if (!listEntities || entities.len() == 0)
		{
			entities = [];
			allyBanners = [];
			enemyBanners = [];

			if (!_isPlayerInitiated)
			{
				text = "Nie udało ci się na czas dowiedzieć, kto cię atakuje.<br/>Musisz się bronić!";
			}
			else
			{
				text = "Nie udało ci się dowiedzieć, z kim będziesz się mierzyć. Atakuj na własne ryzyko i przygotuj się do odwrotu, jeśli zajdzie potrzeba!";
			}
		}

		local tile = this.World.getTile(this.World.worldToTile(_pos));
		local image = this.Const.World.TerrainTacticalImage[tile.TacticalType];

		if (!this.World.getTime().IsDaytime)
		{
			image = image + "_night";
		}

		image = image + ".png";
		this.setAutoPause(true);
		this.Cursor.setCursor(this.Const.UI.Cursor.Hand);
		this.m.EngageCombatPos = _pos;
		this.m.EngageByPlayer = _isPlayerInitiated;
		this.Tooltip.hide();
		this.m.WorldScreen.hide();
		this.m.CombatDialog.show(entities, allyBanners, enemyBanners, _isPlayerInitiated || this.m.EscortedEntity != null, _allowFormationPicking, text, image, this.m.EscortedEntity != null ? "Uciekać!" : "Odwrót!");
		this.m.MenuStack.push(function ()
		{
			this.m.EngageCombatPos = null;
			this.m.CombatDialog.hide();
			this.m.WorldScreen.show();
			this.stunPartiesNearPlayer(_isPlayerInitiated);
			this.setAutoPause(false);
		}, function ()
		{
			return !this.m.CombatDialog.isAnimating();
		}, _isPlayerInitiated);
	};
});

