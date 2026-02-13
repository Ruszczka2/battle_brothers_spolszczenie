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
			Text = "[img]gfx/ui/events/event_05.png[/img]{Zastajesz %anatomist% anatomiste, jak przyglada sie niezgrabnym stopom %clubfoot%: a wlasciwie temu, ze jedna z nich wyglada jak worek mlotow. To obrzydliwe, odpychajace i, rzecz jasna, utrudnia mu wykonywanie pelnych obowiazkow najemnika. Mowi sie, ze to dziwnie pociaga kobiety, ale to niepotwierdzone plotki. Tak czy inaczej, anatomista przychodzi do ciebie z propozycja.%SPEECH_ON%To wcale nie taka rzadka dolegliwosc, ta koslawosc stopy. W mlodym wieku latwo ja naprawic, ale operacja staje sie coraz trudniejsza, im czlowiek starszy. Na szczescie jestem wyszkolonym anatomista z ogromna wiedza na ten temat. Jesli mi pozwolisz, sprobuje wyleczyc tego mezczyzne z jego nieszczesnej i zupelnie niepotrzebnej, dozywotniej przypadlosci.%SPEECH_OFF%%clubfoot% kiwa glowa, mowiac, ze jest gotow sprobowac, jesli uznasz to za najlepsze.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zrob to, wykonaj swoje rzemioslo.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "Nie, ryzyko jest zbyt duze.",
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
			Text = "[img]gfx/ui/events/event_05.png[/img]{Dajesz %anatomist% zielone swiatlo. On i koslawy mezczyzna odchodza, kroczac i kulejac, by zalatwic sprawe. Naturalnie idziesz popatrzec. Widzisz, jak %anatomist% uklada stope %clubfoot% na stolku. Wyciaga kawalek drewna, w ktorym juz widac odciski zebow. Potem bierze fiolke z plynem, odtyka korek, naciera nim drewno, sam bierze lyk, po czym podaje reszte pacjentowi. %clubfoot% wypija, a potem zagryza drewno. Nastepuje obrzydliwa seria laman nogi, zakladania gipsu i ponownego gipsowania. %anatomist% zaczyna naciecie skalpelem, szczerzac sie oblakanczo podczas pracy. %clubfoot% dawno juz odpłynal.\n\nGdy wszystko sie konczy, noga %clubfoot% jest kompletnie zmasakrowana i zagesowana. %anatomist% twierdzi, ze operacja sie powiodla, choc potrzebny bedzie dość dlugi okres rekonwalescencji. Stopa bedzie musiala byc gipsowana raz po raz, a za kazdym razem ustawiana odrobine bardziej, ale da sie to zrobic. Omajaczony %clubfoot% usmiecha sie, spogladajac na swoja stope.%SPEECH_ON%Warto bedzie, kapitanie. Dla mnie i dla %companyname%.%SPEECH_OFF%Dosyc sumienny i odurzony najemnik pada do tylu i zasypia z glosnym chrapaniem.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Maszeruj, bracie, to twoje zycie.",
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
					text = _event.m.Clubfooted.getName() + " nie jest juz Koslawy"
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
				_event.m.Clubfooted.improveMood(1.0, "Wyleczono mu koslawosc");
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Clubfooted.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Niechetnie dajesz zielone swiatlo, by %anatomist% anatomista zabral sie do pracy. Rozwazasz dolaczenie do niego i %clubfoot% w namiocie, ale cos w lamaniu stopy, by ja wyleczyc, nie do końca... stoi. Zamiast tego zajmujesz sie ulubionym zadaniem: liczeniem zapasow. Spokoj i cisza, notowanie ile czego masz, ile bedziesz potrzebowal, i w jakim tempie kompanie zuzywa te rzeczy. To wszystko jest fascynujace.\n\nNaprawde nie ma nic lepszego od liczenia zapasow, a jedyne, co mogloby przerwac twoja przyjemnosc, to przenikliwe, okropne krzyki %clubfoot% dobiegajace z namiotu, do ktorego tak skrupulatnie nie wchodziles. Teraz, gdy jego pisk wypełnia powietrze, biegniesz do namiotu i wchodzisz do srodka. Zastajesz %anatomist% z boku, ocierajacego pot z czola.%SPEECH_ON%Witaj, kapitanie. Cóż, pozwol, ze podsumuje. Jak widac, pojawily sie pewne nieprzewidziane komplikacje. Oczywiscie wyzdrowieje, nie martw sie o to, ale koslawosc pozostanie. Okazala sie, eee, odporna na moje zabiegi.%SPEECH_OFF%Patrzysz na %clubfoot%. Teraz jest nieprzytomny, a ponizej kolan noga jest wykrecona jak szmata. Anatomista kiwa uprzejmie glowa.%SPEECH_ON%Nie martw sie tym, to tez naprawie. Potrzebowalem tylko, by przestal tak krzyczec i wiercic sie oraz chwili oddechu, zebym sam mogl zlapac oddech. Chcesz patrzec?%SPEECH_OFF%Anatomista chwyta mezczyzne za stope. Ta lata w jego uscisku, jakby trzymal ciasto. Krecisz glowa i pospiesznie wychodzisz z namiotu.}",
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
				_event.m.Clubfooted.worsenMood(this.Const.MoodChange.PermanentInjury, "Eksperymentowano na nim jak na szalencu");
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Clubfooted.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Patrzysz na %anatomist% pytajaco.%SPEECH_ON%Czy ja tu prowadze stadnine wyscigowa? Jesli ten czlowiek chce naprawic zepsuta stope, niech odejdzie na odpoczynek z honorem i godnoscia. Nie potrzebujemy dziwacznych eksperymentow, ktore skoncza sie bogowie wiedza jakimi rezultatami.%SPEECH_OFF%Anatomista odchrzakuje i mowi, ze zabiegi sa dosc proste, ale zdradza sie, wspominajac, ze zyski naukowe z ich przeprowadzenia sa ogromne, co pokazuje, ze wcale nie mial na uwadze interesu %clubfoot%. Mowisz mu, ze rozmowa jest skonczona.}",
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
				_event.m.Anatomist.worsenMood(1.0, "Odmowiono mu okazji do badan");

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

