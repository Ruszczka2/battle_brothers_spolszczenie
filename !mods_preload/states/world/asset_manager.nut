::mods_hookNewObject("states/world/asset_manager", function ( o )
{
	o.getAllBrotherNames = function ()
	{
		local ret = "";
		local roster = this.World.getPlayerRoster().getAll();

		for( local i = 0; i < roster.len(); i = i )
		{
			if (i != 0)
			{
				if (i == roster.len() - 1)
				{
					ret = ret + " i ";
				}
				else
				{
					ret = ret + ", ";
				}
			}

			ret = ret + roster[i].getName();
			i = ++i;
		}

		return ret;
	};
	o.update = function ( _worldState )
	{
		if (this.World.getTime().Days > this.m.LastDayPaid && this.World.getTime().Hours > 8 && this.m.IsConsumingAssets)
		{
			this.m.LastDayPaid = this.World.getTime().Days;

			if (this.m.BusinessReputation > 0)
			{
				this.m.BusinessReputation = this.Math.max(0, this.m.BusinessReputation + this.Const.World.Assets.ReputationDaily);
			}

			this.World.Retinue.onNewDay();

			if (this.World.Flags.get("IsGoldenGoose") == true)
			{
				this.addMoney(15);
			}

			local roster = this.World.getPlayerRoster().getAll();
			local mood = 0;
			local slaves = 0;
			local nonSlaves = 0;

			if (this.m.Origin.getID() == "scenario.manhunters")
			{
				foreach( bro in roster )
				{
					if (bro.getBackground().getID() == "background.slave")
					{
						slaves = ++slaves;
						slaves = slaves;
					}
					else
					{
						nonSlaves = ++nonSlaves;
						nonSlaves = nonSlaves;
					}
				}
			}

			foreach( bro in roster )
			{
				bro.getSkills().onNewDay();
				bro.updateInjuryVisuals();

				if (bro.getDailyCost() > 0 && this.m.Money < bro.getDailyCost())
				{
					if (bro.getSkills().hasSkill("trait.greedy"))
					{
						bro.worsenMood(this.Const.MoodChange.NotPaidGreedy, "Nie otrzymał żołdu");
					}
					else
					{
						bro.worsenMood(this.Const.MoodChange.NotPaid, "Nie otrzymał żołdu");
					}
				}

				if (this.m.IsUsingProvisions && this.m.Food < bro.getDailyFood())
				{
					if (bro.getSkills().hasSkill("trait.spartan"))
					{
						bro.worsenMood(this.Const.MoodChange.NotEatenSpartan, "Głodował");
					}
					else if (bro.getSkills().hasSkill("trait.gluttonous"))
					{
						bro.worsenMood(this.Const.MoodChange.NotEatenGluttonous, "Głodował");
					}
					else
					{
						bro.worsenMood(this.Const.MoodChange.NotEaten, "Głodował");
					}
				}

				if (this.m.Origin.getID() == "scenario.manhunters" && slaves <= nonSlaves)
				{
					if (bro.getBackground().getID() != "background.slave")
					{
						bro.worsenMood(this.Const.MoodChange.TooFewSlaves, "Zbyt mało zadłużonych w kompanii");
					}
				}

				this.m.Money -= bro.getDailyCost();
				mood = mood + bro.getMoodState();
			}

			this.Sound.play(this.Const.Sound.MoneyTransaction[this.Math.rand(0, this.Const.Sound.MoneyTransaction.len() - 1)], this.Const.Sound.Volume.Inventory);
			this.m.AverageMoodState = this.Math.round(mood / roster.len());
			_worldState.updateTopbarAssets();

			if (this.m.EconomicDifficulty >= 1 && this.m.CombatDifficulty >= 1)
			{
				if (this.World.getTime().Days >= 365)
				{
					this.updateAchievement("Anniversary", 1, 1);
				}
				else if (this.World.getTime().Days >= 100)
				{
					this.updateAchievement("Campaigner", 1, 1);
				}
				else if (this.World.getTime().Days >= 10)
				{
					this.updateAchievement("Survivor", 1, 1);
				}
			}
		}

		if (this.World.getTime().Hours != this.m.LastHourUpdated && this.m.IsConsumingAssets)
		{
			this.m.LastHourUpdated = this.World.getTime().Hours;
			this.consumeFood();
			local roster = this.World.getPlayerRoster().getAll();
			local campMultiplier = this.isCamping() ? this.m.CampingMult : 1.0;

			foreach( bro in roster )
			{
				local d = bro.getHitpointsMax() - bro.getHitpoints();

				if (bro.getHitpoints() < bro.getHitpointsMax())
				{
					bro.setHitpoints(this.Math.minf(bro.getHitpointsMax(), bro.getHitpoints() + (this.Const.World.Assets.HitpointsPerHour + this.m.AdditionalHitpointsPerHour) * campMultiplier * this.m.HitpointsPerHourMult));
				}
			}

			foreach( bro in roster )
			{
				if (this.m.ArmorParts == 0)
				{
					break;
				}

				local items = bro.getItems().getAllItems();
				local updateBro = false;

				foreach( item in items )
				{
					if (item.getCondition() < item.getConditionMax())
					{
						local d = this.Math.minf(this.Const.World.Assets.ArmorPerHour * campMultiplier * this.m.RepairSpeedMult, item.getConditionMax() - item.getCondition());
						item.improveCondition(d);
						this.m.ArmorParts = this.Math.maxf(0, this.m.ArmorParts - d * this.m.ArmorPartsPerArmor);
						updateBro = true;
					}

					if (item.getCondition() >= item.getConditionMax())
					{
						item.setToBeRepaired(false);
					}

					if (this.m.ArmorParts == 0)
					{
						break;
					}
				}

				if (updateBro)
				{
					bro.getSkills().update();
				}
			}

			local items = this.m.Stash.getItems();

			foreach( item in items )
			{
				if (this.m.ArmorParts == 0)
				{
					break;
				}

				if (item == null)
				{
					continue;
				}

				if (item.isToBeRepaired())
				{
					if (item.getCondition() < item.getConditionMax())
					{
						local d = this.Math.minf(this.Const.World.Assets.ArmorPerHour * campMultiplier, item.getConditionMax() - item.getCondition());
						item.improveCondition(d);
						this.m.ArmorParts = this.Math.maxf(0, this.m.ArmorParts - d * this.m.ArmorPartsPerArmor);
					}

					if (item.getCondition() >= item.getConditionMax())
					{
						item.setToBeRepaired(false);
					}
				}
			}

			if (this.World.getTime().Hours % 4 == 0)
			{
				this.checkDesertion();
				local towns = this.World.EntityManager.getSettlements();
				local playerTile = this.World.State.getPlayer().getTile();
				local town;

				foreach( t in towns )
				{
					if (t.getSize() >= 2 && !t.isMilitary() && t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
					{
						town = t;
						break;
					}
				}

				foreach( bro in roster )
				{
					bro.recoverMood();

					if (town != null && bro.getMoodState() <= this.Const.MoodState.Neutral)
					{
						bro.improveMood(this.Const.MoodChange.NearCity, "Uradowała go wizyta w " + town.getName());
					}
				}
			}

			_worldState.updateTopbarAssets();
		}
	};
	o.checkAmbitionItems = function ()
	{
		local supposedToHaveStandard = this.World.Ambitions.getAmbition("ambition.battle_standard").isDone();
		local supposedToHaveSergeant = this.World.Ambitions.getAmbition("ambition.sergeant").isDone();
		local hasStandard = false;
		local hasSergeant = false;

		if (supposedToHaveStandard || supposedToHaveSergeant)
		{
			local items = this.m.Stash.getItems();

			foreach( item in items )
			{
				if (item != null)
				{
					if (item.getID() == "weapon.player_banner")
					{
						hasStandard = true;
					}
					else if (item.getID() == "accessory.sergeant_badge")
					{
						hasSergeant = true;
					}
				}
			}

			local roster = this.World.getPlayerRoster().getAll();

			foreach( bro in roster )
			{
				local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

				if (item != null && item.getID() == "weapon.player_banner")
				{
					hasStandard = true;
				}

				item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

				if (item != null && item.getID() == "accessory.sergeant_badge")
				{
					hasSergeant = true;
				}

				for( local i = 0; i < bro.getItems().getUnlockedBagSlots(); i = i )
				{
					item = bro.getItems().getItemAtBagSlot(i);

					if (item != null && item.getID() == "weapon.player_banner")
					{
						hasStandard = true;
					}
					else if (item != null && item.getID() == "accessory.sergeant_badge")
					{
						hasSergeant = true;
					}

					i = ++i;
				}
			}

			if (supposedToHaveStandard && !hasStandard)
			{
				this.World.Ambitions.getAmbition("ambition.battle_standard").setDone(false);

				foreach( bro in roster )
				{
					bro.worsenMood(this.Const.MoodChange.StandardLost, "Utracono chorągiew kompanii");
				}
			}

			if (supposedToHaveSergeant && !hasSergeant)
			{
				this.World.Ambitions.getAmbition("ambition.sergeant").setDone(false);
			}
		}
	};
});

