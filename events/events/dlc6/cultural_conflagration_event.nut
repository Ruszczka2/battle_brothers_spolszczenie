this.cultural_conflagration_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.cultural_conflagration";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_175.png[/img]{Krzyki i wrzaski wyrywają cię z liczenia zapasów. Zastajesz kilku ludzi stojących po przeciwnych stronach ogniska, wskazujących palcami, a nawet bronią. Wygląda na to, że wybuchła sprzeczka o to, czyje kobiety są piękniejsze: południowe czy północne. Ironicznie, północniacy głosują na południowe i odwrotnie. Kilka stanowczych rozkazów przywraca porządek w kompanii, ale napięcie pozostaje. | Doszło do bójki między kilkoma ludźmi. Najwyraźniej nie zgadzali się co do obrzędów małżeńskich między mężczyznami i kobietami. Północniacy uważają, że powinno być jeden na jedną, podczas gdy południowcy wolą poślubić tyle kobiet, ile się da. Mówisz im, żeby przestali bić się jak kobiety i skupili na zadaniu - którym może być, a może nie, dokończenie roboty, żeby zdobyć monetę i wydać ją na kobietę, ale to już inna sprawa. | Kilku ludzi kłóci się o różnice religijne. Spór o starych bogów i Gildera, każdy mężczyzna małego ambasadora swojej wiary, dyplomatycznie wkładającego pięści w twarze przeciwnika. Mówisz wszystkim, żeby przestali i nastawili głowy na właściwy tor. Jeśli chcą kłócić się o to, którzy bogowie są lepsi, niech zrobią to w zaświatach. | Kilku ludzi kłóci się o... piasek? Wygląda na to, że północniacy w kompanii podśmiewają się z południowców, pytając, jak głupim trzeba być, by osiedlić się w krainie pełnej samego piasku.%SPEECH_ON%Kto rozgląda się po gorącym, cholernym piaszczystym wydmowisku i myśli: tak, to będzie mój dom. Założę się, że żałujecie, iż wasi przodkowie nie mieli rozumu, by zrozumieć, że świat to coś więcej niż przeklęte, wieczne poparzenie słoneczne.%SPEECH_OFF%To wywołuje pierwszy cios. Szamotanina kończy się kilkoma rannymi, ale przywracasz porządek, każąc im zachować swoje opinie geograficzne dla siebie. | Spór wybucha, gdy południowcy w kompanii zaczynają kpić z braku elokwencji u północnych braci. Jeden naśladuje ich, rozkładając dłonie przy uszach.%SPEECH_ON%My wszyscy tak godomy, ano, teroz, nie gotowi, żebyście przyszli na jakieś cośtam, no? Ano, ano, an-%SPEECH_OFF%Bójka kończy żarty. Kilku ma siniaki po wymianie ciosów, ale udaje ci się to przerwać, zanim zrobi się poważniej. | Choć zwykle pogardzają swoimi zwierzchnikami, północniacy i południowcy zaczynają bronić odpowiednio panów i wezyrów swoich ziem. Wygląda na to, że kontrast kulturowy obudził dotąd nieznane lojalności. Spory przeradzają się w prawdziwą bójkę na pięści, i to bez żadnego lorda w pobliżu, by się popisać. Rozdzielasz ich, mówiąc, że jedynym, kogo powinni chcieć zaimponować, jesteś ty lub oni nawzajem jako bracia w boju.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dlaczego nie możemy żyć w zgodzie?",
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
					if (this.Math.rand(1, 100) <= 33)
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							bro.improveMood(0.5, "Brał udział w bójce z powodów kulturowych");
						}
						else
						{
							bro.worsenMood(0.5, "Brał udział w bójce z powodów kulturowych");
						}

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}

					if (this.Math.rand(1, 100) <= 40)
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " doznaje lekkich ran"
						});
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() <= 5)
		{
			return;
		}

		local northern = 0;
		local southern = 0;

		foreach( bro in brothers )
		{
			if (bro.getEthnicity() == 0)
			{
				northern = ++northern;
			}
			else
			{
				southern = ++southern;
			}
		}

		if (northern <= 1 || southern <= 1)
		{
			return;
		}

		this.m.Score = this.Math.min(northern, southern) * 2;
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

