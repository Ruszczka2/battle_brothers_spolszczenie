this.anatomist_vs_historian_event <- this.inherit("scripts/events/event", {
	m = {
		Historian = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_vs_historian";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_40.png[/img]{%historian% historyk i anatomisci wdają się w jakąś skrybiarską sprzeczkę. Podchodzisz i widzisz, że %historian% trzyma księgę pełną opisów ciała i rycin. Twierdzi, że to najdokładniejszy obraz ludzkiego ciała znany człowiekowi, ale anatomisci szydzą, mówiąc, że taka księga nie istnieje, bo jeszcze jej nie napisali. Zaintrygowany, spoglądasz na księgę. Rysunki pokazują człowieka jako serię bardzo długich robaków, które płyną do serca i z powrotem, każdy przeznaczony do jednego konkretnego przebiegu. Inne strony pokazują rozłożone części ciała: płuca, nerki, wątrobę i więcej. Wygląda to dość szczegółowo, ale nie jesteś kimś, kto umiałby rozstrzygnąć, kto ma rację.%SPEECH_ON%Nie wierz w kłamstwa tej księgi, kapitanie. Pozwól nam, anatomistom, wykonywać naszą pracę, aby takie paskudne tomy trafiły do kurzu, gdzie ich miejsce.%SPEECH_OFF%Rozgniewany historyk wyrywa ci księgę z rąk i pokazuje im stronę. Widnieje na niej ludzki mózg, z licznymi liniami lub powrozami wychodzącymi z niego i biegnącymi w dół kręgosłupa. Twierdzi, że to centrum ludzkiego doświadczenia, wszystko, czym jesteśmy i czym myślimy, że jesteśmy, znajduje się w tym organie. Anatomisci znów szydzą. Historyk odwraca się do ciebie, jakby twój laicki punkt widzenia miał rozsadzić spory mądrala, i rzeczywiście każdy obecny zdaje się czekać na twoje słowo.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mysle, ze historyk ma racje.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Anatomisci pewnie wiedza o tym wiecej.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_64.png[/img]{Wzdychasz i mówisz, nie mając najmniejszej wiedzy na ten temat, że historyk ma rację. W końcu, jeśli ktoś zapisał to tuszem, to na pewno znaczy coś ważnego i zapewne jest prawdziwe. To stwierdzenie jednoczy obie strony przeciwko tobie. Nawet historyk protestuje, mimo twojej obrony.%SPEECH_ON%To, że coś jest zapisane tuszem, wcale nie znaczy, że jest automatycznie prawdziwe.%SPEECH_OFF%Wzdychasz ponownie i pytasz, kto marnowałby tusz na błędny pomysł? Zarówno historyk, jak i anatomisci śmieją się z ciebie, że brniesz w taką absurdalną ideę. Odchodzą razem, kręcąc głowami i mrucząc coś o laicach. Przez chwilę wyobrażasz sobie, jak przebijasz ich wszystkich mieczem, i ta wizja jest obrzydliwie satysfakcjonująca, ale na tym poprzestajesz.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Gnębiony przez madral.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_64.png[/img]{Mówisz historykowi, że anatomisci są obeznani w świecie i na pewno widzieli inne księgi, większe i wspanialsze niż ta, którą ma. Anatomisci odwracają się do ciebie. Mówią wprost.%SPEECH_ON%Nie, nie widzieliśmy.%SPEECH_OFF%Nie wiedząc, co mają na myśli, próbujesz podkreślić, że ich bronisz, i powtarzasz, że na pewno sporo czytali na ten temat. Znowu z ciebie szydzą.%SPEECH_ON%Czytali? CZYTALI? Czy nie widzisz, że nie wyruszyliśmy tu dla czytania, lecz dla działania. Jesteśmy ludźmi czynu i poprzez czyny znajdziemy prawdę o wszystkich sprawach tego świata, zwłaszcza tych dotyczących ludzi i bestii. Myśl, że doszliśmy do tego, czytając, jest dla nas obraźliwa.%SPEECH_OFF%Wzdychasz i próbujesz załagodzić sytuację, ale teraz %historian% historyk włącza się do rozmowy.%SPEECH_ON%Kapitanie, czy widzisz mnie tak samo? Że doszedłem do tego miejsca jedynie przez czytanie? Ja też potrafię walczyć. Dlatego tu jestem. Mam nadzieję, że nie widzisz we mnie kogoś o znikomym znaczeniu, kto co chwila czyta księgę i niewiele poza tym robi.%SPEECH_OFF%Masz dość tego towarzystwa i odchodzisz, słysząc pomruki o tym, jak obraźliwe jest to, że uważasz ich za samych mądrali, a nie wojowników, których każda kompania najemników by zatrudniła. Przychodzi ci do głowy myśl o wyzwaniu ich na pojedynek, ale odpuszczasz. Pojawia się też myśl, by po prostu wyrżnąć ich we śnie. Rozważasz to chwilę, ale też to porzucasz.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Gnębiony przez madral.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
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
		local historianCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomistCandidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.historian")
			{
				historianCandidates.push(bro);
			}
		}

		if (historianCandidates.len() == 0 || anatomistCandidates.len() <= 1)
		{
			return;
		}

		this.m.Historian = historianCandidates[this.Math.rand(0, historianCandidates.len() - 1)];
		this.m.Score = 5 * historianCandidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"historian",
			this.m.Historian.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Historian = null;
	}

});

