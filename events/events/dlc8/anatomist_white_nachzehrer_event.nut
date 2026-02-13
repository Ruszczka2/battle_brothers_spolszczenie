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
			Text = "[img]gfx/ui/events/event_184.png[/img]{%anatomist% ostatnio niewiele pisze w swoich dziennikach. Gdy juz to robi, pioro tylko stuka w kartki, nie zapisujac niczego istotnego. Pytasz, co go tak trapi. Ponurym tonem odpowiada, ze jego glowna nadzieja na tych ziemiach to odnalezienie Bialego Nachzehrera, potwora wiekszego niz wszystkie inne. Mowisz mu, ze zabiliscie kilka nachow calkiem tepych, ale anatomista kreci glowa.%SPEECH_ON%Zgodnie z literatura, tego nachzehrera nie mozna powalic, bo urusl do takich rozmiarow, ze jego mieso zbielalo, a skore pokrywaja grube, zrogowaciale grzbiety, ktorych nie przebije zadna stal. Widziano go na tych ziemiach i liczylem, ze go znajde, ale wydaje sie, ze byc moze zostalem zwiedziony. Moze anatomisci, ktorzy opowiedzieli mi te historie, wrobili mnie w bezsensowne poszukiwania. Obawiam sie, rabusiu, ze zrobiono ze mnie glupca.%SPEECH_OFF%Mowisz mu, ze to stworzenie brzmi jak \"krol\" nachzehrerow i jesli tak, to byc moze juz nie wedruje, tylko uzywa malej armii slabszych nachzehrerow, by wykonywaly jego rozkazy. Anatomista usmiecha sie.%SPEECH_ON%To moze byc prawda! Oczywiscie potrzeba bylo przenikliwego oka pospolstwa, przywyklego do wpatrywania sie w naszych purpurowych suzerenow, by zwrocic na to moja zamglona uwage!%SPEECH_OFF%Zgadzajac sie jeszcze bardziej sam ze soba, dodajesz, ze moze \"Bialy Nachzehrer\" jest taki blady, bo rzadko widzi slonce. Anatomista smieje sie.%SPEECH_ON%Prosze, rabusiu, pierwsza uwaga w pelni wystarczyla.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Niech twoj Bialy Nach nie skonczy sie dla ciebie siniakiem, krwawy tepak.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				_event.m.Anatomist.improveMood(1.5, "Odzyskal wiare w istnienie bialego nachzehrera");

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

