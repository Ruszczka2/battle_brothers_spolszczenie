this.ranged_mastery_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.ranged_mastery";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "W kompanii brakuje kompetentnych strzelców, co ogranicza nasze opcje taktyczne.\nWyszkolimy trzech ludzi w łukach lub kuszach, by siali śmierć z daleka!";
		this.m.UIText = "Miej ludzi z mistrzostwem w łukach lub kuszach";
		this.m.TooltipText = "Miej 3 ludzi z talentem mistrzostwa w łukach lub kuszach.";
		this.m.SuccessText = "[img]gfx/ui/events/event_10.png[/img]At every opportunity, you encourage the men under your command to let loose a few volleys. Everyone participates, even the slow witted louts who would sleep in their armor if you let them. Any target at all suffices: the bole of a small tree, a doe grazing in the early hours, or a goblin scout fleeing for his life.%SPEECH_ON%Yes, we are the terror of hay bales throughout the land!%SPEECH_OFF%%randombrother% says, referring to a common choice of target during practice. He ducks when an arrow from one of his comrades whistles close past his skull and starts cursing at the shooter.\n\nWith plenty of practice, those arrows are striking closer and closer to the bullseye, and now that the company is fielding better trained bowmen, your frontline is breathing easier and living, at least marginally, longer.";
		this.m.SuccessButtonText = "To się nam przysłuży.";
	}

	function getUIText()
	{
		return this.m.UIText + " (" + this.Math.min(3, this.getBrosWithMastery()) + "/3)";
	}

	function getBrosWithMastery()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local count = 0;

		foreach( bro in brothers )
		{
			local p = bro.getCurrentProperties();

			if (p.IsSpecializedInBows)
			{
				count = ++count;
				count = count;
			}
			else if (p.IsSpecializedInCrossbows)
			{
				count = ++count;
				count = count;
			}
		}

		return count;
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days <= 25)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 2)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		local count = this.getBrosWithMastery();

		if (count >= 3)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local count = this.getBrosWithMastery();

		if (count >= 3)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
	}

});

