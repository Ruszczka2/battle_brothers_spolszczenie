this.hidden_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "terrain.hidden";
		this.m.Name = "Ukryty";
		this.m.Description = "Ta postać jest ukryta w terenie i nie jest widoczna dla przeciwników, chyba ze znajdą się bezpośrednio przy niej lub sama ich wpierw zaatakuje.";
		this.m.Icon = "skills/status_effect_08.png";
		this.m.IconMini = "status_effect_08_mini";
		this.m.Type = this.Const.SkillType.Terrain | this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsHidden = false;
		this.m.IsSerialized = false;
	}

	function getDescription()
	{
		local ret = this.m.Description;
		return ret;
	}

});

