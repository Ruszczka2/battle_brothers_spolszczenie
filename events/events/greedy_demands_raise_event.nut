this.greedy_demands_raise_event <- this.inherit("scripts/events/event", {
	m = {
		Greedy = null
	},
	function create()
	{
		this.m.ID = "event.greedy_demands_raise";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]{%bro% wchodzi do twojego namiotu ze zwojem u boku. Rozwija go, ujawniając dosłowną listę rzeczy, które zabił. Pytasz, co masz z tym zrobić. Zrzuca zwój na biurko i odpowiada.%SPEECH_ON%Zrekompensować mi. Wyższy żołd od teraz. %newpay% koron dziennie.%SPEECH_OFF% | %bro% najwyraźniej chce wyższego żołdu, %newpay% koron dziennie zamiast %oldpay% koron, które teraz dostaje, twierdząc, że zabił mnóstwo wrogów, będąc w szeregach %companyname%.\n\nZabijanie wielu rzeczy to dobry argument, gdy to właśnie wasz interes, przyznajesz mu to. | Wygląda na to, że %bro% chce większego żołdu za to, że zabijał dużo, no cóż, wszystkiego w twoim imieniu. Mówisz mu, że nic z tego nie było w twoim osobistym imieniu, po prostu mu za to płaciłeś. Kiwając głową, mówi.%SPEECH_ON%W porządku. A teraz chcę więcej. %newpay% koron dziennie.%SPEECH_OFF% | %bro% czuje, że jego usługi dla kompanii nie są odpowiednio opłacane. Prosi o więcej, %newpay% koron dziennie zamiast %oldpay% koron, które teraz dostaje, ze względu na to, jak dobrym jest najemnikiem. | %bro% domaga się, abyś płacił mu więcej, %newpay% koron dziennie zamiast %oldpay% koron, które dotąd dostawał, teraz gdy udowodnił, że świetnie walczy dla %companyname%.\n\nMa trochę racji, ale nie jesteś pewien, czy już chcesz wyłożyć te korony.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze, zasłużyłeś na to.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Dostaniesz to, na co się umówiliśmy, i ani korony więcej.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Greedy.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_64.png[/img]{Zgadzasz się na warunki %bro%. Jest, co zrozumiałe, bardzo zadowolony i ty wracasz do swoich zajęć. | Żądania %bro% nie są zbyt wygórowane i z chęcią dorzucasz mu kilka koron dziennie. Podaje ci rękę. Uścisk jest mocny, ale nie za mocny. | %bro% chwieje się na nogach, czekając na twoją odpowiedź. Mówisz mu, by się rozluźnił, bo zgadzasz się na jego warunki. W końcu wzdycha z ulgą.%SPEECH_ON%Dziękuję, panie. Myślałem, że będę musiał, no nie wiem.%SPEECH_OFF%Unosisz brew.%SPEECH_ON%Mam nadzieję, że to nie była groźba.%SPEECH_OFF%Mężczyzna śmieje się niezręcznie i kręci głową.%SPEECH_ON%Nie, nie, oczywiście, że nie!%SPEECH_OFF% | Mówisz %bro%, że zwiększysz jego żołd pod jednym warunkiem: ma zatańczyć.%SPEECH_ON%Taniec zwycięstwa?%SPEECH_OFF%Wzruszasz ramionami.%SPEECH_ON%Jakiś taniec.%SPEECH_OFF%Unosi ręce i trochę nimi wymachuje. Wybuchasz śmiechem.%SPEECH_ON%Żadna liczba zabitych nie dorówna temu, co właśnie zobaczyłem.%SPEECH_OFF%Mężczyzna chichocze.%SPEECH_ON%Dziękuję, panie.%SPEECH_OFF% | Zgadzasz się dać %bro% wyższy żołd.%SPEECH_ON%To będzie dla mnie zaszczyt.%SPEECH_OFF%Mężczyzna unosi brew.%SPEECH_ON%Oszczędź mi ceremonii. Jestem tu, by zabijać, nie róbmy z tego tańca.%SPEECH_OFF%Kiwając głową, przyjmujesz to.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zasłużyłeś na to!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Greedy.getImagePath());
				_event.m.Greedy.getBaseProperties().DailyWage += 8;
				_event.m.Greedy.improveMood(2.0, "Received a pay raise");
				_event.m.Greedy.getSkills().update();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_daily_money.png",
					text = _event.m.Greedy.getName() + " otrzymuje teraz " + _event.m.Greedy.getDailyCost() + " koron dziennie"
				});

				if (_event.m.Greedy.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Greedy.getMoodState()],
						text = _event.m.Greedy.getName() + this.Const.MoodStateEvent[_event.m.Greedy.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_64.png[/img]{Odrzucasz prośbę %bro%. Zaciska usta, splata dłonie, po czym kiwa głową, odwraca się i odchodzi. Cisza jest nieco ciężka, ale przekaz jasny: to nie jest szczęśliwy człowiek. | Odrzucenie prośby %bro% prowadzi do nagłego wybuchu.%SPEECH_ON%No to pieprzyć to. I tak będę za ciebie walczył, ale nie spodziewaj się po mnie cudów!%SPEECH_OFF%Kiwając głową, mówisz mu, że bez dawania z siebie wszystkiego i tak byłby martwy, więc dostaniesz to, czego chcesz, niezależnie od niego. | %bro% krzywi się, gdy odrzucasz jego propozycję.%SPEECH_ON%No dobrze, widzę, jak tu się toczy życie. Wchodzimy, wychodzimy. Dla ciebie bez znaczenia, prawda? Jesteśmy tylko pionkami, którymi się posługujesz, by dostać, czego chcesz. W porządku. W porządku, naprawdę.%SPEECH_OFF%Odwraca się i odchodzi. Masz wrażenie, że wcale nie jest \"w porządku\". | Mówisz %bro%, że nie zgadzasz się z jego wyliczeniami, ile powinien zarabiać. Odpowiada kilkoma przekleństwami o głośności, którą można określić jako \"głośną\". Gdy kończy, kiwa głową.%SPEECH_ON%Ale to w porządku. Rozumiem interesy. I jestem pewien, że rozumiesz, dlaczego muszę też dbać o interes, którym jestem ja sam.%SPEECH_OFF% | %bro% naciska na wyższy żołd, ale ty stawiasz sprawę jasno.%SPEECH_ON%Dostaniesz to, na co się umówiliśmy, nic więcej.%SPEECH_OFF%Kiwa głową i powoli wycofuje się z namiotu.%SPEECH_ON%Jak pan każe.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie zawsze dostajemy to, czego chcemy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Greedy.getImagePath());
				_event.m.Greedy.worsenMood(this.Math.rand(2, 3), "Was denied a pay raise");

				if (_event.m.Greedy.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Greedy.getMoodState()],
						text = _event.m.Greedy.getName() + this.Const.MoodStateEvent[_event.m.Greedy.getMoodState()]
					});

					if (_event.m.Greedy.getMoodState() == this.Const.MoodState.Angry)
					{
						if (!_event.m.Greedy.getSkills().hasSkill("trait.loyal") && !_event.m.Greedy.getSkills().hasSkill("trait.disloyal"))
						{
							local trait = this.new("scripts/skills/traits/disloyal_trait");
							_event.m.Greedy.getSkills().add(trait);
							this.List.push({
								id = 10,
								icon = trait.getIcon(),
								text = _event.m.Greedy.getName() + " staje się nielojalny"
							});
						}
						else if (_event.m.Greedy.getSkills().hasSkill("trait.loyal"))
						{
							_event.m.Greedy.getSkills().removeByID("trait.loyal");
							this.List.push({
								id = 10,
								icon = "ui/traits/trait_icon_39.png",
								text = _event.m.Greedy.getName() + " nie jest już lojalny"
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Retinue.hasFollower("follower.paymaster"))
		{
			return;
		}

		if (this.World.Assets.getMoney() < 4000)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() < 8)
			{
				continue;
			}

			if (bro.getSkills().hasSkill("trait.greedy"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Greedy = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"bro",
			this.m.Greedy.getName()
		]);
		_vars.push([
			"oldpay",
			this.m.Greedy.getDailyCost()
		]);
		_vars.push([
			"newpay",
			this.m.Greedy.getDailyCost() + 8
		]);
	}

	function onClear()
	{
		this.m.Greedy = null;
	}

});

