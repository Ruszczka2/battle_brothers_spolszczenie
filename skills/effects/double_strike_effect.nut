this.double_strike_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TimeAdded = 0
	},
	function create()
	{
		this.m.ID = "effects.double_strike";
		this.m.Name = "Podwójne Uderzenie!";
		this.m.Icon = "skills/status_effect_01.png";
		this.m.IconMini = "status_effect_01_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Zadając skuteczny cios, ta postać jest gotowa do wykonania potężnego następującego uderzenia! Kolejny atak zada [color=" + this.Const.UI.Color.PositiveValue + "]+20%[/color] obrażeń pojedynczemu celowi. Jeśli postać trafi wiele celów, tylko pierwszy trafiony otrzyma zwiększone obrażenia. Jeżeli atak spudłuje, efekt jest utracony.";
	}

	function onAdded()
	{
		this.m.TimeAdded = this.Time.getVirtualTimeF();
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_targetEntity == null)
		{
			return;
		}

		if (!this.m.IsGarbage && this.m.TimeAdded + 0.1 < this.Time.getVirtualTimeF() && !_targetEntity.isAlliedWith(this.getContainer().getActor()))
		{
			_properties.DamageTotalMult *= 1.2;
			this.removeSelf();
		}
	}

});

