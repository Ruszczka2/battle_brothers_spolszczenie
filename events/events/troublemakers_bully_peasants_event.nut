this.troublemakers_bully_peasants_event <- this.inherit("scripts/events/event", {
	m = {
		Troublemaker = null,
		Peacekeeper = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.troublemakers_bully_peasants";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%townImage%Po wejściu do %townname% nie mija wiele czasu, a %troublemaker% zaczyna nękać miejscowych. Wybija im wiadra z rąk i kopie kobiety w błoto. Gdy stary człowiek staje mu na drodze, najemnik dobywa broni. Inni wieśniacy błagają, byś natychmiast to przerwał.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie mam na to czasu.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Musisz z tym skończyć, %troublemaker%. To źle świadczy o kompanii.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Ustaw chłopów do pionu i przeszukaj ich domy w poszukiwaniu kosztowności!",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Peacekeeper != null)
				{
					this.Options.push({
						Text = "%peacekeeperfull%, spróbuj uspokoić %troublemaker% swoją mądrością.",
						function getResult( _event )
						{
							return this.Math.rand(1, 100) <= 70 ? "E" : "F";
						}

					});
				}

				this.World.Assets.addMoralReputation(-1);
				local f = _event.m.Town.getFactionOfType(this.Const.FactionType.Settlement);
				f.addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "One of your men caused havoc in town");
				this.Characters.push(_event.m.Troublemaker.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%townImage%Wzruszasz ramionami. %troublemaker% nie przebija starca, ale grozi, unosząc broń wysoko. Kiedy starzec się kuli, najemnik wymierza cios, który powala go na ziemię, a zęby rozpryskują się w błocie jak białe krople deszczu. To wywołuje kilka gwizdów ze strony mieszkańców, ale wiedzą, by nie sprzeciwiać się waszej obecności.\n\nKilku mężczyzn odciąga starca, podczas gdy dzieci buczą, a kobiety syczą. Jedno dziecko nawet podbiega do najemnika i wskazując go krzyczy: \'to zły człowiek.\' %troublemaker% wzrusza ramionami, chowając broń.%SPEECH_ON%A jednak zły człowiek wciąż stoi. Chcesz też posmakować błota, maluchu?%SPEECH_OFF%Dzieciak szybko ucieka.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A teraz do rzeczy, które naprawdę się liczą...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Troublemaker.getImagePath());
				this.World.Assets.addMoralReputation(-3);
				local f = _event.m.Town.getFactionOfType(this.Const.FactionType.Settlement);
				f.addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "One of your men caused havoc in town");
				_event.m.Troublemaker.improveMood(1.0, "Gnębił wieśniaków");

				if (_event.m.Troublemaker.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Troublemaker.getMoodState()],
						text = _event.m.Troublemaker.getName() + this.Const.MoodStateEvent[_event.m.Troublemaker.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "%townImage%Gdy %troublemaker% unosi broń wysoko, chwytasz go za przedramię i opuszczasz ją. Odwraca się, patrząc na ciebie surowo. Kulący się starzec cofa się, wkrótce zabierany przez opiekunów, którzy wciągają go do środka, zanim zrobi sobie krzywdę.\n\nKilku innych chłopów zostaje w pobliżu, obserwując z zaciekawieniem. Mówisz najemnikowi, by się wycofał. Dostaje żołd za to, by walczyć z tymi, z którymi ty każesz mu walczyć, a nie z garścią ludzi, którzy pilnują własnych spraw.\n\n Gdy %troublemaker% rozgląda się, uświadamiasz sobie, że nie zostawiłeś mu żadnego wyjścia, które ocaliłoby jego twarz. W jego oczach pojawia się spojrzenie, które mówi, że zaraz cię zabije. To byłby jego koniec, ale odszedłby z samobójczą dumą nienaruszoną. Jednak spojrzenie gaśnie, a na jego miejsce wchodzą zakłopotanie i upokorzenie. Chowa broń, spluwa i mówi, że tylko się bawił.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zachowaj to na czas, gdy nam za to zapłacą.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Troublemaker.getImagePath());
				_event.m.Troublemaker.worsenMood(2.0, "Został upokorzony na oczach kompanii");

				if (_event.m.Troublemaker.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Troublemaker.getMoodState()],
						text = _event.m.Troublemaker.getName() + this.Const.MoodStateEvent[_event.m.Troublemaker.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_30.png[/img]Patrzysz na chłopa, który cię zatrzymał.%SPEECH_ON%Kim jesteś, chłopie, żeby mówić mi albo moim ludziom, co mamy robić?%SPEECH_OFF%Mężczyzna cofa się o krok, jąkając się, że \'tylko próbował pomóc\'. Śmiejąc się, każesz ludziom brać, co chcą. Skoro ta wioska nie szanuje autorytetu uzbrojonych mężczyzn, będziesz musiał nauczyć ich tego szacunku.\n\nKobiety krzyczą i chwytają dzieci, gdy rozkaz wychodzi z twoich ust. Uciekają, a kilku mężczyzn dołącza do nich. Inni zostają, broniąc swych domów, ale %companyname% szybko rozprawia się z ich skromną obroną. Twoi najemnicy wkrótce rabują każdy dom, zabierając, co się da, z ryczącym śmiechem. To dobry dzień.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To ich nauczy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Troublemaker.getImagePath());
				this.World.Assets.addMoralReputation(-5);
				local f = _event.m.Town.getFactionOfType(this.Const.FactionType.Settlement);
				f.addPlayerRelation(this.Const.World.Assets.RelationAttacked, "You pillaged the town");
				local money = this.Math.rand(100, 500);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] koron"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getBackground().isCombatBackground())
					{
						bro.improveMood(1.0, "Cieszył się z rabunku i grabieży");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getBackground().isOffendedByViolence() && this.Math.rand(1, 100) <= 75)
					{
						bro.worsenMood(1.0, "Był oburzony postępowaniem kompanii");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
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
			ID = "E",
			Text = "%townImage%%peacekeeperfull% staje między %troublemaker% a starym człowiekiem. W skromny sposób kręci głową na \'nie\', ale nie sposób nie zauważyć, że jego dłoń również spoczywa na głowicy broni. Kłopotliwy najemnik przez chwilę wydaje się rozważać, czy go nie ściąć, ale wtedy na jego twarzy pojawia się uśmiech. Śmieje się, chowając broń.%SPEECH_ON%Tylko się bawiłem, bracie.%SPEECH_OFF%Chłopi powoli wracają do swoich zajęć, ale są czujni i spoglądają na twoich ludzi spode łba przez cały wasz pobyt w %townname%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobra robota.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Troublemaker.getImagePath());
				this.Characters.push(_event.m.Peacekeeper.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "%townImage%%peacekeeperfull% staje między %troublemaker% a starym człowiekiem. Kłopotliwy najemnik śmieje się i chowa broń. Odwraca się do reszty kompanii, uśmiechając się i kręcąc głową, lecz zauważasz, że uśmiech szybko gaśnie. Zanim zdążysz cokolwiek powiedzieć, %troublemaker% cofa pięść i uderza %peacekeeper%, powalając go na ziemię bez przytomności.\n\n Cóż, to jeden ze sposobów na uspokojenie najemnika.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Chyba muszę zrobić coś z dyscypliną w tej kompanii.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Troublemaker.getImagePath());
				this.Characters.push(_event.m.Peacekeeper.getImagePath());
				local injury = _event.m.Peacekeeper.addInjury(this.Const.Injury.Knockout);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Peacekeeper.getName() + " doznaje " + injury.getNameOnly()
				});
				_event.m.Peacekeeper.worsenMood(2.0, "Został upokorzony na oczach kompanii");

				if (_event.m.Peacekeeper.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Peacekeeper.getMoodState()],
						text = _event.m.Peacekeeper.getName() + this.Const.MoodStateEvent[_event.m.Peacekeeper.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
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
		local candidates_troublemaker = [];
		local candidates_peacekeeper = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getSkills().hasSkill("trait.brute") || bro.getBackground().getID() == "background.raider" || bro.getBackground().getID() == "background.sellsword" || bro.getBackground().getID() == "background.hedge_knight" || bro.getBackground().getID() == "background.brawler")
			{
				candidates_troublemaker.push(bro);
			}
			else if (bro.getBackground().getID() == "background.monk" || bro.getBackground().getID() == "background.monk_turned_flagellant")
			{
				candidates_peacekeeper.push(bro);
			}
		}

		if (candidates_troublemaker.len() == 0)
		{
			return;
		}

		this.m.Troublemaker = candidates_troublemaker[this.Math.rand(0, candidates_troublemaker.len() - 1)];

		if (candidates_peacekeeper.len() != 0)
		{
			this.m.Peacekeeper = candidates_peacekeeper[this.Math.rand(0, candidates_peacekeeper.len() - 1)];
		}

		this.m.Town = town;
		this.m.Score = candidates_troublemaker.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"troublemaker",
			this.m.Troublemaker.getName()
		]);
		_vars.push([
			"peacekeeper",
			this.m.Peacekeeper != null ? this.m.Peacekeeper.getNameOnly() : ""
		]);
		_vars.push([
			"peacekeeperfull",
			this.m.Peacekeeper != null ? this.m.Peacekeeper.getName() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Troublemaker = null;
		this.m.Peacekeeper = null;
		this.m.Town = null;
	}

});

