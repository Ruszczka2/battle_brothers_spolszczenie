this.pimp_vs_harlot_event <- this.inherit("scripts/events/event", {
	m = {
		Minstrel = null,
		Monk = null,
		Tailor = null,
		Dude = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.pimp_vs_harlot";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_92.png[/img]Natrafiasz na mężczyznę i kobietę kłócących się przed jednym z miejskich budynków.%SPEECH_ON%Czemu oddaję ci wszystko? To ja robię całą robotę!%SPEECH_OFF%krzyczy. Mężczyzna pociera brodę i odpowiada.%SPEECH_ON%Ja zarządzam cipą! Jak znalazłabyś robotę beze mnie?%SPEECH_OFF%Kobieta, widząc cię, odwraca się i pyta, czy byś z nią pospał. Mogłaby być ukształtowana jak dwa koła i trójkąt, a i tak byś się skusił. Kobieta rozkłada ręce.%SPEECH_ON%Widzisz? Połowa tego świata jest gotowa na interesy, jeśli tylko rozchylę nogi!%SPEECH_OFF%Niedoszły sutener prosi cię, byś przemówił do rozsądku jego \"towarowi\".",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Sutenerzy dbają o twoje bezpieczeństwo w tym świecie.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Nie ma nic złego w dziwce, która gra według własnych zasad.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Minstrel != null)
				{
					this.Options.push({
						Text = "Wygląda na to, że nasz minstrela ma coś do powiedzenia.",
						function getResult( _event )
						{
							return "Minstrel";
						}

					});
				}

				if (_event.m.Monk != null)
				{
					this.Options.push({
						Text = "Czy nasz mnich chce się wypowiedzieć o tym... fachu?",
						function getResult( _event )
						{
							return "Monk";
						}

					});
				}

				if (_event.m.Tailor != null)
				{
					this.Options.push({
						Text = "Krawiec kompanii może mieć tu coś do dodania.",
						function getResult( _event )
						{
							return "Tailor";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_92.png[/img]Udzielasz odpowiedzi.%SPEECH_ON%Sutener zapewnia ochronę. To, że każdy napalony fiut chce tego, co masz między nogami, nie znaczy, że jesteś bezpieczna. Najmniejsza zniewaga potrafi obudzić w kliencie jego mroczniejszą, bardziej brutalną naturę.%SPEECH_OFF% Sutener kiwa głową.%SPEECH_ON%Właśnie! Słuchaj go!%SPEECH_OFF%Zamyślona prostytutka kiwa głową, po czym nagle policzkuje sutenera. Ten krzyczy i pociera bąbel. Kobieta znów kiwa głową.%SPEECH_ON%To to ma mnie chronić, serio? Dobrego dnia, panowie.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cholera. Myślałem, że lepiej ogarnia sutenerkę.",
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
			Text = "[img]gfx/ui/events/event_92.png[/img]Z ojcowską powagą kładziesz sutenerowi dłoń na ramieniu.%SPEECH_ON%Możesz wyjąć kobietę z dziwki, ale nie wyjmiesz dziwki z kobiety.%SPEECH_OFF%Sutener chwilę nad tym myśli. Ty też, bo nigdy nie byłeś mistrzem logiki. Sutener patrzy na ciebie.%SPEECH_ON%Co?%SPEECH_OFF%Kobieta podchodzi, kładąc sutenerowi dłoń na drugim ramieniu.%SPEECH_ON%Myślę, że mówi, żebyś mnie puścił wolno.%SPEECH_OFF%Gdy sutener unosi brew, kobieta doprecyzowuje.%SPEECH_ON%W przenośni.%SPEECH_OFF%Sutener wzdycha.%SPEECH_ON%Nie rozumiem, co wy do cholery mówicie, ale dobra. Myślałem, że może rozkręcę tu interes. Kobieta tu, kobieta tam, sprzedawać ich cipki i tyłki, zarobić trochę koron, przejść na emeryturę wcześniej. No cóż, wracam do mielenia zboża na mąkę, aż padnę i zdechnę.%SPEECH_OFF%Mężczyzna odchodzi, pociągając nosem.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Sutenerka nie jest dla każdego.",
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
			ID = "Minstrel",
			Text = "[img]gfx/ui/events/event_92.png[/img]%minstrel% minstrela sunie do przodu.%SPEECH_ON%Ahoj, cóż to jest, jeśli nie opowieść o głupcu i ogonie dziwki? Po jednym spojrzeniu wiem, co musisz zrobić, przyjacielu: wyznać tej cipce swoją nieśmiertelną miłość!%SPEECH_OFF%Kobieta krzyżuje ręce i marszczy brwi.%SPEECH_ON%Ale o czym ty w ogóle--%SPEECH_OFF%Minstrela odsuwa ją na bok, unosząc ramię i pojedynczy głos wraz z nim.%SPEECH_ON%Ahoooo! Miłość, tak, miłość unosi się w powietrzu! Niech płonie! - i nie mówię tylko o jego fiucie i jajach. On cię kocha, moja droga, nie widzisz? Czemu inaczej zrobiłby dziwkę tylko z ciebie? Sutener potrzebuje zróżnicowanego portfela, a nie interesu na jedną, święt-oh, ohhh!%SPEECH_OFF%Sutener spuszcza głowę, twarz mu czerwienieje z zawstydzenia. Przyznaje, że to prawda, wszystko. Kobieta spogląda, rumieniąc się. Krzyżują spojrzenia. Ty przewracasz oczami. Obejmują się i odchodzą w miłosnym uniesieniu. %minstrel% drapie się po brodzie.%SPEECH_ON%Jestem poetą i nawet... o tym nie wiedziałem.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Naprawdę niezła robota, minstrelu.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Minstrel.getImagePath());
				_event.m.Minstrel.improveMood(2.0, "Oczarowany własną poezją");

				if (_event.m.Minstrel.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Minstrel.getMoodState()],
						text = _event.m.Minstrel.getName() + this.Const.MoodStateEvent[_event.m.Minstrel.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Tailor",
			Text = "[img]gfx/ui/events/event_92.png[/img]\'Tsk, tsk, tsk.\' %tailor% krawiec podchodzi, kręcąc głową. Przeciąga palcem po sukience prostytutki. Zauważa, że myślał, iż dziwki powinny być ładne. Sutener unosi rękę.%SPEECH_ON%To moja własność, na którą plujesz.%SPEECH_OFF%%tailor% kłania się.%SPEECH_ON%Wybacz, panie, ale sądzę, że już sam na nią splunąłeś, ubierając ją w taki sposób. Nie wiedziałbym, że szuka pieniędzy z dziwki, gdybyś nie krzyczał na nią sutenerem, hm, beztroskim sensem ekonomii.%SPEECH_OFF%Sutener dobywa sztyletu i atakuje. Krawiec robi piruet, obracając się pod ciosem. Prostuje się i przykłada masywne nożyczki do gardła sutenera.%SPEECH_ON%Mmm, cóż za urocza pozycja. Śmiem twierdzić, że masz tylko dwa wyjścia, a jedno jest znacznie bardziej błyszczące od drugiego. Tak, właśnie, rozumiesz, prawda? Płać, albo poderżnę ci gardło i obetnę jaja, a kolejność może cię zaskoczyć.%SPEECH_OFF%Sutener w pośpiechu oddaje trochę koron, by ocalić życie. Krawiec \"trzaska\" nożyczkami i chowa je do kieszeni.%SPEECH_ON%Dobrze. A teraz rada. Na tamtej ulicy dostaniesz tanie płótna. Człowiek w sklepie jest, hm, szczególnie dobry w ubieraniu kobiet... i mężczyzn. Tata na razie.%SPEECH_OFF%%tailor% odwraca się do ciebie z uśmiechem i pyta, czy może zajrzeć do kilku sklepów, by wydać świeżo zdobyte złoto.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobra robota.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local money = this.Math.rand(100, 200);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] koron"
				});
				_event.m.Tailor.getBaseProperties().Initiative += 2;
				_event.m.Tailor.getSkills().update();
				this.List.push({
					id = 17,
					icon = "ui/icons/initiative.png",
					text = _event.m.Tailor.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Inicjatywy"
				});
				this.Characters.push(_event.m.Tailor.getImagePath());
				_event.m.Tailor.improveMood(1.0, "Sprowadził sutenera do parteru");

				if (_event.m.Tailor.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Tailor.getMoodState()],
						text = _event.m.Tailor.getName() + this.Const.MoodStateEvent[_event.m.Tailor.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Monk",
			Text = "[img]gfx/ui/events/event_92.png[/img]%monk% mnich robi krok do przodu. Chwyta sutenera za dłonie. Gdybyś ty to zrobił, sutener bez wątpienia cofnąłby się albo cię uderzył. Lecz święty mąż robi to z taką gracją i pokorą, że sutener tylko na niego patrzy. Mnich uśmiecha się ciepło.%SPEECH_ON%To nie jest twoja ścieżka, to jasne. Nie masz środków, by radzić sobie z tą kobietą, a to tylko jedna kobieta, gdy sutener naprawdę potrzebuje wielu. Starzy bogowie mówią mi, że przeznaczono cię na inną drogę, dla twardszych ludzi. Ośmielę się rzec, że nadajesz się do kompanii najemników. Zostaw ujarzmianie kobiet treserom węży.%SPEECH_OFF%Sutener chwilę myśli, ale widać, że słowa do niego trafiły. Pyta, czy przyjąłbyś go do kompanii.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze, weźmiemy cię.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "Nie, dzięki.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Monk.improveMood(1.0, "Sprowadził człowieka na ścieżkę prawości");

				if (_event.m.Monk.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk.getMoodState()],
						text = _event.m.Monk.getName() + this.Const.MoodStateEvent[_event.m.Monk.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Monk.getImagePath());
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"pimp_background"
				]);
				_event.m.Dude.setTitle("Sutener");
				_event.m.Dude.getBackground().m.RawDescription = "Podczas wizyty w " + _event.m.Town.getName() + " znalazłeś %name% kłócącego się ze swoją jedyną ladacznicą. " + _event.m.Monk.getName() + " przekonał go, by dołączył do kompanii, a ty zgodziłeś się go przyjąć. Oby lepiej radził sobie w walce w szyku tarcz niż w ogarnianiu dziwek.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getSize() >= 2 && !t.isMilitary() && !t.isSouthern() && t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidate_minstrel = [];
		local candidate_monk = [];
		local candidate_tailor = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.minstrel")
			{
				candidate_minstrel.push(bro);
			}
			else if (bro.getBackground().getID() == "background.monk")
			{
				candidate_monk.push(bro);
			}
			else if (bro.getBackground().getID() == "background.tailor")
			{
				candidate_tailor.push(bro);
			}
		}

		if (candidate_minstrel.len() != 0)
		{
			this.m.Minstrel = candidate_minstrel[this.Math.rand(0, candidate_minstrel.len() - 1)];
		}

		if (candidate_monk.len() != 0)
		{
			this.m.Monk = candidate_monk[this.Math.rand(0, candidate_monk.len() - 1)];
		}

		if (candidate_tailor.len() != 0)
		{
			this.m.Tailor = candidate_tailor[this.Math.rand(0, candidate_tailor.len() - 1)];
		}

		this.m.Town = town;
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"minstrel",
			this.m.Minstrel != null ? this.m.Minstrel.getNameOnly() : ""
		]);
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getNameOnly() : ""
		]);
		_vars.push([
			"tailor",
			this.m.Tailor != null ? this.m.Tailor.getNameOnly() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Monk = null;
		this.m.Minstrel = null;
		this.m.Tailor = null;
		this.m.Dude = null;
		this.m.Town = null;
	}

});

