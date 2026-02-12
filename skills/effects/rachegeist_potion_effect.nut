this.rachegeist_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.rachegeist_potion";
		this.m.Name = "Upiorna Aura";
		this.m.Icon = "skills/status_effect_153.png";
		this.m.IconMini = "status_effect_153_mini";
		this.m.Overlay = "status_effect_153";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Postać ta skonsumowała substancję, która teraz krąży w jej żyłach i emituje pole kinetyczne. To pole nabiera na sile wraz ze słabnącym zdrowiem postaci, aż w końcu zaczyna migotać na niebiesko i wywoływać wyraźny efekt podczas zadawania obrażeń, a także podczas ich otrzymywania. Postać twierdzi też, że gdy jest w samotności to słyszy nieprzerwany, niemal niedostrzegalny szept, ale to zapewne tylko jakieś przesądy.";
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
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+25%[/color] do zadawanych obrażeń, jeżeli Zdrowie jest poniżej [color=" + this.Const.UI.Color.NegativeValue + "]50%[/color]"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Otrzymuje tylko [color=" + this.Const.UI.Color.PositiveValue + "]75%[/color] obrażeń, jeżeli Zdrowie jest poniżej[color=" + this.Const.UI.Color.NegativeValue + "]50%[/color]"
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
		local actor = this.getContainer().getActor();

		if (actor.getHitpoints() < actor.getHitpointsMax() / 2)
		{
			_properties.DamageTotalMult *= 1.25;
			_properties.DamageReceivedTotalMult *= 0.75;
		}
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isRachegeistPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isRachegeistPotionAcquired", false);
	}

});

