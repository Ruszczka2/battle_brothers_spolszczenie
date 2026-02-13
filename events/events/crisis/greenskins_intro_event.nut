this.greenskins_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.greenskins_intro";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_59.png[/img]%randombrother% wchodzi do twojego namiotu.%SPEECH_ON%Panie, mamy tu grupę uchodźców, którzy chcieliby z tobą porozmawiać.%SPEECH_OFF%Odkładasz pióro i idziesz ich spotkać. To straszna zbieranina, wyglądają bardziej jak szmaty rzucone w błoto niż ludzie. Jeden z nich, mężczyzna trzymający kikut tam, gdzie kiedyś miał dłoń, wychodzi do przodu i mówi.%SPEECH_ON%Rozumiem, że to ty tu rządzisz?%SPEECH_OFF%Kiwasz głową i pytasz, co się stało i dlaczego to obchodzi kompanię. Wyjaśnia, gestykulując jedyną sprawną ręką.%SPEECH_ON%Zielonoskórzy atakują.%SPEECH_OFF%Cóż, to nic nowego. Pytasz, gdzie są i czy to gobliny, czy orki. Mężczyzna kręci głową.%SPEECH_ON%No właśnie o to chodzi. To jedno i drugie. Oni... oni działają razem. Hordy tak liczne jak źdźbła trawy pod naszymi stopami. W pewnym sensie źle się wyraziłem. Powinienem powiedzieć, że oni nie tylko atakują, oni NAJEŻDŻAJĄ. Wszyscy. Razem. Inwazja ponad wszelki zakres i miarę, rozumiesz?%SPEECH_OFF%Patrzysz na tłum uchodźców. Dzieci skulone pod spódnicami matek, mężczyźni z zagubionym wzrokiem. Mężczyzna ciągnie dalej.%SPEECH_ON%Mój ojciec walczył w Bitwie Wielu Imion. Zawsze mówił, że wrócą, i teraz chyba miał rację. Słyszymy, że szlacheckie rody panikują i mogą połączyć siły, żebyśmy wszyscy nie zostali zgnieceni! Jeśli chcesz mojej rady, mówię: trzymaj się z dala. Tych hord... nie da się powstrzymać. A to, co robią...%SPEECH_OFF%Chwytasz go za koszulę.%SPEECH_ON%To, co robią, mnie nie martwi. Wynoś się stąd, chłopie, i zostaw walkę walczącym.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wojna jest u naszych bram.",
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
	}

	function onUpdateScore()
	{
		if (this.World.Statistics.hasNews("crisis_greenskins_start"))
		{
			this.m.Score = 6000;
		}
	}

	function onPrepare()
	{
		this.World.Statistics.popNews("crisis_greenskins_start");
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

