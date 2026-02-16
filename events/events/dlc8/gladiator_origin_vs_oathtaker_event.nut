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
			Text = "[img]gfx/ui/events/event_26.png[/img]{%oathtaker% i %gladiator% rozmyślają o właściwym użyciu broni. Świętobiorca skłania się ku przekonaniu, że każde machnięcie mieczem jest napędzane zamiarem czynienia dobra. Gladiator odpowiada, że utrzymanie się przy życiu to największe dobro, więc początek zamachu miecza ma już dobre intencje, a jego finał nie powinien być dla samego siebie, lecz dla tłumu, który patrzy. Unosząc brew, %oathtaker% pyta,%SPEECH_ON%Uważasz, że bitwy to przedstawienia, gladiatorze?%SPEECH_OFF%%gladiator% uśmiecha się, pochylając się bliżej.%SPEECH_ON%Życie samo w sobie jest przedstawieniem, Świętobiorco, a ja jestem jego największą gwiazdą.%SPEECH_OFF%Żałujesz, że w ogóle słuchałeś tej rozmowy.}",
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
				_event.m.Gladiator.improveMood(1.0, "Upewnił się o swoim znaczeniu na świecie");

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

