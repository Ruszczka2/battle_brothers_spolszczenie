this.anatomist_reflects_on_webknechts_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		OtherBro = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_reflects_on_webknechts";
		this.m.Title = "W czasie obozu...";
		this.m.Cooldown = 80.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_184.png[/img]{%anatomist% wyciąga ramię, obserwując długonogiego pająka, który człapie po jego skórze. Gdy stworzenie dociera do końca swojej nowej ziemi, anatomista obraca rękę, sugerując pająkowi dalszą drogę. Robi tak przez jakiś czas, aż opuszcza palce ku ziemi i pająk całkiem schodzi, być może ani razu nie uświadomiwszy sobie, że chodził po żywym. Anatomista zapisuje kilka stron w notatkach.%SPEECH_ON%Ostatnio widziałem pająka, który skoczył na dwudziestokrotność długości swojego ciała, by porwać muchę. A ten, którego wypuściłem, na widok zdobyczy pędziłby po ziemi jak pies myśliwski. Wygląda na to, że starzy bogowie ulitowali się nad nami, łobuzie, bo żadnego z tych stworzeń nie spotyka się w ich większych, sieciopajęczych formach.%SPEECH_OFF%Choć bycie powalonym i rozerwanym byłoby straszne, mówisz mu, że bycie owiniętym w kokon, zanim kły wyssą z ciebie krew, jest bez wątpienia gorsze. Anatomista unosi palec.%SPEECH_ON%To powszechne nieporozumienie, łobuzie, bo sieciopająk woli żerować długo po twojej śmierci. Wierzymy, że jego toksyny są zaprojektowane, by atakować brzuch, rozcinać go i używać jego płynów do topienia cię od środka. To zapewne dlatego wieszają ofiary głową w dół, by toksyny mogły oblać organy, zamieniając cię w coś w rodzaju worka płynów. Faza zjadania to tylko trawienie tego, co zostało. Jedyny raz, gdy cię nie jedzą, to wtedy, gdy składają w tobie lęg, bo pajączki będą potrzebowały pożywienia po wykluciu.%SPEECH_OFF%To wciąż brzmi nieskończenie gorzej niż bycie dźgniętym przez łowczego pająka, ale tak czy inaczej żałujesz tej rozmowy i nie ciągniesz jej dalej. Niestety, %otherbro% jest w pobliżu i słyszał zbyt wiele...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Przestań straszyć, do diabła.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.OtherBro.getImagePath());
				local trait = this.new("scripts/skills/traits/fear_beasts_trait");
				_event.m.OtherBro.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.OtherBro.getName() + " teraz boi się bestii"
				});
				_event.m.OtherBro.worsenMood(1.0, "Przerażony pająkami");

				if (_event.m.OtherBro.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.OtherBro.getMoodState()],
						text = _event.m.OtherBro.getName() + this.Const.MoodStateEvent[_event.m.OtherBro.getMoodState()]
					});
				}

				_event.m.Anatomist.improveMood(1.0, "Zafascynowany pająkami");

				if (_event.m.Anatomist.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomist_candidates = [];
		local other_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
			else if (bro.getBackground().getID() != "background.beast_slayer" && bro.getBackground().getID() != "background.wildman" && !bro.getSkills().hasSkill("trait.brave") && !bro.getSkills().hasSkill("trait.fearless") && !bro.getSkills().hasSkill("trait.fear_beasts") && !bro.getSkills().hasSkill("trait.hate_beasts"))
			{
				other_candidates.push(bro);
			}
		}

		if (anatomist_candidates.len() == 0 || other_candidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		this.m.OtherBro = other_candidates[this.Math.rand(0, other_candidates.len() - 1)];
		this.m.Score = 2 * anatomist_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getName()
		]);
		_vars.push([
			"otherbro",
			this.m.OtherBro.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.OtherBro = null;
	}

});

