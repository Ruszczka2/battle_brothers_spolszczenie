this.drill_sergeant_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.drill_sergeant";
		this.m.Name = "Sierżant Musztry";
		this.m.Description = "Sierżant Musztry był ongiś najemnikiem, jednak kontuzja przedwcześnie zakończyła jego karierę. Teraz musztruje twoich ludzi i wpaja im dyscyplinę, a do tego wydziera się niemal bez przerwy, aby mieć pewność, że każdy uczy się na swych błędach.";
		this.m.Image = "ui/campfire/drill_01";
		this.m.Cost = 3500;
		this.m.Effects = [
			"Sprawia, że twoi ludzie otrzymują 20% więcej doświadczenia na poziomie 1 oraz o 2% mniej na każdym kolejnym poziomie",
			"Sprawia, że ludzie w rezerwie nie tracą nastroju z powodu nie brania udziału w bitwach"
		];
		this.m.Requirements = [
			{
				IsSatisfied = false,
				Text = "Zwolnij człowieka z permanentną raną, który nie jest zadłużonym"
			}
		];
	}

	function onUpdate()
	{
		this.World.Assets.m.IsDisciplined = true;
	}

	function onEvaluate()
	{
		if (this.World.Statistics.getFlags().getAsInt("BrosWithPermanentInjuryDismissed") > 0)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});

