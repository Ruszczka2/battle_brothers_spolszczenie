this.miner_fresh_air_event <- this.inherit("scripts/events/event", {
	m = {
		Miner = null
	},
	function create()
	{
		this.m.ID = "event.miner_fresh_air";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{%miner%, górnik, wciąga wielkie hausty powietrza, po czym wypuszcza je długimi, choć lekko świszczącymi wydechami. Kiwając do siebie głową, zdaje się być zadowolony z czegoś, co wszyscy robią. Widać niektórzy łatwo się cieszą. Ale wyjaśnia.%SPEECH_ON%Wiesz, spędziłem lata w wilgoci i ciemnościach kopalni, oddychając pyłem i metalami. Myślę, że to długie życie na powierzchni to samo w sobie szczęście, skarb, o którym nie wiedziałem, że tu na mnie czeka. Dziękuję, kapitanie, bo nie byłoby mnie teraz tutaj, gdyby nie ty.%SPEECH_OFF%Kiwasz głową i dziękujesz mu za miłe słowa.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Od morza wieje świeża bryza.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Miner.getImagePath());
				_event.m.Miner.improveMood(1.0, "Cieszył się nowym życiem na powierzchni");

				if (_event.m.Miner.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Miner.getMoodState()],
						text = _event.m.Miner.getName() + this.Const.MoodStateEvent[_event.m.Miner.getMoodState()]
					});
				}

				local stamina = this.Math.rand(3, 6);
				_event.m.Miner.getBaseProperties().Stamina += stamina;
				_event.m.Miner.getSkills().update();
				_event.m.Miner.getFlags().add("fresh_air");
				this.List.push({
					id = 17,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Miner.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + stamina + "[/color] Maks. Zmęczenia"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() > 3 && bro.getBackground().getID() == "background.miner" && !bro.getFlags().has("fresh_air"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 1)
		{
			return;
		}

		this.m.Miner = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"miner",
			this.m.Miner.getName()
		]);
	}

	function onClear()
	{
		this.m.Miner = null;
	}

});

