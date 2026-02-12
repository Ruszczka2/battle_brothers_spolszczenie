this.double_grip <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "special.double_grip";
		this.m.Name = "Podwójny Chwyt";
		this.m.Description = "Ta postać ma drugą rękę wolną, więc może pewniej chwycić swoją broń, zadając dodatkowe obrażenia.";
		this.m.Icon = "skills/passive_07.png";
		this.m.IconMini = "passive_07_mini";
		this.m.Type = this.Const.SkillType.StatusEffect | this.Const.SkillType.Special;
		this.m.IsActive = false;
		this.m.IsSerialized = false;
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
			}
		];
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/regular_damage.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+25%[/color] obrażeń"
		});
		return ret;
	}

	function canDoubleGrip()
	{
		local main = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		local off = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		return main != null && off == null && main.isDoubleGrippable();
	}

	function isHidden()
	{
		return this.skill.isHidden() || !this.canDoubleGrip();
	}

	function onUpdate( _properties )
	{
		if (this.canDoubleGrip())
		{
			_properties.MeleeDamageMult *= 1.25;
		}
	}

});

