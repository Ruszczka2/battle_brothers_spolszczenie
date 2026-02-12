this.geist_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.geist_potion";
		this.m.Name = "Powłoka Kinetyczna";
		this.m.Icon = "skills/status_effect_137.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_137";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Ta postać jest zdolna do wydzielania substancji, która wibruje gwałtownie, gdy jest pobudzona. Zaaplikowana na broń jest w stanie wytworzyć sporą moc kinetyczną, która pomaga w przebijaniu pancerza.";
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
				text = "Dodatkowe [color=" + this.Const.UI.Color.PositiveValue + "]5%[/color] obrażeń ignoruje pancerz, gdy postać używa broni do walki w zwarciu"
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
		_properties.DamageDirectMeleeAdd += 0.05;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isGeistPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isGeistPotionAcquired", false);
	}

});

