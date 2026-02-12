this.new_trained_effect <- this.inherit("scripts/skills/skill", {
	m = {
		XPGainMult = 1.0,
		Duration = 0,
		Battles = 0,
		IsCountingBattle = false
	},
	function create()
	{
		this.m.ID = "effects.trained";
		this.m.Name = "Doświadczenie Treningowe";
		this.m.Description = "Mając niedawno zaszczyt ćwiczyć i uczyć się pod okiem doświadczonych wojowników, ta postać jest wręcz przesiąknięta wiedzą i musi teraz zastosować ją na polu bitwy, aby w całości ją przyswoić.";
		this.m.Icon = "skills/status_effect_62.png";
		this.m.Type = this.m.Type | this.Const.SkillType.StatusEffect;
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
				id = 13,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + (this.m.XPGainMult * 100 - 100) + "%[/color] do zdobywanego doświadczenia"
			}
		];
		ret.push({
			id = 7,
			type = "hint",
			icon = "ui/icons/action_points.png",
			text = "Efekt zniknie po następnych " + (this.m.Duration - this.m.Battles) + " bitwach"
		});
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.XPGainMult *= this.m.XPGainMult;
	}

	function onCombatStarted()
	{
		this.m.IsCountingBattle = true;
	}

	function onCombatFinished()
	{
		if (!this.m.IsCountingBattle)
		{
			return;
		}

		this.m.IsCountingBattle = false;
		++this.m.Battles;

		if (this.m.Battles >= this.m.Duration)
		{
			this.removeSelf();
		}
	}

	function onSerialize( _out )
	{
		this.skill.onSerialize(_out);
		_out.writeU16(this.m.Duration);
		_out.writeU16(this.m.Battles);
		_out.writeF32(this.m.XPGainMult);
		_out.writeString(this.m.Icon);
	}

	function onDeserialize( _in )
	{
		this.skill.onDeserialize(_in);
		this.m.Duration = _in.readU16();
		this.m.Battles = _in.readU16();
		this.m.XPGainMult = _in.readF32();
		this.m.Icon = _in.readString();
	}

});

