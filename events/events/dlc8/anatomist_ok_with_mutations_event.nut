this.anatomist_ok_with_mutations_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_ok_with_mutations";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_05.png[/img]{Po pewnym czasie spędzonym ze swoimi nowymi, zdeformowanymi kształtami, %anatomist% zaakceptował to, kim jest teraz. Te okropne blizny i narastające krosty traktuje jako dowód, że kroczy właściwą drogą. W pewnym sensie ma rację. Te dziwne zmiany uczyniły go znacznie lepszym wojownikiem, co wiele mówi, bo ty osobiście nie wierzyłeś, że te jajogłowe w ogóle zdołają zostać choćby przyzwoitymi wojownikami. Wszelkie wcześniejsze lęki i obawy zniknęły, zastąpione odnowionym poczuciem celu i pragnieniem działania. | %anatomist% przestał marudzić i martwić się bliznami oraz okropnym wyglądem. Wygląda na to, że pogodził się z tym, jak teraz wygląda, albo po prostu tak przywykł do odoru bijącego z każdej części ciała, że przestał go zauważać. Choć jego smród niemal cię wymiata za każdym razem, gdy jest blisko, przynajmniej wyszedł z ponurego nastroju, który wcześniej zajmował każdą jego chwilę. Być może teraz znów podąży swoją słuszną ścieżką naukowych odkryć, czy jak on to nazywa. | Trudno pogodzić się z tym, kim się jest, a mimo że to powierzchowne, jeszcze trudniej zaakceptować swój wygląd. Tym bardziej, gdy to, jak wyglądasz, nie jest tym, z czym się urodziłeś, lecz zostało ukształtowane przez twoje wybory. Jeśli to twoje decyzje doprowadziły cię do tego stanu, to tylko nad nimi będziesz się zastanawiał do końca życia. Widziałeś to wiele razy, zwłaszcza u najemników, którzy tracili uszy, nosy, wargi i gorzej. Czasem potrzeba dużo czasu, by człowiek pogodził się z nową sytuacją, i %anatomist% nie był wyjątkiem. Ale się pogodził. Jakiekolwiek straszne blizny i mutacje, które zniósł z własnej winy, już mu nie ciążą - przynajmniej w głowie. Ruszył dalej i jest gotów kontynuować swoją drogę jako ten, kto szuka naukowych dokonań i godzi się z wielkim ryzykiem, jakie one niosą. | %anatomist% pogodził się z nowym wyglądem. Z początku reakcje jego ciała na mikstury i wywary, które wypijał, były tak niepokojące, że stał się cieniem samego siebie. Trudno go winić, bo wyglądał i nadal wygląda okropnie. Ale po czasie po prostu dociera do ciebie, że życie toczy się dalej i jeśli nic nie da się z tym zrobić, to nic się nie da z tym zrobić. A w każdym razie prawdziwym celem tych wyborów było zaspokojenie naukowej ciekawości, i wygląda na to, że ponowne uświadomienie sobie tego ożywiło poczucie celu u %anatomist%. Nadal jest niezgrabny i obrzydliwy, i ciężko na niego patrzeć, ale przynajmniej jest teraz szczęśliwszy. | Kiedyś poraniony chorobami i zniekształceniami, %anatomist% anatomista zaczyna wyglądać znacznie lepiej. To znaczy: zrozumiał, że niewiele może zrobić ze swoim wyglądem, który, mówiąc krótko, wciąż wymaga odwagi i silnej woli, by na niego spojrzeć. Ale przypomniał sobie prawdziwy powód, dla którego sięgał po mikstury, dziwne mieszanki i nalewki, które uczyniły go chodzącą i mówiącą potwornością, a tym powodem są naukowe dążenia. Anatomista jest teraz szczęśliwszym człowiekiem i dopóki będzie trzymany z dala choćby od najmniejszego lustra, tak raczej pozostanie. | Zwyczaj %anatomist% polegający na wypijaniu każdej mikstury, którą uwarzył, w końcu ugryzł go w tyłek. Ostatni łyk poszedł koszmarnie źle, zamieniając jego twarz w mięsistą ciastowatość i wywołując na skórze wszelkie guzy, siniaki, krosty i ropnie. Naturalnie, zmiany te mocno uderzyły w morale. Ale w końcu się z tym uporał. Nadal jest chodzącą, mówiącą potwornością w pełnym znaczeniu słowa, lecz wewnątrz pogodził się z tym, a to, co w środku, jest najważniejsze. A przynajmniej lepiej, żeby było, bo na to, co na zewnątrz, ledwie starcza odwagi spojrzeć. | %anatomist% anatomista nazywa zmiany w swoim ciele \'mutacjami\', co musi być jakimś jajogłowym określeniem na wyglądanie jak gówno. Przez pewien czas jego wygląd ciążył mu w codziennym życiu. Trudno go winić, sam sprowadził na siebie te dolegliwości, co zawsze jest gorsze niż wtedy, gdy robi to świat i nie pozostawia wątpliwości, jak można było tego uniknąć. Na szczęście anatomista uporał się z depresją i lękiem o swój okropny wygląd. Może nawet chętniej niż kiedykolwiek będzie dalej wypijał swoje mikstury i wywary. Przecież nie może wyglądać dużo gorzej niż teraz, a w pewnym momencie nawet kobiety reagują na kompletną ohydę, jak na psa tak zapchlonego i zniszczonego, że aż chce się go pogłaskać z ciekawości. | Po wypiciu kilku podejrzanych mikstur ciało %anatomist% anatomisty zaczęło się zmieniać i, jak u każdego dojrzałego człowieka, zmiany w tym wieku rzadko są dobre. Twarz uległa zniekształceniu, ciało pokryły owrzodzenia i blizny. Przez pewien czas anatomista popadł w głęboką depresję, a ty zastanawiałeś się, czy nie został nieodwracalnie uszkodzony nie tylko na zewnątrz, ale i wewnątrz. Na szczęście to morale człowieka bywa najtrudniejsze do złamania. %anatomist% pogodził się ze swoim nowym wyglądem. Niewiele da się z tym zrobić, a on traktuje to teraz jako pewien fundamentalny chrzest ognia, będący ceną za dążenia naukowe, które sprowadziły go do tych krain. Ty sam musisz tylko dopilnować, by nie był pierwszą rzeczą, którą widzisz rano.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cieszę się, że czujesz się lepiej, %anatomist%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(1.0, "Pogodził się ze swoimi mutacjami");

				if (_event.m.Anatomist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Anatomist.getFlags().add("isOkWithMutations");
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

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist" && bro.getFlags().has("gotUpsetAtMutations") && !bro.getFlags().has("isOkWithMutations"))
			{
				anatomistCandidates.push(bro);
			}
		}

		if (anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Score = 10 * anatomistCandidates.len();
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
	}

	function onClear()
	{
		this.m.Anatomist = null;
	}

});

