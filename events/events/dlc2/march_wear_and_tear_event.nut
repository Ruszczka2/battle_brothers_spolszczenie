this.march_wear_and_tear_event <- this.inherit("scripts/events/event", {
	m = {
		Tailor = null,
		Other = null,
		Vagabond = null,
		Thief = null
	},
	function create()
	{
		this.m.ID = "event.march_wear_and_tear";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Maszerowanie po całym świecie odcisnęło na ludziach swoje piętno. Gdy tylko najemnik zdejmuje but, widać krew przesiąkającą przez skarpetę. Nagromadziły się otarcia i czyraki. Jeden z ludzi zdziera skórę z palca u stopy i mówi, że żałuje, a ty kiwasz głową. Ogólnie rzecz biorąc, to cena za ciągłe bycie w drodze.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zaciśnijcie zęby.",
					function getResult( _event )
					{
						return "End";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Tailor != null)
				{
					this.Options.push({
						Text = "Może zrobimy świeże opatrunki z tego, co mamy?",
						function getResult( _event )
						{
							return "Tailor";
						}

					});
				}

				if (_event.m.Vagabond != null)
				{
					this.Options.push({
						Text = "Zwiedziłeś świat, %travelbro%. Jakieś rady?",
						function getResult( _event )
						{
							return "Vagabond";
						}

					});
				}

				if (_event.m.Thief != null)
				{
					this.Options.push({
						Text = "Czekaj. %streetrat%, wygląda, jakbyś miał coś do powiedzenia?",
						function getResult( _event )
						{
							return "Thief";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "End",
			Text = "%terrainImage%{Następny postój jest niedaleko. Masz nadzieję, że ludzie wytrzymają do tego czasu. Te bandaże, które masz, używasz w razie potrzeby.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Załóżcie z powrotem buty.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.vagabond" || bro.getBackground().getID() == "background.refugee" || bro.getBackground().getID() == "background.messenger")
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 25)
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " odnosi lekkie rany"
						});
					}
				}

				local amount = brothers.len();
				this.World.Assets.addMedicine(-amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_medicine.png",
					text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] Zapasów Medycznych."
				});
			}

		});
		this.m.Screens.push({
			ID = "Tailor",
			Text = "%terrainImage%{%tailor%, krawiec, pociera podbródek dwoma palcami. W końcu wskazuje nimi do przodu.%SPEECH_ON%Mam to. Panowie, dajcie mi każdy skrawek nieużywanej albo zniszczonej odzieży, jaką macie. Każdy ciuch. Dawajcie. O, proszę. Tak, to jest absolutny śmieć, %otherbrother%. Twoja ulubiona koszula? Na bogów, po prostu mi ją już daj. Dziękuję.%SPEECH_OFF%Krawiec zbiera naręcza porzuconych ubrań i zabiera się do pracy z nożycami. Tnie, rwie, zatrzymuje się. Zatrzymuje się często, zawsze niepewny swojej roboty. W końcu jednak prezentuje rezultat. Stos świeżych skarpet i dość resztek, by zrobić dodatkowe bandaże. Ma też na sobie zaskakująco efektowny nowy strój, nie masz pojęcia, jak to stworzył.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jeśli to nie magik, to ja nie wiem.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Tailor.getImagePath());
				_event.m.Tailor.improveMood(1.0, "Uszył sobie coś ładnego ze skrawków materiału");

				if (_event.m.Tailor.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Tailor.getMoodState()],
						text = _event.m.Tailor.getName() + this.Const.MoodStateEvent[_event.m.Tailor.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();
				local amount = brothers.len();
				this.World.Assets.addMedicine(amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_medicine.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + amount + "[/color] Zapasów Medycznych."
				});
			}

		});
		this.m.Screens.push({
			ID = "Vagabond",
			Text = "%terrainImage%{Jeśli chodzi o chodzenie po świecie, %travelbro% zjadł zęby bardziej niż ktokolwiek. Śmieje się z niedoli swoich towarzyszy najemników.%SPEECH_ON%Ach, o to mi chodzi! Nie przejmujcie się bólem, panowie, przyjmijcie tę obolałość!%SPEECH_OFF%Kompania zbiorowo każe mu się odczepić, a włóczęga wesoło porusza palcami. Nawet nie zauważyłeś, że wcześniej zdjął buty, jego stopy są tak zrogowaciałe, że wydawały się kostniste, jakby były z fałd skóry!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Załóż te cholerne buty z powrotem.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Vagabond.getImagePath());
				_event.m.Vagabond.improveMood(1.0, "Cieszył się życiem w drodze");

				if (_event.m.Vagabond.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Vagabond.getMoodState()],
						text = _event.m.Vagabond.getName() + this.Const.MoodStateEvent[_event.m.Vagabond.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.vagabond" || bro.getBackground().getID() == "background.refugee" || bro.getBackground().getID() == "background.messenger")
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 25)
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " odnosi lekkie rany"
						});
					}
				}

				local amount = brothers.len();
				this.World.Assets.addMedicine(-amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_medicine.png",
					text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] Zapasów Medycznych."
				});
			}

		});
		this.m.Screens.push({
			ID = "Thief",
			Text = "%terrainImage%{%thief%, złodziej, podchodzi do ciebie bokiem. Odsuwasz się i wkładasz ręce do kieszeni, pytając, czego chce. On uśmiecha się szyderczo i odpowiada.%SPEECH_ON%Dobra, powiem szczerze, kapitanie. Ostatnim razem, gdy zatrzymaliśmy się w mieście, poczęstowałem się towarem niewidomego uzdrowiciela. Co? Bolał mnie ząb. Nie ma powodu płacić za naprawę tego, co dali mi starzy bogowie. W każdym razie naprawiłem ząb. Widzisz? Jaki uśmiech, co? A potem pomyślałem, że czuję jakieś bóle, człowieku, bóle wszędzie! Więc odwiedziłem uzdrowiciela znowu i...%SPEECH_OFF%Przerywasz mu i pytasz, ile ukradł. Wyciąga worek medykamentów. Dumnie opiera dłonie na biodrach i spogląda na świat ze swoim krzywym uśmiechem.%SPEECH_ON%Wystarczy powiedzieć, że już mnie nic nie boli.%SPEECH_OFF%} ",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Na co my właściwie narzekaliśmy?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Thief.getImagePath());
				local amount = this.Math.rand(5, 15);
				this.World.Assets.addMedicine(amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_medicine.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]-" + amount + "[/color] Zapasów Medycznych."
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

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 5)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		if (this.World.Assets.getMedicine() < brothers.len())
		{
			return;
		}

		local candidates_tailor = [];
		local candidates_vagabond = [];
		local candidates_thief = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.tailor")
			{
				candidates_tailor.push(bro);
			}
			else
			{
				candidates_other.push(bro);

				if (bro.getBackground().getID() == "background.thief")
				{
					candidates_thief.push(bro);
				}
				else if (bro.getBackground().getID() == "background.vagabond" || bro.getBackground().getID() == "background.refugee" || bro.getBackground().getID() == "background.messenger")
				{
					candidates_vagabond.push(bro);
				}
			}
		}

		if (candidates_tailor.len() != 0 && candidates_other.len() != 0)
		{
			this.m.Tailor = candidates_tailor[this.Math.rand(0, candidates_tailor.len() - 1)];
			this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		}

		if (candidates_vagabond.len() != 0)
		{
			this.m.Vagabond = candidates_vagabond[this.Math.rand(0, candidates_vagabond.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"tailor",
			this.m.Tailor != null ? this.m.Tailor.getName() : ""
		]);
		_vars.push([
			"otherbrother",
			this.m.Other != null ? this.m.Other.getName() : ""
		]);
		_vars.push([
			"travelbro",
			this.m.Vagabond != null ? this.m.Vagabond.getName() : ""
		]);
		_vars.push([
			"thief",
			this.m.Thief != null ? this.m.Thief.getName() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Tailor = null;
		this.m.Other = null;
		this.m.Vagabond = null;
		this.m.Thief = null;
	}

});

