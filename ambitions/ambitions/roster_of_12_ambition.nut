this.roster_of_12_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.roster_of_12";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Zwiększymy siłę kompanii do tuzina ludzi! Staniemy się wówczas\nznaczącą siłą i będziemy mieć dostęp do bardziej dochodowej pracy.";
		this.m.UIText = "Miej w swych szeregach co najmniej 12 ludzi";
		this.m.TooltipText = "Najmij wystarczająco dużo rekrutów, aby mieć w szeregach co najmniej 12 ludzi. Odwiedzaj osady w różnych stronach, by znaleźć ochotników, którzy najbardziej ci się przysłużą. Posiadanie pełnych szeregów pozwoli ci podejmować niebezpieczniejsze i lepiej płatne kontrakty.";
		this.m.SuccessText = "[img]gfx/ui/events/event_80.png[/img]Having finally gathered the coin and equipment, you manage to assemble a full complement of twelve able fighters. When next you walk down %currenttown%\'s main street, the men break into a full-throated marching song. A few of the townsfolk mutter under their breath about dirty mercenaries taking over the town, but others walk alongside and shout the words with you. %SPEECH_ON%Stand tall, brothers. People can see this is a real mercenary company now, and not a handful of wandering vagabonds.%SPEECH_OFF%%highestexperience_brother% declares.%SPEECH_ON%We trade in strength, and now that our numbers have gone up, so will our price.%SPEECH_OFF%It appears he has the right of it. You notice one particularly fat nobleman sizing up the company as if he already has a task in mind. The %companyname% are now a force to be reckoned with. Once the men have settled in for a celebratory drink, perhaps you should take another stroll through town to see if any more lucrative contracts may be available.";
		this.m.SuccessButtonText = "Dobrze nam idzie.";
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getOrigin().getID() == "scenario.militia")
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 1 && this.World.Assets.getOrigin().getID() != "scenario.deserters" && this.World.Assets.getOrigin().getID() != "scenario.raiders")
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= 12)
		{
			this.m.IsDone = true;
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.getPlayerRoster().getSize() >= 12)
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

