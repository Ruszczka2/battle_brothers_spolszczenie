this.rallied_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.rallied";
		this.m.Name = "Pokrzepiony";
		this.m.Description = "Dasz radę, jesteś zwycięzcą! Inspirujący przywódca natchnął tę postać, aby zebrała się w sobie i walczyła dalej. Postać może zostać pokrzepiona tylko raz na turę i nie można próbować pokrzepić innych samemu będąc pokrzepionym";
		this.m.Icon = "skills/status_effect_56.png";
		this.m.IconMini = "status_effect_56_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function onTurnEnd()
	{
		this.removeSelf();
	}

});

