this.grand_diviner <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Type = this.Const.EntityType.GrandDiviner;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.GrandDiviner.XP;
		this.human.create();
		this.m.Faces = this.Const.Faces.Necromancer;
		this.m.Hairs = this.Const.Hair.Necromancer;
		this.m.HairColors = this.Const.HairColors.Zombie;
		this.m.Beards = null;
		this.m.ConfidentMoraleBrush = "icon_confident_undead";
		this.m.Sound[this.Const.Sound.ActorEvent.Resurrect] = [
			"sounds/enemies/diviner_resurrect_01.wav",
			"sounds/enemies/diviner_resurrect_02.wav"
		];
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Resurrect] = 2.0;
		this.m.SoundPitch = 0.9;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/grand_diviner_agent");
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.GrandDiviner);
		b.IsAffectedByNight = false;
		b.Vision = 8;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.getSprite("socket").setBrush("bust_base_undead");
		this.getSprite("head").Color = this.createColor("#ffffff");
		this.getSprite("head").Saturation = 1.0;
		this.getSprite("body").Saturation = 0.6;
		b.IsSpecializedInFlails = true;
		this.m.Skills.add(this.new("scripts/skills/perks/perk_adrenalin"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_hold_out"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_anticipation"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_reach_advantage"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_nimble"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fearsome"));
		this.m.Skills.add(this.new("scripts/skills/racial/grand_diviner_racial"));
		this.m.Skills.add(this.new("scripts/skills/actives/footwork"));
		this.m.Skills.add(this.new("scripts/skills/actives/corpse_explosion_skill"));
	}

	function onPossess( _data )
	{
		local newDiviner = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/grand_diviner", _data.SpawnTile.Coords);
		newDiviner.assignRandomEquipment();
		newDiviner.setFaction(_data.Faction);
		newDiviner.setMoraleState(this.Const.MoraleState.Confident);
		newDiviner.riseFromGround();
		this.Tactical.Entities.setBusy(false);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		local instances = this.Tactical.Entities.getAllInstances();
		local faultfinders = [];

		foreach( instance in instances )
		{
			foreach( actor in instance )
			{
				if (actor.getFaction() == this.getFaction() && actor.getType() == this.Const.EntityType.FaultFinder)
				{
					faultfinders.push(actor);
				}
			}
		}

		if (faultfinders.len() == 0)
		{
			this.human.onDeath(_killer, _skill, _tile, _fatalityType);
			return;
		}

		this.Tactical.Entities.setBusy(true);
		local nearestFaultfinder = faultfinders[0];

		foreach( faultfinder in faultfinders )
		{
			if (faultfinder.getTile().getDistanceTo(_tile) < nearestFaultfinder.getTile().getDistanceTo(_tile))
			{
				nearestFaultfinder = faultfinder;
			}
		}

		local spawnTile = nearestFaultfinder.getTile();
		nearestFaultfinder.kill(null, null);
		this.Time.scheduleEvent(this.TimeUnit.Real, 300, this.onPossess.bindenv(this), {
			SpawnTile = spawnTile,
			Faction = this.getFaction()
		});
		local miasma_effect = {
			Type = "miasma",
			Tooltip = "Pozostał tu wyziew groźny dla każdej żyjącej istoty",
			IsPositive = false,
			IsAppliedAtRoundStart = false,
			IsAppliedAtTurnEnd = true,
			IsAppliedOnMovement = false,
			IsAppliedOnEnter = false,
			IsByPlayer = false,
			Timeout = this.Time.getRound() + 3,
			Callback = this.Const.Tactical.Common.onApplyMiasma,
			function Applicable( _a )
			{
				return !_a.getFlags().has("undead");
			}

		};

		if (_tile.Properties.Effect != null && _tile.Properties.Effect.Type == "miasma")
		{
			_tile.Properties.Effect.Timeout = this.Time.getRound() + 3;
		}
		else
		{
			if (_tile.Properties.Effect != null)
			{
				this.Tactical.Entities.removeTileEffect(_tile);
			}

			_tile.Properties.Effect = clone miasma_effect;
			local particles = [];

			for( local i = 0; i < this.Const.Tactical.MiasmaParticles.len(); i = i )
			{
				particles.push(this.Tactical.spawnParticleEffect(true, this.Const.Tactical.MiasmaParticles[i].Brushes, _tile, this.Const.Tactical.MiasmaParticles[i].Delay, this.Const.Tactical.MiasmaParticles[i].Quantity, this.Const.Tactical.MiasmaParticles[i].LifeTimeQuantity, this.Const.Tactical.MiasmaParticles[i].SpawnRate, this.Const.Tactical.MiasmaParticles[i].Stages));
				i = ++i;
			}

			this.Tactical.Entities.addTileEffect(_tile, _tile.Properties.Effect, particles);
		}

		this.human.onDeath(_killer, _skill, null, this.Const.FatalityType.Unconscious);
	}

	function assignRandomEquipment()
	{
		this.m.Items.equip(this.new("scripts/items/weapons/legendary/miasma_flail_enemy"));
		this.m.Items.equip(this.new("scripts/items/armor/golems/grand_diviner_robes_enemy"));
		this.m.Items.equip(this.new("scripts/items/helmets/golems/grand_diviner_headdress_enemy"));
	}

	function sortByNearest( _a, _b )
	{
		if (_a.getTile().getDistanceTo(this._tile) < _b.getTile().getDistanceTo(this._tile))
		{
			return -1;
		}
		else if (_a.getTile().getDistanceTo(this._tile) > _b.getTile().getDistanceTo(this._tile))
		{
			return 1;
		}

		return 0;
	}

});

