this.disowned_noble_reminisces_event <- this.inherit("scripts/events/event", {
	m = {
		Disowned = null
	},
	function create()
	{
		this.m.ID = "event.disowned_noble_reminisces";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]Zastajesz %disowned% siedzącego samotnie poza obozem. Gdy za tobą trzaskają drwiny i okrzyki ludzi przy ognisku, podchodzisz do niego i pytasz, czemu się dąsa. Wzrusza ramionami.%SPEECH_ON%Nie dąsam się, panie, tylko myślę. Choć przyznam, łatwo pomylić jedno z drugim.%SPEECH_OFF%Chichocząc, podaje ci trochę swojego trunku, który przyjmujesz. Siadasz obok i pytasz, o czym tak \"myśli\". Wydziedziczony szlachcic znów wzrusza ramionami.%SPEECH_ON%Ach, tak naprawdę o niczym. Tylko o domu. Jestem teraz daleko od niego, a ostatnie wspomnienia nie są najlepsze, a jednak co jakiś czas życzę sobie tam wrócić. Tęsknota za krainą, która uważa mnie za swego rodzaju szlachetną chorobę, wyobraź sobie.%SPEECH_OFF%Oddajesz mu trunek, bo zapewne potrzebuje go bardziej niż ty. Póki masz jeszcze jasną głowę, próbujesz powiedzieć, co myślisz...",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Pieprzyć stary dom, teraz jesteś z nami.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Dobrze jest czasem pomyśleć o domu.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Disowned.getImagePath());
				_event.m.Disowned.getFlags().set("disowned_noble_reminisces", true);
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_26.png[/img]Mówisz.%SPEECH_ON%To, skąd pochodzisz, to dom, nie ojczyzna. Tęsknisz za innym miejscem w innym czasie, kiedy jesteś tu, właśnie tutaj, teraz. %companyname% dba o ciebie, a ty o nich, i tylko razem przetrwamy.%SPEECH_OFF%Mężczyzna przez chwilę wpatruje się w swój trunek. Chichocze, pije łyk i wyciera pianę.%SPEECH_ON%Tak, chyba można na to tak spojrzeć. Dziękuję, kapitanie.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Kiedy chcesz.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Disowned.getImagePath());
				local resolve = this.Math.rand(1, 3);
				_event.m.Disowned.getBaseProperties().Bravery += resolve;
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Disowned.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve + "[/color] Determinacji"
				});
				_event.m.Disowned.improveMood(1.0, "Had a good talk with you");

				if (_event.m.Disowned.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Disowned.getMoodState()],
						text = _event.m.Disowned.getName() + this.Const.MoodStateEvent[_event.m.Disowned.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_26.png[/img]Klepiąc go po ramieniu, mówisz.%SPEECH_ON%Hej, myślenie o dawnych czasach jest dobre dla duszy, nawet jeśli prowadzi przez gąszcz gówna, okrucieństwa, zła i wszystkiego, co trzyma człowieka po nocach. Ale tylko przez chwilę. Spoglądasz w przeszłość, uznajesz ją, a potem idziesz dalej. Musisz pamiętać, by przeszłość tylko odwiedzać, nie mieszkać w niej. Każdy tutaj ma swoją przeszłość, %disowned%, i pod tym względem nigdy nie będziesz sam.%SPEECH_OFF%Wydziedziczony szlachcic przez chwilę wpatruje się w ziemię. Powoli zaczyna kiwać głową.%SPEECH_ON%Tak, tak, masz rację. Chyba część mnie martwiła się, że naprawdę chcę tam wrócić. Wyobrażałem to sobie z rozpalonym paleniskiem, dymem z komina, miękkim światłem świec za oknami i moją rodziną, czekającą na mnie. Ignorowałem zamknięte drzwi, psy strażnicze kucające na zewnątrz i tych, których kocham, mówiących mi, żebym nigdy nie wracał, chyba że w skrzyni do pochówku głęboko pod ziemią. Nie tyle myślałem o przeszłości, co o niej marzyłem, i myślę, że pomogłeś mi to zrozumieć, kapitanie. Dziękuję. Wiem, że pewnego dnia nie będę musiał marzyć o %companyname%, tylko wspominać ją wyraźnie i z czułością.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Kompania to docenia.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Disowned.getImagePath());
				local resolve = this.Math.rand(1, 3);
				_event.m.Disowned.getBaseProperties().Bravery += resolve;
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Disowned.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve + "[/color] Determinacji"
				});
				_event.m.Disowned.improveMood(1.0, "Had a good talk with you");

				if (_event.m.Disowned.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Disowned.getMoodState()],
						text = _event.m.Disowned.getName() + this.Const.MoodStateEvent[_event.m.Disowned.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 5 && bro.getBackground().getID() == "background.disowned_noble" && !bro.getFlags().get("disowned_noble_reminisces"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Disowned = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"disowned",
			this.m.Disowned.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Disowned = null;
	}

});

