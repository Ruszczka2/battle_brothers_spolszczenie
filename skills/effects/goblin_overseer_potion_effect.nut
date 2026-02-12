this.goblin_overseer_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.goblin_overseer_potion";
		this.m.Name = "Zmutowana Rogówka";
		this.m.Icon = "skills/status_effect_126.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_126";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Oczy tej postaci trwale zmutowały i są teraz w stanie dostrzegać nawet najsubtelniejsze ruchy wiatru i powietrza. Choć samo w sobie jest to niewiele, zdolność ta pozwala lepiej przewidzieć trajektorię wystrzelonego pocisku i skuteczniej trafiać w czułe miejsca celu..";
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
				icon = "ui/icons/direct_damage.png",
				text = "Dodatkowe [color=" + this.Const.UI.Color.PositiveValue + "]5%[/color] obrażeń ignoruje pancerz, gdy postać korzysta z łuku bądź kuszy"
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
		_properties.IsSharpshooter = true;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isGoblinOverseerPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isGoblinOverseerPotionAcquired", false);
	}

});

