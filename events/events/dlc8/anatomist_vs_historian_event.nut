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
			Text = "[img]gfx/ui/events/event_40.png[/img]{%historian% historyk i anatomisci wdaja sie w jakas skrybiarska sprzeczke. Podchodzisz i widzisz, ze %historian% trzyma ksiege pelna opisow ciala i rycin. Twierdzi, ze to najdokladniejszy obraz ludzkiego ciala znany czlowiekowi, ale anatomisci szydza, mowiac, ze taka ksiega nie istnieje, bo jeszcze jej nie napisali. Zaintrygowany, spogladasz na ksiege. Rysunki pokazuja czlowieka jako serie bardzo dlugich robakow, które plyna do serca i z powrotem, kazdy przeznaczony do jednego konkretnego przebiegu. Inne strony pokazuja rozlozone czesci ciala: pluca, nerki, watrobe i wiecej. Wyglada to dosc szczegolowo, ale nie jestes kims, kto umialby rozstrzygnac, kto ma racje.%SPEECH_ON%Nie wierz w klamstwa tej ksiegi, kapitanie. Pozwol nam, anatomistom, wykonywac nasza prace, aby takie paskudne tomy trafily do kurzu, gdzie ich miejsce.%SPEECH_OFF%Rozgniewany historyk wyrywa ci ksiege z rak i pokazuje im strone. Widnieje na niej ludzki mozg, z licznymi linami lub powrozami wychodzacymi z niego i biegnacymi w dol kregoslupa. Twierdzi, ze to centrum ludzkiego doswiadczenia, wszystko, czym jestesmy i czym myslimy, ze jestesmy, znajduje sie w tym organie. Anatomisci znów szydza. Historyk odwraca sie do ciebie, jakby twoj laicki punkt widzenia mial rozsadzic spory madral, i rzeczywiscie kazdy obecny zdaje sie czekac na twoje slowo.}",
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
			Text = "[img]gfx/ui/events/event_64.png[/img]{Wzdychasz i mowisz, nie majac najmniejszej wiedzy na ten temat, ze historyk ma racje. W koncu, jesli ktos zapisal to tuszem, to na pewno znaczy cos waznego i zapewne jest prawdziwe. To stwierdzenie jednoczy obie strony przeciwko tobie. Nawet historyk protestuje, mimo twojej obrony.%SPEECH_ON%To, ze cos jest zapisane tuszem, wcale nie znaczy, ze jest automatycznie prawdziwe.%SPEECH_OFF%Wzdychasz ponownie i pytasz, kto marnowalby tusz na bledny pomysl? Zarowno historyk, jak i anatomisci smieja sie z ciebie, ze brniesz w taka absurdalna idee. Odchodza razem, kręcac glowami i mruczac cos o laicach. Przez chwile wyobrazasz sobie, jak przebijasz ich wszystkich mieczem, i ta wizja jest obrzydliwie satysfakcjonujaca, ale na tym poprzestajesz.}",
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
			Text = "[img]gfx/ui/events/event_64.png[/img]{Mowisz historykowi, ze anatomisci sa obeznani w swiecie i na pewno widzieli inne ksiegi, wieksze i wspanialsze niz ta, ktora ma. Anatomisci odwracaja sie do ciebie. Mowia wprost.%SPEECH_ON%Nie, nie widzielismy.%SPEECH_OFF%Nie wiedzac, co maja na mysli, probujesz podkreslic, ze ich bronisz, i powtarzasz, ze na pewno sporo czytali na ten temat. Znowu z ciebie szydza.%SPEECH_ON%Czytali? CZYTALI? Czy nie widzisz, ze nie wyruszylismy tu dla czytania, lecz dla dzialania. Jestesmy ludzmi czynu i poprzez czyny znajdziemy prawde o wszystkich sprawach tego swiata, zwlaszcza tych dotyczacych ludzi i bestii. Mysl, ze doszlismy do tego, czytajac, jest dla nas obrazliwa.%SPEECH_OFF%Wzdychasz i probujesz załagodzic sytuacje, ale teraz %historian% historyk wlacza sie do rozmowy.%SPEECH_ON%Kapitanie, czy widzisz mnie tak samo? Ze doszedlem do tego miejsca jedynie przez czytanie? Ja tez potrafie walczyc. Dlatego tu jestem. Mam nadzieje, ze nie widzisz we mnie kogos o znikomym znaczeniu, kto co chwila czyta ksiege i niewiele poza tym robi.%SPEECH_OFF%Masz dość tego towarzystwa i odchodzisz, slyszac pomruki o tym, jak obrazliwe jest to, ze uwazasz ich za samych madral, a nie wojownikow, ktorych każda kompania najemnikow by zatrudnila. Przychodzi ci do glowy mysl o wyzwaniu ich na pojedynek, ale odpuszczasz. Pojawia sie tez mysl, by po prostu wyrznac ich we snie. Rozwazasz to chwile, ale tez to porzucasz.}",
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

