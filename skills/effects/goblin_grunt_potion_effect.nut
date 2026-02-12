this.goblin_grunt_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.goblin_grunt_potion";
		this.m.Name = "Reaktywne Mięśnie Nóg";
		this.m.Icon = "skills/status_effect_124.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_124";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Nogi tej postaci zmutowały, pozwalając jej na wykonywanie zwinnych, złożonych ruchów z większą gracją i szybkością. W stanie odpoczynku, można nadal zaobserwować, jak mięśnie od czasu do czasu drgają pod skórą.";
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
				id = 11,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "Koszt Punktów Akcji dla umiejętności \'Rotacja\' i \'Praca Nóg\' jest zmniejszony do [color=" + this.Const.UI.Color.PositiveValue + "]2[/color]"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "Umiejętności \'Rotacja\' i \'Praca Nóg\' generują o [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] mniej Zmęczenia"
			},
			{
				id = 12,
				type = "hint",
				icon = "ui/tooltips/warning.png",
				text = "Dalsze mutacje spowodują dłuższy okres trwania choroby"
			}
		];
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.IsFleetfooted = true;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isGoblinGruntPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isGoblinGruntPotionAcquired", false);
	}

});

