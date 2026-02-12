this.desertion_event <- this.inherit("scripts/events/event", {
	m = {
		Deserter = null,
		Other = null
	},
	function setDeserter( _d )
	{
		this.m.Deserter = _d;
		this.m.Other = null;
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() > 1)
		{
			do
			{
				this.m.Other = brothers[this.Math.rand(0, brothers.len() - 1)];
			}
			while (this.m.Other == null || this.m.Other.getID() == this.m.Deserter.getID());
		}
		else
		{
			this.m.Other = this.m.Deserter;
		}
	}

	function create()
	{
		this.m.ID = "event.desertion";
		this.m.Title = "W trakcie podróży...";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]{%desertedbrother% zdezerterował z kompanii. Kiedy dni się ciągną bez końca, a droga dłuży, ludzie poddani są próbuje charakteru. Odkryłeś, że nawet ci, którzy na polu bitwy są nieulękli, czasem ciężko znoszą trudy najemniczego życia. Są też tacy, którzy są zarówno tchórzami, jak i obibokami. Masz tylko nadzieję, że nie stracisz zbyt dużo koron na ludzi tego typu, zanim ich wykryjesz.\n\n%otherbrother% podchodzi do ciebie.%SPEECH_ON%Nie przejmuj się nim, panie. %desertedbrother% nigdy mi się nie podobał. Teraz, gdy nasza kompania już się o niego nie troszczy, daję mu góra dwa tygodnie, zanim zawiśnie z szafotu.%SPEECH_OFF% | Biadolenie to wiekowa tradycja pośród najemników, a także wśród ludzi w ogóle, jednak %desertedbrother% nad wyraz cię denerwował swymi nieustannymi narzekaniami.\n\nJeśli prowiant był czerstwy, piwo zbyt gorzkie, albo mięso zbyt żylaste, to właśnie on pierwszy cię o tym powiadamiał. Raz za razem. To samo było wtedy, gdy bolały go stopy, gdy pogoda była kiepska, gdy tarcze zbutwiały, pancerze się przetarły, karawana szła zbyt wolno, karawana szła zbyt szybko, klingi były tępe, chleb spleśniał, żołd był niski, pierwszy szedł na wartę, gdy się nudził lub gdy sowy nie dawały mu spać w nocy. To nie jest kompletna lista jego skarg, ale w tej chwili tylko tyle przychodzi ci do głowy.\n\nTakie narzekania są jednak niestety typową rzeczą w wędrownej kompanii najemniczej, zwykle nieuniknioną. Nie jesteś wiec zbytnio zdziwiony, gdy dowiadujesz się, że %desertedbrother% opuścił was w poszukiwaniu mniej uciążliwego życia. | %desertedbrother% od kilku dni nie wkładał zbyt wielkiego serca w gnanie na pewną śmierć i miażdżenie wrogów pod swymi stopami. Nie spotkałeś go dziś w obozie, lecz powiedziano ci, że poszedł szukać drewna na opał. Jako że ta robota zwykle nie zajmuje dwunastu godzin, wygląda na to, iż %desertedbrother% w końcu zdecydował się coś zrobić ze swym niezadowoleniem i ruszył w drogę, by poszukać szczęścia gdzie indziej. Wątpisz, czy jeszcze kiedyś go spotkasz. | W trakcie ostatnich podróży kompanię niestety spotkał szereg nieszczęść. %desertedbrother% odczuł to bardziej, niż pozostali. Kiepsko sypiał, wszczynał bójki i okazywał brak zdyscyplinowania Znaczy wtedy, gdy udało ci się go znaleźć. To nie podobało się ani tobie, ani jego kompanom. Nie pomogło też to, że %otherbrother% zamoczył jego śpiwór w płytkim rowie, którego bracia używali jako latryny.\n\nZazwyczaj najlepiej jest pozwolić, aby ludzie sami znaleźli upust swojemu nieszczęściu, a jako że kompania ostatnio przechodziła przez trudne czasy, byłeś tolerancyjny. Kiedy tego ranka okazało się, że %desertedbrother% zniknął, nie było to dla ciebie zaskoczeniem. Zdezerterował z kompanii. | Z niepokojem przyjmujesz informację, że %desertedbrother% zniknął podczas nocy. Po przepytaniu pozostałych i upewnieniu się, że po prostu nie odszedł za pobliski głaz, by ulżyć swym jelitom, wzywasz do rozpoczęcia poszukiwań. Jesteś przekonany, że %desertedbrother% został wzięty podstępem, porwany dla okupu lub że został rozszarpany przez jakąś bestię i bracia poświęcają kilka godzin na przeczesywanie okolicy, wzywając jego imię.\n\nW końcu %otherbrother% zasugerował, że %desertedbrother% wcale nie zniknął, a po prostu zdezerterował.%SPEECH_ON%Ostatnio strasznie biadolił na temat kompanii, ale widocznie to przed tobą skrywał, panie, by mieć szansę na wymknięcie się niepostrzeżonym.%SPEECH_OFF%Powstrzymując nagłą chęć obicia gęby posłańcowi przynoszącemu złe nowiny, pytasz, dlaczego wcześniej się z tym nie zgłosił, lecz brat nie odpowiedział. | Nigdy nie sądziłeś, by %desertedbrother% był typem dezertera, jednak gdy nadszedł świt, a jego nie było w okolicy, nagle zrozumiałeś, że byłeś naiwny. W każdym marszu coraz bardziej się ociągał i zostawał z tyłu, a za każdym razem, gdy wydawałeś rozkaz do zwinięcia obozu, on był ostatnim do zebrania swego sprzętu i ruszenia w drogę. Jego wyposażenie też wyglądało coraz gorzej. Mimo iż swe myśli zachowywał dla siebie, to z perspektywy czasu jego kwaśne miny i brak zainteresowania kompanami wyraźnie wskazywały, że nie jest zadowolony z kierunku, w którym zmierza ostatnio kompania.\n\nWzywasz innych i dowiadujesz się, ze że ogólne niezadowolenie wzrosło. Karm i pój swych ludzi, jak każde zwierzę, i dopilnuj, by płacono im na czas, a być może %desertedbrother% będzie ostatnim, który uciekł pod osłoną nocy. | Nie wiesz, czy chodziło o niski żołd, groźbę kalectwa, wymuszony marsz w lodowatym deszczu, wulgarne słownictwo i podłe jedzenie, znęcanie się innych braci, dzieciaki ciskające w was kamieniami, chłodny wiatr czy bezsenne noce, ale %desertedbrother% stawał się coraz bardziej nieszczęśliwy, aż w końcu całkiem zrezygnował z życia najemnika.%SPEECH_ON%Nie wiem na co miałby narzekać. Jak dla mnie wszystko jest w porządku.%SPEECH_OFF%Rzekł %otherbrother%, słysząc o całym zajściu. %desertedbrother% wybrał wolność ponad kompanię. Przynajmniej miał na tyle przyzwoitości, by osobiście ci to oznajmić - choć, gdy teraz o tym myślę, zapewne zrobił to tylko po to, by odebrać zaległy żołd. | Ostatnimi czasy %desertedbrother% zaczął wybierać się na długie wieczorne przechadzki, gdy robota na dany dzień była skończona. Choć jego nawyk samotnego wędrowania nie był zbyt bezpieczny, nie miałeś powodu go zatrzymywać, skoro nie był potrzebny w obozie. Jednakże z im większymi trudnościami mierzyła się kompania, tym, dłuższe były spacery, aż pewnego ranka %desertedbrother% wcale nie wrócił.\n\n%desertedbrother% zdezerterował z kompanii. Prawdopodobnie tak będzie najlepiej. | %desertedbrother% był ostatnio dość markotny, spędzając całe godziny pieszcząc stary nóż do rzucania, którego ostrze było w tak kiepskim stanie, że bardziej przypominał on jakiś kawałek złomu, niż prawdziwą broń. Minione wieczory spędził rzucając nim w pień uschłego drzewa, jęcząc za każdym razem, gdy wstawał, aby pójść po nóż, po czym odchodził na kilka kroków, kucał i znów nim miotał, prosto w czerń nocy.\n\nBył wyraźnie nieszczęśliwy z niedawnych komplikacji, z którymi mierzyła się kompania, a tego ranka zebrał w sobie na tyle odwagi, by wejść do twego namiotu i wytłumaczyć, że opuszcza kompanię, by szukać szczęścia gdzie indziej.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "{Nie mogę go zmusić do pozostania w kompanii... | W rzeczy samej, kiepskie wieści. | Chwilowa komplikacja. | Nie mogę pozwolić, by coś takiego się powtórzyło.}",
					function getResult( _event )
					{
						if (this.World.Assets.getEconomicDifficulty() != this.Const.Difficulty.Hard)
						{
							_event.m.Deserter.getItems().transferToStash(this.World.Assets.getStash());
						}

						this.World.getPlayerRoster().remove(_event.m.Deserter);
						_event.m.Deserter = null;
						_event.m.Other = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Deserter.getImagePath());
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Deserter.getName() + " opuszcza kompanię"
				});
				this.updateAchievement("Deserter", 1, 1);
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"desertedbrother",
			this.m.Deserter.getName()
		]);
		_vars.push([
			"otherbrother",
			this.m.Other.getName()
		]);
	}

	function onClear()
	{
		this.m.Deserter = null;
	}

});

