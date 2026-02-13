this.goblin_city_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.goblin_city_enter";
		this.m.Title = "Gdy się zbliżasz...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_119.png[/img]{%randombrother% kręci głową.%SPEECH_ON%Niech starzy bogowie zlitują się nad nami za to, że pozwolili na taki widok.%SPEECH_OFF%Miasto goblinów jest wciśnięte między przeciwległe góry. Mówienie, że gobliny zbudowały miasto wokół gór, jest jak twierdzić, że żołnierz schował miecz w klatce piersiowej wroga. Gaworzące zielonoskóre nie dodały nic do terenu, tylko zbezcześciły to miejsce w całości, kładąc kopalnie tam, gdzie kiedyś stały drzewa, budując labirynt zardzewiałych szałasów i prowizorek, stawiając kultowe totemy i kopiąc prymitywne doły ofiarne, piętrząc nieużyteczne drewno, jakby okaleczanie góry nie było dokończone bez jawnego marnotrawstwa.\n\n Jednak ponad goblińskim śmietniskiem wznosi się centralny rdzeń miasta, kilka wież wyraźnie odseparowanych od pospólstwa. To ewidentnie starożytne konstrukcje, kamieniarka niepodobna do niczego, co kiedykolwiek widziałeś, i z pewnością poza możliwościami zielonoskórych. Gobliny chodzące wśród murów są wyprostowane i wyniosłe, jakby dodawało im sił pozwolenie na stąpanie po tak uświęconych ziemiach. Wewnątrz fortecy zdają się mieszkać jakaś wyższa szlachta, dobrze ubrane gobliny z krzątającymi się sługami, co znaczy to samo, co u ludzi: jest tu dobry łup.\n\n Rzadkim widokiem są małe gobliny biegające wszędzie. Rodziny, jeśli zielonoskórzy w ogóle je mają, oznaczają, że walka będzie tu wyjątkowo zaciekła. Te małe larwy będą miały do ochrony coś więcej niż tylko dzikość i chciwość, a to, co musi wyjść poza własne występki, jest zarazem tym, co zostało osłabione.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jaki plan?",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Na razie odejdźmy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IsGoblinCityVisited", true);

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_119.png[/img]{Po pewnym czasie obserwacji miasta wiesz, że nie możesz po prostu zaatakować go frontalnie. Jest ich zbyt wielu i przy tej przewadze liczebnej prawdopodobne jest, że nawet rodziny goblinów wezmą udział w twojej rzezi, a miasto jedynie zyska dodatkowe doświadczenie w mordowaniu ludzi. Więc czekasz. I myślisz. A potem podchodzi mężczyzna.\n\n Jest opięty w lekkiej zbroi, z liściastym kapturem maskującym metal pod spodem, a z jego biodra brzęczy mnóstwo mieczy, przez plecy ma przewieszoną włócznię z jednej strony i topór z drugiej, a bandolier z miksturami pobrzękuje, gdy się zatrzymuje. Nie widzisz jego twarzy, a tym bardziej oczu, i ocieka krwią świeżej akcji.%SPEECH_ON%Mimo swoich okrucieństw i okrutnego wyglądu, gobliny są w pewien sposób cywilizowane. Zareagują na przemoc, która u podstaw jest niczym innym jak bezsensowną dzikością. Jeśli chcesz je wywabić, musisz zrobić to, co robią orki. Mój plan zakładał wybicie tylu, ilu znajdę na polach: grup łupieżczych, zwiadowców i tym podobnych, ale równie dobrze, by ich obozowiska zostały zniszczone w dużej liczbie. Razem ta rzeź będzie jak kleszcze na ich strachu, bo bardziej niż czegokolwiek boją się nieokrzesanych orków i będą chcieli wyprzedzająco ich zdusić.%SPEECH_OFF%Mężczyzna kiwa głową, jakbyś już na coś przystał.%SPEECH_ON%Zatem wybierz, wędrowcze, sposób, w jaki chcesz zrównać to miasto z ziemią. Wyrżniesz ich grupy łupieżcze i zwiadowców, czy spalisz wysunięte posterunki? Cokolwiek zrobisz, ja zrobię drugie, sam, a spotkamy się tu, gdy wynik naszych działań będzie oczywisty.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wyrżniemy ich zwiadowców i grupy łupieżcze.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Zajmiemy się wysuniętymi posterunkami.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_119.png[/img]{Mówisz mu, że %companyname% wyrżnie gobliny na polach. Mężczyzna kiwa głową.%SPEECH_ON%Ach, wędrowcze, to dobry wybór. Znikanie tych grup nadwyręży przekonania zielonoskórych. To urodzeni zwiadowcy i rabusie, więc gdy ci z takiego rodzaju znikają, niepokoi ich to do głębi. Wysunięte posterunki się wycofają i rozniosą plotki do miasta, a wtedy wyjdzie siła ekspedycyjna. Gdy ty będziesz ich łapał na polach, ja dopilnuję, by wiele obozowisk zostało zniszczonych. Z własnego doświadczenia wiem, że wystarczy zniszczyć około %goblinkillcount% ich grup.%SPEECH_OFF%Odchodzi, ale wołasz, pytając kim jest, albo czy nie lepiej byłoby połączyć siły. Całkowicie cię ignoruje i odchodzi.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wrócimy po zniszczeniu %goblinkillcount% goblińskich grup.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IsGoblinCityScouts", true);
				this.World.Flags.set("GoblinCityCount", 0);
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_119.png[/img]{Mówisz nieznajomemu, że %companyname% zajmie się niszczeniem obozowisk. Kiwając głową, mówi:%SPEECH_ON%Wspaniale, wędrowcze, wspaniale! Gobliny często wysyłają grupy łupieżcze, a gdy wracają do popiołów, wrócą tutaj, roznosząc wieści o zniszczeniu, i zostaną wyprowadzeni. Dobrze. Mamy plan i z własnego doświadczenia wiem, że trzeba zniszczyć około %goblinpostcount% obozowisk. Ty weźmiesz ich posterunki, ja wezmę ich grupy.%SPEECH_OFF%Odchodzi, ale wołasz, pytając kim jest, albo czy nie lepiej byłoby połączyć siły. Całkowicie cię ignoruje i odchodzi.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wrócimy po zrównaniu z ziemią pięciu posterunków.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IsGoblinCityOutposts", true);
				this.World.Flags.set("GoblinCityCount", 0);
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_119.png[/img]{Wracasz do miasta, ale nieznajomy, którego spotkałeś wcześniej, nigdzie się nie pokazuje. Jednak to, co widać, to ogromny kontyngent goblińskich sił maszerujących z miasta. Idą zwartym krokiem i głośno skrzeczą. Ich przywódcy siedzą na osiodłanych wilkach, a ich sztandary wojenne kołyszą się na boki niczym flota wypływająca na morze. Rodziny goblinów stoją przy bramach. Rzucają garści kości na maszerujących, a czasem widzisz, jak spada kończyna psa lub człowieka, a którykolwiek goblin ją złapie, unosi ją jak trofeum, a otaczający oddział wiwatuje. Zajmuje pełną godzinę, by armia przeszła, po czym gobliny przy bramach cofają się do miasta, a kilku strażników kręci się bez celu.\n\nWciąż jest ich dość, by stawić dobry opór, ale za mało, by poradzić sobie z %companyname%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Przygotować atak.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setAttackable(true);
							this.World.State.getLastLocation().m.IsShowingDefenders = true;
						}

						this.World.Events.showCombatDialog(true, true, true);
						return 0;
					}

				},
				{
					Text = "Wycofać się na razie.",
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
			ID = "F",
			Text = "[img]gfx/ui/events/event_119.png[/img]{Miasto goblinów pozostaje strzeżone przez hordę małych zielonoskórych. Przypominasz sobie, że %companyname% musi zniszczyć jeszcze kilka ich patroli i zwiadowców, aby odciągnąć armię od miasta.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wrócimy po zniszczeniu %goblinkillcount% goblińskich grup.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_119.png[/img]{Miasto goblinów pozostaje strzeżone przez hordę małych zielonoskórych. Przypominasz sobie, że %companyname% musi zniszczyć jeszcze kilka ich obozowisk i wysuniętych posterunków, aby odciągnąć armię od miasta.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wrócimy po zrównaniu z ziemią %goblinpostcount% posterunków.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}
			}

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"goblinkillcount",
			"dziesięć"
		]);
		_vars.push([
			"goblinpostcount",
			"pięć"
		]);
	}

	function onDetermineStartScreen()
	{
		if (!this.World.Flags.get("IsGoblinCityVisited"))
		{
			return "A";
		}
		else if (this.World.Flags.get("IsGoblinCityOutposts") && this.World.Flags.get("GoblinCityCount") >= 5 || this.World.Flags.get("IsGoblinCityScouts") && this.World.Flags.get("GoblinCityCount") >= 10)
		{
			return "E";
		}
		else if (this.World.Flags.get("IsGoblinCityScouts"))
		{
			return "F";
		}
		else if (this.World.Flags.get("IsGoblinCityOutposts"))
		{
			return "G";
		}
		else
		{
			return "A";
		}
	}

	function onClear()
	{
	}

});

