this.traveling_troupe_event <- this.inherit("scripts/events/event", {
	m = {
		Entertainer = null,
		Noble = null,
		Payment = 0
	},
	function create()
	{
		this.m.ID = "event.traveling_troupe";
		this.m.Title = "Przy drodze...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_92.png[/img]Podczas obozu przy drodze z turkotem podjeżdża kolorowy wóz, brzęcząc i dzwoniąc muzyczną bezwstydnością. Nie wydawał się szczególnie duży, ale z jego tyłu wylewa się około piętnastu mężczyzn i kobiet. Pomalowane twarze, instrumenty, piłki do żonglerki, miecze do połykania, dzbany wina do zionęcia ogniem - trupa artystów rozchodzi się i prezentuje mini‑pokazy talentów, jakbyś już zapłacił za ich usługi. Gdy kończą, klaszczą, tupią i zamierają przed tobą z wyciągniętymi dłońmi i uśmiechami na twarzach. Białolicy mim ironicznie przemawia.%SPEECH_ON%Cóż powiesz, podróżniku, chcesz przedstawienia? Zaledwie %payment% koron, by zabawiać was przez cały wieczór!%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Jasne, zapłacimy za przedstawienie.",
					function getResult( _event )
					{
						return "Regular";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Entertainer != null)
				{
					this.Options.push({
						Text = "%entertainerfull%, co powiesz?",
						function getResult( _event )
						{
							return "Entertainer";
						}

					});
				}

				if (_event.m.Noble != null)
				{
					this.Options.push({
						Text = "Wyglądasz, jakbyś miał coś na głowie, %noblefull%.",
						function getResult( _event )
						{
							return "Noble";
						}

					});
				}

				this.Options.push({
					Text = "A może po prostu oddacie kosztowności?",
					function getResult( _event )
					{
						return "Robbing";
					}

				});
				this.Options.push({
					Text = "Jest dobrze, dzięki.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Entertainer",
			Text = "[img]gfx/ui/events/event_26.png[/img]%entertainer% wychodzi naprzód i podnosi kilka narzędzi z rzemiosła trupy. Testuje je, imponując artystom tym, jak dobrze potrafi używać ich własnego sprzętu. Mim pyta, czy mogliby zagrać z nim kilka melodii. Ten kiwa głową i dołącza do artystów, dając pokaz na miarę legend. Gdy wszystko się kończy, trupa jest tak zachwycona, że próbuje zwerbować mężczyznę. Mówisz im, że nic z tego, a %entertainer% przytakuje.%SPEECH_ON%Mój czas należy teraz do %companyname%, ale dziękuję za komplement.%SPEECH_OFF%Pytasz, ile kosztuje pokaz, lecz lider trupy kręci głową.%SPEECH_ON%Nie ma potrzeby. To była przyjemność z nim grać. Nie wystawialiśmy takiego pokazu od dawna i taka praktyka dobrze nam zrobi.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bywajcie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Entertainer.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.improveMood(1.0, "Zabawiony przez wędrowną trupę");

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

		});
		this.m.Screens.push({
			ID = "Noble",
			Text = "[img]gfx/ui/events/event_26.png[/img]Zanim trupa zacznie, %nobleman% szlachcic wstaje i pyta, czy znają pewną pieśń z czasów jego pobytu na dworze.%SPEECH_ON%Śpiewali ją, gdy byłem małym chłopcem. Minęły lata, odkąd ją słyszałem.%SPEECH_OFF%Mim, znów łamiąc rolę, uśmiecha się i głośno ogłasza, że ją znają. Pstryka palcami, a muzycy chwytają instrumenty. Gdy zaczynają, melodia od razu wpada w ucho. To orkiestracja strun i rogów, której towarzyszy wielka kobieta śpiewająca z serca i brzucha. Jest jak burza w głosie, niosąc zarazem ciszę i gwałtowność wielkiej nawałnicy, a jej słowa mówią o niezwykłym bohaterstwie dawnych dni.\n\n Gdy trupa kończy, pytasz, ile im winien. Mim kręci głową.%SPEECH_ON%Nie, panie, zapłata nie jest potrzebna. Dawno nikt o to nie prosił i było nam miło zagrać to dla was.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Piękne.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Noble.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.improveMood(1.0, "Zabawiony przez wędrowną trupę");

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

		});
		this.m.Screens.push({
			ID = "Robbing",
			Text = "[img]gfx/ui/events/event_60.png[/img]Rozkazujesz obrabować trupę. Mim, tym razem faktycznie w roli, unosi dłonie i bezgłośnie pyta: \'co?\'. Ale zabawa kończy się, gdy %randombrother% podchodzi i sadzi mu pięść prosto w brodę. Mim pada z kocim jękiem, miaucząc w błocie, gdy trzyma się za szczękę.\n\nReszta kompanii obija trupę, przeszukując ich wóz w poszukiwaniu towarów. Żongler dostaje kopa prosto w jaja, a śpiewaczka ma gardło ściśnięte przez dłoń %randombrother2%. Połykacz mieczy próbuje ukryć swój miecz w jedynym miejscu, które zna, ale najemnik wyciąga go, boleśnie rozszarpując. Zioniący ogniem wypija cały dzban, po czym pyta, czy chcesz zabrać i to. Dostaje cios w brzuch za zuchwałość.\n\n Gdy wszystko się kończy, nie ma wiele do zabrania, bo bicie błaznów nie jest najbardziej dochodowym interesem. Przynajmniej z rozbitą gębą mim może lepiej wykonywać swoją pracę.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Naucz się mimu, ty obleśny draniu.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-2);
				local item = this.new("scripts/items/helmets/jesters_hat");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/weapons/lute");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.Math.rand(50, 200);
				this.World.Assets.addMoney(item);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + item + "[/color] koron"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getBackground().getID() == "background.raider")
					{
						bro.improveMood(1.0, "Cieszył się z obicia wędrownej trupy");

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
			ID = "Regular",
			Text = "[img]gfx/ui/events/event_26.png[/img]Płacisz za przedstawienie, które trupa wystawia całkiem dobrze. Błaźni rzucają żartami, żonglerzy żonglują, co jest już trochę oklepane, ale trudno, śpiewacy śpiewają, miecze są połykane, ogniem się \'zionie\', a mim, cóż, jest okropny i naprawdę masz nadzieję, że zginie.\n\n Gdy wszystko się kończy, czujesz, że dostałeś warte swojej ceny przedstawienie, a ludzie są zadowoleni.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Dzięki.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-_event.m.Payment);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Payment + "[/color] koron"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.improveMood(1.0, "Zabawiony przez wędrowną trupę");

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

		});
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (this.World.Assets.getMoney() < 40 * brothers.len() + 500)
		{
			return;
		}

		local candidates_entertainer = [];
		local candidates_noble = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.juggler" || bro.getBackground().getID() == "background.minstrel")
			{
				candidates_entertainer.push(bro);
			}
			else if (bro.getBackground().getID() == "background.adventurous_noble" || bro.getBackground().getID() == "background.disowned_noble" || bro.getBackground().getID() == "background.regent_in_absentia")
			{
				candidates_noble.push(bro);
			}
		}

		if (candidates_entertainer.len() != 0)
		{
			this.m.Entertainer = candidates_entertainer[this.Math.rand(0, candidates_entertainer.len() - 1)];
		}

		if (candidates_noble.len() != 0)
		{
			this.m.Noble = candidates_noble[this.Math.rand(0, candidates_noble.len() - 1)];
		}

		this.m.Payment = 40 * brothers.len();
		this.m.Score = 7;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"entertainer",
			this.m.Entertainer != null ? this.m.Entertainer.getNameOnly() : ""
		]);
		_vars.push([
			"entertainerfull",
			this.m.Entertainer != null ? this.m.Entertainer.getName() : ""
		]);
		_vars.push([
			"nobleman",
			this.m.Noble != null ? this.m.Noble.getNameOnly() : ""
		]);
		_vars.push([
			"noblefull",
			this.m.Noble != null ? this.m.Noble.getName() : ""
		]);
		_vars.push([
			"payment",
			this.m.Payment
		]);
	}

	function onClear()
	{
		this.m.Entertainer = null;
		this.m.Noble = null;
		this.m.Payment = 0;
	}

});

