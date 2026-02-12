this.raid_farmstead_event <- this.inherit("scripts/events/event", {
	m = {
		SomeGuy1 = null,
		SomeGuy2 = null
	},
	function create()
	{
		this.m.ID = "event.raid_farmstead";
		this.m.Title = "Na drodze...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_72.png[/img]%randombrother% przychodzi z raportem o zapasach żywności. Wyjaśnia, że niewiele zostało i że chleb, który macie, lepiej nadawałby się do budowy domu lub zabicia człowieka. Większość owoców jest miękka w dotyku i pokryta czymś, co wygląda na szare futro. Resztę wrzucono do wielkiego gulaszu, który ludzie trafnie nazwali \"rosołem z krocza\". Szczerze mówiąc, nie wygląda to dobrze.\n\nJednak, przez fortunny zbieg okoliczności, w oddali stoi mała farma. Brat nie mówi tego wprost, ale delikatnie sugeruje, że kompania mogłaby ją splądrować.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Plądrujemy ją.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Idziemy dalej.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_72.png[/img]Ruszacie w stronę farmy. Kilku parobków prostuje się na polach, patrząc na was, gdy się zbliżacie, i wymieniają między sobą spojrzenia. Pracownik zwijający siano wbija widły w ziemię i opiera na nich dłonie. Wszyscy obserwują was z nerwową ciekawością, gdy przecinacie równiny, a twoi ludzie wcale nie ukrywają pożądliwych spojrzeń na mijane plony.\n\nGdy zbliżacie się do gospodarstwa, wychodzi do was kobieta. Ociera czoło i pyta, czego chcecie. Z pobliskiego domu wychodzi kilkoro dzieci i staje na ganku. Spoglądają na was niepewnie zza nóg starszego mężczyzny, być może ojca kobiety.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Weź tylko to, co potrzebne.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Weź wszystko.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Weź wszystko. Zabij wszystkich.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_72.png[/img]Wyjaśniasz kobiecie, że twoi ludzie potrzebują jedzenia. Wzdryga się, ale unosisz dłoń.%SPEECH_ON%Weźmiemy tylko to, czego potrzebujemy - ani więcej, ani mniej. Nie chcemy kłopotów i wiem, że ty też ich nie chcesz. Jasne?%SPEECH_OFF%Kobieta szybko kiwa głową. Odwracasz się i każesz ludziom zebrać trochę plonów, a jednocześnie kobieta podnosi głos i mówi parobkom, by nie próbowali żadnych głupstw. Cała sprawa trwa jakieś dziesięć minut, po czym wracacie na drogę.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To musiało się stać.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
				local food;
				food = this.new("scripts/items/supplies/smoked_ham_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Zyskujesz " + food.getName()
				});
				food = this.new("scripts/items/supplies/bread_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Zyskujesz " + food.getName()
				});
				this.World.Assets.updateFood();
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_72.png[/img]Jedzenia jest tu pod dostatkiem. Odwracasz się do ludzi i każesz im wziąć wszystko, co mogą. Kobieta wzdycha, cofa się i wygląda, jakby miała krzyknąć. Chwytasz ją, wywołując serię krzyków dzieci. Kilku parobków chwyta sierpy i widły. Mówisz jej, by kazała reszcie parobków położyć broń na ziemi. Jest posłuszna, a parobkowie robią, co każe, choć dość niechętnie.\n\nTrzymasz kobietę, podczas gdy twoi ludzie zabierają, co mogą. Gdy zrabowali tyle, ile uniosą, puszczasz ją i każesz ludziom ruszać.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Na to zasługujemy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-2);
				local food;
				food = this.new("scripts/items/supplies/smoked_ham_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Zyskujesz " + food.getName()
				});
				food = this.new("scripts/items/supplies/smoked_ham_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Zyskujesz " + food.getName()
				});
				food = this.new("scripts/items/supplies/goat_cheese_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Zyskujesz " + food.getName()
				});
				food = this.new("scripts/items/supplies/bread_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Zyskujesz " + food.getName()
				});
				this.World.Assets.updateFood();
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_30.png[/img]Jest tu mnóstwo jedzenia. I zbyt wielu świadków.\n\nOdwracasz się i rzucasz znaczące spojrzenie na %someguy1%. Kiwają głową i nakłada strzałę. Zanim kobieta zdąży krzyknąć, brat wypuszcza strzałę, a starzec na ganku cofa się do domu, za nim biegnie grupa krzyczących dzieci. Reszta kompanii rozchodzi się, dobywając mieczy i biegnąc na pola. Kilku parobków próbuje się bronić, ale twoja dobrze uzbrojona banda szybko ich eliminuje. %someguy2% wpada do gospodarstwa i wewnątrz słyszysz serię krzyków, które jeden po drugim cichną, aż zapada cisza. Oddajesz kobietę kilku braciom, mówiąc im, by upewnili się, że nie żyje, zanim odejdziecie. Kilku innych najemników od razu zaczyna ścinać plony i wynosić przedmioty z domu. Niedługo potem wracacie na drogi, a wasze zapasy są niemal pełne. Kilku braci wyciera mokre ostrza w czerwone szmaty.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nie ma nikogo, kto opowie, co tu się stało.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-5);
				local food;
				food = this.new("scripts/items/supplies/smoked_ham_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Zyskujesz " + food.getName()
				});
				food = this.new("scripts/items/supplies/smoked_ham_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Zyskujesz " + food.getName()
				});
				food = this.new("scripts/items/supplies/goat_cheese_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Zyskujesz " + food.getName()
				});
				food = this.new("scripts/items/supplies/bread_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Zyskujesz " + food.getName()
				});
				this.World.Assets.updateFood();

				for( local i = 0; i < this.Math.rand(1, 2); i = ++i )
				{
					local pitchfork = this.new("scripts/items/weapons/pitchfork");
					this.World.Assets.getStash().add(pitchfork);
					this.List.push({
						id = 10,
						icon = "ui/items/" + pitchfork.getIcon(),
						text = "Zyskujesz " + pitchfork.getName()
					});
				}

				local item = this.Math.rand(100, 300);
				this.World.Assets.addMoney(item);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + item + "[/color] koron"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getSkills().hasSkill("trait.bloodthirsty"))
					{
						bro.improveMood(1.0, "Cieszył się z napadu i grabieży");

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
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Plains && currentTile.Type != this.Const.World.TerrainType.Farmland)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.Assets.getFood() > 50)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 5)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.bloodthirsty") || !bro.getBackground().isOffendedByViolence())
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 2)
		{
			return;
		}

		local x = 0;
		local y = 0;

		while (x == y)
		{
			x = this.Math.rand(0, candidates.len() - 1);
			y = this.Math.rand(0, candidates.len() - 1);
		}

		this.m.SomeGuy1 = candidates[x];
		this.m.SomeGuy2 = candidates[y];
		this.m.Score = 30;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"someguy1",
			this.m.SomeGuy1.getName()
		]);
		_vars.push([
			"someguy2",
			this.m.SomeGuy2.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.SomeGuy1 = null;
		this.m.SomeGuy2 = null;
	}

});

