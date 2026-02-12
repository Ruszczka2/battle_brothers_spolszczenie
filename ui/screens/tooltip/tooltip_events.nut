this.tooltip_events <- {
	m = {},
	function create()
	{
	}

	function destroy()
	{
	}

	function onQueryTileTooltipData()
	{
		if (this.Tactical.isActive())
		{
			return this.TooltipEvents.tactical_queryTileTooltipData();
		}
		else
		{
			return this.TooltipEvents.strategic_queryTileTooltipData();
		}
	}

	function onQueryEntityTooltipData( _entityId, _isTileEntity )
	{
		if (this.Tactical.isActive())
		{
			return this.TooltipEvents.tactical_queryEntityTooltipData(_entityId, _isTileEntity);
		}
		else
		{
			return this.TooltipEvents.strategic_queryEntityTooltipData(_entityId, _isTileEntity);
		}
	}

	function onQueryRosterEntityTooltipData( _entityId )
	{
		local entity = this.Tactical.getEntityByID(_entityId);

		if (entity != null)
		{
			return entity.getRosterTooltip();
		}

		return null;
	}

	function onQuerySkillTooltipData( _entityId, _skillId )
	{
		return this.TooltipEvents.general_querySkillTooltipData(_entityId, _skillId);
	}

	function onQueryStatusEffectTooltipData( _entityId, _statusEffectId )
	{
		return this.TooltipEvents.general_queryStatusEffectTooltipData(_entityId, _statusEffectId);
	}

	function onQuerySettlementStatusEffectTooltipData( _statusEffectId )
	{
		return this.TooltipEvents.general_querySettlementStatusEffectTooltipData(_statusEffectId);
	}

	function onQueryUIItemTooltipData( _entityId, _itemId, _itemOwner )
	{
		if (this.Tactical.isActive())
		{
			return this.TooltipEvents.tactical_queryUIItemTooltipData(_entityId, _itemId, _itemOwner);
		}
		else
		{
			return this.TooltipEvents.strategic_queryUIItemTooltipData(_entityId, _itemId, _itemOwner);
		}
	}

	function onQueryUIPerkTooltipData( _entityId, _perkId )
	{
		return this.TooltipEvents.general_queryUIPerkTooltipData(_entityId, _perkId);
	}

	function onQueryUIElementTooltipData( _entityId, _elementId, _elementOwner )
	{
		return this.TooltipEvents.general_queryUIElementTooltipData(_entityId, _elementId, _elementOwner);
	}

	function onQueryFollowerTooltipData( _followerID )
	{
		if (typeof _followerID == "integer")
		{
			local renown = "\'" + this.Const.Strings.BusinessReputation[this.Const.FollowerSlotRequirements[_followerID]] + "\' (" + this.Const.BusinessReputation[this.Const.FollowerSlotRequirements[_followerID]] + ")";
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Zablokowane Miejsce"
				},
				{
					id = 4,
					type = "description",
					text = "Twoja kompania nie ma wystarczająco dużo sławy, aby nająć więcej nie-walczących towarzyszy. Zdobądź co najmniej " + renown + " sławy, aby odblokować to miejsce. Sławę zdobywa się wypełniając ambicje i kontrakty, a także wygrywając bitwy."
				}
			];
			return ret;
		}
		else if (_followerID == "free")
		{
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Wolne Miejsce"
				},
				{
					id = 4,
					type = "description",
					text = "Jest tu miejsce na kolejnego nie-walczącego towarzysza twej kompanii."
				},
				{
					id = 1,
					type = "hint",
					icon = "ui/icons/mouse_left_button.png",
					text = "Otwórz ekran werbunku"
				}
			];
			return ret;
		}
		else
		{
			local p = this.World.Retinue.getFollower(_followerID);
			return p.getTooltip();
		}
	}

	function tactical_queryTileTooltipData()
	{
		local lastTileHovered = this.Tactical.State.getLastTileHovered();

		if (lastTileHovered == null)
		{
			return null;
		}

		if (!lastTileHovered.IsDiscovered)
		{
			return null;
		}

		if (lastTileHovered.IsDiscovered && !lastTileHovered.IsEmpty && (!lastTileHovered.IsOccupiedByActor || lastTileHovered.IsVisibleForPlayer))
		{
			local entity = lastTileHovered.getEntity();
			return this.tactical_helper_getEntityTooltip(entity, this.Tactical.TurnSequenceBar.getActiveEntity(), true);
		}
		else
		{
			local tooltipContent = [
				{
					id = 1,
					type = "title",
					text = this.Const.Strings.Tactical.TerrainName[lastTileHovered.Subtype],
					icon = "ui/tooltips/height_" + lastTileHovered.Level + ".png"
				}
			];
			tooltipContent.push({
				id = 2,
				type = "description",
				text = this.Const.Strings.Tactical.TerrainDescription[lastTileHovered.Subtype]
			});

			if (lastTileHovered.IsCorpseSpawned)
			{
				tooltipContent.push({
					id = 3,
					type = "description",
					text = this.removeFromBeginningOfText("A ", this.removeFromBeginningOfText("An ", lastTileHovered.Properties.get("Corpse").CorpseName)) + " tutaj poległ."
				});
			}

			if (this.Tactical.TurnSequenceBar.getActiveEntity() != null)
			{
				local actor = this.Tactical.TurnSequenceBar.getActiveEntity();

				if (actor.isPlacedOnMap() && actor.isPlayerControlled())
				{
					if (this.Math.abs(lastTileHovered.Level - actor.getTile().Level) == 1)
					{
						tooltipContent.push({
							id = 90,
							type = "text",
							text = "Wymaga [b][color=" + this.Const.UI.Color.PositiveValue + "]" + actor.getActionPointCosts()[lastTileHovered.Type] + "+" + actor.getLevelActionPointCost() + "[/color][/b] PA oraz [b][color=" + this.Const.UI.Color.PositiveValue + "]" + actor.getFatigueCosts()[lastTileHovered.Type] + "+" + actor.getLevelFatigueCost() + "[/color][/b] Zmęczenia, by tu przejść, ponieważ pole znajduje się na innej wysokości"
						});
					}
					else
					{
						tooltipContent.push({
							id = 90,
							type = "text",
							text = "Wymaga [b][color=" + this.Const.UI.Color.PositiveValue + "]" + actor.getActionPointCosts()[lastTileHovered.Type] + "[/color][/b] PA oraz [b][color=" + this.Const.UI.Color.PositiveValue + "]" + actor.getFatigueCosts()[lastTileHovered.Type] + "[/color][/b] Zmęczenia, aby tu przejść"
						});
					}
				}
			}

			foreach( i, line in this.Const.Tactical.TerrainEffectTooltip[lastTileHovered.Type] )
			{
				tooltipContent.push(line);
			}

			if (lastTileHovered.IsHidingEntity)
			{
				tooltipContent.push({
					id = 98,
					type = "text",
					icon = "ui/icons/vision.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]Ukrywa schowaną w nich postać przed dostrzeżeniem z oddali.[/color]"
				});
			}

			local allies;

			if (this.Tactical.State.isScenarioMode())
			{
				allies = this.Const.FactionAlliance[this.Const.Faction.Player];
			}
			else
			{
				allies = this.World.FactionManager.getAlliedFactions(this.Const.Faction.Player);
			}

			if (lastTileHovered.IsVisibleForPlayer && lastTileHovered.hasZoneOfControlOtherThan(allies))
			{
				tooltipContent.push({
					id = 99,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]Znajduje się w Strefie Kontroli przeciwnika.[/color]"
				});
			}

			if (lastTileHovered.IsVisibleForPlayer && (lastTileHovered.SquareCoords.X == 0 || lastTileHovered.SquareCoords.Y == 0 || lastTileHovered.SquareCoords.X == 31 || lastTileHovered.SquareCoords.Y == 31))
			{
				tooltipContent.push({
					id = 99,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]Każda postać na tym polu może się bezpiecznie i natychmiastowo wycofać z bitwy.[/color]"
				});
			}

			if (lastTileHovered.IsVisibleForPlayer && lastTileHovered.Properties.Effect != null)
			{
				tooltipContent.push({
					id = 100,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + lastTileHovered.Properties.Effect.Tooltip + "[/color]"
				});
			}

			if (lastTileHovered.Items != null)
			{
				local result = [];

				foreach( item in lastTileHovered.Items )
				{
					result.push(item.getIcon());
				}

				if (result.len() > 0)
				{
					tooltipContent.push({
						id = 100,
						type = "icons",
						useItemPath = true,
						icons = result
					});
				}
			}

			return tooltipContent;
		}
	}

	function tactical_queryEntityTooltipData( _entityId, _isTileEntity )
	{
		local entity = this.Tactical.getEntityByID(_entityId);

		if (entity != null)
		{
			return this.tactical_helper_getEntityTooltip(entity, this.Tactical.TurnSequenceBar.getActiveEntity(), _isTileEntity);
		}

		return null;
	}

	function tactical_queryUIItemTooltipData( _entityId, _itemId, _itemOwner )
	{
		local entity = this.Tactical.getEntityByID(_entityId);
		local activeEntity = this.Tactical.TurnSequenceBar.getActiveEntity();

		switch(_itemOwner)
		{
		case "entity":
			if (entity != null)
			{
				local item = entity.getItems().getItemByInstanceID(_itemId);

				if (item != null)
				{
					return this.tactical_helper_addHintsToTooltip(activeEntity, entity, item, _itemOwner);
				}
			}

			return null;

		case "ground":
		case "character-screen-inventory-list-module.ground":
			if (entity != null)
			{
				local item = this.tactical_helper_findGroundItem(entity, _itemId);

				if (item != null)
				{
					return this.tactical_helper_addHintsToTooltip(activeEntity, entity, item, _itemOwner);
				}
			}

			return null;

		case "stash":
		case "character-screen-inventory-list-module.stash":
			local result = this.Stash.getItemByInstanceID(_itemId);

			if (result != null)
			{
				return this.tactical_helper_addHintsToTooltip(activeEntity, entity, result.item, _itemOwner);
			}

			return null;

		case "tactical-combat-result-screen.stash":
			local result = this.Stash.getItemByInstanceID(_itemId);

			if (result != null)
			{
				return this.tactical_helper_addHintsToTooltip(activeEntity, entity, result.item, _itemOwner, true);
			}

			return null;

		case "tactical-combat-result-screen.found-loot":
			local result = this.Tactical.CombatResultLoot.getItemByInstanceID(_itemId);

			if (result != null)
			{
				return this.tactical_helper_addHintsToTooltip(activeEntity, entity, result.item, _itemOwner, true);
			}

			return null;
		}

		return null;
	}

	function tactical_helper_findGroundItem( _entity, _itemId )
	{
		local items = _entity.getTile() != null ? _entity.getTile().Items : null;

		if (items != null && items.len() > 0)
		{
			foreach( item in items )
			{
				if (item.getInstanceID() == _itemId)
				{
					return item;
				}
			}
		}

		return null;
	}

	function tactical_helper_getEntityTooltip( _targetedEntity, _activeEntity, _isTileEntity )
	{
		if (this.Tactical.State != null && this.Tactical.State.getCurrentActionState() == this.Const.Tactical.ActionState.SkillSelected)
		{
			if (_activeEntity != null && this.isKindOf(_targetedEntity, "actor") && _activeEntity.isPlayerControlled() && _targetedEntity != null && !_targetedEntity.isPlayerControlled())
			{
				local skill = _activeEntity.getSkills().getSkillByID(this.Tactical.State.getSelectedSkillID());

				if (skill != null)
				{
					return this.tactical_helper_addContentTypeToTooltip(_targetedEntity, _targetedEntity.getTooltip(skill), _isTileEntity);
				}
			}

			return null;
		}

		if (this.isKindOf(_targetedEntity, "entity"))
		{
			return this.tactical_helper_addContentTypeToTooltip(_targetedEntity, _targetedEntity.getTooltip(), _isTileEntity);
		}

		return null;
	}

	function tactical_helper_addContentTypeToTooltip( _entity, _tooltip, _isTileEntity )
	{
		if (_isTileEntity == false && !_entity.isHiddenToPlayer())
		{
			_tooltip.push({
				id = 1,
				type = "hint",
				icon = "ui/icons/mouse_left_button.png",
				text = this.Const.Strings.Tooltip.Tactical.Hint_FocusCharacter
			});
		}

		if (_isTileEntity == true)
		{
			_tooltip.push({
				contentType = "tile-entity",
				entityId = _entity.getID()
			});
		}
		else
		{
			_tooltip.push({
				contentType = "entity",
				entityId = _entity.getID()
			});
		}

		return _tooltip;
	}

	function tactical_helper_addHintsToTooltip( _activeEntity, _entity, _item, _itemOwner, _ignoreStashLocked = false )
	{
		local stashLocked = true;

		if (this.Stash != null)
		{
			stashLocked = this.Stash.isLocked();
		}

		local tooltip = _item.getTooltip();

		if (stashLocked == true && _ignoreStashLocked == false)
		{
			if (_item.isChangeableInBattle() == false)
			{
				tooltip.push({
					id = 1,
					type = "hint",
					icon = "ui/icons/icon_locked.png",
					text = this.Const.Strings.Tooltip.Tactical.Hint_CannotChangeItemInCombat
				});
				return tooltip;
			}

			if (_activeEntity == null || _entity != null && _activeEntity != null && _entity.getID() != _activeEntity.getID())
			{
				tooltip.push({
					id = 1,
					type = "hint",
					icon = "ui/icons/icon_locked.png",
					text = this.Const.Strings.Tooltip.Tactical.Hint_OnlyActiveCharacterCanChangeItemsInCombat
				});
				return tooltip;
			}

			if (_activeEntity != null && _activeEntity.getItems().isActionAffordable([
				_item
			]) == false)
			{
				tooltip.push({
					id = 1,
					type = "hint",
					icon = "ui/tooltips/warning.png",
					text = "Zbyt mało Punktów Akcji, by wymienić przedmioty (wymaga [b][color=" + this.Const.UI.Color.NegativeValue + "]" + _activeEntity.getItems().getActionCost([
						_item
					]) + "[/color][/b])"
				});
				return tooltip;
			}
		}

		switch(_itemOwner)
		{
		case "entity":
			if (_item.getCurrentSlotType() == this.Const.ItemSlot.Bag && _item.getSlotType() != this.Const.ItemSlot.None)
			{
				if (stashLocked == true)
				{
					if (_item.getSlotType() != this.Const.ItemSlot.Bag && (_entity.getItems().getItemAtSlot(_item.getSlotType()) == null || _entity.getItems().getItemAtSlot(_item.getSlotType()) == "-1" || _entity.getItems().getItemAtSlot(_item.getSlotType()).isAllowedInBag()))
					{
						tooltip.push({
							id = 1,
							type = "hint",
							icon = "ui/icons/mouse_right_button.png",
							text = "Weź przedmiot do rąk ([b][color=" + this.Const.UI.Color.PositiveValue + "]" + _activeEntity.getItems().getActionCost([
								_item,
								_entity.getItems().getItemAtSlot(_item.getSlotType()),
								_entity.getItems().getItemAtSlot(_item.getBlockedSlotType())
							]) + "[/color][/b] PA)"
						});
					}

					tooltip.push({
						id = 2,
						type = "hint",
						icon = "ui/icons/mouse_right_button_ctrl.png",
						text = "Upuść przedmiot na ziemię ([b][color=" + this.Const.UI.Color.PositiveValue + "]" + _activeEntity.getItems().getActionCost([
							_item
						]) + "[/color][/b] PA)"
					});
				}
				else
				{
					if (_item.getSlotType() != this.Const.ItemSlot.Bag && (_entity.getItems().getItemAtSlot(_item.getSlotType()) == null || _entity.getItems().getItemAtSlot(_item.getSlotType()) == "-1" || _entity.getItems().getItemAtSlot(_item.getSlotType()).isAllowedInBag()))
					{
						tooltip.push({
							id = 1,
							type = "hint",
							icon = "ui/icons/mouse_right_button.png",
							text = "Weź przedmiot do rąk"
						});
					}

					tooltip.push({
						id = 2,
						type = "hint",
						icon = "ui/icons/mouse_right_button_ctrl.png",
						text = "Umieść przedmiot w ekwipunku"
					});
				}
			}
			else if (stashLocked == true)
			{
				if (_item.isChangeableInBattle() && _item.isAllowedInBag() && _entity.getItems().hasEmptySlot(this.Const.ItemSlot.Bag))
				{
					tooltip.push({
						id = 1,
						type = "hint",
						icon = "ui/icons/mouse_right_button.png",
						text = "Umieść przedmiot w podręcznej sakwie ([b][color=" + this.Const.UI.Color.PositiveValue + "]" + _activeEntity.getItems().getActionCost([
							_item
						]) + "[/color][/b] PA)"
					});
				}

				tooltip.push({
					id = 2,
					type = "hint",
					icon = "ui/icons/mouse_right_button_ctrl.png",
					text = "Upuść przedmiot na ziemię ([b][color=" + this.Const.UI.Color.PositiveValue + "]" + _activeEntity.getItems().getActionCost([
						_item
					]) + "[/color][/b] PA)"
				});
			}
			else
			{
				if (_item.isChangeableInBattle() && _item.isAllowedInBag())
				{
					tooltip.push({
						id = 1,
						type = "hint",
						icon = "ui/icons/mouse_right_button.png",
						text = "Umieść przedmiot w podręcznej sakwie"
					});
				}

				tooltip.push({
					id = 2,
					type = "hint",
					icon = "ui/icons/mouse_right_button_ctrl.png",
					text = "Umieść przedmiot w ekwipunku"
				});
			}

			break;

		case "ground":
		case "character-screen-inventory-list-module.ground":
			if (_item.isChangeableInBattle())
			{
				if (_item.getSlotType() != this.Const.ItemSlot.None)
				{
					tooltip.push({
						id = 1,
						type = "hint",
						icon = "ui/icons/mouse_right_button.png",
						text = "Weź przedmiot do rąk ([b][color=" + this.Const.UI.Color.PositiveValue + "]" + _activeEntity.getItems().getActionCost([
							_item,
							_entity.getItems().getItemAtSlot(_item.getSlotType()),
							_entity.getItems().getItemAtSlot(_item.getBlockedSlotType())
						]) + "[/color][/b] PA)"
					});
				}

				if (_item.isAllowedInBag())
				{
					tooltip.push({
						id = 2,
						type = "hint",
						icon = "ui/icons/mouse_right_button_ctrl.png",
						text = "Umieść przedmiot w podręcznej sakwie ([b][color=" + this.Const.UI.Color.PositiveValue + "]" + _activeEntity.getItems().getActionCost([
							_item
						]) + "[/color][/b] PA)"
					});
				}
			}

			break;

		case "stash":
		case "character-screen-inventory-list-module.stash":
			if (_item.isUsable())
			{
				tooltip.push({
					id = 1,
					type = "hint",
					icon = "ui/icons/mouse_right_button.png",
					text = "Użyj przedmiotu"
				});
			}
			else if (_item.getSlotType() != this.Const.ItemSlot.None && _item.getSlotType() != this.Const.ItemSlot.Bag)
			{
				tooltip.push({
					id = 1,
					type = "hint",
					icon = "ui/icons/mouse_right_button.png",
					text = "Weź przedmiot do rąk"
				});
			}

			if (_item.isChangeableInBattle() == true && _item.isAllowedInBag())
			{
				tooltip.push({
					id = 2,
					type = "hint",
					icon = "ui/icons/mouse_right_button_ctrl.png",
					text = "Umieść przedmiot w podręcznej sakwie"
				});
			}

			if (_item.getCondition() < _item.getConditionMax())
			{
				tooltip.push({
					id = 3,
					type = "hint",
					icon = "ui/icons/mouse_right_button_alt.png",
					text = _item.isToBeRepaired() ? "Ustaw, aby przedmiot nie był naprawiany" : "Ustaw, by przedmiot był naprawiany"
				});
			}

			break;

		case "tactical-combat-result-screen.stash":
			tooltip.push({
				id = 1,
				type = "hint",
				icon = "ui/icons/mouse_right_button.png",
				text = "Upuść przedmiot na ziemię"
			});
			break;

		case "tactical-combat-result-screen.found-loot":
			if (this.Stash.hasEmptySlot())
			{
				tooltip.push({
					id = 1,
					type = "hint",
					icon = "ui/icons/mouse_right_button.png",
					text = "Umieść przedmiot w ekwipunku"
				});
			}
			else
			{
				tooltip.push({
					id = 1,
					type = "hint",
					icon = "ui/tooltips/warning.png",
					text = "Ekwipunek jest pełen"
				});
			}

			break;

		case "world-town-screen-shop-dialog-module.stash":
			tooltip.push({
				id = 1,
				type = "hint",
				icon = "ui/icons/mouse_right_button.png",
				text = "Sprzedaj przedmiot za [img]gfx/ui/tooltips/money.png[/img]" + _item.getSellPrice()
			});

			if (this.World.State.getCurrentTown() != null && this.World.State.getCurrentTown().getCurrentBuilding() != null && this.World.State.getCurrentTown().getCurrentBuilding().isRepairOffered() && _item.getConditionMax() > 1 && _item.getCondition() < _item.getConditionMax())
			{
				local price = (_item.getConditionMax() - _item.getCondition()) * this.Const.World.Assets.CostToRepairPerPoint;
				local value = _item.m.Value * (1.0 - _item.getCondition() / _item.getConditionMax()) * 0.2 * this.World.State.getCurrentTown().getPriceMult() * this.Const.Difficulty.SellPriceMult[this.World.Assets.getEconomicDifficulty()];
				price = this.Math.max(price, value);

				if (this.World.Assets.getMoney() >= price)
				{
					tooltip.push({
						id = 3,
						type = "hint",
						icon = "ui/icons/mouse_right_button_alt.png",
						text = "Zapłać [img]gfx/ui/tooltips/money.png[/img]" + price + ", aby naprawiono przedmiot"
					});
				}
				else
				{
					tooltip.push({
						id = 3,
						type = "hint",
						icon = "ui/tooltips/warning.png",
						text = "Zbyt mało koron, by zapłacić za naprawy!"
					});
				}
			}

			break;

		case "world-town-screen-shop-dialog-module.shop":
			if (this.Stash.hasEmptySlot())
			{
				tooltip.push({
					id = 1,
					type = "hint",
					icon = "ui/icons/mouse_right_button.png",
					text = "Kup przedmiot za [img]gfx/ui/tooltips/money.png[/img]" + _item.getBuyPrice()
				});
			}
			else
			{
				tooltip.push({
					id = 1,
					type = "hint",
					icon = "ui/tooltips/warning.png",
					text = "Ekwipunek jest pełen"
				});
			}

			break;
		}

		return tooltip;
	}

	function strategic_queryTileTooltipData()
	{
		local lastTileHovered = this.World.State.getLastTileHovered();

		if (lastTileHovered != null)
		{
			if (this.World.Assets.m.IsShowingExtendedFootprints)
			{
				local footprints = this.World.getAllFootprintsAtPos(this.World.getCamera().screenToWorld(this.Cursor.getX(), this.Cursor.getY()), this.Const.World.FootprintsType.COUNT);
				local ret = [
					{
						id = 1,
						type = "title",
						text = "Meldunek Zwiadowcy"
					}
				];

				for( local i = 1; i < footprints.len(); i = i )
				{
					if (footprints[i])
					{
						ret.push({
							id = 1,
							type = "hint",
							text = this.Const.Strings.FootprintsType[i] + " ostatnio tędy przechodzili"
						});
					}

					i = ++i;
				}

				if (ret.len() > 1)
				{
					return ret;
				}
			}
		}

		return null;
	}

	function strategic_queryEntityTooltipData( _entityId, _isTileEntity )
	{
		if (_isTileEntity)
		{
			local lastEntityHovered = this.World.State.getLastEntityHovered();
			local entity = this.World.getEntityByID(_entityId);

			if (lastEntityHovered != null && entity != null && lastEntityHovered.getID() == entity.getID())
			{
				return this.strategic_helper_addContentTypeToTooltip(entity, entity.getTooltip());
			}
		}
		else
		{
			local entity = this.Tactical.getEntityByID(_entityId);

			if (entity != null)
			{
				return this.strategic_helper_addContentTypeToTooltip(entity, entity.getRosterTooltip());
			}
		}

		return null;
	}

	function strategic_queryUIItemTooltipData( _entityId, _itemId, _itemOwner )
	{
		local entity = _entityId != null ? this.Tactical.getEntityByID(_entityId) : null;

		switch(_itemOwner)
		{
		case "entity":
			if (entity != null)
			{
				local item = entity.getItems().getItemByInstanceID(_itemId);

				if (item != null)
				{
					return this.tactical_helper_addHintsToTooltip(null, entity, item, _itemOwner);
				}
			}

			return null;

		case "ground":
		case "character-screen-inventory-list-module.ground":
			if (entity != null)
			{
				local item = this.tactical_helper_findGroundItem(entity, _itemId);

				if (item != null)
				{
					return this.tactical_helper_addHintsToTooltip(null, entity, item, _itemOwner);
				}
			}

			return null;

		case "stash":
		case "character-screen-inventory-list-module.stash":
			local result = this.Stash.getItemByInstanceID(_itemId);

			if (result != null)
			{
				return this.tactical_helper_addHintsToTooltip(null, entity, result.item, _itemOwner);
			}

			return null;

		case "craft":
			return this.World.Crafting.getBlueprint(_itemId).getTooltip();

		case "blueprint":
			return this.World.Crafting.getBlueprint(_entityId).getTooltipForComponent(_itemId);

		case "world-town-screen-shop-dialog-module.stash":
			local result = this.Stash.getItemByInstanceID(_itemId);

			if (result != null)
			{
				return this.tactical_helper_addHintsToTooltip(null, entity, result.item, _itemOwner, true);
			}

			return null;

		case "world-town-screen-shop-dialog-module.shop":
			local stash = this.World.State.getTownScreen().getShopDialogModule().getShop().getStash();

			if (stash != null)
			{
				local result = stash.getItemByInstanceID(_itemId);

				if (result != null)
				{
					return this.tactical_helper_addHintsToTooltip(null, entity, result.item, _itemOwner, true);
				}
			}

			return null;
		}

		return null;
	}

	function strategic_helper_addContentTypeToTooltip( _entity, _tooltip )
	{
		_tooltip.push({
			contentType = "tile-entity",
			entityId = _entity.getID()
		});
		return _tooltip;
	}

	function general_querySkillTooltipData( _entityId, _skillId )
	{
		local entity = this.Tactical.getEntityByID(_entityId);

		if (entity != null)
		{
			local skill = entity.getSkills().getSkillByID(_skillId);

			if (skill != null)
			{
				return skill.getTooltip();
			}
		}

		return null;
	}

	function general_queryStatusEffectTooltipData( _entityId, _statusEffectId )
	{
		local entity = this.Tactical.getEntityByID(_entityId);

		if (entity != null)
		{
			local statusEffect = entity.getSkills().getSkillByID(_statusEffectId);

			if (statusEffect != null)
			{
				local ret = statusEffect.getTooltip();

				if (statusEffect.isType(this.Const.SkillType.Background) && ("State" in this.World) && this.World.State != null)
				{
					this.World.Assets.getOrigin().onGetBackgroundTooltip(statusEffect, ret);
				}

				return ret;
			}
		}

		return null;
	}

	function general_querySettlementStatusEffectTooltipData( _statusEffectId )
	{
		local currentTown = this.World.State.getCurrentTown();

		if (currentTown != null)
		{
			local statusEffect = currentTown.getSituationByID(_statusEffectId);

			if (statusEffect != null)
			{
				return statusEffect.getTooltip();
			}
		}

		return null;
	}

	function general_queryUIPerkTooltipData( _entityId, _perkId )
	{
		local perk = this.Const.Perks.findById(_perkId);

		if (perk != null)
		{
			local ret = [
				{
					id = 1,
					type = "title",
					text = perk.Name
				},
				{
					id = 2,
					type = "description",
					text = perk.Tooltip
				}
			];
			local player = this.Tactical.getEntityByID(_entityId);

			if (!player.hasPerk(_perkId))
			{
				if (player.getPerkPointsSpent() >= perk.Unlocks)
				{
					if (player.getPerkPoints() == 0)
					{
						ret.push({
							id = 3,
							type = "hint",
							icon = "ui/icons/icon_locked.png",
							text = "Dostępny, jednak ta postać nie ma wolnych punktów talentów"
						});
					}
				}
				else if (perk.Unlocks - player.getPerkPointsSpent() > 1)
				{
					ret.push({
						id = 3,
						type = "hint",
						icon = "ui/icons/icon_locked.png",
						text = "Zablokowany, trzeba wydać jeszcze " + (perk.Unlocks - player.getPerkPointsSpent()) + " punkt. talentów"
					});
				}
				else
				{
					ret.push({
						id = 3,
						type = "hint",
						icon = "ui/icons/icon_locked.png",
						text = "Zablokowany, trzeba wydać jeszcze " + (perk.Unlocks - player.getPerkPointsSpent()) + " punkt talentów"
					});
				}
			}

			return ret;
		}

		return null;
	}

	function general_queryUIElementTooltipData( _entityId, _elementId, _elementOwner )
	{
		local entity;

		if (_entityId != null)
		{
			entity = this.Tactical.getEntityByID(_entityId);
		}

		switch(_elementId)
		{
		case "CharacterName":
			local ret = [
				{
					id = 1,
					type = "title",
					text = entity.getName()
				}
			];
			return ret;

		case "CharacterNameAndTitles":
			local ret = [
				{
					id = 1,
					type = "title",
					text = entity.getName()
				}
			];

			if ("getProperties" in entity)
			{
				foreach( p in entity.getProperties() )
				{
					local s = this.World.getEntityByID(p);
					ret.push({
						id = 2,
						type = "text",
						text = "Lord " + s.getName()
					});
				}
			}

			if ("getTitles" in entity)
			{
				foreach( s in entity.getTitles() )
				{
					ret.push({
						id = 3,
						type = "text",
						text = s
					});
				}
			}

			return ret;

		case "assets.Money":
			local money = this.World.Assets.getMoney();
			local dailyMoney = this.World.Assets.getDailyMoneyCost();
			local time = this.Math.floor(money / this.Math.max(1, dailyMoney));

			if (dailyMoney == 0)
			{
				return [
					{
						id = 1,
						type = "title",
						text = "Korony"
					},
					{
						id = 2,
						type = "description",
						text = "Ilość monet, jaką posiada twoja kompania najemników. Wykorzystywane dziennie, w samo południe, do wypłacania żołdu twoim ludziom, a także do werbowania nowych rekrutów i kupna wyposażenia.\n\nObecnie nikomu nie płacisz."
					}
				];
			}
			else if (time >= 1.0 && money > 0)
			{
				return [
					{
						id = 1,
						type = "title",
						text = "Korony"
					},
					{
						id = 2,
						type = "description",
						text = "Ilość monet, jaką posiada twoja kompania najemników. Wykorzystywane dziennie, w samo południe, do wypłacania żołdu twoim ludziom, a także do werbowania nowych rekrutów i kupna wyposażenia.\n\nWypłacasz [color=" + this.Const.UI.Color.PositiveValue + "]" + dailyMoney + "[/color] koron na dzień. Twoje [color=" + this.Const.UI.Color.PositiveValue + "]" + money + "[/color] korony wystarczą ci jeszcze na [color=" + this.Const.UI.Color.PositiveValue + "]" + time + "[/color] dni."
					}
				];
			}
			else
			{
				return [
					{
						id = 1,
						type = "title",
						text = "Korony"
					},
					{
						id = 2,
						type = "description",
						text = "Ilość monet, jaką posiada twoja kompania najemników. Wykorzystywane dziennie, w samo południe, do wypłacania żołdu twoim ludziom, a także do werbowania nowych rekrutów i kupna wyposażenia.\n\nWypłacasz [color=" + this.Const.UI.Color.PositiveValue + "]" + dailyMoney + "[/color]  koron na dzień.\n\n[color=" + this.Const.UI.Color.NegativeValue + "]Nie masz już koron, by móc zapłacić swym ludziom! Zarób nieco jak najszybciej lub zwolnij niektórych ludzi, inaczej po kolei zaczną dezerterować.[/color]"
					}
				];
			}

		case "assets.InitialMoney":
			return [
				{
					id = 1,
					type = "title",
					text = "Najemne"
				},
				{
					id = 2,
					type = "description",
					text = "Najemne zostanie wypłacone niezwłocznie podczas werbowania osoby, w ramach przypieczętowania umowy i dowiedzenia, że swe słowo jesteś w stanie poprzeć monetami."
				}
			];

		case "assets.Fee":
			return [
				{
					id = 1,
					type = "title",
					text = "Koszty z góry"
				},
				{
					id = 2,
					type = "description",
					text = "Tę opłatę trzeba uiścić z góry, aby usługa została wykonana."
				}
			];

		case "assets.TryoutMoney":
			return [
				{
					id = 1,
					type = "title",
					text = "Koszt Wypróbowania"
				},
				{
					id = 2,
					type = "description",
					text = "Ta opłata zostanie uiszczona niezwłocznie podczas dokładniejszej inspekcji rekruta, by poznać jego cechy charakteru... o ile jakieś ma."
				}
			];

		case "assets.DailyMoney":
			return [
				{
					id = 1,
					type = "title",
					text = "Dzienny Żołd"
				},
				{
					id = 2,
					type = "description",
					text = "Dzienny żołd będzie wypłacany każdego dnia w południe, jako zapłata za służbę pod twymi rozkazami. Żołd wzrasta automatycznie o 10% na poziom doświadczenia aż do osiągnięcia poziomu 11, a następnie o 3% na poziom."
				}
			];

		case "assets.Food":
			local food = this.World.Assets.getFood();
			local dailyFood = this.Math.ceil(this.World.Assets.getDailyFoodCost() * this.Const.World.TerrainFoodConsumption[this.World.State.getPlayer().getTile().Type]);
			local time = this.Math.floor(food / dailyFood);

			if (food > 0 && time > 1)
			{
				return [
					{
						id = 1,
						type = "title",
						text = "Prowiant"
					},
					{
						id = 2,
						type = "description",
						text = "Całkowita ilość prowiantu twojej kompanii. Przeciętny człowiek spożywa 2 sztuki prowiantu dziennie, nieco więcej w trudnym terenie. Twoi ludzie najpierw zjedzą żywność o krótszym terminie przydatności do spożycia. Jeśli prowiant ci się skończy, morale twoich ludzi zostanie obniżone i ostatecznie może to doprowadzić do masowych dezercji w obawie przed śmiercią głodową.\n\nZużywasz [color=" + this.Const.UI.Color.PositiveValue + "]" + dailyFood + "[/color] prowiantu na dzień. Twoje [color=" + this.Const.UI.Color.PositiveValue + "]" + food + "[/color] zapasy żywności wystarczą co najwyżej na [color=" + this.Const.UI.Color.PositiveValue + "]" + time + "[/color] dni. Pamiętaj, że poszczególna żywność ma swój termin przydatności i może się zepsuć!"
					}
				];
			}
			else if (food > 0 && time == 1)
			{
				return [
					{
						id = 1,
						type = "title",
						text = "Prowiant"
					},
					{
						id = 2,
						type = "description",
						text = "Całkowita ilość prowiantu twojej kompanii. Przeciętny człowiek spożywa 2 sztuki prowiantu dziennie, nieco więcej w trudnym terenie. Twoi ludzie najpierw zjedzą żywność o krótszym terminie przydatności do spożycia. Jeśli prowiant ci się skończy, morale twoich ludzi zostanie obniżone i ostatecznie może to doprowadzić do masowych dezercji w obawie przed śmiercią głodową.\n\nZużywasz [color=" + this.Const.UI.Color.PositiveValue + "]" + dailyFood + "[/color] prowiantu na dzień.\n\n[color=" + this.Const.UI.Color.NegativeValue + "]Twoje zapasy żywności niemal się skończyły i nie będziesz mieć czym wykarmić ludzi! Kup dodatkowy prowiant najszybciej, jak to możliwe, inaczej twoi ludzie jeden po drugim zdezerterują w obawie przed śmiercią głodową![/color]"
					}
				];
			}
			else
			{
				return [
					{
						id = 1,
						type = "title",
						text = "Prowiant"
					},
					{
						id = 2,
						type = "description",
						text = "Całkowita ilość prowiantu twojej kompanii. Przeciętny człowiek spożywa 2 sztuki prowiantu dziennie, nieco więcej w trudnym terenie. Twoi ludzie najpierw zjedzą żywność o krótszym terminie przydatności do spożycia. Jeśli prowiant ci się skończy, morale twoich ludzi zostanie obniżone i ostatecznie może to doprowadzić do masowych dezercji w obawie przed śmiercią głodową.\n\nZużywasz [color=" + this.Const.UI.Color.PositiveValue + "]" + dailyFood + "[/color] prowiantu na dzień.\n\n[color=" + this.Const.UI.Color.NegativeValue + "]Twoje zapasy żywności się wyczerpały i nie masz już czym wykarmić ludzi! Kup dodatkowy prowiant najszybciej, jak to możliwe, inaczej twoi ludzie jeden po drugim zdezerterują w obawie przed śmiercią głodową![/color]"
					}
				];
			}

		case "assets.DailyFood":
			return [
				{
					id = 1,
					type = "title",
					text = "Dzienny prowiant"
				},
				{
					id = 2,
					type = "description",
					text = "Ilość zapasów żywności do wyżywienia jednej postaci na dzień. Brak żywności skutkuje obniżeniem morale ludzi i ostatecznie może doprowadzić do masowych dezercji w obawie przed śmiercią głodową."
				}
			];

		case "assets.Ammo":
			return [
				{
					id = 1,
					type = "title",
					text = "Amunicja"
				},
				{
					id = 2,
					type = "description",
					text = "Wszelakie pociski, jak strzały, bełty i broń miotana, używane by automatycznie uzupełnić kołczany po bitwie. Uzupełnienie jednej strzały lub bełtu będzie kosztować jeden punk, uzupełnienie jednego strzału z Rusznicy kosztuje dwa punkty, a uzupełnienie jednej broni miotanej lub ładunku Lancy Ognistej kosztuje trzy. Brak amunicji w zapasie będzie oznaczał puste kołczany i niemożność używania broni dystansowej. Możesz nieść co najwyżej " + (this.Const.Difficulty.MaxResources[this.World.Assets.getEconomicDifficulty()].Ammo + this.World.Assets.m.AmmoMaxAdditional) + " jednostek."
				}
			];

		case "assets.Supplies":
			local repair = this.World.Assets.getRepairRequired();
			local desc = "Różnorakie narzędzia i zapasy konieczne, by utrzymać broń, zbroję, hełmy i tarcze w dobrej kondycji. Jedne punkt jest wymagany, aby naprawić 15 punktów wytrzymałości przedmiotu. Brak narzędzi może zaskutkować tym, że oręż ulegnie zniszczeniu w trakcie bitwy, a nienaprawione pancerze staną się bezużyteczne.";

			if (repair.ArmorParts > 0)
			{
				desc = desc + ("\n\nNaprawa twojego wyposażenia zajmie [color=" + this.Const.UI.Color.PositiveValue + "]" + repair.Hours + "[/color] godzin i wymaga ");

				if (repair.ArmorParts <= this.World.Assets.getArmorParts())
				{
					desc = desc + ("[color=" + this.Const.UI.Color.PositiveValue + "]");
				}
				else
				{
					desc = desc + ("[color=" + this.Const.UI.Color.NegativeValue + "]");
				}

				desc = desc + (repair.ArmorParts + "[/color] narzędzi i zapasów.");
			}

			desc = desc + ("  Możesz nieść co najwyżej " + (this.Const.Difficulty.MaxResources[this.World.Assets.getEconomicDifficulty()].ArmorParts + this.World.Assets.m.ArmorPartsMaxAdditional) + " jednostek.");
			return [
				{
					id = 1,
					type = "title",
					text = "Narzędzia i Zapasy"
				},
				{
					id = 2,
					type = "description",
					text = desc
				}
			];

		case "assets.Medicine":
			local heal = this.World.Assets.getHealingRequired();
			local desc = "Medykamenty składają się z bandaży, ziół, maści, naparów i tym podobnych. Używa się ich do leczenia poważniejszych ran, odniesionych przez twoich ludzi w bitwie. Jeden punkt medykamentów jest wymagany dziennie na każdą odniesioną ranę, aby tę ranę złagodzić i ostatecznie całkowicie uleczyć. Utracone punkty zdrowia same się regenerują.\n\nBrak medykamentów będzie oznaczał, że twoi ludzie nie będą w stanie w pełni wrócić do zdrowia i wylizać się z poważnych ran.";

			if (heal.MedicineMin > 0)
			{
				desc = desc + ("\n\nUleczenie wszystkich twoich ludzi zajmie pomiędzy [color=" + this.Const.UI.Color.PositiveValue + "]" + heal.DaysMin + "[/color] a [color=" + this.Const.UI.Color.PositiveValue + "]" + heal.DaysMax + "[/color] dni i wymaga pomiędzy ");

				if (heal.MedicineMin <= this.World.Assets.getMedicine())
				{
					desc = desc + ("[color=" + this.Const.UI.Color.PositiveValue + "]");
				}
				else
				{
					desc = desc + ("[color=" + this.Const.UI.Color.NegativeValue + "]");
				}

				desc = desc + (heal.MedicineMin + "[/color] a ");

				if (heal.MedicineMax <= this.World.Assets.getMedicine())
				{
					desc = desc + ("[color=" + this.Const.UI.Color.PositiveValue + "]");
				}
				else
				{
					desc = desc + ("[color=" + this.Const.UI.Color.NegativeValue + "]");
				}

				desc = desc + (heal.MedicineMax + "[/color] medykamentów.");
			}

			desc = desc + ("  Możesz nieść co najwyżej " + (this.Const.Difficulty.MaxResources[this.World.Assets.getEconomicDifficulty()].Medicine + this.World.Assets.m.MedicineMaxAdditional) + " jednostek.");
			return [
				{
					id = 1,
					type = "title",
					text = "Medykamenty"
				},
				{
					id = 2,
					type = "description",
					text = desc
				}
			];

		case "assets.Brothers":
			return [
				{
					id = 1,
					type = "title",
					text = "Drużyna (I, C)"
				},
				{
					id = 2,
					type = "description",
					text = "Pokazuje drużynę bojową twoje kompanii najemników."
				}
			];

		case "assets.BusinessReputation":
			return [
				{
					id = 1,
					type = "title",
					text = "Sława: " + this.World.Assets.getBusinessReputationAsText() + " (" + this.World.Assets.getBusinessReputation() + ")"
				},
				{
					id = 2,
					type = "description",
					text = "Twoja sława to twoje poważanie jako profesjonalnej kompanii najemników i odzwierciedla ona to, jak bardzo w oczach innych ludzi jesteście godni zaufania i kompetentni. Im wyższa sława, tym lepiej płatne i trudniejsze kontrakty ludzie będą wam powierzać. Sława zwiększa się wraz z wypełnianiem ambicji i kontraktów oraz wygrywaniem bitew, a zmniejsza się po porażkach."
				}
			];

		case "assets.MoralReputation":
			return [
				{
					id = 1,
					type = "title",
					text = "Reputacja: " + this.World.Assets.getMoralReputationAsText()
				},
				{
					id = 2,
					type = "description",
					text = "Twoja reputacja odzwierciedla to, w jaki sposób ludność świata ocenia zachowanie twojej kompanii najemnej w świetle jej postępków. Czy okazuje litość swym wrogom? Czy palisz gospodarstwa rolne i masakrujesz bezbronne chłopstwo? Na podstawie twojej reputacji ludzie mogą oferować ci inne typy kontraktów, a same kontrakty i wydarzenia mogą się inaczej się potoczyć."
				}
			];

		case "assets.Ambition":
			if (this.World.Ambitions.hasActiveAmbition())
			{
				local ret = this.World.Ambitions.getActiveAmbition().getButtonTooltip();

				if (this.World.Ambitions.getActiveAmbition().isCancelable())
				{
					ret.push({
						id = 10,
						type = "hint",
						icon = "ui/icons/mouse_right_button.png",
						text = "Anuluj Ambicję"
					});
				}

				return ret;
			}
			else
			{
				return [
					{
						id = 1,
						type = "title",
						text = "Ambicja"
					},
					{
						id = 2,
						type = "description",
						text = "Twoja kompania nie ma wyznaczonej ambicji, za którą mogłaby podążać. Wraz z rozwojem gry będziesz mieć możliwość wybrania nowej ambicji."
					}
				];
			}

		case "stash.FreeSlots":
			return [
				{
					id = 1,
					type = "title",
					text = "Udźwig"
				},
				{
					id = 2,
					type = "description",
					text = "Pokazuje obecną i maksymalną pojemność ekwipunku twojej kompanii."
				}
			];

		case "stash.ActiveRoster":
			return [
				{
					id = 1,
					type = "title",
					text = "Ludzie w formacji"
				},
				{
					id = 2,
					type = "description",
					text = "Pokazuje obecną i maksymalną liczebność ludzi ustawionych w formacji, by walczyć w następnej bitwie.\n\nPrzeciągnij i upuść swych ludzi na wybrane przez siebie pozycje; górny szereg to ten zwrócony do wroga, drugi szereg jest twym tylnym szeregiem, a najniższy szereg to twoje rezerwy, czyli postacie nie biorące udziału w bitwie."
				}
			];

		case "ground.Slots":
			return [
				{
					id = 1,
					type = "title",
					text = "Ziemia"
				},
				{
					id = 2,
					type = "description",
					text = "Pokazuje przedmioty obecnie leżące na ziemi."
				}
			];

		case "character-stats.ActionPoints":
			return [
				{
					id = 1,
					type = "title",
					text = "Punkty Akcji"
				},
				{
					id = 2,
					type = "description",
					text = "Punkty Akcji (PA) wydawane są na każdą czynność, jak ruch czy używanie umiejętności. Kiedy wszystkie punkty zostaną wydane, automatycznie zakończy się tura obecnej postaci. PA w pełni regenerują się w nowej turze."
				}
			];

		case "character-stats.Hitpoints":
			return [
				{
					id = 1,
					type = "title",
					text = "Zdrowie"
				},
				{
					id = 2,
					type = "description",
					text = "Zdrowie reprezentuje ilość obrażeń, jakie może przyjąć na siebie postać, zanim polegnie. Gdy ta wartość spadnie do zera, postać zostaje uznana za martwą. Im wyższe maksymalne zdrowie, tym mniejsze szanse na to, że postać odniesie osłabiające rany, gdy zostanie trafiona."
				}
			];

		case "character-stats.Morale":
			return [
				{
					id = 1,
					type = "title",
					text = "Morale"
				},
				{
					id = 2,
					type = "description",
					text = "Morale może przyjąć jeden z pięciu stanów i reprezentuje kondycję umysłową wojowników oraz ich efektywność w bitwie. W najniższym stanie, ucieczki, postać będzie poza twoją kontrolą - choć może znów się w sobie zebrać. Morale zmienia się wraz z rozwojem bitwy, a postacie o wyższej stanowczości są mniej podatne na niskie stany morale. Wielu z przeciwników również jest podatnych na zmiany morale.\n\nPróby morale wyzwalają się w następujących sytuacjach:\n- Zabicie wroga\n- Zobaczenie, jak wróg ginie\n- Zobaczenie, jak sojusznik ucieka\n- Otrzymanie 15 lub więcej punktów obrażeń do zdrowia\n- Zostanie zaatakowanym przez więcej niż jednego przeciwnika\n- Używanie specjalnych zdolności, które wpływają na morale"
				}
			];

		case "character-stats.Fatigue":
			return [
				{
					id = 1,
					type = "title",
					text = "Zmęczenie"
				},
				{
					id = 2,
					type = "description",
					text = "Zmęczenie akumuluje się wraz z wykonywaniem czynności, takich jak ruch, korzystanie z umiejętności postaci, otrzymywanie obrażeń czy unikanie ciosów w walce wręcz. Zmęczenie co każdą turę zostaje obniżone o stałe 15 punktów lub o tyle, by każda postać rozpoczęła swą turę z wartością o 15 punktów mniejszą, niż swoje maksymalne zmęczenie. Jeżeli postać za bardzo się zmęczy, być może będzie zmuszona odpocząć przez turę (np. nie robiąc nic), aby w kolejnej turze móc użyć bardziej wyspecjalizowanych umiejętności."
				}
			];

		case "character-stats.MaximumFatigue":
			return [
				{
					id = 1,
					type = "title",
					text = "Maksymalne Zmęczenie"
				},
				{
					id = 2,
					type = "description",
					text = "Maksymalne Zmęczenie to wartość zmęczenia, jaką postać może osiągnąć zanim stanie się niezdolna do wykonania jakiejkolwiek czynności i będzie zmuszona odpocząć. Wartość ta jest obniżona, gdy postać dźwiga ciężkie wyposażenie, zwłaszcza zbroję."
				}
			];

		case "character-stats.ArmorHead":
			return [
				{
					id = 1,
					type = "title",
					text = "Pancerz Głowy"
				},
				{
					id = 2,
					type = "description",
					text = "Opancerzenie głowy chroni, co zaskakujące, głowę, którą co prawda trudniej jest trafić niż tułów, ale jest za to bardziej wrażliwa na obrażenia. Im lepsze opancerzenie głowy, tym mniej obrażeń zadanych zostanie zdrowiu postaci po otrzymaniu ciosu w głowę."
				}
			];

		case "character-stats.ArmorBody":
			return [
				{
					id = 1,
					type = "title",
					text = "Pancerz Ciała"
				},
				{
					id = 2,
					type = "description",
					text = "Im lepsze opancerzenie ciała, tym mniej obrażeń zadanych zostanie zdrowiu postaci po otrzymaniu ciosu w tułów."
				}
			];

		case "character-stats.MeleeSkill":
			return [
				{
					id = 1,
					type = "title",
					text = "Atak w Zwarciu"
				},
				{
					id = 2,
					type = "description",
					text = "Określa podstawową szansę na trafienie celu bronią do walki wręcz, jak np. miecze czy włócznie. Atrybut można zwiększyć awansując na kolejne poziomy doświadczenia."
				}
			];

		case "character-stats.RangeSkill":
			return [
				{
					id = 1,
					type = "title",
					text = "Atak Dystansowy"
				},
				{
					id = 2,
					type = "description",
					text = "Określa podstawową szansę na trafienie celu z broni dystansowej, jak np. łuki czy kusze. Atrybut można zwiększyć awansując na kolejne poziomy doświadczenia."
				}
			];

		case "character-stats.MeleeDefense":
			return [
				{
					id = 1,
					type = "title",
					text = "Obrona w Zwarciu"
				},
				{
					id = 2,
					type = "description",
					text = "Im wyższa obrona w zwarciu, tym mniejsze szanse na zostanie trafionym w walce wręcz, np. mieczem lub włócznią. Atrybut można zwiększyć awansując na kolejne poziomy doświadczenia lub dzierżąc solidną tarczę."
				}
			];

		case "character-stats.RangeDefense":
			return [
				{
					id = 1,
					type = "title",
					text = "Obrona Dystansowa"
				},
				{
					id = 2,
					type = "description",
					text = "Im wyższa obrona dystansowa, tym mniejsze szanse na zostanie trafionym z broni dystansowej, jak np. łuku czy kuszy. Atrybut można zwiększyć awansując na kolejne poziomy doświadczenia lub dzierżąc solidną tarczę."
				}
			];

		case "character-stats.SightDistance":
			return [
				{
					id = 1,
					type = "title",
					text = "Wzrok"
				},
				{
					id = 2,
					type = "description",
					text = "Wzrok, lub inaczej zasięg widzenia, określa na jaką odległość widzi postać, odkrywając \'mgłę wojny\' i zagrożenia, oraz na jak daleko jest w stanie razić wrogów z broni dystansowej. Cięższe hełmy oraz noc pogarszają ten współczynnik."
				}
			];

		case "character-stats.RegularDamage":
			return [
				{
					id = 1,
					type = "title",
					text = "Obrażenia"
				},
				{
					id = 2,
					type = "description",
					text = "Podstawowe obrażenia, jakie zadaje obecnie dzierżona broń. Zostaną w pełni zadane zdrowiu, jeśli cel nie ma żadnego opancerzenia. Jeżeli cel posiada pancerz, obrażenia zostają zadane wpierw pancerzowi, w zależności od skuteczności broni względem pancerza. Ostateczna ilość obrażeń zależy od użytej umiejętności i trafionego celu."
				}
			];

		case "character-stats.CrushingDamage":
			return [
				{
					id = 1,
					type = "title",
					text = "Skuteczność Przeciwko Pancerzowi"
				},
				{
					id = 2,
					type = "description",
					text = "Podstawowa procentowa wartość obrażeń, jakie zostaną zadane po trafieniu w cel chroniony przez pancerz. Gdy pancerz zostanie zniszczony, obrażenia broni zostają w 100% zadane zdrowiu. Ostateczna ilość obrażeń zależy od użytej umiejętności i trafionego celu."
				}
			];

		case "character-stats.ChanceToHitHead":
			return [
				{
					id = 1,
					type = "title",
					text = "Szansa na trafienie w głowę"
				},
				{
					id = 2,
					type = "description",
					text = "Podstawowa procentowa szansa na trafienie przeciwnika w głowę i zadanie tym samym wyższych obrażeń. Ostateczna szansa może się zmienić w zależności od użytej umiejętności."
				}
			];

		case "character-stats.Initiative":
			return [
				{
					id = 1,
					type = "title",
					text = "Inicjatywa"
				},
				{
					id = 2,
					type = "description",
					text = "Im wyższa jest ta wartość, tym wcześniejsza pozycja postaci w kolejce ruchu danej rundy. Inicjatywa zostaje pomniejszona o obecne zmęczenie, jak i o karę do maksymalnego zmęczenia (np. od ciężkiej zbroi czy oręża). Generalnie osoba w lekkiej zbroi będzie mogła wykonać swój ruch przed postacią ciężko opancerzoną, a ktoś rześki i wypoczęty wykona swój ruch przed osobą zmęczoną."
				}
			];

		case "character-stats.Bravery":
			return [
				{
					id = 1,
					type = "title",
					text = "Stanowczość"
				},
				{
					id = 2,
					type = "description",
					text = "Stanowczość reprezentuje siłę woli oraz odwagę postaci. Im wyższa, tym postać mniej podatna jest na obniżenie morale po negatywnych wydarzeniach, a jednocześnie bardziej podatna na zdobycie większej pewności siebie po pozytywnych wydarzeniach. Stanowczość pełni też rolę obrony przed pewnymi atakami psychicznymi, wywołującymi panikę, strach czy kontrolę umysłu. Zobacz także: Morale."
				}
			];

		case "character-stats.Talent":
			return [
				{
					id = 1,
					type = "title",
					text = "Talent"
				},
				{
					id = 2,
					type = "description",
					text = "TODO"
				}
			];

		case "character-stats.Undefined":
			return [
				{
					id = 1,
					type = "title",
					text = "UNDEFINED"
				},
				{
					id = 2,
					type = "description",
					text = "TODO"
				}
			];

		case "character-backgrounds.generic":
			if (entity != null)
			{
				local tooltip = entity.getBackground().getGenericTooltip();
				return tooltip;
			}

			return null;

		case "character-levels.generic":
			return [
				{
					id = 1,
					type = "title",
					text = "Wyższy poziom"
				},
				{
					id = 2,
					type = "description",
					text = "Ta postać jest już doświadczona w boju i zaczyna z wyższym poziomem."
				}
			];

		case "menu-screen.load-campaign.LoadButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Wczytaj Kampanię"
				},
				{
					id = 2,
					type = "description",
					text = "Wczytaj wybraną kampanię."
				}
			];

		case "menu-screen.load-campaign.CancelButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Anuluj"
				},
				{
					id = 2,
					type = "description",
					text = "Wróć do menu głównego."
				}
			];

		case "menu-screen.load-campaign.DeleteButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Usuń Kampanię"
				},
				{
					id = 2,
					type = "description",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]UWAGA:[/color] Usuwa wybraną kampanię bez dalszych ostrzeżeń."
				}
			];

		case "menu-screen.save-campaign.LoadButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Zapisz Kampanię"
				},
				{
					id = 2,
					type = "description",
					text = "Zapisz kampanię na wybranym slocie."
				}
			];

		case "menu-screen.save-campaign.CancelButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Anuluj"
				},
				{
					id = 2,
					type = "description",
					text = "Wróć do menu głównego."
				}
			];

		case "menu-screen.save-campaign.DeleteButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Usuń Kampanię"
				},
				{
					id = 2,
					type = "description",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]UWAGA:[/color] Usuwa wybraną kampanię bez dalszych ostrzeżeń."
				}
			];

		case "menu-screen.new-campaign.CompanyName":
			return [
				{
					id = 1,
					type = "title",
					text = "Nazwa Kompanii"
				},
				{
					id = 2,
					type = "description",
					text = "Nazwa twojej kompanii najemników, która będzie znana w całej krainie."
				}
			];

		case "menu-screen.new-campaign.Seed":
			return [
				{
					id = 1,
					type = "title",
					text = "Kod mapy"
				},
				{
					id = 2,
					type = "description",
					text = "Kod mapy to unikalny ciąg znaków, który określa jak będzie wyglądał świat w twojej kampanii. Kod mapy w trwających kampaniach możesz podejrzeć w menu dostępnym po naciśnięciu klawisza Escape i później podzielić się nim z przyjaciółmi, by mogli zagrać w tym samym świecie."
				}
			];

		case "menu-screen.new-campaign.EasyDifficulty":
			return [
				{
					id = 1,
					type = "title",
					text = "Poz. Trudności - Początkujący"
				},
				{
					id = 2,
					type = "description",
					text = "Zmierzysz się z mniejszą liczbą i gorzej wyszkolonymi przeciwnikami, twoi ludzie zdobywają doświadczenie szybciej, a wycofywanie się z bitew będzie łatwiejsze.\n\nTwoi ludzie zyskają niewielką premię do szansy trafienia, a wróg otrzyma niewielką karę, aby nieco ułatwić ci walkę.\n\nZalecane dla nowych graczy."
				}
			];

		case "menu-screen.new-campaign.NormalDifficulty":
			return [
				{
					id = 1,
					type = "title",
					text = "Poz. Trudności - Doświadczony"
				},
				{
					id = 2,
					type = "description",
					text = "Zapewnia zbalansowaną rozgrywkę i może stanowić spore wyzwanie.\n\nZalecane dla doświadczonych graczy."
				}
			];

		case "menu-screen.new-campaign.HardDifficulty":
			return [
				{
					id = 1,
					type = "title",
					text = "Poz. Trudności - Ekspert"
				},
				{
					id = 2,
					type = "description",
					text = "Twoi wrogowie będą liczniejsi i potężniejsi.\n\nZalecane dla znawców gry, którzy szukają prawdziwego wyzwania."
				}
			];

		case "menu-screen.new-campaign.EasyDifficultyEconomic":
			return [
				{
					id = 1,
					type = "title",
					text = "Poz. Trudności - Początkujący"
				},
				{
					id = 2,
					type = "description",
					text = "Kontrakty będą lepiej płatne, a ty będziesz w stanie nieść więcej zapasów.\n\nZalecane dla nowych graczy."
				}
			];

		case "menu-screen.new-campaign.NormalDifficultyEconomic":
			return [
				{
					id = 1,
					type = "title",
					text = "Poz. Trudności - Doświadczony"
				},
				{
					id = 2,
					type = "description",
					text = "Zapewnia zbalansowaną rozgrywkę i może stanowić spore wyzwanie.\n\nZalecane dla doświadczonych graczy."
				}
			];

		case "menu-screen.new-campaign.HardDifficultyEconomic":
			return [
				{
					id = 1,
					type = "title",
					text = "Poz. Trudności - Ekspert"
				},
				{
					id = 2,
					type = "description",
					text = "Kontrakty będą mniej płatne, a dezerterzy zabiorą ze sobą swój sprzęt.\n\nZalecane dla znawców gry, którzy szukają prawdziwego wyzwania w zarządzaniu zapasami i funduszami kompanii."
				}
			];

		case "menu-screen.new-campaign.EasyDifficultyBudget":
			return [
				{
					id = 1,
					type = "title",
					text = "Wysokie Fundusze Początkowe"
				},
				{
					id = 2,
					type = "description",
					text = "Rozpoczniesz grę z większą ilością koron i zapasów.\n\nZalecane dla początkujących graczy."
				}
			];

		case "menu-screen.new-campaign.NormalDifficultyBudget":
			return [
				{
					id = 1,
					type = "title",
					text = "Średnie Fundusze Początkowe"
				},
				{
					id = 2,
					type = "description",
					text = "Zalecana dla zbalansowanej rozgrywki."
				}
			];

		case "menu-screen.new-campaign.HardDifficultyBudget":
			return [
				{
					id = 1,
					type = "title",
					text = "Niskie Fundusze Początkowe"
				},
				{
					id = 2,
					type = "description",
					text = "Rozpoczniesz grę z mniejszą ilością koron i zapasów.\n\nZalecane dla doświadczonych graczy."
				}
			];

		case "menu-screen.new-campaign.StartingScenario":
			return [
				{
					id = 1,
					type = "title",
					text = "Scenariusz Początkowy"
				},
				{
					id = 2,
					type = "description",
					text = "Wybierz początek historii swojej kompanii. W zależności od twego wyboru, rozpoczniesz z różnymi ludźmi, ekwipunkiem, zasobami i specjalnymi zasadami gry."
				}
			];

		case "menu-screen.new-campaign.Ironman":
			return [
				{
					id = 1,
					type = "title",
					text = "Tryb Ironman"
				},
				{
					id = 2,
					type = "description",
					text = "Tryb Ironman (Człowiek z Żelaza) wyłącza ręczne zapisy stanu gry. Dla kompanii istnieć będzie tylko jeden zapis, a gra automatycznie będzie zapisywać na nim stan rozgrywki. Utracenie całej kompanii oznacza utracenie zapisu. Zalecany dla osiągniecia najlepszych wrażeń, gdy już lepiej poznasz grę. \n\nPamiętaj, że na słabszych komputerach automatyczne zapisy mogą zatrzymać grę na kilka sekund."
				}
			];

		case "menu-screen.new-campaign.Exploration":
			return [
				{
					id = 1,
					type = "title",
					text = "Nieodsłonięta Mapa"
				},
				{
					id = 2,
					type = "description",
					text = "Opcjonalny sposób rozgrywki, gdzie mapa jest całkowicie zasłonięta na początku kampanii. Twoja drużyna będzie musiała samodzielnie wszystko odkryć, co czyni rozgrywkę nieco trudniejszą, ale też i bardziej ekscytującą.\n\nZalecane dla doświadczonych graczy, którzy wiedzą, co czynią."
				}
			];

		case "menu-screen.new-campaign.EvilRandom":
			return [
				{
					id = 1,
					type = "title",
					text = "Losowy Kryzys Późniejszej Gry"
				},
				{
					id = 2,
					type = "description",
					text = "Wszystkie kryzysy zostaną losowo wybrane z poniższej listy."
				}
			];

		case "menu-screen.new-campaign.EvilNone":
			return [
				{
					id = 1,
					type = "title",
					text = "Brak Kryzysu"
				},
				{
					id = 2,
					type = "description",
					text = "Nie będzie kryzysu na późniejszym etapie gry i możesz grać nieskończenie. Pamiętaj, że gdy ta opcja jest włączona to niektóre części gry i wyzwania związane z kryzysami będą niedostępne. Nie zalecane."
				}
			];

		case "menu-screen.new-campaign.EvilPermanentDestruction":
			return [
				{
					id = 1,
					type = "title",
					text = "Trwałe Zniszczenia"
				},
				{
					id = 2,
					type = "description",
					text = "Wioski, miasta i zamki mogą zostać nieodwracalnie zniszczone podczas kryzysu na późniejszym etapie gry, a świat stojący w ogniu jest jednym ze sposobów na jaki możesz przegrać swoją kampanię."
				}
			];

		case "menu-screen.new-campaign.EvilWar":
			return [
				{
					id = 1,
					type = "title",
					text = "Wojna"
				},
				{
					id = 2,
					type = "description",
					text = "Pierwszym kryzysem będzie bezwzględna wojna o władzę między rodami szlacheckimi. Jeśli przetrwasz wystarczająco długo, kolejne kryzysy zostaną wybrane losowo."
				}
			];

		case "menu-screen.new-campaign.EvilGreenskins":
			return [
				{
					id = 1,
					type = "title",
					text = "Inwazja Zielonoskórych"
				},
				{
					id = 2,
					type = "description",
					text = "Pierwszym kryzysem będzie inwazja zielonoskórych hord, zagrażająca światu ludzi. Jeśli przetrwasz wystarczająco długo, kolejne kryzysy zostaną wybrane losowo."
				}
			];

		case "menu-screen.new-campaign.EvilUndead":
			return [
				{
					id = 1,
					type = "title",
					text = "Plaga Nieumarłych"
				},
				{
					id = 2,
					type = "description",
					text = "Pierwszym kryzysem będą starożytni zmarli powstający ze swych grobów, aby odzyskać to, co niegdyś do nich należało. Jeśli przetrwasz wystarczająco długo, kolejne kryzysy zostaną wybrane losowo."
				}
			];

		case "menu-screen.new-campaign.EvilCrusade":
			return [
				{
					id = 1,
					type = "title",
					text = "Święta Wojna"
				},
				{
					id = 2,
					type = "description",
					text = "Pierwszym kryzysem będzie święta wojna pomiędzy kulturami północy i południa. Jeśli przetrwasz wystarczająco długo, kolejne kryzysy zostaną wybrane losowo."
				}
			];

		case "menu-screen.options.DepthOfField":
			return [
				{
					id = 1,
					type = "title",
					text = "Głebia Widzenia"
				},
				{
					id = 2,
					type = "description",
					text = "Włączenie efektu Głębi Widzenia sprawi, że w trakcie bitwy wszystkie pola o wysokości niższej niż wysokość kamery będą lekko rozmazane, co da lekko miniaturkowy klimat i ułatwi rozpoznawanie wysokości, jednak kosztem drobnych detali."
				}
			];

		case "menu-screen.options.UIScale":
			return [
				{
					id = 1,
					type = "title",
					text = "Skalowanie UI"
				},
				{
					id = 2,
					type = "description",
					text = "Zmień skalę interfejsu użytkownika, np. menu, ekranów postaci, tekstów."
				}
			];

		case "menu-screen.options.SceneScale":
			return [
				{
					id = 1,
					type = "title",
					text = "Skalowanie Scen"
				},
				{
					id = 2,
					type = "description",
					text = "Zmień skalę sceny, czyli wszystkiego co nie jest elementem interfejsu użytkownika, jak np. postacie na polu bitwy."
				}
			];

		case "menu-screen.options.EdgeOfScreen":
			return [
				{
					id = 1,
					type = "title",
					text = "Kursor do Krawędzi"
				},
				{
					id = 2,
					type = "description",
					text = "Przesuwaj ekran przesuwając kursor myszy do krawędzi ekranu."
				}
			];

		case "menu-screen.options.DragWithMouse":
			return [
				{
					id = 1,
					type = "title",
					text = "Przeciągnij Myszką"
				},
				{
					id = 2,
					type = "description",
					text = "Przesuwaj ekran przytrzymując lewy przycisk myszy i przeciągając go (domyślne)."
				}
			];

		case "menu-screen.options.HardwareMouse":
			return [
				{
					id = 1,
					type = "title",
					text = "Użyj Kursora Sprzętowego"
				},
				{
					id = 2,
					type = "description",
					text = "Używanie kursora sprzętowego ogranicza opóźnienie podczas ruszania myszką w grze. Wyłącz tę opcję, jeśli będziesz mieć jakieś problemy związane z kursorem myszy."
				}
			];

		case "menu-screen.options.HardwareSound":
			return [
				{
					id = 1,
					type = "title",
					text = "Użyj Dźwięku Sprzętowego"
				},
				{
					id = 2,
					type = "description",
					text = "Używaj sprzętowego wsparcia odtwarzania dźwięków dla lepszej wydajności. Wyłącz tę opcję, jeśli będziesz mieć jakieś problemy związane z dźwiękiem."
				}
			];

		case "menu-screen.options.CameraFollow":
			return [
				{
					id = 1,
					type = "title",
					text = "Zawsze Śledź Ruch SI"
				},
				{
					id = 2,
					type = "description",
					text = "Kamera zawsze będzie wyśrodkowana na ruchu postaci sterowanych przez komputer w zasięgu twego wzroku."
				}
			];

		case "menu-screen.options.CameraAdjust":
			return [
				{
					id = 1,
					type = "title",
					text = "Automatycznie Dostosuj Wysokość"
				},
				{
					id = 2,
					type = "description",
					text = "Automatycznie dostosowuje wysokość kamery podczas bitwy, aby widać było postać obecnie wykonującą ruch. Wyłączenie tej opcji powstrzyma kamerę przed zmianą wysokości, jeżeli nie będzie to konieczne, jednak będzie wymagało ręcznej zmiany wysokości kamery, gdy przewyższenie terenu przesłoni postać."
				}
			];

		case "menu-screen.options.StatsOverlays":
			return [
				{
					id = 1,
					type = "title",
					text = "Zawsze Pokazuj Paski Zdrowia"
				},
				{
					id = 2,
					type = "description",
					text = "Zawsze pokazuj paski zdrowia i pancerza nad postaciami w trakcie bitwy, a nie tylko wtedy, gdy postać odniesie obrażenia."
				}
			];

		case "menu-screen.options.OrientationOverlays":
			return [
				{
					id = 1,
					type = "title",
					text = "Pokaż Ikonki Orientacyjne"
				},
				{
					id = 2,
					type = "description",
					text = "Pokazuje ikonki na krawędziach ekranu, określające kierunki w jakich znajdują się postacie będące aktualnie poza ekranem."
				}
			];

		case "menu-screen.options.MovementPlayer":
			return [
				{
					id = 1,
					type = "title",
					text = "Szybszy Ruch Gracza"
				},
				{
					id = 2,
					type = "description",
					text = "Znacząco przyspiesza ruch każdej postaci kontrolowanej przez gracza. Nie ma wpływu na umiejętności związane z ruchem."
				}
			];

		case "menu-screen.options.MovementAI":
			return [
				{
					id = 1,
					type = "title",
					text = "Szybszy Ruch SI"
				},
				{
					id = 2,
					type = "description",
					text = "Znacząco przyspiesza ruch każdej postaci kontrolowanej przez komputer. Nie ma wpływu na umiejętności związane z ruchem."
				}
			];

		case "menu-screen.options.AutoLoot":
			return [
				{
					id = 1,
					type = "title",
					text = "Auto-łup"
				},
				{
					id = 2,
					type = "description",
					text = "Zawsze i automatycznie zbieraj wszystkie łupy po bitwie, gdy już zamkniesz ekran łupów - o ile masz miejsce w ekwipunku dla nowych przedmiotów."
				}
			];

		case "menu-screen.options.RestoreEquipment":
			return [
				{
					id = 1,
					type = "title",
					text = "Resetuj Ekwipunek po Bitwie"
				},
				{
					id = 2,
					type = "description",
					text = "Automatycznie umieść przedmioty w slotach, w których znajdowały się przed rozpoczęciem bitwy, jeżeli to możliwe. Dla przykładu, jeżeli postać rozpoczęła bitwę z kuszą, lecz zmieniła ją na pikę podczas walki, automatycznie zmieni broń z powrotem na kuszę po zakończeniu bitwy.."
				}
			];

		case "menu-screen.options.AutoPauseAfterCity":
			return [
				{
					id = 1,
					type = "title",
					text = "Auto-pauza po Wyjściu z Miasta"
				},
				{
					id = 2,
					type = "description",
					text = "Automatycznie zatrzymuje grę po opuszczeniu miasta, abyś nie tracił czasu - jednak kosztem konieczności ręcznego odpauzowania gry."
				}
			];

		case "menu-screen.options.AlwaysHideTrees":
			return [
				{
					id = 1,
					type = "title",
					text = "Zawsze Ukrywaj Drzewa"
				},
				{
					id = 2,
					type = "description",
					text = "Zawsze renderuje wierzchołki drzew i innych dużych obiektów jako pół-przezroczyste, a nie tylko wtedy, gdy coś przysłaniają."
				}
			];

		case "menu-screen.options.AutoEndTurns":
			return [
				{
					id = 1,
					type = "title",
					text = "Automatycznie Kończ Tury"
				},
				{
					id = 2,
					type = "description",
					text = "Automatycznie zakończy turę kontrolowanej przez ciebie postaci, gdy jej liczba dostępnych Punktów Akcji nie pozwoli na wykonanie żadnej czynności."
				}
			];

		case "tactical-screen.topbar.event-log-module.ExpandButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Rozwiń/Zwiń Log Wydarzeń"
				},
				{
					id = 2,
					type = "description",
					text = "Powiększa lub zmniejsza Log Wydarzeń w trakcie walki."
				}
			];

		case "tactical-screen.topbar.round-information-module.BrothersCounter":
			return [
				{
					id = 1,
					type = "title",
					text = "Sojusznicy"
				},
				{
					id = 2,
					type = "description",
					text = "Liczba towarzyszy kontrolowanych przez gracza i sojuszników prowadzonych przez komputer, obecnych na polu bitwy."
				}
			];

		case "tactical-screen.topbar.round-information-module.EnemiesCounter":
			return [
				{
					id = 1,
					type = "title",
					text = "Przeciwnicy"
				},
				{
					id = 2,
					type = "description",
					text = "Liczba przeciwników obecnych na polu bitwy."
				}
			];

		case "tactical-screen.topbar.round-information-module.RoundCounter":
			return [
				{
					id = 1,
					type = "title",
					text = "Runda"
				},
				{
					id = 2,
					type = "description",
					text = "Liczba rund rozegranych od początku bitwy."
				}
			];

		case "tactical-screen.topbar.options-bar-module.CenterButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Wycentruj Kamerę (Shift)"
				},
				{
					id = 2,
					type = "description",
					text = "Wyśrodkowuje kamerę na postaci, która aktualnie wykonuje ruch."
				}
			];

		case "tactical-screen.topbar.options-bar-module.ToggleHighlightBlockedTilesButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Pokaż/Ukryj Podświetlenie Zablokowanych Pól (B)"
				},
				{
					id = 2,
					type = "description",
					text = "Przełącza pomiędzy pokazywaniem a ukrywaniem czerwonych znaczników, które oznaczają pola zablokowane przez elementy otoczenia (jak np. drzewa), na które postać nie może się przemieścić."
				}
			];

		case "tactical-screen.topbar.options-bar-module.SwitchMapLevelUpButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Podnieś Poziom Kamery (+)"
				},
				{
					id = 2,
					type = "description",
					text = "Podnosi poziom kamery, aby ujrzeć więcej wyższe pola na mapie."
				}
			];

		case "tactical-screen.topbar.options-bar-module.SwitchMapLevelDownButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Obniż Poziom Kamery (-)"
				},
				{
					id = 2,
					type = "description",
					text = "Obniża poziom kamery i ukrywa wyższe pola na mapie."
				}
			];

		case "tactical-screen.topbar.options-bar-module.ToggleStatsOverlaysButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Pokaż/Ukryj Paski Zdrowia (Alt)"
				},
				{
					id = 2,
					type = "description",
					text = "Przełącza pomiędzy pokazywaniem a ukrywaniem pasków zdrowia i pancerza, a także ikonek efektów nad każdą widoczną postacią."
				}
			];

		case "tactical-screen.topbar.options-bar-module.ToggleTreesButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Pokaż/Ukryj Drzewa (T)"
				},
				{
					id = 2,
					type = "description",
					text = "Przełącza pomiędzy pokazywaniem a ukrywaniem drzew i innych dużych obiektów na mapie."
				}
			];

		case "tactical-screen.topbar.options-bar-module.FleeButton":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Wycofaj się z bitwy"
				},
				{
					id = 2,
					type = "description",
					text = "Wycofaj się z walki i ratuj swe życie. Lepiej przeżyć i wrócić do bitwy kiedy indziej, niż bezsensownie tu polec.."
				}
			];

			if (!this.Tactical.State.isScenarioMode() && this.Tactical.State.getStrategicProperties() != null && this.Tactical.State.getStrategicProperties().IsFleeingProhibited)
			{
				ret.push({
					id = 3,
					type = "hint",
					icon = "ui/tooltips/warning.png",
					text = "Z tej konkretnej bitwy nie możesz się wycofać"
				});
			}

			return ret;

		case "tactical-screen.topbar.options-bar-module.QuitButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Otwórz Menu (Esc)"
				},
				{
					id = 2,
					type = "description",
					text = "Otwórz menu, by dostosować ustawienia gry."
				}
			];

		case "tactical-screen.turn-sequence-bar-module.EndTurnButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Zakończ Turę (Enter, F)"
				},
				{
					id = 2,
					type = "description",
					text = "Zakończ turę aktywnej postaci i rozpocznij turę postaci następnej w kolejce."
				}
			];

		case "tactical-screen.turn-sequence-bar-module.WaitTurnButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Zaczekaj (Spacebar, End)"
				},
				{
					id = 2,
					type = "description",
					text = "Wstrzymuje turę postaci i przesuwa ją na koniec kolejki. Czekanie w obecnej turze powoduje, że w następnej rundzie postać będzie wykonywała swój ruch nieco później."
				}
			];

		case "tactical-screen.turn-sequence-bar-module.EndTurnAllButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Zakończ Rundę (R)"
				},
				{
					id = 2,
					type = "description",
					text = "Zakończ obecną rundę i spraw, aby wszyscy twoi ludzie pominęli swoją turę, aż nowa runda się rozpocznie."
				}
			];

		case "tactical-screen.turn-sequence-bar-module.OpenInventoryButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Otwórz Ekwipunek (I, C)"
				},
				{
					id = 2,
					type = "description",
					text = "Otwiera ekran postaci i ekwipunek aktywnego towarzysza."
				}
			];

		case "tactical-combat-result-screen.LeaveButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Odejdź"
				},
				{
					id = 2,
					type = "description",
					text = "Opuszcza walkę taktyczną i wraca na mapę świata."
				}
			];

		case "tactical-combat-result-screen.statistics-panel.LeveledUp":
			local result = [
				{
					id = 1,
					type = "title",
					text = "Awans"
				},
				{
					id = 2,
					type = "description",
					text = "Ta postać właśnie awansowała na wyższy poziom! Odszukaj ją w swojej drużynie, dostępnej z poziomu mapy świata, aby zwiększyć jej atrybuty i wybrać talent."
				}
			];
			return result;

		case "tactical-combat-result-screen.statistics-panel.DaysWounded":
			local result = [
				{
					id = 1,
					type = "title",
					text = "Lekkie Rany"
				},
				{
					id = 2,
					type = "description",
					text = "Lekkie siniaki, powierzchowne rany, utrata krwi i podobne niewielkie obrażenia, które spowodowały utratę punktów zdrowia tej postaci, nie obniżając jednak jej zdolności bojowych."
				}
			];

			if (entity != null)
			{
				if (entity.getDaysWounded() <= 1)
				{
					result.push({
						id = 1,
						type = "text",
						icon = "ui/icons/days_wounded.png",
						text = "Zagoi się do jutra"
					});
				}
				else
				{
					result.push({
						id = 1,
						type = "text",
						icon = "ui/icons/days_wounded.png",
						text = "Zagoi się za [color=" + this.Const.UI.Color.NegativeValue + "]" + entity.getDaysWounded() + "[/color] dni"
					});
				}
			}

			return result;

		case "tactical-combat-result-screen.statistics-panel.KillsValue":
			return [
				{
					id = 1,
					type = "title",
					text = "Zabójstwa"
				},
				{
					id = 2,
					type = "description",
					text = "Liczba zabójstw dokonanych przez tę postać w trakcie bitwy."
				}
			];

		case "tactical-combat-result-screen.statistics-panel.XPReceivedValue":
			return [
				{
					id = 1,
					type = "title",
					text = "Zdobyte Doświadczenie"
				},
				{
					id = 2,
					type = "description",
					text = "Liczba punktów doświadczenia zdobytych w bitwie z a walkę i zabijanie przeciwników. Zebranie wystarczającej liczby punktów doświadczenia umożliwi tej postaci awansowanie na kolejny poziom oraz zwiększenie atrybutów i zdobycie nowego talentu."
				}
			];

		case "tactical-combat-result-screen.statistics-panel.DamageDealtValue":
			local result = [
				{
					id = 1,
					type = "title",
					text = "Zadane Obrażenia"
				},
				{
					id = 2,
					type = "description",
					text = "Obrażenia zadane przez tę postać w walce, rozdzielone na obrażenia zdrowia i obrażenia pancerza."
				}
			];

			if (entity != null)
			{
				local combatStats = entity.getCombatStats();
				result.push({
					id = 1,
					type = "text",
					icon = "ui/icons/regular_damage.png",
					text = "Zadał [color=" + this.Const.UI.Color.PositiveValue + "]" + combatStats.DamageDealtHitpoints + "[/color] obrażeń zdrowia"
				});
				result.push({
					id = 2,
					type = "text",
					icon = "ui/icons/shield_damage.png",
					text = "Zadał [color=" + this.Const.UI.Color.PositiveValue + "]" + combatStats.DamageDealtArmor + "[/color] obrażeń pancerza"
				});
			}

			return result;

		case "tactical-combat-result-screen.statistics-panel.DamageReceivedValue":
			local result = [
				{
					id = 1,
					type = "title",
					text = "Otrzymane obrażenia"
				},
				{
					id = 2,
					type = "description",
					text = "Obrażenia otrzymane przez tę postać, rozdzielone na obrażenia zdrowia i obrażenia pancerza. Wartość jest po uwzględnieniu wszelkich ewentualnych redukcji."
				}
			];

			if (entity != null)
			{
				local combatStats = entity.getCombatStats();
				result.push({
					id = 1,
					type = "text",
					icon = "ui/icons/regular_damage.png",
					text = "Otrzymał [color=" + this.Const.UI.Color.NegativeValue + "]" + combatStats.DamageReceivedHitpoints + "[/color] obrażeń zdrowia"
				});
				result.push({
					id = 2,
					type = "text",
					icon = "ui/icons/shield_damage.png",
					text = "Otrzymał [color=" + this.Const.UI.Color.NegativeValue + "]" + combatStats.DamageReceivedArmor + "[/color] obrażeń pancerza"
				});
			}

			return result;

		case "tactical-combat-result-screen.loot-panel.LootAllItemsButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Zgarnij wszystkie łupy"
				},
				{
					id = 2,
					type = "description",
					text = "Zabierz wszystkie znalezione przedmioty, aż do wypełnienia ekwipunku."
				}
			];

		case "character-screen.left-panel-header-module.ChangeNameAndTitle":
			return [
				{
					id = 1,
					type = "title",
					text = "Zmień Imię i Tytuł"
				},
				{
					id = 2,
					type = "description",
					text = "Kliknij tutaj, aby zmienić imię i tytuł postaci."
				}
			];

		case "character-screen.left-panel-header-module.Experience":
			return [
				{
					id = 1,
					type = "title",
					text = "Doświadczenie"
				},
				{
					id = 2,
					type = "description",
					text = "Postacie zdobywają doświadczenie za każdym razem gdy one lub ich sojusznicy zabiją wroga. Kiedy postać zgromadzi wystarczająco dużo doświadczenia, awansuje na kolejny poziom i będzie mogła zwiększyć swoje atrybuty i wybrać talent, który przyzna jej dodatkowe premie.\n\nPo osiągnięciu 11. poziomu doświadczenia, postacie stają się weteranami i już nie będą zdobywać punktów talentów, choć nadal mogą podnosić swoje atrybuty."
				}
			];

		case "character-screen.left-panel-header-module.Level":
			return [
				{
					id = 1,
					type = "title",
					text = "Poziom"
				},
				{
					id = 2,
					type = "description",
					text = "Poziom postaci określa jej doświadczenie bojowe. Postać awansuje na kolejne poziomy zdobywając doświadczenie, dzięki czemu może podnosić swoje atrybuty i odblokowywać nowe talenty, stając się coraz to lepszym najemnikiem.\n\nPo osiągnięciu 11. poziomu doświadczenia, postacie stają się weteranami i już nie będą zdobywać punktów talentów, choć nadal mogą podnosić swoje atrybuty."
				}
			];

		case "character-screen.brothers-list.LevelUp":
			local result = [
				{
					id = 1,
					type = "title",
					text = "Awans"
				},
				{
					id = 2,
					type = "description",
					text = "Ta postać awansowała na wyższy poziom doświadczenia. Zwiększ jej atrybuty i wybierz talent!"
				}
			];
			return result;

		case "character-screen.left-panel-header-module.Dismiss":
			return [
				{
					id = 1,
					type = "title",
					text = "Zwolnij"
				},
				{
					id = 2,
					type = "description",
					text = "Zwolnij tę postać ze swojej kompanii, aby zaoszczędzić nieco na dziennym żołdzie i zrobić miejsce dla kogoś innego. Zadłużone postacie zostaną uwolnione z niewoli i opuszczą twoją kompanię."
				}
			];

		case "character-screen.right-panel-header-module.InventoryButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Ekwipunek/Ziemia"
				},
				{
					id = 2,
					type = "description",
					text = "Przełącz się na kartę głównego ekwipunku twojej kompanii najemników, albo na ziemię pod nogami obecnie wybranej postaci, jeżeli trwa bitwa."
				}
			];

		case "character-screen.right-panel-header-module.PerksButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Talenty"
				},
				{
					id = 2,
					type = "description",
					text = "Przełącz się na kartę talentów obecnie wybranej postaci.\n\nCyfra w nawiasie, jeżeli taka jest, oznacza ilość dostępnych punktów talentów."
				}
			];

		case "character-screen.right-panel-header-module.CloseButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Zamknij (ESC)"
				},
				{
					id = 2,
					type = "description",
					text = "Zamknij ten ekran."
				}
			];

		case "character-screen.right-panel-header-module.SortButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Sortuj Przedmioty"
				},
				{
					id = 2,
					type = "description",
					text = "Sortuj przedmioty według typu."
				}
			];

		case "character-screen.right-panel-header-module.FilterAllButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Filtruj Według Typu"
				},
				{
					id = 2,
					type = "description",
					text = "Pokaż wszystkie przedmioty."
				}
			];

		case "character-screen.right-panel-header-module.FilterWeaponsButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Filtruj Według Typu"
				},
				{
					id = 2,
					type = "description",
					text = "Pokaż tylko broń, ofensywne narzędzia i akcesoria."
				}
			];

		case "character-screen.right-panel-header-module.FilterArmorButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Filtruj Według Typu"
				},
				{
					id = 2,
					type = "description",
					text = "Pokaż tylko zbroje, hełmy i tarcze."
				}
			];

		case "character-screen.right-panel-header-module.FilterMiscButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Filtruj Według Typu"
				},
				{
					id = 2,
					type = "description",
					text = "Pokaż tylko zapasy, żywność, skarby i różności."
				}
			];

		case "character-screen.right-panel-header-module.FilterUsableButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Filtruj Według Typu"
				},
				{
					id = 2,
					type = "description",
					text = "Pokaż tylko przedmioty do wykorzystania w trybie ekwipunku, jak farby czy ulepszenia zbroi."
				}
			];

		case "character-screen.right-panel-header-module.FilterMoodButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Pokaż/Ukryj Nastrój"
				},
				{
					id = 2,
					type = "description",
					text = "Przełącza pomiędzy pokazywaniem i ukrywaniem nastroju twoich ludzi."
				}
			];

		case "character-screen.battle-start-footer-module.StartBattleButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Rozpocznij Bitwę"
				},
				{
					id = 2,
					type = "description",
					text = "Rozpoczyna bitwę z użyciem wybranego wyposażenia."
				}
			];

		case "character-screen.levelup-popup-dialog.StatIncreasePoints":
			return [
				{
					id = 1,
					type = "title",
					text = "Punkty Atrybutów"
				},
				{
					id = 2,
					type = "description",
					text = "Wykorzystaj te punkty, aby zwiększyć poziom 3 z 8 atrybutów o losową wartość podczas awansowania postaci. Dany atrybut może zostać zwiększony tylko raz podczas jednego awansu.\n\nGwiazdki oznaczają, że postać jest wyjątkowo uzdolniona w danym atrybucie, dzięki czemu wylosowane wartości zwykle są wyższe."
				}
			];

		case "character-screen.dismiss-popup-dialog.Compensation":
			return [
				{
					id = 1,
					type = "title",
					text = "Zadośćuczynienie"
				},
				{
					id = 2,
					type = "description",
					text = "Wypłata rekompensaty, napiwku czy renty za czas spędzony w kompanii pozwoli opuszczającemu odejść z godnością i ułatwi mu rozpoczęcie nowego życia. Zapobiegnie też wybuchom złości w twojej kompanii, spowodowanej zwolnieniem jednego z towarzyszy broni.\n\nPostaciom zadłużonym i niewolnikom wypłacane jest zamiast tego zadośćuczynienie za ich czas w służbie kompanii. Inni niewolnicy docenią twoją szczodrość, lecz nie zareagują złością, jeśli zadośćuczynienia nie wypłacisz.."
				}
			];

		case "world-screen.topbar.TimePauseButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Pauza (Spacja)"
				},
				{
					id = 2,
					type = "description",
					text = "Wstrzymuje grę."
				}
			];

		case "world-screen.topbar.TimeNormalButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Normalna Prędkość (1)"
				},
				{
					id = 2,
					type = "description",
					text = "Ustaw, aby czas płynął normalnie."
				}
			];

		case "world-screen.topbar.TimeFastButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Przyspieszenie (2)"
				},
				{
					id = 2,
					type = "description",
					text = "Ustaw, aby czas płynął szybciej niż zwykle."
				}
			];

		case "world-screen.topbar.options-module.ActiveContractButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Aktywny Kontrakt"
				},
				{
					id = 2,
					type = "description",
					text = "Pokaż szczegóły twojego aktywnego kontraktu."
				}
			];

		case "world-screen.topbar.options-module.RelationsButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Pokaż Frakcje i Relacje (R)"
				},
				{
					id = 2,
					type = "description",
					text = "Obejrzyj wszystkie znane ci frakcje i twoje relacje z nimi."
				}
			];

		case "world-screen.topbar.options-module.CenterButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Wycentruj Kamerę (Enter, Shift)"
				},
				{
					id = 2,
					type = "description",
					text = "Przesuń kamerę, aby wycentrowała i skupiła się na twojej kompanii najemników."
				}
			];

		case "world-screen.topbar.options-module.CameraLockButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Przełącz Blokadę Kamery (X)"
				},
				{
					id = 2,
					type = "description",
					text = "Uwolnij lub zablokuj kamerę, aby zawsze była wycentrowana na twojej kompanii najemników."
				}
			];

		case "world-screen.topbar.options-module.TrackingButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Przełącz Śledzenie Tropów (F)"
				},
				{
					id = 2,
					type = "description",
					text = "Pokazuje lub ukrywa tropy pozostawione przez inne drużyny przemierzające świat, aby łatwiej ci było za tymi grupami podążać lub ich unikać."
				}
			];

		case "world-screen.topbar.options-module.CampButton":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Obóz (T)"
				},
				{
					id = 2,
					type = "description",
					text = "Rozbij lub zwiń obóz. Podczas obozowania czas biegnie szybciej, a twoi ludzie prędzej dochodzą do zdrowia i sprawniej naprawiają swoje wyposażenie. Jednakże jesteście wówczas bardziej narażeni na ataki z zaskoczenia."
				}
			];

			if (!this.World.State.isCampingAllowed())
			{
				ret.push({
					id = 9,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]Nie można obozować podczas podróżowania z innymi drużynami[/color]"
				});
			}

			return ret;

		case "world-screen.topbar.options-module.PerksButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Świta (P)"
				},
				{
					id = 2,
					type = "description",
					text = "Przejrzyj swoją świtę nie-walczących towarzyszy, którzy przyznają różne zalety niezwiązane bezpośrednio z walką, lub ulepsz swój wóz, by zyskać więcej miejsca w ekwipunku."
				}
			];

		case "world-screen.topbar.options-module.ObituaryButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Nekrolog (O)"
				},
				{
					id = 2,
					type = "description",
					text = "Przejrzyj nekrolog, w którym znajdziesz informacje o tych, którzy polegli w służbie kompanii, odkąd nią dowodzisz."
				}
			];

		case "world-screen.topbar.options-module.QuitButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Otwórz Menu (Esc)"
				},
				{
					id = 2,
					type = "description",
					text = "Otwórz menu, aby zapisać lub wczytać grę, zmienić ustawienia lub opuścić obecną kampanię i wyjść do menu głównego."
				}
			];

		case "world-screen.active-contract-panel-module.ToggleVisibilityButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Anuluj Kontrakt"
				},
				{
					id = 2,
					type = "description",
					text = "Anuluj obecny kontrakt."
				}
			];

		case "world-screen.obituary.ColumnName":
			return [
				{
					id = 1,
					type = "title",
					text = "Imię"
				},
				{
					id = 2,
					type = "description",
					text = "Imię postaci."
				}
			];

		case "world-screen.obituary.ColumnTime":
			return [
				{
					id = 1,
					type = "title",
					text = "Dni"
				},
				{
					id = 2,
					type = "description",
					text = "Liczba dni, jakie postać spędziła służąc w twojej kompanii, zanim spotkał ją jej straszliwy koniec."
				}
			];

		case "world-screen.obituary.ColumnBattles":
			return [
				{
					id = 1,
					type = "title",
					text = "Bitwy"
				},
				{
					id = 2,
					type = "description",
					text = "Liczba bitew, w których postać wzięła udział."
				}
			];

		case "world-screen.obituary.ColumnKills":
			return [
				{
					id = 1,
					type = "title",
					text = "Zabici"
				},
				{
					id = 2,
					type = "description",
					text = "Liczba zabójstwa, których dokonała postać."
				}
			];

		case "world-screen.obituary.ColumnKilledBy":
			return [
				{
					id = 1,
					type = "title",
					text = "Zgon"
				},
				{
					id = 2,
					type = "description",
					text = "W jaki sposób postać rozstała się z tym ziemskim padołem."
				}
			];

		case "world-town-screen.main-dialog-module.LeaveButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Odejdź"
				},
				{
					id = 2,
					type = "description",
					text = "Odejdź i wróć na mapę świata."
				}
			];

		case "world-town-screen.main-dialog-module.Contract":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Dostępny kontrakt"
				},
				{
					id = 2,
					type = "description",
					text = "Ktoś szuka najemników."
				}
			];
			return ret;

		case "world-town-screen.main-dialog-module.ContractNegotiated":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Dostępny kontrakt"
				},
				{
					id = 2,
					type = "description",
					text = "Warunki tego kontraktu zostały już wynegocjowane. Zostało ci tylko podpisać kontrakt."
				}
			];
			return ret;

		case "world-town-screen.main-dialog-module.ContractDisabled":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Już masz kontrakt!"
				},
				{
					id = 2,
					type = "description",
					text = "Możesz mieć tylko jeden aktywny kontrakt w danym czasie. Oferty kontraktów pozostaną aż do czasu, gdy wypełnisz swój obecny, chyba że w międzyczasie dany problem sam się rozwiąże."
				}
			];
			return ret;

		case "world-town-screen.main-dialog-module.ContractLocked":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Kontrakt zablokowany"
				},
				{
					id = 2,
					type = "description",
					text = "Dostępne są tu tylko kontrakty rodu szlacheckiego, władającego tą fortyfikacją, jednakże szlacha nie uważa cię jeszcze za godnego zaufania. Zwiększ poziom swojej sławy i spełnij ambicje zwrócenia na siebie uwagi rodów szlacheckich, aby odblokować nowe kontrakty!"
				}
			];
			return ret;

		case "world-town-screen.main-dialog-module.Crowd":
			return [
				{
					id = 1,
					type = "title",
					text = "Ochotnicy"
				},
				{
					id = 2,
					type = "description",
					text = "Zwerbuj nowych ludzi do swej kompanii najemników. Jakość i ilość ochotników zależy od wielkości i rodzaju osady, a także od twojej miejscowej reputacji. Co kilka dni nadciągają nowi ludzie, inni zaś wyruszają w dalszą drogę."
				}
			];

		case "world-town-screen.main-dialog-module.Tavern":
			return [
				{
					id = 1,
					type = "title",
					text = "Karczma"
				},
				{
					id = 2,
					type = "description",
					text = "Duża gospoda wypełniona miejscową ludnością i przyjezdnymi z różnych stron świata, oferująca jadło, napitek i żywą atmosferę, w której można podzielić się wieściami i plotkami."
				}
			];

		case "world-town-screen.main-dialog-module.Temple":
			return [
				{
					id = 1,
					type = "title",
					text = "Świątynia"
				},
				{
					id = 2,
					type = "description",
					text = "Oaza spokoju i bezpieczny azyl przed tym bezwzględnym światem zewnętrznym. Możesz tu szukać pomocy dla swych rannych towarzyszy oraz modlić się o zbawienie dla swej nieśmiertelnej duszy."
				}
			];

		case "world-town-screen.main-dialog-module.VeteransHall":
			return [
				{
					id = 1,
					type = "title",
					text = "Sala Szkoleniowa"
				},
				{
					id = 2,
					type = "description",
					text = "Miejsce spotkań dla ludzi parających się wojaczką. Twoi ludzie mogą tu ćwiczyć pod okiem doświadczonych wojowników, więc możesz ich szybciej przekuć w zaprawionych w boju najemników."
				}
			];

		case "world-town-screen.main-dialog-module.Taxidermist":
			return [
				{
					id = 1,
					type = "title",
					text = "Taksydermista"
				},
				{
					id = 2,
					type = "description",
					text = "Za odpowiednią opłatą, taksydermista może wytworzyć użyteczne przedmioty z dostarczonych przez ciebie różnorakich trofeów."
				}
			];

		case "world-town-screen.main-dialog-module.Kennel":
			return [
				{
					id = 1,
					type = "title",
					text = "Psiarnia"
				},
				{
					id = 2,
					type = "description",
					text = "W psiarni hoduje się oraz szkoli silne i szybkie wojenne ogary."
				}
			];

		case "world-town-screen.main-dialog-module.Barber":
			return [
				{
					id = 1,
					type = "title",
					text = "Golibroda"
				},
				{
					id = 2,
					type = "description",
					text = "Wizyta u golibrody umożliwia zmianę wyglądu twoich ludzi. Możesz zlecić ściąć im włosy, przystrzyc zarost lub nawet kupić podejrzane mikstury odchudzania."
				}
			];

		case "world-town-screen.main-dialog-module.Fletcher":
			return [
				{
					id = 1,
					type = "title",
					text = "Łuczarz"
				},
				{
					id = 2,
					type = "description",
					text = "Łuczarz oferuje różnoraką i fachowo wytworzoną broń dystansową."
				}
			];

		case "world-town-screen.main-dialog-module.Alchemist":
			return [
				{
					id = 1,
					type = "title",
					text = "Alchemik"
				},
				{
					id = 2,
					type = "description",
					text = "Alchemik oferuje egzotyczne i dość niebezpieczne ustrojstwa za przyzwoitą sumkę."
				}
			];

		case "world-town-screen.main-dialog-module.Arena":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Arena"
				},
				{
					id = 2,
					type = "description",
					text = "Arena daje możliwość zarobienia złota i sławy w walkach na śmierć i życie, które odbywają się na oczach złaknionej krwi publiczności, wiwatującej na widok najbardziej makabrycznych sposobów odbierania życia."
				}
			];

			if (this.World.State.getCurrentTown() != null && this.World.State.getCurrentTown().getBuilding("building.arena").isClosed())
			{
				ret.push({
					id = 3,
					type = "hint",
					icon = "ui/tooltips/warning.png",
					text = "Dzisiaj już nie będzie więcej walk. Wróć jutro!"
				});
			}

			if (this.World.Contracts.getActiveContract() != null && this.World.Contracts.getActiveContract().getType() != "contract.arena" && this.World.Contracts.getActiveContract().getType() != "contract.arena_tournament")
			{
				ret.push({
					id = 3,
					type = "hint",
					icon = "ui/tooltips/warning.png",
					text = "Nie możesz walczyć na arenie mając aktywny kontrakt"
				});
			}
			else if (this.World.Contracts.getActiveContract() == null && this.World.State.getCurrentTown() != null && this.World.State.getCurrentTown().hasSituation("situation.arena_tournament") && this.World.Assets.getStash().getNumberOfEmptySlots() < 5)
			{
				ret.push({
					id = 3,
					type = "hint",
					icon = "ui/tooltips/warning.png",
					text = "Potrzebujesz co najmniej 5 wolnych miejsc w ekwipunku, aby walczyć w toczącym się turnieju"
				});
			}
			else if (this.World.Contracts.getActiveContract() == null && this.World.Assets.getStash().getNumberOfEmptySlots() < 3)
			{
				ret.push({
					id = 3,
					type = "hint",
					icon = "ui/tooltips/warning.png",
					text = "Potrzebujesz co najmniej 3 wolne miejsca w ekwipunku, aby walczyć na arenie"
				});
			}

			return ret;

		case "world-town-screen.main-dialog-module.Port":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Przystań"
				},
				{
					id = 2,
					type = "description",
					text = "Przystań służy zarówno zagranicznym kupcom, jak i miejscowym rybakom. Możesz tu wykupić sobie miejsce na jednej z łajb i drogą morską dostać się na inne części kontynentu."
				}
			];

			if (this.World.Contracts.getActiveContract() != null && this.World.Contracts.getActiveContract().getType() == "contract.escort_caravan")
			{
				ret.push({
					id = 3,
					type = "hint",
					icon = "ui/tooltips/warning.png",
					text = "Nie możesz korzystać z przystani mając kontrakt eskortowania karawany"
				});
			}

			return ret;

		case "world-town-screen.main-dialog-module.Marketplace":
			return [
				{
					id = 1,
					type = "title",
					text = "Targ"
				},
				{
					id = 2,
					type = "description",
					text = "Tętniący życiem targ, oferujący rożnego rodzaju towary pospolite w danym regionie. Nowe dobra pojawiają się tu co kilka dni oraz wtedy, gdy karawany kupieckie docierają do osady."
				}
			];

		case "world-town-screen.main-dialog-module.Weaponsmith":
			return [
				{
					id = 1,
					type = "title",
					text = "Zbrojmistrz"
				},
				{
					id = 2,
					type = "description",
					text = "Kuźnia tego kowala, specjalizującego się w wytwarzaniu broni, obfituje w dobrze wykonany oręż. Można tu także naprawić uszkodzone wyposażenie, za odpowiednią zapłatą oczywiście."
				}
			];

		case "world-town-screen.main-dialog-module.Armorsmith":
			return [
				{
					id = 1,
					type = "title",
					text = "Płatnerz"
				},
				{
					id = 2,
					type = "description",
					text = "Warsztat płatnerski jest odpowiednim miejscem dla kogoś, kto szuka porządnej i trwałej ochrony. Można tu także za odpowiednią opłatą naprawić uszkodzone wyposażenie."
				}
			];

		case "world-town-screen.hire-dialog-module.LeaveButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Odejdź"
				},
				{
					id = 2,
					type = "description",
					text = "Opuść ten ekran i wróć do poprzedniego."
				}
			];

		case "world-town-screen.hire-dialog-module.HireButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Zwerbuj Rekruta"
				},
				{
					id = 2,
					type = "description",
					text = "Najmij wybranego ochotnika, by dołączył do twojej kompanii."
				}
			];

		case "world-town-screen.hire-dialog-module.TryoutButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Wypróbuj Rekruta"
				},
				{
					id = 2,
					type = "description",
					text = "Poddaj rekruta dokładniejszej próbie, aby odkryć jego ukryte cechy charakteru, o ile jakieś ma."
				}
			];

		case "world-town-screen.hire-dialog-module.UnknownTraits":
			return [
				{
					id = 1,
					type = "title",
					text = "Nieznane Cechy Charakteru"
				},
				{
					id = 2,
					type = "description",
					text = "Ta postać może mieć nieznane cechy. Możesz zapłacić, by poddać go próbie i odkryć te cechy."
				}
			];

		case "world-town-screen.taxidermist-dialog-module.CraftButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Wytwórz"
				},
				{
					id = 2,
					type = "description",
					text = "Zapłać wskazaną cenę i wydaj niezbędne komponenty, aby w zamian otrzymać wytworzony przedmiot."
				}
			];

		case "world-town-screen.travel-dialog-module.LeaveButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Odejdź"
				},
				{
					id = 2,
					type = "description",
					text = "Opuść ten ekran i wróć do poprzedniego."
				}
			];

		case "world-town-screen.travel-dialog-module.TravelButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Podróżuj"
				},
				{
					id = 2,
					type = "description",
					text = "Zarezerwuj miejsce na łodzi dla swojej kompanii, aby szybko przemieścić się do wybranego celu podróży."
				}
			];

		case "world-town-screen.shop-dialog-module.LeaveButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Opuść Sklep"
				},
				{
					id = 2,
					type = "description",
					text = "Opuść ten ekran i wróć do poprzedniego."
				}
			];

		case "world-town-screen.training-dialog-module.Train1":
			return [
				{
					id = 1,
					type = "title",
					text = "Walka Sparingowa"
				},
				{
					id = 2,
					type = "description",
					text = "Każ swoim ludziom wziąć udział w walce sparingowej z doświadczonymi przeciwnikami, stosującymi różne style walki. Dzięki zarobionym siniakom i odbytym lekcjom postać zyska [color=" + this.Const.UI.Color.PositiveValue + "]+50%[/color] do zdobywanego doświadczenia podczas następnej bitwy."
				}
			];

		case "world-town-screen.training-dialog-module.Train2":
			return [
				{
					id = 1,
					type = "title",
					text = "Lekcje Weterana"
				},
				{
					id = 2,
					type = "description",
					text = "Niech twój człowiek nauczy się czegoś od prawdziwego weterana wojaczego rzemiosła, który da mu nieco wskazówek. Zyskana wiedza przełoży się na [color=" + this.Const.UI.Color.PositiveValue + "]+35%[/color] do zdobywanego doświadczenia na czas trzech bitew."
				}
			];

		case "world-town-screen.training-dialog-module.Train3":
			return [
				{
					id = 1,
					type = "title",
					text = "Rygorystyczne Szkolenie"
				},
				{
					id = 2,
					type = "description",
					text = "Niech twój człowiek przejdzie rygorystyczne szkolenie, które przemieni go w zdolnego wojaka. Krew i pot przelane dzisiaj zaprocentują na dłuższą metę i dadzą mu [color=" + this.Const.UI.Color.PositiveValue + "]+20%[/color] do zdobywanego doświadczenia na czas pięciu bitew."
				}
			];

		case "world-game-finish-screen.dialog-module.QuitButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Wyjdź z Gry"
				},
				{
					id = 2,
					type = "description",
					text = "Opuść grę i wróć do menu głównego. Twoje postępy nie zostaną zapisane."
				}
			];

		case "world-relations-screen.Relations":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Relacje"
				},
				{
					id = 2,
					type = "description",
					text = "Twoje relacje z frakcją decydują o tym, czy jej oddziały będą z tobą walczyć, czy też traktować cię pokojowo, na dostępność kontraktów, wysokość wynagrodzeń i dostępność ochotników w kontrolowanych przez daną frakcję osadach.\n\nRelacje poprawiają się, gdy skutecznie dla danej frakcji pracujesz, a pogarszają, gdy nie udaje ci się wypełnić kontraktu, dopuszczasz się zdrady czy wręcz atakujesz podwładnych frakcji. Z czasem relacje, tak wrogie, jak i przyjacielskie, ostudzają się i powoli dążą do neutralności."
				}
			];
			local changes = this.World.FactionManager.getFaction(_entityId).getPlayerRelationChanges();

			foreach( change in changes )
			{
				if (change.Positive)
				{
					ret.push({
						id = 11,
						type = "hint",
						icon = "ui/tooltips/positive.png",
						text = "" + change.Text + ""
					});
				}
				else
				{
					ret.push({
						id = 11,
						type = "hint",
						icon = "ui/tooltips/negative.png",
						text = "" + change.Text + ""
					});
				}
			}

			return ret;

		case "world-campfire-screen.Cart":
			local ret = [
				{
					id = 1,
					type = "title",
					text = this.Const.Strings.InventoryHeader[this.World.Retinue.getInventoryUpgrades()]
				},
				{
					id = 2,
					type = "description",
					text = "Kompania najemników zmuszona jest dźwigać sporo sprzętu i zapasów. Używając wozów i furmanek możesz powiększyć pojemność swego ekwipunku i targać ze sobą jeszcze więcej."
				}
			];

			if (this.World.Retinue.getInventoryUpgrades() < this.Const.Strings.InventoryUpgradeHeader.len())
			{
				ret.push({
					id = 1,
					type = "hint",
					icon = "ui/icons/mouse_left_button.png",
					text = this.Const.Strings.InventoryUpgradeHeader[this.World.Retinue.getInventoryUpgrades()] + " za [img]gfx/ui/tooltips/money.png[/img]" + this.Const.Strings.InventoryUpgradeCosts[this.World.Retinue.getInventoryUpgrades()]
				});
			}

			return ret;

		case "dlc_1":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Lindwurm"
				},
				{
					id = 2,
					type = "description",
					text = "Darmowy DLC \'Lindwurm\' dodaje nową bestię, która jest nie lada wyzwaniem, nową chorągiew dla gracza, a także nową osławioną zbroję, hełm i tarczę."
				}
			];

			if (this.Const.DLC.Lindwurm == true)
			{
				ret[1].text += "\n\n[color=" + this.Const.UI.Color.PositiveValue + "]Ten dodatek został zainstalowany.[/color]";
			}
			else
			{
				ret[1].text += "\n\n[color=" + this.Const.UI.Color.NegativeValue + "]Brakuje tego dodatku. Jest dostępny za darmo na platformach Steam i GOG![/color]";
			}

			ret.push({
				id = 1,
				type = "hint",
				icon = "ui/icons/mouse_left_button.png",
				text = "Otwórz stronę sklepu w przeglądarce"
			});
			return ret;

		case "dlc_2":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Bestie i Eksploracja"
				},
				{
					id = 2,
					type = "description",
					text = "DLC \'Bestie i Eksploracja\' dodaje szereg nowych bestii wędrujących po dziczy, nowy system craftingu, aby wytwarzać przedmioty z trofeów, legendarne lokacje z unikalnymi nagrodami, wiele nowych kontraktów i wydarzeń, nowy system komponentów zbroi, nowe bronie, pancerze i przedmioty użytkowe, a także wiele więcej."
				}
			];

			if (this.Const.DLC.Unhold == true)
			{
				ret[1].text += "\n\n[color=" + this.Const.UI.Color.PositiveValue + "]Ten dodatek został zainstalowany.[/color]";
			}
			else
			{
				ret[1].text += "\n\n[color=" + this.Const.UI.Color.NegativeValue + "]Brakuje tego dodatku. Można go kupić na platformach Steam lub GOG![/color]";
			}

			ret.push({
				id = 1,
				type = "hint",
				icon = "ui/icons/mouse_left_button.png",
				text = "Otwórz stronę sklepu w przeglądarce"
			});
			return ret;

		case "dlc_4":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Wojownicy Północy"
				},
				{
					id = 2,
					type = "description",
					text = "DLC \'Wojownicy Północy\' dodaje nową frakcję ludzką północnych barbarzyńców, posiadającą własny styl walki i ekwipunek; różne scenariusze rozpoczęcia gry, nowe wyposażenie inspirowane kulturą nordycką i Rusi, a także nowe kontrakty i wydarzenia."
				}
			];

			if (this.Const.DLC.Wildmen == true)
			{
				ret[1].text += "\n\n[color=" + this.Const.UI.Color.PositiveValue + "]Ten dodatek został zainstalowany.[/color]";
			}
			else
			{
				ret[1].text += "\n\n[color=" + this.Const.UI.Color.NegativeValue + "]Brakuje tego dodatku. Można go kupić na platformach Steam lub GOG![/color]";
			}

			ret.push({
				id = 1,
				type = "hint",
				icon = "ui/icons/mouse_left_button.png",
				text = "Otwórz stronę sklepu w przeglądarce"
			});
			return ret;

		case "dlc_6":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Gorejące Pustynie"
				},
				{
					id = 2,
					type = "description",
					text = "DLC \'Gorejące Pustynie\' dodaje nowy pustynny region na południu, inspirowany średniowiecznymi kulturami arabskimi i perskimi, nowy kryzys późniejszego etapu gry (Świętą Wojnę), świtę niewalczących towarzyszy dla twojej kompanii, urządzenia alchemiczne i prymitywną broń palną, nowych przeciwników, nowe kontrakty i wydarzenia, i więcej..."
				}
			];

			if (this.Const.DLC.Desert == true)
			{
				ret[1].text += "\n\n[color=" + this.Const.UI.Color.PositiveValue + "]Ten dodatek został zainstalowany.[/color]";
			}
			else
			{
				ret[1].text += "\n\n[color=" + this.Const.UI.Color.NegativeValue + "]Brakuje tego dodatku. Można go kupić na platformach Steam lub GOG![/color]";
			}

			ret.push({
				id = 1,
				type = "hint",
				icon = "ui/icons/mouse_left_button.png",
				text = "Otwórz stronę sklepu w przeglądarce"
			});
			return ret;

		case "dlc_8":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "O Ciele i Wierze"
				},
				{
					id = 2,
					type = "description",
					text = "Darmowy dodatek \'O Ciele i Wierze\' wprowadza dwa nowe i wyjątkowe początkowe scenariusze: Anatomowie oraz Przysięgający. Co więcej, dostępne są dwa nowe sztandary, nowe przedmioty, nowe postacie do zwerbowania oraz mnóstwo nowych wydarzeń losowych."
				}
			];

			if (this.Const.DLC.Paladins == true)
			{
				ret[1].text += "\n\n[color=" + this.Const.UI.Color.PositiveValue + "]Ten dodatek został zainstalowany.[/color]";
			}
			else
			{
				ret[1].text += "\n\n[color=" + this.Const.UI.Color.NegativeValue + "]Brakuje tego dodatku. Jest dostępny za darmo na platformach Steam i GOG![/color]";
			}

			ret.push({
				id = 1,
				type = "hint",
				icon = "ui/icons/mouse_left_button.png",
				text = "Otwórz stronę sklepu w przeglądarce"
			});
			return ret;

		case "polska_wersja":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Polska Wersja"
				},
				{
					id = 2,
					type = "description",
					text = "Nieoficjalne polskie tłumaczenie gry.\n\nOpracowanie:\nSławomir Libura \'Daedalus\'\n\nKontakt:\ndaedalus.pl@gmail.com\n\nWWW:\nwww.daedalus.pl"
				}
			];
			ret.push({
				id = 1,
				type = "hint",
				icon = "ui/icons/mouse_left_button.png",
				text = "Otwórz stronę w przeglądarce"
			});
			return ret;
		}

		return null;
	}

};

