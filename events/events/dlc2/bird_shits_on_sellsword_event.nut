this.bird_shits_on_sellsword_event <- this.inherit("scripts/events/event", {
	m = {
		Victim = null,
		Superstitious = null,
		Archer = null,
		Historian = null
	},
	function create()
	{
		this.m.ID = "event.bird_shits_on_sellsword";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Podczas wędrówki %birdbro% zostaje trafiony ptasim gównem. Uderza w jego dłoń na mieczu i rozbryzguje się po zbroi.%SPEECH_ON%Ooo, ooo!%SPEECH_OFF%Rozkłada ramiona jak kurze skrzydła, oglądając szkody.%SPEECH_ON%Cholera, tylko moje szczęście!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tak, nie roztrząsaj tego i ruszajmy dalej.",
					function getResult( _event )
					{
						if (_event.m.Historian == null)
						{
							return "Continue";
						}
						else
						{
							return "Historian";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Victim.getImagePath());

				if (_event.m.Superstitious != null)
				{
					this.Options.push({
						Text = "Czy to może być omen?",
						function getResult( _event )
						{
							return "Superstitious";
						}

					});
				}

				if (_event.m.Archer != null)
				{
					this.Options.push({
						Text = "Niech ktoś strąci tego pierzastego winowajcę!",
						function getResult( _event )
						{
							return "Archer";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Continue",
			Text = "%terrainImage%{%birdbro% kiwa głową.%SPEECH_ON%Pewnie. Po prostu zepsuł mi dzień, to wszystko.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "No cóż.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Victim.getImagePath());
				_event.m.Victim.worsenMood(0.5, "Został obsrany przez ptaka");

				if (_event.m.Victim.getMoodState() <= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Victim.getMoodState()],
						text = _event.m.Victim.getName() + this.Const.MoodStateEvent[_event.m.Victim.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Superstitious",
			Text = "%terrainImage%{Wiecznie przesądny %superstitious% analizuje gówno z oceniającym okiem prawdziwego jubilera. Zaciska usta i kiwa głową, jak najbardziej zadowolony znawca ptasiego gówna. Mówi.%SPEECH_ON%To dobra rzecz.%SPEECH_OFF%Wobec wyraźnie niedowierzającej kompanii mężczyzna spokojnie tłumaczy, że obsranie przez ptaka jest omenem dobrych rzeczy, które nadejdą. Kilku najemników wydaje się przekonanych tą myślą. To dość spektakularne, że ptak wybiera właśnie ciebie, spośród całej ziemi pod nim, by na ciebie przykucnąć. Kiwasz głową i mówisz, że %birdbro% następnym razem powinien otworzyć usta dla wyjątkowego szczęścia.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Szczęściarz.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Victim.getImagePath());
				this.Characters.push(_event.m.Superstitious.getImagePath());
				_event.m.Victim.improveMood(1.0, "Został obsrany przez ptaka na szczęście");

				if (_event.m.Victim.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Victim.getMoodState()],
						text = _event.m.Victim.getName() + this.Const.MoodStateEvent[_event.m.Victim.getMoodState()]
					});
				}

				_event.m.Superstitious.improveMood(0.5, "Był świadkiem obsrania " + _event.m.Victim.getName() + " przez ptaka");

				if (_event.m.Superstitious.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Superstitious.getMoodState()],
						text = _event.m.Superstitious.getName() + this.Const.MoodStateEvent[_event.m.Superstitious.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Archer",
			Text = "[img]gfx/ui/events/event_10.png[/img]{%archer% spogląda w górę, osłaniając oczy dłonią, z wysuniętym językiem. Widzi ptaka i kiwa głową. Liże palec, przykłada go do powietrza i znów kiwa. Łucznik uśmiecha się, naciągając strzałę.%SPEECH_ON%Za zbrodnią idzie kara.%SPEECH_OFF%Najemnicy jęczą i kpią z jego moralizowania, ale on spokojnie unosi łuk i wypuszcza strzałę. Śmiga wysoko w powietrze i prawie jej nie widać, ale widać, jak ptak nagle skręca na bok i zaczyna wirować ku ziemi. Strzelec kiwa głową i spogląda na kompanię.%SPEECH_ON%Śmiejecie się teraz?%SPEECH_OFF%To tylko wywołuje jeszcze więcej kpin. Łucznik złośliwie komentuje własną ważność, co wywołuje zdrową debatę między ludźmi stojącymi w pierwszym szeregu a tymi z tyłu. Mówisz im, że jeśli chcą się spierać, co jest lepsze, niech udowodnią to na polu bitwy.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobry strzał!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Victim.getImagePath());
				this.Characters.push(_event.m.Archer.getImagePath());
				_event.m.Victim.improveMood(0.5, "Zemścił się na ptaku, który go obsrał");

				if (_event.m.Victim.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Victim.getMoodState()],
						text = _event.m.Victim.getName() + this.Const.MoodStateEvent[_event.m.Victim.getMoodState()]
					});
				}

				_event.m.Archer.improveMood(1.0, "Zemścił się na ptaku, który obsrał " + _event.m.Victim.getName() + " z niezwykłą celnością");

				if (_event.m.Archer.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Archer.getMoodState()],
						text = _event.m.Archer.getName() + this.Const.MoodStateEvent[_event.m.Archer.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Archer.getID() || bro.getID() == _event.m.Victim.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(1.0, "Był świadkiem świetnego pokazu łucznictwa " + _event.m.Archer.getName());

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "Historian",
			Text = "%terrainImage%{Mówisz %birdbro%owi, że bycie obsranym to część życia, i szykujesz kompanię do drogi. Ale skromny %historian% podchodzi i mówi pechowemu najemnikowi, by wstrzymał się z czyszczeniem gówna. Historyk przygląda się mu uważnie, a potem ptakowi, który je zrzucił.%SPEECH_ON%Tak, tak... Znam tego ptaka! To magiczne stworzenie!%SPEECH_OFF%Ludzie patrzą w górę na ptaka, jakby byli marynarzami po długiej żegludze znajdującymi upragniony ląd. %historian% wskazuje na %birdbro%a.%SPEECH_ON%Obsrał cię czerwono-niebieski drozd! To wszystko, co chciałem powiedzieć. Po prostu dawno żadnego nie widziałem. Możesz... możesz już to wyczyścić.%SPEECH_OFF%Najemnicy stoją z opadniętymi szczękami, po czym wybuchają śmiechem. %birdbro% chwyta historyka i używa jego rękawów, by zetrzeć gówno, co wywołuje kolejne ryki śmiechu.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "No i zagadka rozwiązana.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Victim.getImagePath());
				this.Characters.push(_event.m.Historian.getImagePath());
				_event.m.Victim.worsenMood(0.5, "Został obsrany przez ptaka");

				if (_event.m.Victim.getMoodState() <= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Victim.getMoodState()],
						text = _event.m.Victim.getName() + this.Const.MoodStateEvent[_event.m.Victim.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Victim.getID() || bro.getID() == _event.m.Historian.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(1.0, "Był rozbawiony przez " + _event.m.Historian.getName());

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type == this.Const.World.TerrainType.Snow)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_victim = [];
		local candidates_archer = [];
		local candidates_super = [];
		local candidates_historian = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.historian")
			{
				candidates_historian.push(bro);
			}
			else if (bro.getSkills().hasSkill("trait.superstitious"))
			{
				candidates_super.push(bro);
			}
			else if (bro.getBackground().getID() == "background.hunter" || bro.getCurrentProperties().RangedSkill > 70)
			{
				candidates_archer.push(bro);
			}
			else if (!bro.getSkills().hasSkill("trait.lucky") && bro.getBackground().getID() != "background.slave")
			{
				candidates_victim.push(bro);
			}
		}

		if (candidates_victim.len() == 0)
		{
			return;
		}

		this.m.Victim = candidates_victim[this.Math.rand(0, candidates_victim.len() - 1)];

		if (candidates_historian.len() != 0)
		{
			this.m.Historian = candidates_historian[this.Math.rand(0, candidates_historian.len() - 1)];
		}

		if (candidates_archer.len() != 0)
		{
			this.m.Archer = candidates_archer[this.Math.rand(0, candidates_archer.len() - 1)];
		}

		if (candidates_super.len() != 0)
		{
			this.m.Superstitious = candidates_super[this.Math.rand(0, candidates_super.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"birdbro",
			this.m.Victim.getNameOnly()
		]);
		_vars.push([
			"superstitious",
			this.m.Superstitious != null ? this.m.Superstitious.getName() : ""
		]);
		_vars.push([
			"archer",
			this.m.Archer != null ? this.m.Archer.getName() : ""
		]);
		_vars.push([
			"historian",
			this.m.Historian != null ? this.m.Historian.getName() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Victim = null;
		this.m.Superstitious = null;
		this.m.Archer = null;
		this.m.Historian = null;
	}

});

