this.sellsword_gets_better_deal_event <- this.inherit("scripts/events/event", {
	m = {
		Sellsword = null,
		Amount = 0,
		OldPay = 0
	},
	function create()
	{
		this.m.ID = "event.sellsword_gets_better_deal";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 35.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]Podczas liczenia zapasów %sellsword% staje obok, bezmyślnie grzebiąc przy tym mieczu czy tarczy. Odkładasz pióro i pytasz, o co chodzi, bo na pewno nie przyszedł niczego liczyć. Wyjaśnia, że inna kompania chce jego ręki do miecza - i są gotowi płacić więcej. Pytasz ile, a on unosi dłonie, by policzyć.%SPEECH_ON%Mówią o %newpay% koron dziennie.%SPEECH_OFF%U ciebie zarabia %pay% koron dziennie.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Rozumiem, czas się rozstać.",
					function getResult( _event )
					{
						_event.m.Sellsword.getSkills().onDeath(this.Const.FatalityType.None);
						this.World.getPlayerRoster().remove(_event.m.Sellsword);
						return 0;
					}

				},
				{
					Text = "Musi być jakiś sposób, by cię od tego odwieść.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= _event.m.Sellsword.getLevel() * 10 ? "B" : "C";
					}

				},
				{
					Text = "W takim razie wyrównam ich ofertę.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Sellsword.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img] Obracasz się, krzyżujesz ręce i opierasz but o skrzynię. Patrząc w dal, mówisz %sellsword%, że kompania wiele razem przeszła i wszyscy, a szczególnie ty, nie chcieliby go stracić. Ma tu drugą rodzinę w %companyname%, a to rzadkość w świecie najemników. Tam, dokąd idzie, nie ma żadnej gwarancji tego, co znajdzie. Wiesz, bo sam tam byłeś. Byłeś na jego miejscu, wziąłeś te buty i odszedłeś. I tego żałowałeś.\n\nNajemnik patrzy w ziemię, rozważając twoje słowa. W końcu kiwa głową i zgadza się zostać. Mówisz mu, że podjął właściwą decyzję. Odwraca się i stukając w kołczan strzał odchodzi.%SPEECH_ON%Może byś je uzupełnił.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cieszę się, że z nami zostajesz.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Sellsword.getImagePath());
				_event.m.Sellsword.getFlags().add("convincedToStayWithCompany");
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_16.png[/img] Obracasz się, krzyżujesz ręce i opierasz but o skrzynię. Patrząc w dal, mówisz %sellsword%, że kompania wiele razem przeszła i wszyscy, a szczególnie ty, nie chcieliby go stracić. Ma tu drugą rodzinę w %companyname%, a to rzadkość w świecie najemników. Tam, dokąd idzie, nie ma żadnej gwarancji tego, co znajdzie. Wiesz, bo sam tam byłeś. Byłeś na jego miejscu, wziąłeś te buty i odszedłeś. I tego żałowałeś.\n\n Najemnik patrzy w ziemię, rozważając twoje słowa. W końcu kręci głową i zaciska usta z wyrazem \"przepraszam\". Mówisz mu, że podejmuje złą decyzję, ale on nie chce o tym słyszeć. Odwraca się i stukając w kołczan strzał odchodzi.%SPEECH_ON%Może byś je uzupełnił.%SPEECH_OFF%Strzał jest trochę mało, ale jedyne, o czym myślisz, to jak zastąpić tak dobrego miecznika.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cholerna szkoda.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Sellsword.getName() + " odchodzi z " + this.World.Assets.getName()
				});
				_event.m.Sellsword.getItems().transferToStash(this.World.Assets.getStash());
				_event.m.Sellsword.getSkills().onDeath(this.Const.FatalityType.None);
				this.World.getPlayerRoster().remove(_event.m.Sellsword);
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_04.png[/img] Wzdychasz. Mężczyzna kiwa głową i rusza, by odejść, ale go zatrzymujesz. Zapłacisz tyle, by został. %companyname% po prostu nie może sobie pozwolić na utratę takiego człowieka.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobry człowiek nie jest tani.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Sellsword.getImagePath());
				_event.m.Sellsword.getBaseProperties().DailyWage += _event.m.Amount;
				_event.m.Sellsword.getSkills().update();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_daily_money.png",
					text = _event.m.Sellsword.getName() + " otrzymuje teraz " + _event.m.Sellsword.getDailyCost() + " koron dziennie"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Retinue.hasFollower("follower.paymaster"))
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 4 && bro.getLevel() <= 9 && this.Time.getVirtualTimeF() - bro.getHireTime() > this.World.getTime().SecondsPerDay * 25.0 && bro.getBackground().getID() == "background.sellsword" && !bro.getFlags().has("convincedToStayWithCompany"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Sellsword = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Amount = this.Math.rand(5, 15);
		this.m.OldPay = this.m.Sellsword.getDailyCost();
		this.m.Score = candidates.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"sellsword",
			this.m.Sellsword.getName()
		]);
		_vars.push([
			"newpay",
			this.m.OldPay + this.m.Amount
		]);
		_vars.push([
			"pay",
			this.m.OldPay
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Sellsword = null;
		this.m.Amount = 0;
		this.m.OldPay = 0;
	}

});

