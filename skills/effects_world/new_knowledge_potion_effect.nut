this.new_knowledge_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {
		Battles = 0,
		IsCountingBattle = false
	},
	function create()
	{
		this.m.ID = "effects.knowledge_potion";
		this.m.Name = "Przyśpieszone Uczenie Się";
		this.m.Description = "Dzięki koktajlowi nootropowemu eufemicznie zwanemu \'Mikstura Wiedzy\', zdolności kognitywne tej postaci, a zwłaszcza jej pamięć i zdolności uczenia się, zostały wzmocnione, tak jak i jej skłonności do robienia tików nerwowych.";
		this.m.Icon = "skills/status_effect_94.png";
		this.m.Type = this.m.Type | this.Const.SkillType.StatusEffect | this.Const.SkillType.DrugEffect;
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+100%[/color] do zdobywanego doświadczenia"
			}
		];
		ret.push({
			id = 7,
			type = "hint",
			icon = "ui/icons/action_points.png",
			text = "Efekt zniknie po następnych " + (3 - this.m.Battles) + " bitwach"
		});
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.XPGainMult *= 2.0;
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

		if (this.m.Battles >= 3)
		{
			this.removeSelf();
		}
	}

	function onSerialize( _out )
	{
		this.skill.onSerialize(_out);
		_out.writeU16(this.m.Battles);
	}

	function onDeserialize( _in )
	{
		this.skill.onDeserialize(_in);
		this.m.Battles = _in.readU16();
	}

});

