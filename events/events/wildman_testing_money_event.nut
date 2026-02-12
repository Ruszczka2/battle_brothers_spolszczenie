this.wildman_testing_money_event <- this.inherit("scripts/events/event", {
	m = {
		Wildman = null,
		OtherGuy = null,
		Item = null
	},
	function create()
	{
		this.m.ID = "event.wildman_testing_money";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 90.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_04.png[/img]Zastajesz %wildman% dzikusa, który układa swoje korony w wieże. Odchyla się od tych pieniężnych tworów z szerokim uśmiechem, po czym nagle rzuca się do przodu i przewraca wieże jak dziecko swoje klocki. Śmieje się maniakalnie, gdy monety się rozsypują. Widok człowieka bawiącego się pieniędzmi jest osobliwy. Może dzikus nie ma pojęcia, do czego służą korony? Jeśli tak, to może... może mógłbyś je odzyskać?",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Sprawdźmy, czy odda to wszystko za coś innego.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				},
				{
					Text = "Lepiej zostawić człowieka i jego korony w spokoju.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
				_event.m.Wildman.getFlags().set("IsConceptionOfMoneyTested", true);
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_04.png[/img]Kucasz.%SPEECH_ON%Hej, %wildman%. Mogę wziąć jedną z tych?%SPEECH_OFF%Ostrożnie podnosisz monetę i mierzysz reakcję dzikusa. Wzrusza ramionami i mruczy, jakby mówił \'twoja\'. Bierzesz kolejną koronę. I jeszcze jedną. Dzikus patrzy na ciebie złowrogo, ale ty powoli wyciągasz patyk z przywiązaną do końca ozdobną kokardką. Jego wirujący wygląd przyciąga wzrok dzikusa. Gdy wyciąga po niego rękę, cofasz patyk i kręcisz głową. Potem wskazujesz na korony, a następnie na patyk.%SPEECH_ON%Jedno za drugie, tak?%SPEECH_OFF%Dzikus spogląda na swoje korony, rozważając je jak księgowy, choć wiesz, że jego myśli są znacznie bardziej chaotyczne. Nagle warczy, popycha korony do przodu i zabiera patyk. Wygląda na to, że wymiana doszła do skutku.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To poszło dobrze.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
				local money = 10 * _event.m.Wildman.getDaysWithCompany();
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] koron"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_06.png[/img]Kucasz i patrzysz na bałagan z koronami.%SPEECH_ON%Ależ one błyszczą, co?%SPEECH_OFF%Dzikus mruczy i próbuje cię przegonić. Nie ustępujesz, podnosisz koronę. Jego ręce opadają, a on zrywa głowę, patrząc na ciebie spode łba. Powoli odkładasz monetę i wyciągasz patyk z owiniętym na końcu sznurkiem. Jego spojrzenie mięknie, mocny patyk to kuszący smakołyk dla zaniedbanego dzikusa. Dajesz znak, że oddasz mu patyk w zamian za korony. On bierze patyk. Ty bierzesz korony.\n\n Ale gdy dzikus bawi się sznurkiem, ten odpada i odlatuje z wiatrem. Dzikus krzyczy, po czym wpatruje się w ciebie morderczo, gdy stoisz z obiema rękami zajętymi próbą utrzymania wszystkich koron. Dzikus wrzeszczy. Upuszczasz korony i biegniesz ile sił. Za tobą dzieje się chaos - narzędzia i broń są łamane, bracia uciekają, a całkowite pandemonium zdezorientowanych ludzi atakowanych przez dzikusa - ale nie śmiesz się odwrócić.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Pewnie nie powinienem był tego robić.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
				_event.m.Wildman.worsenMood(1.0, "Zrobił zły interes");

				if (_event.m.Wildman.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Wildman.getMoodState()],
						text = _event.m.Wildman.getName() + this.Const.MoodStateEvent[_event.m.Wildman.getMoodState()]
					});
				}

				local injury = _event.m.OtherGuy.addInjury(this.Const.Injury.Brawl);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.OtherGuy.getName() + " doznaje " + injury.getNameOnly()
				});

				if (_event.m.Item != null)
				{
					this.World.Assets.getStash().remove(_event.m.Item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + _event.m.Item.getIcon(),
						text = "Tracisz " + this.Const.Strings.getArticle(_event.m.Item.getName()) + _event.m.Item.getName()
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.wildman" && !bro.getFlags().get("IsConceptionOfMoneyTested"))
			{
				candidates.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates.len() == 0 || candidates_other.len() == 0)
		{
			return;
		}

		this.m.Wildman = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.OtherGuy = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Score = candidates.len() * 3;
	}

	function onPrepare()
	{
		local items = this.World.Assets.getStash().getItems();
		local candidates = [];

		foreach( item in items )
		{
			if (item == null)
			{
				continue;
			}

			if (item.isItemType(this.Const.Items.ItemType.Legendary) || item.isIndestructible())
			{
				continue;
			}

			if (item.isItemType(this.Const.Items.ItemType.Weapon) || item.isItemType(this.Const.Items.ItemType.Shield) || item.isItemType(this.Const.Items.ItemType.Armor) || item.isItemType(this.Const.Items.ItemType.Helmet))
			{
				candidates.push(item);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Item = candidates[this.Math.rand(0, candidates.len() - 1)];
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"wildman",
			this.m.Wildman.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Wildman = null;
		this.m.OtherGuy = null;
		this.m.Item = null;
	}

});

