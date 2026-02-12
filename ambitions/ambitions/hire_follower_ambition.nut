this.hire_follower_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.hire_follower";
		this.m.Duration = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Kucharze, zwiadowcy i wielu innych, mogliby nas wspomóc poza polem bitwy.\nNajmiemy kogoś, kto najbardziej nam się przyda!";
		this.m.UIText = "Najmij kogoś do twej świty niewalczących towarzyszy";
		this.m.TooltipText = "Zdobądź sławę na poziomie co najmniej \'Rozpoznawany\' (250), aby odblokować pierwszy slot dla niewalczących towarzyszy w twojej świcie. Swoją sławę możesz zwiększyć wypełniając kontrakty i wygrywając bitwy. następnie najmij niewalczącego towarzysza na ekranie świty. Niektórzy towarzysze wymagają spełnienia określonych kryteriów, byś mógł odblokować ich usługi.";
		this.m.SuccessText = "[img]gfx/ui/events/event_82.png[/img]%SPEECH_ON%So they\'re not a fighter?%SPEECH_OFF%One of the sellswords asks. You shake your head, and they scratch theirs.%SPEECH_ON%But they\'re hired on anyway?%SPEECH_OFF%You nod. The sellsword purses their lips for a second then clarifies.%SPEECH_ON%And absolutely no fighting?%SPEECH_OFF%No fighting.%SPEECH_ON%None? So they\'ll just fart around doing whatever task here and there?%SPEECH_OFF%You explain that not every important role in a mercenary band needs to be one of fighting. After you\'ve laid out all the jobs others could help out around here, the sellsword thinks for a time.%SPEECH_ON%Can they take up inventory counting, then? Cause I\'m real tired of that.%SPEECH_OFF%No. Of course not. You\'ll never let your secret punishment go to someone else.";
		this.m.SuccessButtonText = "To nam bardzo pomoże w nadchodących dniach.";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 1)
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < this.Const.BusinessReputation[this.Const.FollowerSlotRequirements[0]] - 100)
		{
			return;
		}

		if (this.World.Retinue.getNumberOfCurrentFollowers() >= 1)
		{
			this.m.IsDone = true;
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Retinue.getNumberOfCurrentFollowers() >= 1)
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

