this.gladiator_origin_vs_oathtaker_event <- this.inherit("scripts/events/event", {
	m = {
		Gladiator = null,
		Oathtaker = null
	},
	function create()
	{
		this.m.ID = "event.gladiator_origin_vs_oathtaker";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{%oathtaker% i %gladiator% rozmyslaja o wlasciwym uzyciu broni. Swietobiorca sklania sie ku przekonaniu, ze kazde machniecie mieczem jest napedzane zamiarem czynienia dobra. Gladiator odpowiada, ze utrzymanie sie przy zyciu to najwieksze dobro, wiec poczatek zamachu miecza ma juz dobre intencje, a jego final nie powinien byc dla samego siebie, lecz dla tlumu, ktory patrzy. Unoszac brew, %oathtaker% pyta,%SPEECH_ON%Uwazasz, ze bitwy to przedstawienia, gladiatorze?%SPEECH_OFF%%gladiator% usmiecha sie, pochylajac sie blizej.%SPEECH_ON%Zycie samo w sobie jest przedstawieniem, Swietobiorco, a ja jestem jego najwieksza gwiazda.%SPEECH_OFF%Zalujesz, ze w ogole sluchales tej rozmowy.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To prawdziwy horror.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gladiator.getImagePath());
				this.Characters.push(_event.m.Oathtaker.getImagePath());
				_event.m.Gladiator.improveMood(1.0, "Upewnil sie o swoim znaczeniu na swiecie");

				if (_event.m.Gladiator.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Gladiator.getMoodState()],
						text = _event.m.Gladiator.getName() + this.Const.MoodStateEvent[_event.m.Gladiator.getMoodState()]
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

		if (this.World.Assets.getOrigin().getID() != "scenario.gladiators")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local gladiator_candidates = [];
		local oathtaker_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.paladin")
			{
				oathtaker_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.gladiator" && bro.getFlags().get("IsPlayerCharacter"))
			{
				gladiator_candidates.push(bro);
			}
		}

		if (oathtaker_candidates.len() == 0 || gladiator_candidates.len() == 0)
		{
			return;
		}

		this.m.Gladiator = gladiator_candidates[this.Math.rand(0, gladiator_candidates.len() - 1)];
		this.m.Oathtaker = oathtaker_candidates[this.Math.rand(0, oathtaker_candidates.len() - 1)];
		this.m.Score = 3 * oathtaker_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"gladiator",
			this.m.Gladiator.getName()
		]);
		_vars.push([
			"oathtaker",
			this.m.Oathtaker.getName()
		]);
	}

	function onClear()
	{
		this.m.Gladiator = null;
		this.m.Oathtaker = null;
	}

});

