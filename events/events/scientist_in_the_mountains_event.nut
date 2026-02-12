this.scientist_in_the_mountains_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.scientist_in_the_mountains";
		this.m.Title = "W górach...";
		this.m.Cooldown = 150.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_42.png[/img]Na szczycie góry napotykasz niespodziewany widok: mężczyznę siedzącego w dziwnej drewnianej konstrukcji, którą przechyla ku krawędzi śmiertelnego urwiska. Ma szalik na oczach, zsuwa go, by mówić.%SPEECH_ON%Ahoy, nieznajomi. Wygląda na to, że zapiszecie historię! Skoro ludzie nauczyli pospolitego konia biec szybciej, niż potrafił, ja ujarzmię ptaki, by... cóż, nie da się jeździć na ptakach, ale jak widzicie po tej maszynie, mogę je naśladować. Kajdany przestrzeni i czasu zostaną zerwane, tak jak te drewniane skrzydła uniosą mnie w samo niebo!%SPEECH_OFF%Ta \"konstrukcja\" ma pedały, drewniane szprychy i płachty bardzo cienkiej, pospiesznie zszytej skóry.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Musisz to przerwać, tylko się zabijesz.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "To będzie ciekawe do oglądania.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "C" : "D";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_42.png[/img]Podchodzisz i wyjaśniasz mu realia sytuacji.%SPEECH_ON%Dobry... panie. Jaki ptak startuje z takiej wysokości? Czy ptak nie unosi się po prostu dzięki uderzeniom skrzydeł? Rzucisz się z tego urwiska z nadzieją, że maszyna zadziała, wiedząc w głębi serca, że nie zadziała.%SPEECH_OFF%Zmęczony górski uczony spogląda na swoje stopy. Kiwie uroczyście głową.%SPEECH_ON%Pewnie przydałoby się trochę poprawek. Masz ptasie oko, dobry panie. I masz też moje podziękowania. Opowiem ludziom o twojej wielkiej mądrości!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tak, jestem mądry.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_42.png[/img]{Cofasz się i pozwalasz mężczyźnie wzlecieć. Owija twarz szalikiem i siada w siedzisku swojej maszyny. Po kilku głębokich oddechach zaczyna pedałować do przodu. Konstrukcja natychmiast spada za krawędź. Mężczyzna zostaje wyrzucony przez skórzane skrzydła niczym krzyczący nietoperz. Wiruje w urządzeniu, gdy to rozbija się w dół skalnej ściany w potoku drewna i złego projektu. Chwilę później słyszysz słaby odgłos jego ostatecznego lądowania. Spektakularne! | Mężczyzna popycha maszynę z krawędzi, wskakując do siedziska w ostatniej chwili. Oboje przechylają się nad przepaścią i słychać krótki krzyk. Ale, wbrew wszelkim szansom, mężczyzna szybko się pojawia! Jego konstrukcja trzepocze z boku na bok jak pijany motyl, ale mimo to leci.%SPEECH_ON%Udało się, na bogów, udało się! Spójrzcie na mnie...%SPEECH_OFF%Nagle krzyczący sokół przebija jedno ze skrzydeł. Ptak zatacza krąg i uderza ponownie, rozrywając drugie skrzydło. Machasz rękami i próbujesz spłoszyć zabójczego ptaka.%SPEECH_ON%Hej, hej!%SPEECH_OFF%Maszyna chwieje się i zaczyna powoli tracić wysokość. Mężczyzna pedałuje coraz mocniej, by to zrekompensować, szprychy zaczynają pękać i chwilę później wszystko się rozpada, a ty możesz tylko patrzeć, jak zmęczony uczony spada na pewną śmierć. Sokół przysiada na skalnej ścianie i obserwuje śmierć swojego wroga.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Co za widowisko!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_42.png[/img]{Wbrew zdrowemu rozsądkowi pozwalasz mu lecieć. Owija twarz szalikiem, jakby miało go to uchronić przed twardym lądowaniem. Z głębokim oddechem popycha konstrukcję z krawędzi i wskakuje w ostatniej chwili, jakby dołączał do kochanki w romantycznym samobójstwie. Mężczyzna i maszyna szybko znikają. Zaczynasz się śmiać, gdy nagle mężczyzna znów się pojawia. Furiośnie pedałuje, skrzydła trzepoczą mocno. Krąży, robiąc pętle, coraz wyżej i wyżej.%SPEECH_ON%Udało się! Na bogów, udało się! Patrzcie, jak wysoko mogę!%SPEECH_OFF%Wzbija się w chmury, a rzężenie drewnianych szprych cichnie.%SPEECH_ON%Och, ochhhh!%SPEECH_OFF%To ostatnie, co o nim widzisz lub słyszysz. | Mężczyzna popycha maszynę z krawędzi i wskakuje do siedziska, gdy ta przechyla się nad przepaścią. Krzycząc, wspina się z powrotem po konstrukcji, gdy ta opada. Skacze z ostatniego czubka źle zbudowanej drewnianej ramy, odpychając się z powrotem do urwiska, gdzie wisi, trzymając się kurczowo. Pędzisz i wyciągasz go na górę. Jego maszyna rozbija się daleko poniżej, cichym dźwiękiem przewidywalnego zniszczenia. Otrzepuje się i kiwa ci głową.%SPEECH_ON%Dziękuję, panie. Miałem przebłysk. Co robi ptak? Nie startuje z wielkich wysokości, startuje, skąd zechce! Przerobię projekt! Dziękuję za uratowanie życia, panie.%SPEECH_OFF%Z twojej perspektywy poszło najlepiej, jak mogło. Ludzie i tak są mocno rozbawieni.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Spektakularna nauka.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(1.0, "Czuł się rozbawiony");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Mountains)
		{
			return;
		}

		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

