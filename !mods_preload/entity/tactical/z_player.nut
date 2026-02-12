::mods_hookClass("entity/tactical/player", function ( o )
{
	while (!("getTooltip" in o))
	{
		o = o[o.SuperName];
	}

	o.getTooltip = function ( _targetedWithSkill = null )
	{
		if (!this.isPlacedOnMap() || !this.isAlive() || this.isDying())
		{
			return [];
		}

		local turnsToGo = this.Tactical.TurnSequenceBar.getTurnsUntilActive(this.getID());
		local tooltip = [
			{
				id = 1,
				type = "title",
				text = this.getName(),
				icon = "ui/tooltips/height_" + this.getTile().Level + ".png"
			}
		];

		if (!this.isPlayerControlled() && _targetedWithSkill != null && this.isKindOf(_targetedWithSkill, "skill"))
		{
			local tile = this.getTile();

			if (tile.IsVisibleForEntity && _targetedWithSkill.isUsableOn(this.getTile()))
			{
				tooltip.push({
					id = 3,
					type = "headerText",
					icon = "ui/icons/hitchance.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]" + _targetedWithSkill.getHitchance(this) + "%[/color] szansy na trafienie",
					children = _targetedWithSkill.getHitFactors(tile)
				});
			}
		}

		tooltip.extend([
			{
				id = 2,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = this.Tactical.TurnSequenceBar.getActiveEntity() == this ? "Właśnie wykonuje ruch!" : this.m.IsTurnDone || turnsToGo == null ? "Tura zakończona" : "Wykona ruch za " + turnsToGo + (turnsToGo > 1 ? (turnsToGo > 4 ? " tur" : " tury") : " turę")
			},
			{
				id = 3,
				type = "progressbar",
				icon = "ui/icons/armor_head.png",
				value = this.getArmor(this.Const.BodyPart.Head),
				valueMax = this.getArmorMax(this.Const.BodyPart.Head),
				text = "" + this.getArmor(this.Const.BodyPart.Head) + " / " + this.getArmorMax(this.Const.BodyPart.Head) + "",
				style = "armor-head-slim"
			},
			{
				id = 4,
				type = "progressbar",
				icon = "ui/icons/armor_body.png",
				value = this.getArmor(this.Const.BodyPart.Body),
				valueMax = this.getArmorMax(this.Const.BodyPart.Body),
				text = "" + this.getArmor(this.Const.BodyPart.Body) + " / " + this.getArmorMax(this.Const.BodyPart.Body) + "",
				style = "armor-body-slim"
			},
			{
				id = 5,
				type = "progressbar",
				icon = "ui/icons/health.png",
				value = this.getHitpoints(),
				valueMax = this.getHitpointsMax(),
				text = "" + this.getHitpoints() + " / " + this.getHitpointsMax() + "",
				style = "hitpoints-slim"
			},
			{
				id = 6,
				type = "progressbar",
				icon = "ui/icons/morale.png",
				value = this.getMoraleState(),
				valueMax = this.Const.MoraleState.COUNT - 1,
				text = this.Const.MoraleStateName[this.getMoraleState()],
				style = "morale-slim"
			},
			{
				id = 7,
				type = "progressbar",
				icon = "ui/icons/fatigue.png",
				value = this.getFatigue(),
				valueMax = this.getFatigueMax(),
				text = "" + this.getFatigue() + " / " + this.getFatigueMax() + "",
				style = "fatigue-slim"
			}
		]);
		local result = [];
		local statusEffects = this.getSkills().query(this.Const.SkillType.StatusEffect | this.Const.SkillType.TemporaryInjury, false, true);

		foreach( i, statusEffect in statusEffects )
		{
			tooltip.push({
				id = 100 + i,
				type = "text",
				icon = statusEffect.getIcon(),
				text = statusEffect.getName()
			});
		}

		return tooltip;
	};
	o.getRosterTooltip = function ()
	{
		local tooltip = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			}
		];
		local time = this.getDaysWithCompany();
		local text;

		if (!this.isGuest())
		{
			if (this.m.Background != null && this.m.Background.getID() == "background.companion")
			{
				text = "Z kompanią od samego początku.";
			}
			else if (time > 1)
			{
				text = "Z kompanią od " + time + " dni.";
			}
			else
			{
				text = "Dopiero co dołączył do kompanii.";
			}

			if (this.m.LifetimeStats.Battles != 0)
			{
				if (this.m.LifetimeStats.Battles == 1)
				{
					text = text + (" Wziął udział w " + this.m.LifetimeStats.Battles + " bitwie");
				}
				else
				{
					text = text + (" Wziął udział w " + this.m.LifetimeStats.Battles + " bitwach");
				}

				if (this.m.LifetimeStats.Kills == 1)
				{
					text = text + (" i zabił " + this.m.LifetimeStats.Kills + " istotę.");
				}
				else if (this.m.LifetimeStats.Kills > 1)
				{
					text = text + (" i zabił " + this.m.LifetimeStats.Kills + " istot(y).");
				}
				else
				{
					text = text + ".";
				}

				if (this.m.LifetimeStats.MostPowerfulVanquished != "")
				{
					text = text + (" Najpotężniejszy przeciwnik, jakiego pokonał to " + this.m.LifetimeStats.MostPowerfulVanquished + ".");
				}
			}

			tooltip.push({
				id = 2,
				type = "description",
				text = text
			});
			tooltip.push({
				id = 5,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "Poziom " + this.m.Level
			});

			if (this.getDailyCost() != 0)
			{
				tooltip.push({
					id = 3,
					type = "text",
					icon = "ui/icons/asset_daily_money.png",
					text = "Żołd: [img]gfx/ui/tooltips/money.png[/img]" + this.getDailyCost() + " dziennie"
				});
			}

			tooltip.push({
				id = 4,
				type = "text",
				icon = this.Const.MoodStateIcon[this.getMoodState()],
				text = this.Const.MoodStateName[this.getMoodState()]
			});

			if (this.m.PlaceInFormation <= 17)
			{
				tooltip.push({
					id = 6,
					type = "hint",
					icon = "ui/icons/stat_screen_dmg_dealt.png",
					text = "W szeregach bojowych"
				});
			}
			else
			{
				tooltip.push({
					id = 6,
					type = "hint",
					icon = "ui/icons/camp.png",
					text = "W rezerwie"
				});
			}
		}

		local injuries = this.getSkills().query(this.Const.SkillType.Injury | this.Const.SkillType.SemiInjury);

		foreach( injury in injuries )
		{
			if (injury.isType(this.Const.SkillType.TemporaryInjury))
			{
				local ht = injury.getHealingTime();

				if (ht.Min != ht.Max)
				{
					tooltip.push({
						id = 90,
						type = "text",
						icon = injury.getIcon(),
						text = injury.getName() + " (" + ht.Min + "-" + ht.Max + " dni)"
					});
				}
				else if (ht.Min > 1)
				{
					tooltip.push({
						id = 90,
						type = "text",
						icon = injury.getIcon(),
						text = injury.getName() + " (" + ht.Min + " dni)"
					});
				}
				else
				{
					tooltip.push({
						id = 90,
						type = "text",
						icon = injury.getIcon(),
						text = injury.getName() + " (" + ht.Min + " dzień)"
					});
				}
			}
			else
			{
				tooltip.push({
					id = 90,
					type = "text",
					icon = injury.getIcon(),
					text = injury.getName()
				});
			}
		}

		if (this.getHitpoints() < this.getHitpointsMax())
		{
			local ht = this.Math.ceil((this.getHitpointsMax() - this.getHitpoints()) / ((this.Const.World.Assets.HitpointsPerHour + this.World.Assets.m.AdditionalHitpointsPerHour) * (("State" in this.World) && this.World.State != null ? this.World.Assets.m.HitpointsPerHourMult : 1.0)) / 24.0);

			if (ht > 1)
			{
				tooltip.push({
					id = 133,
					type = "text",
					icon = "ui/icons/days_wounded.png",
					text = "Lekkie rany (" + ht + " dni)"
				});
			}
			else
			{
				tooltip.push({
					id = 133,
					type = "text",
					icon = "ui/icons/days_wounded.png",
					text = "Lekkie rany (" + ht + " dzień)"
				});
			}
		}

		return tooltip;
	};
	o.onHired = function ()
	{
		this.m.HireTime = this.Time.getVirtualTimeF();

		if (this.getBackground().getID() != "background.slave")
		{
			this.improveMood(1.5, "Dołączył do kompanii najemników");
		}

		if (("State" in this.World) && this.World.State != null && this.World.Assets.getOrigin() != null)
		{
			this.World.Assets.getOrigin().onHired(this);
		}

		if (this.World.getPlayerRoster().getSize() >= 12)
		{
			this.updateAchievement("AFullCompany", 1, 1);
		}

		if (this.World.getPlayerRoster().getSize() >= 20)
		{
			this.updateAchievement("PowerInNumbers", 1, 1);
		}

		if (this.World.getPlayerRoster().getSize() == 25 && this.World.Assets.getOrigin().getID() == "scenario.militia")
		{
			this.updateAchievement("HumanWave", 1, 1);
		}
	};
	o.isReallyKilled = function ( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.None)
		{
			return true;
		}

		if (this.Tactical.State.isScenarioMode())
		{
			return true;
		}

		if (this.Tactical.State.isAutoRetreat())
		{
			return true;
		}

		if (this.isGuest())
		{
			return true;
		}

		if (this.Math.rand(1, 100) <= this.Const.Combat.SurviveWithInjuryChance * this.m.CurrentProperties.SurviveWithInjuryChanceMult || this.World.Assets.m.IsSurvivalGuaranteed && !this.m.Skills.hasSkillOfType(this.Const.SkillType.PermanentInjury) && (this.World.Assets.getOrigin().getID() != "scenario.manhunters" || this.getBackground().getID() != "background.slave"))
		{
			local potential = [];
			local injuries = this.Const.Injury.Permanent;
			local numPermInjuries = 0;

			foreach( inj in injuries )
			{
				if (!this.m.Skills.hasSkill(inj.ID))
				{
					potential.push(inj);
				}
				else
				{
					numPermInjuries = ++numPermInjuries;
					numPermInjuries = numPermInjuries;
				}
			}

			if (potential.len() != 0)
			{
				local skill = this.new("scripts/skills/" + potential[this.Math.rand(0, potential.len() - 1)].Script);
				this.m.Skills.add(skill);
				this.Tactical.getSurvivorRoster().add(this);
				this.m.IsDying = false;
				this.worsenMood(this.Const.MoodChange.PermanentInjury, "Otrzymał permanentną ranę");
				this.updateAchievement("ScarsForLife", 1, 1);

				if (numPermInjuries + 1 >= 3)
				{
					this.updateAchievement("HardToKill", 1, 1);
				}

				return false;
			}
		}

		return true;
	};
	o.getObituaryInfo = function ( _skill, _killer, _fatalityType )
	{
		local killedBy;

		if (_fatalityType == this.Const.FatalityType.Devoured)
		{
			killedBy = "Pożarty przez Nachzehrera";
		}
		else if (_fatalityType == this.Const.FatalityType.Kraken)
		{
			killedBy = "Pożarty przez Krakena";
		}
		else if (_fatalityType == this.Const.FatalityType.Suicide)
		{
			killedBy = "Popełnił samobójstwo";
		}
		else if (_skill.isType(this.Const.SkillType.StatusEffect))
		{
			killedBy = _skill.getKilledString();
		}
		else if (_killer.getID() == this.getID())
		{
			killedBy = "Poległ w bitwie";
		}
		else
		{
			if (_fatalityType == this.Const.FatalityType.Decapitated)
			{
				killedBy = "Zdekapitowany";
			}
			else if (_fatalityType == this.Const.FatalityType.Disemboweled)
			{
				if (this.Math.rand(1, 2) == 1)
				{
					killedBy = "Wypatroszony";
				}
				else
				{
					killedBy = "Wybebeszony";
				}
			}
			else
			{
				killedBy = _skill.getKilledString();
			}

			killedBy = killedBy + (" przez: " + _killer.getKilledName());
		}

		local fallen = {
			Name = this.getName(),
			Time = this.World.getTime().Days,
			TimeWithCompany = this.Math.max(1, this.getDaysWithCompany()),
			Kills = this.m.LifetimeStats.Kills,
			Battles = this.m.LifetimeStats.Battles + 1,
			KilledBy = killedBy,
			Expendable = this.getBackground().getID() == "background.slave"
		};
		return fallen;
	};
	o.addInjury = function ( _injuries, _maxThreshold = 1.0, _isOutOfCombat = true )
	{
		if (_injuries.len() == 0)
		{
			return null;
		}

		local candidates = [];

		foreach( inj in _injuries )
		{
			if (inj.Threshold <= _maxThreshold && !this.m.Skills.hasSkill(inj.ID))
			{
				candidates.push(inj.Script);
			}
		}

		if (candidates.len() == 0)
		{
			return null;
		}

		local injury;

		while (candidates.len() != 0)
		{
			local r = this.Math.rand(0, candidates.len() - 1);
			injury = this.new("scripts/skills/" + candidates[r]);

			if (!injury.isValid(this))
			{
				candidates.remove(r);
				injury = null;
				continue;
			}

			break;
		}

		if (injury == null)
		{
			return null;
		}

		if (_isOutOfCombat)
		{
			injury.setOutOfCombat(true);
		}
		else
		{
			this.worsenMood(this.Const.MoodChange.Injury, "Odniósł ranę");
		}

		this.m.Skills.add(injury);
		this.setHitpoints(this.Math.max(1, this.getHitpoints() - this.Math.rand(5, 20)));
		this.updateInjuryVisuals();
		return injury;
	};
	o.retreat = function ()
	{
		if (!this.isHiddenToPlayer())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this) + " wycofuje się z bitwy");
		}

		this.m.IsTurnDone = true;
		this.m.IsAbleToDie = false;
		this.Tactical.getRetreatRoster().add(this);
		this.removeFromMap();
		this.Tactical.Entities.setLastCombatResult(this.Const.Tactical.CombatResult.PlayerRetreated);
	};
});

