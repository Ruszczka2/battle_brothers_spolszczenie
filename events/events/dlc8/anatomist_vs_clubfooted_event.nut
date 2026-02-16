this.anatomist_vs_clubfooted_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Clubfooted = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_vs_clubfooted";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Zastajesz %anatomist% anatomistę, jak przygląda się niezgrabnym stopom %clubfoot%: a właściwie temu, że jedna z nich wygląda jak worek młotów. To obrzydliwe, odpychające i, rzecz jasna, utrudnia mu wykonywanie pełnych obowiązków najemnika. Mówi się, że to dziwnie pociąga kobiety, ale to niepotwierdzone plotki. Tak czy inaczej, anatomista przychodzi do ciebie z propozycją.%SPEECH_ON%To wcale nie taka rzadka dolegliwość, ta koślawość stopy. W młodym wieku łatwo ją naprawić, ale operacja staje się coraz trudniejsza, im człowiek starszy. Na szczęście jestem wyszkolonym anatomistą z ogromną wiedzą na ten temat. Jeśli mi pozwolisz, spróbuję wyleczyć tego mężczyznę z jego nieszczęsnej i zupełnie niepotrzebnej, dożywotniej przypadłości.%SPEECH_OFF%%clubfoot% kiwa głową, mówiąc, że jest gotów spróbować, jeśli uznasz to za najlepsze.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zrób to, wykonaj swoje rzemiosło.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "Nie, ryzyko jest zbyt duże.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Clubfooted.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Dajesz %anatomist% zielone światło. On i koślawy mężczyzna odchodzą, krocząc i kulejąc, by załatwić sprawę. Naturalnie idziesz popatrzeć. Widzisz, jak %anatomist% układa stopę %clubfoot% na stołku. Wyciąga kawałek drewna, w którym już widać odciski zębów. Potem bierze fiolkę z płynem, odtyka korek, naciera nim drewno, sam bierze łyk, po czym podaje resztę pacjentowi. %clubfoot% wypija, a potem zagryza drewno. Następuje obrzydliwa seria łamań nogi, zakładania gipsu i ponownego gipsowania. %anatomist% zaczyna nacięcie skalpelem, szczerząc się obłąkańczo podczas pracy. %clubfoot% dawno już odpłynął.\n\nGdy wszystko się kończy, noga %clubfoot% jest kompletnie zmasakrowana i zagesowana. %anatomist% twierdzi, że operacja się powiodła, choć potrzebny będzie dość długi okres rekonwalescencji. Stopa będzie musiała być gipsowana raz po raz, a za każdym razem ustawiana odrobinę bardziej, ale da się to zrobić. Omajaczony %clubfoot% uśmiecha się, spoglądając na swoją stopę.%SPEECH_ON%Warto będzie, kapitanie. Dla mnie i dla %companyname%.%SPEECH_OFF%Dość sumienny i odurzony najemnik pada do tyłu i zasypia z głośnym chrapaniem.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Maszeruj, bracie, to twoje życie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Clubfooted.getSkills().removeByID("trait.clubfooted");
				this.List.push({
					id = 10,
					icon = "ui/traits/trait_icon_23.png",
					text = _event.m.Clubfooted.getName() + " nie jest już Koślawy"
				});
				local injury = _event.m.Clubfooted.addInjury([
					{
						ID = "injury.broken_leg",
						Threshold = 0.0,
						Script = "injury/broken_leg_injury"
					}
				]);
				this.List.push({
					id = 11,
					icon = injury.getIcon(),
					text = _event.m.Clubfooted.getName() + " odnosi " + injury.getNameOnly()
				});
				injury = _event.m.Clubfooted.addInjury([
					{
						ID = "injury.cut_achilles_tendon",
						Threshold = 0.0,
						Script = "injury/cut_achilles_tendon_injury"
					}
				]);
				this.List.push({
					id = 12,
					icon = injury.getIcon(),
					text = _event.m.Clubfooted.getName() + " odnosi " + injury.getNameOnly()
				});
				_event.m.Clubfooted.improveMood(1.0, "Wyleczono mu koślawość");
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Clubfooted.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Niechętnie dajesz zielone światło, by %anatomist% anatomista zabrał się do pracy. Rozważasz dołączenie do niego i %clubfoot% w namiocie, ale coś w łamaniu stopy, by ją wyleczyć, nie do końca... stoi. Zamiast tego zajmujesz się ulubionym zadaniem: liczeniem zapasów. Spokój i cisza, notowanie ile czego masz, ile będziesz potrzebował, i w jakim tempie kompania zużywa te rzeczy. To wszystko jest fascynujące.\n\nNaprawdę nie ma nic lepszego od liczenia zapasów, a jedyne, co mogłoby przerwać twoją przyjemność, to przenikliwe, okropne krzyki %clubfoot% dobiegające z namiotu, do którego tak skrupulatnie nie wchodziłeś. Teraz, gdy jego pisk wypełnia powietrze, biegniesz do namiotu i wchodzisz do środka. Zastajesz %anatomist% z boku, ocierającego pot z czoła.%SPEECH_ON%Witaj, kapitanie. Cóż, pozwól, że podsumuję. Jak widać, pojawiły się pewne nieprzewidziane komplikacje. Oczywiście wyzdrowieje, nie martw się o to, ale koślawość pozostanie. Okazała się, eee, odporna na moje zabiegi.%SPEECH_OFF%Patrzysz na %clubfoot%. Teraz jest nieprzytomny, a poniżej kolan noga jest wykręcona jak szmata. Anatomista kiwa uprzejmie głową.%SPEECH_ON%Nie martw się tym, to też naprawię. Potrzebowałem tylko, by przestał tak krzyczeć i wiercić się oraz chwili oddechu, żebym sam mógł złapać oddech. Chcesz patrzeć?%SPEECH_OFF%Anatomista chwyta mężczyznę za stopę. Ta lata w jego uścisku, jakby trzymał ciasto. Kręcisz głową i pospiesznie wychodzisz z namiotu.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Aaaach.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local injury = _event.m.Clubfooted.addInjury([
					{
						ID = "injury.broken_leg",
						Threshold = 0.0,
						Script = "injury/broken_leg_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Clubfooted.getName() + " odnosi " + injury.getNameOnly()
				});
				injury = _event.m.Clubfooted.addInjury([
					{
						ID = "injury.traumatized",
						Threshold = 0.0,
						Script = "injury_permanent/traumatized_injury"
					}
				]);
				this.List.push({
					id = 11,
					icon = injury.getIcon(),
					text = _event.m.Clubfooted.getName() + " odnosi " + injury.getNameOnly()
				});
				_event.m.Clubfooted.worsenMood(this.Const.MoodChange.PermanentInjury, "Eksperymentowano na nim jak na szaleńcu");
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Clubfooted.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Patrzysz na %anatomist% pytająco.%SPEECH_ON%Czy ja tu prowadzę stadninę wyścigową? Jeśli ten człowiek chce naprawić zepsutą stopę, niech odejdzie na odpoczynek z honorem i godnością. Nie potrzebujemy dziwacznych eksperymentów, które skończą się bogowie wiedzą jakimi rezultatami.%SPEECH_OFF%Anatomista odchrzakuje i mówi, że zabiegi są dość proste, ale zdradza się, wspominając, że zyski naukowe z ich przeprowadzenia są ogromne, co pokazuje, że wcale nie miał na uwadze interesu %clubfoot%. Mówisz mu, że rozmowa jest skończona.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Kulej dalej.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(1.0, "Odmówiono mu okazji do badań");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

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
		local clubfootedCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomistCandidates.push(bro);
			}
			else if (bro.getBackground().getID() != "background.anatomist" && bro.getSkills().hasSkill("trait.clubfooted"))
			{
				clubfootedCandidates.push(bro);
			}
		}

		if (clubfootedCandidates.len() == 0 || anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.Clubfooted = clubfootedCandidates[this.Math.rand(0, clubfootedCandidates.len() - 1)];
		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Score = 5 * clubfootedCandidates.len();
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
		_vars.push([
			"clubfoot",
			this.m.Clubfooted.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Clubfooted = null;
	}

});

