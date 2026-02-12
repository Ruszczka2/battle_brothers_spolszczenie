this.sickness_injury <- this.inherit("scripts/skills/injury/injury", {
	m = {},
	function create()
	{
		this.injury.create();
		this.m.ID = "injury.sickness";
		this.m.Name = "Choroba";
		this.m.Description = "Ta postać została ogarnięta chorobą, fatalnie się czuje i niezbyt nadaje się do walki. Jeśli gorączka nie okaże się zabójcza, to choroba pewnie minie z czasem.";
		this.m.Type = this.m.Type | this.Const.SkillType.StatusEffect | this.Const.SkillType.SemiInjury;
		this.m.DropIcon = "injury_icon_25";
		this.m.Icon = "ui/injury/injury_icon_25.png";
		this.m.IconMini = "injury_icon_25_mini";
		this.m.HealingTimeMin = 1;
		this.m.HealingTimeMax = 3;
		this.m.IsAlwaysInEffect = true;
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/health.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] do Zdrowia"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] maksymalnego zmęczenia"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] do Inicjatywy"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] do Stanowczości"
			},
			{
				id = 14,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] do Ataku w zwarciu"
			},
			{
				id = 15,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] do Ataku dystansowego"
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] do Obrony w zwarciu"
			},
			{
				id = 17,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] do Obrony dystansowej"
			},
			{
				id = 17,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-2[/color] do Wzroku"
			}
		];
		this.addTooltipHint(ret);
		return ret;
	}

	function onAdded()
	{
		this.injury.onAdded();
		local bro = this.getContainer().getActor();

		if (bro.isPlacedOnMap())
		{
			this.Sound.play("sounds/vomit_01.wav", this.Const.Sound.Volume.Actor, bro.getPos());
			local myTile = bro.getTile();
			local candidates = [];

			for( local i = 0; i < 6; i = i )
			{
				if (!myTile.hasNextTile(i))
				{
				}
				else
				{
					local next = myTile.getNextTile(i);

					if (next.IsEmpty)
					{
						candidates.push(next);
					}
				}

				i = ++i;
			}

			if (candidates.len() == 0)
			{
				candidates.push(myTile);
			}

			myTile = candidates[this.Math.rand(0, candidates.len() - 1)];
			myTile.spawnDetail("detail_vomit");
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(bro) + " jest teraz chory");
		}
	}

	function onTurnStart()
	{
		if (this.Math.rand(1, 100) <= 90)
		{
			return;
		}

		local bro = this.getContainer().getActor();
		this.Sound.play("sounds/vomit_01.wav", this.Const.Sound.Volume.Actor, bro.getPos());
		local myTile = bro.getTile();
		local candidates = [];

		for( local i = 0; i < 6; i = i )
		{
			if (!myTile.hasNextTile(i))
			{
			}
			else
			{
				local next = myTile.getNextTile(i);

				if (next.IsEmpty)
				{
					candidates.push(next);
				}
			}

			i = ++i;
		}

		if (candidates.len() == 0)
		{
			candidates.push(myTile);
		}

		myTile = candidates[this.Math.rand(0, candidates.len() - 1)];
		myTile.spawnDetail("detail_vomit");
		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(bro) + " wymiotuje");
	}

	function onUpdate( _properties )
	{
		this.injury.onUpdate(_properties);
		_properties.HitpointsMult *= 0.75;
		_properties.BraveryMult *= 0.75;
		_properties.InitiativeMult *= 0.75;
		_properties.StaminaMult *= 0.75;
		_properties.MeleeSkill *= 0.75;
		_properties.RangedSkill *= 0.75;
		_properties.MeleeDefense *= 0.75;
		_properties.RangedDefense *= 0.75;
		_properties.Vision += -2;
	}

});

