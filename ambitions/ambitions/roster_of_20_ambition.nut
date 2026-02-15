this.roster_of_20_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.roster_of_20";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Podbudujmy liczebność kompanii do dwudziestu ludzi, aby ranni\nmogli odpocząć, a zmęczeni odzyskać siły pomiędzy potyczkami.";
		this.m.UIText = "Miej w swych szeregach co najmniej 20 ludzi";
		this.m.TooltipText = "Najmij wystarczająco dużo rekrutów, aby mieć w szeregach co najmniej 20 ludzi. Odwiedzaj osady w różnych stronach, by znaleźć ochotników, którzy najbardziej ci się przysłużą.";
		this.m.SuccessText = "[img]gfx/ui/events/event_80.png[/img]Przez wiele dni rozmawiasz z potencjalnymi rekrutami z różnych warstw i z każdego zakątka społeczeństwa, odsiewając nieudolnych i targując się z chciwymi. Wygląda na to, że w niespokojnych czasach każdy włóczęga, parobek i najmłodszy syn możnego chce zostać najemnikiem.\n\nLudzie cieszą się z większego stanu kompanii, a ci, których odrzuciłeś, będą przez tygodnie obiektem żartów. %highestexperience_brother% klepie cię po ramieniu.%SPEECH_ON%A co powiesz na tego gościa, co twierdził, że urwał głowy bandzie orków, a był zwykłym piekarzem z %randomtown%? Szczypanie miękkich bicepsów i oklepywanie synów chłopów gałązkami było niezłą zabawą przez pierwsze dni, ale pod koniec było to więcej roboty niż ganianie rzezimieszków, jakby mnie ktoś pytał.%SPEECH_OFF%Masz teraz dwudziestu ludzi pod swoim dowództwem. Nie wszyscy są weteranami i nie wszyscy zostali sprawdzeni, ale możliwość rotowania rannych oznacza świeższe oddziały w polu.";
		this.m.SuccessButtonText = "Pełna kompania, wreszcie.";
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days <= 15)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 2)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= 20)
		{
			this.m.IsDone = true;
			return;
		}

		if (this.World.Assets.getBrothersMax() < 20)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= 15)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.roster_of_12").isDone())
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.getPlayerRoster().getSize() >= 20)
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

