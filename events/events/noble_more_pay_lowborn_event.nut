this.noble_more_pay_lowborn_event <- this.inherit("scripts/events/event", {
	m = {
		Noble = null,
		Lowborn = null
	},
	function create()
	{
		this.m.ID = "event.noble_more_pay_lowborn";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img] %noble% nagle wchodzi do twojego namiotu. Ma na sobie zbroję, a broń u boku. Wygląda niemal tak, jakby specjalnie się wystroił na tę okazję, i rzeczywiście stoi wyprostowany i nienaganny. Pytasz, czego chce, a on mówi z głową uniesioną wysoko i wzrokiem wbitym prosto przed siebie.%SPEECH_ON%Dotarło do mnie, że %lowborn% otrzymuje większy żołd ode mnie. Choć nie mam do tego człowieka osobistych pretensji, chcę podkreślić, że to człowiek bez jakiegokolwiek urodzeniowego prawa do czegokolwiek poza własnymi stopami. Nie możesz płacić nisko urodzonemu więcej niż człowiekowi błękitnej krwi. My, szlachta, zasługujemy na więcej.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dopilnuję, byś nie był opłacany gorzej od niego.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Płacimy za staż i umiejętności, nie za krew.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "A może obniżymy twój żołd?",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Noble.getImagePath());
				this.Characters.push(_event.m.Lowborn.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_64.png[/img]Niekoniecznie się z nim zgadzasz, ale widzisz też, że odmówienie tej prośby może wywołać dotąd niespotykane problemy. Kilkoma pociągnięciami pióra na zwoju listy przydzielasz %noble% wyższy żołd i mówisz mu, by spodziewał się cięższej sakiewki w dniu wypłaty. Mężczyzna w końcu spogląda na ciebie i kłania się w pas.%SPEECH_ON%Podjąłeś dobrą i właściwą decyzję.%SPEECH_OFF%Odwraca się na pięcie i maszeruje z powrotem z takim samym zapałem, z jakim wszedł.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Równy żołd utrzyma spokój.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Noble.getImagePath());
				_event.m.Noble.getBaseProperties().DailyWage += this.Math.max(0, _event.m.Lowborn.getDailyCost() - _event.m.Noble.getDailyCost());
				_event.m.Noble.getSkills().update();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_daily_money.png",
					text = _event.m.Noble.getName() + " otrzymuje teraz " + _event.m.Noble.getDailyCost() + " koron dziennie"
				});
				_event.m.Noble.improveMood(1.0, "Otrzymał podwyżkę");

				if (_event.m.Noble.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Noble.getMoodState()],
						text = _event.m.Noble.getName() + this.Const.MoodStateEvent[_event.m.Noble.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_64.png[/img]Mówisz mu, by na ciebie spojrzał. Powoli przenosi wzrok na twoje oczy. Gdy masz jego uwagę, wyjaśniasz, jak tu się sprawy mają.%SPEECH_ON%Płacę za staż i weteranię, nie za to, kim byłeś, zanim podpisałeś umowę. Mógłbyś być choćby pasterzem kóz, nie obchodzi mnie to - jeśli potrafisz wymachiwać mieczem, dostaniesz żołd, a jeśli robisz to lepiej niż następny, to do diabła, będziesz dostawał więcej niż następny! Coś tu jest dla ciebie niejasne?%SPEECH_OFF%Policzki %noble% drżą, gdy tłumi nagły wybuch złości. Mówi przez zaciśnięte zęby.%SPEECH_ON%Nie, panie.%SPEECH_OFF%Machnięciem ręki każesz mu zniknąć ci z oczu. Odlatuje w pośpiechu, jego wyprostowana postawa zamienia się w kipiące pochylenie.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jeśli chcesz widzieć więcej koron, zarób na nie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Noble.getImagePath());
				_event.m.Noble.worsenMood(2.0, "Odmówiono mu satysfakcji wobec nisko urodzonego");

				if (_event.m.Noble.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Noble.getMoodState()],
						text = _event.m.Noble.getName() + this.Const.MoodStateEvent[_event.m.Noble.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_64.png[/img]Wstajesz z krzesła i krzyczysz, by spojrzał na ciebie. Robi, co mu każesz, więc wyjaśniasz, co się stanie.%SPEECH_ON%%lowborn% przetrwał ten świat, wyciągając się z błota. Ty urodziłeś się ze srebrną łyżką w ustach, ale to nie miejsce twojego urodzenia, prawda? Od dziś uznaj swój żołd za obniżony. Chcesz prawa do wyższej wypłaty? Zasłuż na nie.%SPEECH_OFF%Postawa szlachcica chwieje się. Otwiera usta, ale ty szybko unosisz rękę.%SPEECH_ON%Ani słowa więcej. Znikaj mi z oczu.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wynocha!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Noble.getImagePath());
				_event.m.Noble.getBaseProperties().DailyWage -= _event.m.Noble.getDailyCost() / 2;
				_event.m.Noble.getSkills().update();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_daily_money.png",
					text = _event.m.Noble.getName() + " otrzymuje teraz " + _event.m.Noble.getDailyCost() + " koron dziennie"
				});
				_event.m.Noble.worsenMood(2.0, "Został upokorzony przez kapitana");
				_event.m.Noble.worsenMood(2.0, "Odmówiono mu satysfakcji wobec nisko urodzonego");
				_event.m.Noble.worsenMood(2.0, "Dostał obniżkę żołdu");

				if (_event.m.Noble.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Noble.getMoodState()],
						text = _event.m.Noble.getName() + this.Const.MoodStateEvent[_event.m.Noble.getMoodState()]
					});
				}

				if (!_event.m.Noble.getSkills().hasSkill("trait.greedy"))
				{
					local trait = this.new("scripts/skills/traits/greedy_trait");
					_event.m.Noble.getSkills().add(trait);
					this.List.push({
						id = 10,
						icon = trait.getIcon(),
						text = _event.m.Noble.getName() + " staje się chciwy"
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() < 500)
		{
			return;
		}

		if (this.World.Retinue.hasFollower("follower.paymaster"))
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local lowestPay = 1000;
		local lowestNoble;

		foreach( bro in brothers )
		{
			if (bro.getDailyCost() < lowestPay && bro.getBackground().isNoble())
			{
				lowestNoble = bro;
				lowestPay = bro.getDailyCost();
			}
		}

		if (lowestNoble == null)
		{
			return;
		}

		local lowborn_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getDailyCost() > lowestPay && bro.getBackground().isLowborn())
			{
				lowborn_candidates.push(bro);
			}
		}

		if (lowborn_candidates.len() == 0)
		{
			return;
		}

		this.m.Noble = lowestNoble;
		this.m.Lowborn = lowborn_candidates[this.Math.rand(0, lowborn_candidates.len() - 1)];
		this.m.Score = 7 + (lowestNoble.getSkills().hasSkill("trait.greedy") ? 9 : 0);
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"noble",
			this.m.Noble.getName()
		]);
		_vars.push([
			"lowborn",
			this.m.Lowborn.getName()
		]);
	}

	function onClear()
	{
		this.m.Noble = null;
		this.m.Lowborn = null;
	}

});

