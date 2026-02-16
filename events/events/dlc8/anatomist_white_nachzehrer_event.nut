this.anatomist_white_nachzehrer_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_white_nachzehrer";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_184.png[/img]{%anatomist% ostatnio niewiele pisze w swoich dziennikach. Gdy już to robi, pióro tylko stuka w kartki, nie zapisując niczego istotnego. Pytasz, co go tak trapi. Ponurym tonem odpowiada, że jego główna nadzieja na tych ziemiach to odnalezienie Białego Nachzehrera, potwora większego niż wszystkie inne. Mówisz mu, że zabiliście kilka nachów całkiem tępych, ale anatomista kręci głową.%SPEECH_ON%Zgodnie z literaturą, tego nachzehrera nie można powalić, bo urósł do takich rozmiarów, że jego mięso zbielało, a skórę pokrywają grube, zrogowaciałe grzbiety, których nie przebije żadna stal. Widziano go na tych ziemiach i liczyłem, że go znajdę, ale wydaje się, że być może zostałem zwiedziony. Może anatomisci, którzy opowiedzieli mi te historie, wrobili mnie w bezsensowne poszukiwania. Obawiam się, rabusiu, że zrobiono ze mnie głupca.%SPEECH_OFF%Mówisz mu, że to stworzenie brzmi jak \"król\" nachzehrerów i jeśli tak, to być może już nie wędruje, tylko używa małej armii słabszych nachzehrerów, by wykonywały jego rozkazy. Anatomista uśmiecha się.%SPEECH_ON%To może być prawda! Oczywiście potrzeba było przenikliwego oka pospólstwa, przywykłego do wpatrywania się w naszych purpurowych suzerenów, by zwrócić na to moją zamgloną uwagę!%SPEECH_OFF%Zgadzając się jeszcze bardziej sam ze sobą, dodajesz, że może \"Biały Nachzehrer\" jest taki blady, bo rzadko widzi słońce. Anatomista śmieje się.%SPEECH_ON%Proszę, rabusiu, pierwsza uwaga w pełni wystarczyła.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Niech twój Biały Nach nie skończy się dla ciebie siniakiem, krwawy tępak.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				_event.m.Anatomist.improveMood(1.5, "Odzyskał wiarę w istnienie białego nachzehrera");

				if (_event.m.Anatomist.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomist_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
		}

		if (anatomist_candidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		this.m.Score = 3 * anatomist_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
	}

});

