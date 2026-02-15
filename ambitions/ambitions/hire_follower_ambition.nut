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
		this.m.SuccessText = "[img]gfx/ui/events/event_82.png[/img]%SPEECH_ON%Czyli on nie walczy?%SPEECH_OFF%pyta jeden z najemników. Kręcisz głową, a on drapie się po swojej.%SPEECH_ON%A jednak go zatrudniamy?%SPEECH_OFF%Kiwacie. Najemnik zaciska usta na chwilę i doprecyzowuje.%SPEECH_ON%I absolutnie żadnej walki?%SPEECH_OFF%Żadnej walki.%SPEECH_ON%Wcale? Czyli będzie się tylko kręcił i robił tu i ówdzie jakieś zadania?%SPEECH_OFF%Wyjaśniasz, że nie każda ważna rola w kompanii najemników musi polegać na walce. Gdy wyliczasz wszystkie zajęcia, w których ktoś mógłby tu pomóc, najemnik przez chwilę się zastanawia.%SPEECH_ON%To może niech liczy zapasy? Bo mam tego serdecznie dość.%SPEECH_OFF%Nie. Oczywiście, że nie. Nigdy nie oddasz nikomu swojej sekretnej kary.";
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

