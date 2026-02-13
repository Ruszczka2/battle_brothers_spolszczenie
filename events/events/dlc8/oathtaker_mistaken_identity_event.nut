this.oathtaker_mistaken_identity_event <- this.inherit("scripts/events/event", {
	m = {
		Oathtaker = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.oathtaker_mistaken_identity";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%townImage%{Chlopak nagle podbiega do kompanii. Praktycznie przyczepia sie do nogi %oathtaker% i Swietobiorca przybiera wyraz zaklopotania. Pyta malca, czy sie zgubil. Chlopak odskakuje.%SPEECH_ON%Zgubil? Nie, nie zgubilem sie! Myslalem, ze juz nigdy nie zobacze waszego rodzaju, slawnych Slubodawcow!%SPEECH_OFF%Oko %oathtaker% drga, jego dlonie zaciskaja sie na rekojesci broni. Nie wiesz, kiedy zaczal krzyczec i kiedy chlopak wyladowal na ziemi z podbitym okiem, ale sprawiedliwy gniew pekl ze Swietobiorcy jak blysk swietej furii i patrzysz, jak wpycha chlopaka w bloto, krzyczac i pieniac sie, ze jest Swietobiorca, a nie jakims obrzydliwym, brzydkim i nieslawnym Slubodawca, po czym wpycha mu twarz w trawe i wlecze go w sterte konskiego gnoju oraz przeciaga po drodze na walach nieczystosci, az chlopak krzyczy i ucieka, ratujac zycie. Skonczywszy, %oathtaker% prostuje sie, poprawia stroj i porzadkuje rozczochrana bron.%SPEECH_ON%Opuscmy to pieklo brudnych degeneratow, kapitanie.%SPEECH_OFF%Gdy odmaszerowuje, odwracasz sie i widzisz mieszkancow patrzacych na ciebie z przerazeniem.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To mniej wiecej wyglada tak, jak wyglada.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Oathtaker.getImagePath());
				this.World.Assets.addMoralReputation(-1);
				local f = _event.m.Town.getFactionOfType(this.Const.FactionType.Settlement);
				f.addPlayerRelation(this.Const.World.Assets.RelationMinorOffense, "Jeden z twoich ludzi pobil dziecko");
				_event.m.Oathtaker.worsenMood(2.0, "Wzieto go za Slubodawce");

				if (_event.m.Oathtaker.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Oathtaker.getMoodState()],
						text = _event.m.Oathtaker.getName() + this.Const.MoodStateEvent[_event.m.Oathtaker.getMoodState()]
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

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local oathtaker_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.paladin")
			{
				oathtaker_candidates.push(bro);
			}
		}

		if (oathtaker_candidates.len() == 0)
		{
			return;
		}

		this.m.Oathtaker = oathtaker_candidates[this.Math.rand(0, oathtaker_candidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = 3 * oathtaker_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"oathtaker",
			this.m.Oathtaker.getName()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Oathtaker = null;
		this.m.Town = null;
	}

});

