::mods_hookNewObject("entity/tactical/tactical_entity_manager", function ( o )
{
	o.onResurrect = function ( _info, _force = false )
	{
		if (this.Tactical.State.m.TacticalDialogScreen.isVisible() || this.Tactical.State.m.TacticalDialogScreen.isAnimating())
		{
			this.Time.scheduleEvent(this.TimeUnit.Rounds, 1, this.Tactical.Entities.resurrect, _info);
			return null;
		}

		if (this.Tactical.Entities.isCombatFinished() || !_force && this.Tactical.Entities.isEnemyRetreating())
		{
			return null;
		}

		local targetTile = _info.Tile;

		if (!targetTile.IsEmpty)
		{
			local knockToTile;

			for( local i = 0; i < this.Const.Direction.COUNT; i = i )
			{
				if (!targetTile.hasNextTile(i))
				{
				}
				else
				{
					local newTile = targetTile.getNextTile(i);

					if (!newTile.IsEmpty || newTile.IsCorpseSpawned)
					{
					}
					else if (newTile.Level > targetTile.Level + 1)
					{
					}
					else
					{
						knockToTile = newTile;
						break;
					}
				}

				i = ++i;
			}

			if (knockToTile == null)
			{
				this.Time.scheduleEvent(this.TimeUnit.Rounds, 1, this.Tactical.Entities.resurrect, _info);
				return null;
			}

			this.Tactical.getNavigator().teleport(targetTile.getEntity(), knockToTile, null, null, true);

			if (_info.Tile.IsVisibleForPlayer)
			{
				this.Tactical.CameraDirector.pushMoveToTileEvent(0, _info.Tile, -1, this.onResurrect.bindenv(this), _info, 200, this.Const.Tactical.Settings.CameraNextEventDelay);
				this.Tactical.CameraDirector.addDelay(0.2);
			}
			else if (knockToTile.IsVisibleForPlayer)
			{
				this.Tactical.CameraDirector.pushMoveToTileEvent(0, knockToTile, -1, this.onResurrect.bindenv(this), _info, 200, this.Const.Tactical.Settings.CameraNextEventDelay);
				this.Tactical.CameraDirector.addDelay(0.2);
			}
			else
			{
				this.Tactical.CameraDirector.pushIdleEvent(0, this.onResurrect.bindenv(this), _info, 200, this.Const.Tactical.Settings.CameraNextEventDelay);
				this.Tactical.CameraDirector.addDelay(0.2);
			}

			return null;
		}

		this.Tactical.Entities.removeCorpse(targetTile);
		targetTile.clear(this.Const.Tactical.DetailFlag.Corpse);
		targetTile.Properties.remove("Corpse");
		targetTile.Properties.remove("IsSpawningFlies");
		this.Const.Movement.AnnounceDiscoveredEntities = false;
		local entity = this.Tactical.spawnEntity(_info.Type, targetTile.Coords.X, targetTile.Coords.Y);
		this.Const.Movement.AnnounceDiscoveredEntities = true;
		entity.onResurrected(_info);
		entity.riseFromGround();

		if (!entity.isHiddenToPlayer())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(entity) + " zostaje wskrzeszony z umarłych");
		}

		return entity;
	};
});

