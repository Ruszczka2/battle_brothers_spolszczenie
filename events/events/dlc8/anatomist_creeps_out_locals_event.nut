this.anatomist_creeps_out_locals_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_creeps_out_locals";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 7.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Mimo hałasu okolicznych wieśniaków i ich handlu, %anatomist% otwiera księgę sekcji i zaczyna zagłębiać się w jej treść. Choć miejscowy chłop nie potrafi czytać tekstów, widzi obrzydliwe obrazy na stronach: dosadne zapisy otwartych ciał, nazwy części, o których istnieniu nie miał pojęcia, i mnóstwo dziwacznej symboliki, którą każdy prostak uznałby za zaproszenie do własnych diabelstw. Nic dziwnego, że chłop interesuje się tomem anatomisty.%SPEECH_ON%To ty jakiś czarnoksiężnik czy co?%SPEECH_OFF%Uśmiechając się, %anatomist% odwraca się i mówi, że gdyby chłop choć trochę w to wierzył, czy w ogóle by go o to pytał? Chłop odchyla się.%SPEECH_ON%A więc jesteś spryciarzem, co? Taki mądrala z książką dla głupców.%SPEECH_OFF%%anatomist% patrzy, jak chłop odchodzi, po czym spogląda na ciebie szerokim uśmiechem.%SPEECH_ON%Ten chłop miał dziwną gulę na policzku. Umrze w ciągu roku. Dwóch, jeśli ma pecha i śmierć okaże się zbyt łaskawa w czasie.%SPEECH_OFF% | Odpoczywając od drogi i najemniczenia, %anatomist% siada na kamieniu i otwiera jedną ze swoich ksiąg. Po kilku chwilach jego studiów podchodzi mała dziewczynka z kwiatami w dłoni. Daje mu jeden i pyta, co czyta. Anatomista podnosi książkę i odwraca ją. Dziewczynka wpatruje się w makabryczne rysunki rozciętych bestii i potworów z wyciągniętymi wnętrznościami. Po chwili powoli opuszcza książkę i patrzy na anatomistę, który ją trzyma. Mówi.%SPEECH_ON%Znam bestię, którą mógłbyś mieć.%SPEECH_OFF%Ty i anatomista nadstawiającie ucha. Dziewczynka ścisza głos, niemal sycząc w dziecięcym spisku.%SPEECH_ON%Mój młodszy brat. Ma dwa lata, ale przysięgam, wyrzeka się starych bogów i ma w sobie diabła.%SPEECH_OFF%%anatomist% przytakuje posłusznie.%SPEECH_ON%Oczywiście. Zanotuję to i jeśli będę mieć czas, znajdę plugastwo w twoim rodzie.%SPEECH_OFF%Dziewczynka dziękuje anatomiscie raz jeszcze i daje mu więcej kwiatów za obiecaną pomoc. %anatomist% trzyma kwiaty delikatnie, obracając je w palcach, gdy wraca do czytania, z małym uśmiechem na twarzy. Masz nadzieję, że ten uśmiech oznacza tylko, że bawi go dziecko, a nie że naprawdę chce się zająć jakimś niegodziwym chłopcem. | Gdy kompania odpoczywa, mężczyzna stoi na skraju drogi i przygląda się z zaciekawieniem. Kiwając głową, mówi.%SPEECH_ON%Macie na sobie odór śmierci, ale nie powiedziałbym, że jesteście rzeźnikami czy katami. Jesteście czymś innym.%SPEECH_OFF%Nie tracąc czasu, %anatomist% podchodzi i przygląda się mężczyźnie, stając twarzą w twarz. Ten odchyla się, ale nie ucieka. Zagubione spojrzenie anatomisty kończy się obowiązkowym skinieniem.%SPEECH_ON%Masz rację, niesiemy odór, tak jak ty. Nasz to sprawa nauki, twój to sprawa choroby. A twój... hmm, tak, twój to ślad ospy. Pokaż stopy.%SPEECH_OFF%Chłop nerwowo odmawia. Co fa się, a anatomista napiera, palce wspinają się jak pająk, oczy szeroko otwarte. Mężczyzna w końcu krzyczy i ucieka. %anatomist% odwraca się z uśmiechem.%SPEECH_ON%Cóż za ciekawy osobnik. Sądzę, że był bardzo, bardzo chory, ale jeszcze o tym nie wie. No cóż.%SPEECH_OFF% | Natrafiacie na otwarty wóz niosący trumnę, a jego drogę śledzi orszak żałobników. %anatomist% wychodzi z kompanii i pyta o śmierć zmarłego. Mówią, że zabiła go bestia. Zaintrygowany anatomista pyta, jaka bestia mogła zabić człowieka. Ludzie spoglądają po sobie, po czym otwierają trumnę, ukazując mężczyznę z małym zadrapaniem na policzku. Rana dawno pociemniała na fioletowo, z żyłkami zieleni i innymi niepokojącymi przebarwieniami, dowodem na to, że zmarł od zakażenia. Jeden z chłopów spogląda w górę.%SPEECH_ON%To był jego kot. Drapnął go tutaj, a on się tym nie przejął, potem kolory zeszły i włóczyły się po ciele, aż zmarł po dwóch nocach.%SPEECH_OFF%Anatomista mówi kilka słów żałobnikom i wraca do ciebie. Wzdycha.%SPEECH_ON%To była prosta zaraza. Wystarczyło przemyć ranę. Niefortunne, choć cieszę się, że moje nauki dają mi wgląd w prawdziwy świat, nawet jeśli jest już za późno, by je zastosować.%SPEECH_OFF%Pytasz, co stało się z kotem. Anatomista przytakuje i mówi, że leżał w trumnie obok ofiary, koci \"potwór\" schowany tam, jakby nieświadomy swojego ostatecznego celu.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Gdyby tak samo cieszył się z najemniczej roboty.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
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

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomistCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomistCandidates.push(bro);
			}
		}

		if (anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Score = 4 * anatomistCandidates.len();
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

