this.anatomist_bummed_at_mutations_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_bummed_at_mutations";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{%anatomist% siedzi przy ognisku. Prawie za blisko. Odsuwasz go, żeby się nie poparzył. Patrzy w górę, twarz ma usianą krostami i umazaną tłuszczem z tych, które już pękły.%SPEECH_ON%Zaczynam się zastanawiać, czy wypicie tej mikstury nie było wielkim błędem.%SPEECH_OFF%Przysuwa się z powrotem do płomieni, a w jego oczach jest coś, co mówi, że chciałby się w nie rzucić. Niewiele możesz dla niego zrobić, głównie dlatego, że wygląda teraz okropnie i wolałbyś go już nie dotykać. | Zastajesz %anatomist% stojącego przy wozie kompanii, z odwiniętym rękawem i palcem grzebiącym w jakichś dziwnych znakach. Zaintrygowany pytasz, czy to znamiona. Anatomista odwraca się i kręci głową. Podnosi koszulę, pokazując, że te znaki są na całym ciele, plamią skórę paskudnymi kolorami, które wyglądają na szorstkie w dotyku, jak strupy, których nie da się zdjąć.%SPEECH_ON%Ta mikstura, którą wypiłem, to zrobiła, i nie wiem, co ze sobą począć.%SPEECH_OFF%Kiwasz głową i mówisz, że na pewno będzie lepiej. Wzdycha i po prostu opuszcza koszulę, odwracając wzrok. | %anatomist% stoi nad wiadrem wody, patrząc na swoje ściemnione odbicie. Wzdycha. Pytasz, jak się czuje, a on odwraca się, odsłaniając okropne wysypki i czyraki na skórze.%SPEECH_ON%Nie radzę sobie najlepiej, szczerze mówiąc. Mikstura, którą wypiłem, zdaje się mieć na mnie poważnie zły wpływ, choć być może używam zbyt łagodnych słów. Przeżyję, ale zraniła mnie nie tylko na skórze i ciele, lecz także w głowie. Myślałem, że jestem od takich spraw zdystansowany, ale teraz, widząc swoją okropną twarz...żyję w stanie ciągłego niepokoju.%SPEECH_OFF%Chwytasz go za ramię i ściskasz, potem klepiesz po plecach i rzucasz kilka porad, że powinien napić się wody i oczywiście nie przejmować. Nigdy nie byłeś dobry w pocieszaniu innych, a już zwłaszcza tych, którzy cierpią na straszne dolegliwości zrodzone z naukowego szaleństwa. | %anatomist% anatomista jest w stanie przygnębienia. Mikstura, którą zrobił i w pośpiechu wypił, sprawiła, że całe jego ciało zostało opanowane przez dolegliwości: od wysypek, przez czyraki, po coś, co wygląda na dziwne skurcze, i mnóstwo smarków z nosa. Zapewniasz go, że wyzdrowieje, ale jego przerażający wygląd mocno go przytłacza. | Dziwne mikstury, które %anatomist% anatomista przygotowuje, są dziwnymi miksturami, które także pije. Nic dziwnego, że skutki nie są dobre: wysypki, infekcje, odory, wypadanie włosów i więcej. Choć na zewnątrz twierdzi, że robi to w imię nauki, widać, że wszystkie te dolegliwości i oszpecenia dobijają jego morale. Możesz tylko mieć nadzieję, że z czasem mu przejdzie. | Sprawy nauki, daleko poza twoim zrozumieniem, zawsze wiążą się z ryzykiem. Pamiętasz, jak w dzieciństwie twój przyjaciel zaryzykował, huśtając się na linie nad rzekę, i przypadkiem wszyscy dowiedzieliście się, ile ciężaru potrafi wytrzymać gałąź w samym środku Jesieni.\n\nTeraz wygląda na to, że %anatomist% anatomista poznaje wyniszczającą naturę picia jednej ze swoich dziwacznych mikstur. Jest pokryty wysypkami i infekcjami, a z jakiegoś powodu przyciąga mrówki, które nie wiadomo czemu uwielbiają po nim chodzić o każdej porze dnia i nocy. Oby z czasem te dolegliwości minęły, i oby zabrały ze sobą te przeklęte mrówki. | Zawsze wiedziałeś, że anatomistom nieco brakuje rozsądku, ale to, jak robią mikstury i je piją, naprawdę cię powaliło. Sama woda może być trucizną, jeśli pije się ją z niewłaściwego kubka, nie mówiąc już o całych miksturach destylowanych w błocie jakichś naukowych pomysłów, które anatomistom akurat siedzą w głowie. Nic dziwnego, że niedługo potem jeden z tych jajogłowych, %anatomist%, zapada na zdrowiu. Wciąż jest zdolny do ruchu i codziennych obowiązków, ale wielkie brodawki i sączące się krosty sprawiają, że aż strach na niego patrzeć, i choć może uważać się za zdystansowanego od społeczeństwa, masz niewielkie wątpliwości, że chodzenie jak szmata, którą wytarto świński gnój, jest zdrowe dla umysłu i ducha. Oby z czasem mu przeszło. | %anatomist% niekoniecznie jest chory od swoich mikstur. W końcu wciąż może się poruszać, chodzić, a nawet walczyć, jeśli trzeba. Ale na pewno mikstury odcisnęły na nim paskudne piętno. Na policzkach pojawiły się wielkie czyraki, a czasem oczy wyskakują mu z oczodołów i musi je wpychać z powrotem, co jest czymś, czego wolałbyś nie widzieć. Strużki śliny spływają z kącików ust, a w nozdrzu mieszka ślimactwo ze smarków, gluta i krwi. Jak możesz sobie wyobrazić, jest raczej przybity tym, że wygląda gorzej niż zdechła świnia, ale masz wiarę, że z czasem mu przejdzie.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wracaj do zdrowia, %anatomist%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(1.25, "Zmartwiony tym, jak mutacje go zmieniły");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Anatomist.getFlags().add("gotUpsetAtMutations");
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomistCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist" && !bro.getFlags().has("gotUpsetAtMutations") && bro.getFlags().getAsInt("ActiveMutations") > 0)
			{
				anatomistCandidates.push(bro);
			}
		}

		if (anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Score = 6 * anatomistCandidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
	}

});

