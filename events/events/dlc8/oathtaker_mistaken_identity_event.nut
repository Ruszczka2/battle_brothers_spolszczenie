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
			Text = "%townImage%{Chłopak nagle podbiega do kompanii. Praktycznie przyczepia się do nogi %oathtaker% i Świętobiorca przybiera wyraz zakłopotania. Pyta malca, czy się zgubił. Chłopak odskakuje.%SPEECH_ON%Zgubił? Nie, nie zgubiłem się! Myślałem, że już nigdy nie zobaczę waszego rodzaju, sławnych Ślubodawców!%SPEECH_OFF%Oko %oathtaker% drga, jego dłonie zaciskają się na rękojeści broni. Nie wiesz, kiedy zaczął krzyczeć i kiedy chłopak wylądował na ziemi z podbitym okiem, ale sprawiedliwy gniew pękł ze Świętobiorcy jak błysk świętej furii i patrzysz, jak wpycha chłopaka w błoto, krzycząc i pieniąc się, że jest Świętobiorcą, a nie jakimś obrzydliwym, brzydkim i niesławnym Ślubodawcą, po czym wpycha mu twarz w trawę i wlecze go w stertę końskiego gnoju oraz przeciąga po drodze na wałach nieczystości, aż chłopak krzyczy i ucieka, ratując życie. Skończywszy, %oathtaker% prostuje się, poprawia strój i porządkuje rozczochraną broń.%SPEECH_ON%Opuśćmy to piekło brudnych degeneratów, kapitanie.%SPEECH_OFF%Gdy odmaszerowuje, odwracasz się i widzisz mieszkańców patrzących na ciebie z przerażeniem.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To mniej więcej wygląda tak, jak wygląda.",
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
				f.addPlayerRelation(this.Const.World.Assets.RelationMinorOffense, "Jeden z twoich ludzi pobił dziecko");
				_event.m.Oathtaker.worsenMood(2.0, "Wzięto go za Ślubodawcę");

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

