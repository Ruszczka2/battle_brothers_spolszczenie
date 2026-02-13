this.anatomist_demonology_book_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_demonology_book";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_184.png[/img]{Zastajesz %anatomist% przeglądającego czerwoną księgę. Zamykając ją, wzdycha.%SPEECH_ON%Jako anatomista jestem skłonny sądzić, że potwory, jak wy, laicy, byście je nazwali, nie pojawiają się tylko po to, by wyglądać. Zamiast tego wszystko ma cel. W pewnym sensie, i przez starych bogów, możemy ufać, że te elementy mają faktycznie boski cel. A jednak niektórzy z moich rówieśników znaleźli kości stworzeń, których nigdy nie widziano na żywo. Wygląda na to, że te istoty całkowicie zniknęły. To rodzi pytanie: czy takie dowody oznaczają, że my sami też kiedyś znikniemy? Odpowiedź twierdząca sugeruje, że boskości na górze nie ważą swoich wizji na naszą korzyść. Kroczymy pod spojrzeniem czystego przypadku. Straszna myśl, doprawdy.%SPEECH_OFF%Ciekaw, pytasz, jak wyglądały te tajemnicze potwory. Anatomista otwiera czerwoną księgę i pokazuje ci rysunek.%SPEECH_ON%Są dość podobne do ludzi, ale większe, z wyraźną masywnością wokół szyi i barków. Czaszki mają te wcięcia, podobne do rogów, a kręgosłupy mają dodatkowe kręgi, z trzema przy górze rozszerzającymi się, jakby trzymały coś, coś, co wystawałoby daleko poza ciało. Widzisz? Tu? Plecy są niemal jak kostny płaszcz.%SPEECH_OFF%Interesujące. Pytasz anatomistę, czy sam widział któryś z tych szkieletów, a on mówi, że nie. Twierdzi, że widział to tylko w tekście. Pytasz, czy zapłacił za tę księgę, a on mówi, że tak. Pytasz go, czy może wizja dawnych, dziwacznych potworów była tylko chwytem sprzedażowym, by skłonić go do kupna księgi bzdur. Anatomista rozważa to przez chwilę. Kiwając głową, zgadza się, że najpewniej kupił oszustwo. Z każdą sekundą staje się coraz bardziej zły i nagle wrzuca tom do ogniska, przysięgając, że odtąd zajmie się bardziej przyziemnymi badaniami. Dziękuje ci za to, że potrafisz przebić się przez bzdury i pozory wyniosłości, jakie ten świat nakłada.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie można wierzyć we wszystko, co się czyta.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				_event.m.Anatomist.worsenMood(0.5, "Zmarnował czas, czytając fałszywą księgę demonologii");
				_event.m.Anatomist.improveMood(1.0, "Pomogłeś mu zrozumieć, że jego księga demonologii to mistyfikacja");

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

