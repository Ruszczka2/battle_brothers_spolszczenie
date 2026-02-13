this.undead_outro_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.undead_outro";
		this.m.Title = "Wzdłuż drogi...";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]Zasypiasz.\n\n Czerń. Ciemność. Wszystko, czym powinien być sen, z wyjątkiem jednej drobnej rzeczy: wiesz, że w nim jesteś. Stoisz w pustce jak zagubiona myśl. Głos spływa na ciebie, kropląc ze wszystkich stron, jakbyś był w samych ustach, które go wypowiedziały.%SPEECH_ON%Czemu nas porzuciłeś, Cesarzu?%SPEECH_OFF%Obracasz się, a przynajmniej tak ci się wydaje, bo nie ma niczego wokół, co pozwoliłoby oprzeć choćby najdrobniejszy ruch.%SPEECH_ON%Obiecałeś mi, nie pamiętasz? Powiedziałeś, że będzie dobrze, jeśli wszystko się rozpadnie. Powiedziałeś, że masz plan, że zawarłeś układ z tym brzydkim, brzydkim człowiekiem. Co się stało?%SPEECH_OFF%",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "Nie byłem wybrańcem.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Odpoczywaj spokojnie, moja miłości. W śmierci nie ma czego się bać.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Kim był ten brzydki człowiek?",
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
			ID = "B",
			Text = "[img]gfx/ui/events/event_33.png[/img]Podnosisz głos.%SPEECH_ON%Nie jestem wybrańcem.%SPEECH_OFF%Zanim wyznanie zdąży wybrzmieć, ona zaczyna szlochać. Jej słowa przebijają się przez łkanie jak czkająca szczerość.%SPEECH_ON%J-j-ja wiem... Nie chciałam tego przyznać, ale wiem. Imperium umiera wraz z nami. Sy\'leth daef\'nya, mój Cesarzu.%SPEECH_OFF%Słowo 'Cesarzu' rozbrzmiewa coraz ciszej, aż zostaje tylko ciemność i cisza.",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "Obudź się!",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_33.png[/img]Na początku nic nie mówisz. Ona zaczyna płakać. Słyszysz łzy, każda kropla odbija się echem dookoła ciebie.%SPEECH_ON%Czy jesteś tam, mój Cesarzu?%SPEECH_OFF%Odchrząkujesz i odpowiadasz.%SPEECH_ON%Tak, jestem. Imperium nie powstanie ponownie. Musimy odejść. W śmierci nie ma czego się bać.%SPEECH_OFF%Kobieta szlocha, ale powoli się uspokaja.%SPEECH_ON%Nie boję się. Po drugiej stronie, ish\'nyarh ishe\'yarn, mój Cesarzu.%SPEECH_OFF%Gdy jej słowa bledną w czerni, a być może i w twoim umyśle, zostaje tylko cisza.",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "Obudź się!",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_33.png[/img]Odwracasz się.%SPEECH_ON%Kim był ten brzydki człowiek?%SPEECH_OFF%Głos kobiety drży ze zszokowania.%SPEECH_ON%Ty, ty nie pamiętasz?%SPEECH_OFF%Odchrząkujesz, udając szczerość utraconych wspomnień.%SPEECH_ON%Nie pamiętam nic, moja miłości.%SPEECH_OFF%Nad ciemnością opada wielkie westchnienie. Czujesz jego frustrację. Mówi z rozdrażnieniem.%SPEECH_ON%Wiedziałam, że nie powinniśmy mu ufać... Brzydki człowiek przyszedł do nas w noc, kiedy nasze dziecko urodziło się martwe. Powiedział, że jeśli będzie mógł wziąć naszą krew, a także krew naszego martwego dziecka, sprawi, że Imperium nigdy nie umrze, a my będziemy jego wiecznymi władcami. Ale... było to za cenę.%SPEECH_OFF%Szybko rozumiesz i odpowiadasz.%SPEECH_ON%Uczynił cię bezpłodną.%SPEECH_OFF%Kobieta szlocha.%SPEECH_ON%Nigdy nie powinniśmy mu ufać! Dopadnę tego brzydkiego człowieka! Nie miej wątpliwości, kearem su\'llah. Skazuję go na wieczność, wieczność bólu i cierpienia!%SPEECH_OFF%Niegdyś czarna pustka rozbłyskuje czerwienią, ukazując świat purpury, barwę furii. Podnosisz rękę, zasłaniając oczy. Ona krzyczy, przeszywając twoje uszy, aż słyszysz tylko ostry dzwon.",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "Obudź się!",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_33.png[/img]Budzisz się. Szorstki wiatr wygina namiot, marszcząc skórę i tocząc fale po suficie. Słabe światło świec migocze, tak samo rozpraszając mrok, jak i go budując. %dude% stoi tam, obserwując cię, cienie przesuwają się tam i z powrotem po jego piersi. Przestępuje z nogi na nogę, z niepokojem na twarzy.%SPEECH_ON%Z kim rozmawiałeś?%SPEECH_OFF%Wychodząc z łóżka, stawiasz buty na ziemi, chcąc upewnić się co do tej rzeczywistości, zanim z nią rozmawiasz. Ziemia szeleszczy i chrupie pod stopami. Odpowiadasz.%SPEECH_ON%Nie jestem pewien. Myślę... myślę, że inwazja się skończyła.%SPEECH_OFF%Najemnik kiwa głową i wskazuje ręką wejście do namiotu.%SPEECH_ON%Tak, dlatego tu jestem. Przed chwilą przybył szlachecki posłaniec. Mówi, że nieumarli przestali wyłaniać się z ziemi. Skrybowie uważają, że to koniec. Wszystko w porządku, panie?%SPEECH_OFF%Pocierasz głowę. Czy to czas na emeryturę? Co możesz myśleć o tym świecie teraz, gdy wiesz to, co wiesz? Albo pójdziesz żyć resztę dni w spokoju, albo powiesz do diabła z tym wszystkim i poprowadzisz %companyname% ku dalszej chwale.\n\n%OOC%Wygrałeś! Battle Brothers zostało zaprojektowane z myślą o regrywalności i kampaniach, które kończy się po pokonaniu jednego lub dwóch późnych kryzysów. Nowa kampania pozwoli ci spróbować różnych rzeczy w innym świecie.\n\nMożesz też kontynuować kampanię tak długo, jak chcesz. Pamiętaj jednak, że kampanie nie są przeznaczone do trwania wiecznie i w końcu zabraknie ci wyzwań.%OOC_OFF%",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "%companyname% potrzebuje swojego dowódcy!",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "Czas przejść na emeryturę z życia najemnika. (Zakończ kampanię)",
					function getResult( _event )
					{
						this.World.State.getMenuStack().pop(true);
						this.World.State.showGameFinishScreen(true);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				this.updateAchievement("BaneOfTheUndead", 1, 1);

				if (this.World.Assets.isIronman())
				{
					this.updateAchievement("ManOfIron", 1, 1);
				}

				if (this.World.Assets.isIronman())
				{
					local defeated = this.getPersistentStat("CrisesDefeatedOnIronman");
					defeated = defeated | this.Const.World.GreaterEvilTypeBit.Undead;
					this.setPersistentStat("CrisesDefeatedOnIronman", defeated);

					if (defeated == this.Const.World.GreaterEvilTypeBit.All)
					{
						this.updateAchievement("Savior", 1, 1);
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.Statistics.hasNews("crisis_undead_end"))
		{
			local brothers = this.World.getPlayerRoster().getAll();
			local most_days_with_company = -9000.0;
			local most_days_with_company_bro;

			foreach( bro in brothers )
			{
				if (bro.getDaysWithCompany() > most_days_with_company)
				{
					most_days_with_company = bro.getDaysWithCompany();
					most_days_with_company_bro = bro;
				}
			}

			this.m.Dude = most_days_with_company_bro;
			this.m.Score = 6000;
		}
	}

	function onPrepare()
	{
		this.World.Statistics.popNews("crisis_undead_end");
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"dude",
			this.m.Dude.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

