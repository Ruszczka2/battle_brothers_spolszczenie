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
		this.m.SuccessText = "[img]gfx/ui/events/event_10.png[/img]Przy każdej okazji zachęcasz ludzi pod swoim dowództwem, by wypuszczali choć kilka salw. Wszyscy biorą udział, nawet ci tępi osiłkowie, którzy spali by w zbrojach, gdybyś im na to pozwolił. Wystarczy dowolny cel: pień małego drzewa, sarna pasąca się o świcie albo gobliński zwiadowca uciekający z życiem.%SPEECH_ON%Tak, jesteśmy postrachem stogów siana w całej krainie!%SPEECH_OFF%%randombrother% mówi, nawiązując do częstego celu ćwiczeń. Schyla się, gdy strzała jednego z towarzyszy świszcze tuż przy jego czaszce, i zaczyna miotać przekleństwa pod adresem strzelca.\n\nDzięki licznym treningom strzały trafiają coraz bliżej środka, a teraz, gdy kompania wystawia lepiej wyszkolonych łuczników, wasz pierwszy szereg oddycha łatwiej i żyje, przynajmniej odrobinę, dłużej.";
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

