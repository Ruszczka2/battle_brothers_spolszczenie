this.alp_captured_in_hole_event <- this.inherit("scripts/events/event", {
	m = {
		Beastslayer = null
	},
	function create()
	{
		this.m.ID = "event.alp_captured_in_hole";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 170.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Zastajesz mężczyznę siedzącego obok dziury w ziemi. Przy nim stoi metalowy pal, do którego przymocowany jest łańcuch biegnący w głąb dołu. Dziura przykryta jest kozią skórą. Macha do ciebie, ale mówi, że jeśli chcesz to zobaczyć, musisz zapłacić. Pytasz, co tam ma. Uśmiecha się.%SPEECH_ON%Najdziwniejszą rzecz, panie.%SPEECH_OFF%Kilku uzbrojonych mężczyzn stoi w oddali, bez wątpienia jako część jakiegoś układu.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze, zapłacę trochę, żeby zerknąć.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Nie, dzięki.",
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
			Text = "[img]gfx/ui/events/event_51.png[/img]{Rzucasz mężczyźnie kilka monet. Gryzie je zębami, a ty mówisz mu, by uważał, bo na niektórych jest krew. Wzrusza ramionami i chowa zapłatę. Podchodzisz do dziury, a mężczyzna zrzuca płachtę. Okropnie wyglądający alp wpatruje się w ciebie i syczy, z rzędami ostrych zębów i twarzą jak zasłona z bladego mięsa. Ma obrożę na szyi, a mężczyzna gwiżdże na widok, jakby pierwszy raz to widział.%SPEECH_ON%Okropny mały gnoj, co? Nie podchodź za blisko, bo będziesz widział rzeczy. Chyba że chcesz, oczywiście. Niektórzy chcą. Ale jeśli zaczniesz widzieć rzeczy i ci się to spodoba, musisz dopłacić!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Powinieneś go zabić.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "No cóż, powodzenia.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local money = -10;
				this.World.Assets.addMoney(-10);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]" + money + "[/color] Koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Tak potworne stworzenia nie powinny przetrwać. Mówisz mężczyźnie, że prędzej czy później to coś wydostanie się z dołu i zacznie siać spustoszenie w świecie, a może nawet większe niż zwykle, w napadzie pierwotnej zemsty. Mężczyzna pluje.%SPEECH_ON%Idź się farkuj. Wynoś się stąd i nie dostaniesz zwrotu. Zrobisz jeden zły krok i będę musiał bronić siebie i swojej inwestycji. To była cholernie ciężka robota, żeby to złapać, wiesz?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Sam go zabiję.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Dobra, niech żyje.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Beastslayer != null)
				{
					this.Options.push({
						Text = "%beastslayer%, jesteś ekspertem od takich spraw. Co powiesz?",
						function getResult( _event )
						{
							return "F";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Chwytasz włócznię jednego ze strażników i rzucasz ją do dołu, przebijając alpa przez czaszkę. Jego blade ciało zapada się wokół drzewca, jakbyś powalił ogromną zasłonę. Ciemiężyciel potworów dobywa sztyletu i rusza na ciebie. %randombrother% paruje cios i tnie go w gardło. Kilku strażników rzuca się do walki, wszyscy giną szybko i w pośpiechu, choć kilku najemników zostaje rannych w bijatyce. Gdy przemoc się kończy, zbierasz złoto, które miał przy sobie ciemiężyciel. Każesz wrzucić ciała do dołu razem z martwym alpem, a potem zasypujesz go.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wracajmy na drogę.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local money = this.Math.rand(25, 100);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Koron"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 33)
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " doznaje lekkich ran"
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Nie będziesz się kłócić z tymi ludźmi. Niektórzy z najlepszych wojowników, jakich widziałeś, zginęli w nieprzemyślanych i bezsensownych bójkach w karczmie. Jeśli ci idioci chcą trzymać potwora, niech tak będzie. Ale kilku najemników z kompanii nie jest zadowolonych z pomysłu, by alp miał żyć, zwłaszcza że stworzenie spoglądało bez twarzy na niektórych z nich i wydawało się kiwać, jakby miało ich zobaczyć później.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wracajmy na drogę.",
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
					if (bro.getBackground().getID() == "background.beast_slayer" || bro.getBackground().getID() == "background.witchhunter" || bro.getSkills().hasSkill("trait.hate_beasts") || bro.getSkills().hasSkill("trait.fear_beasts") || bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getSkills().hasSkill("trait.paranoid") || bro.getSkills().hasSkill("trait.superstitious"))
					{
						bro.worsenMood(0.75, "Pozwoliłeś żyć alpowi, który może nawiedzić kompanię później");

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
			ID = "F",
			Text = "[img]gfx/ui/events/event_122.png[/img]{%beastslayer%, pogromca bestii, podchodzi do dołu i zagląda do środka. Kiwając głową, mówi:%SPEECH_ON%Nie macie go schwytanego. Alpów nie da się schwytać.%SPEECH_OFF%Ciemiężyciel potworów spogląda i pyta, czemu. Pogromca śmieje się.%SPEECH_ON%Bo to nie jest zwykłe stworzenie. Ten alp tylko czeka. Mówiłeś, że wysyła koszmary tym, którzy zaglądają, tak? Tak właśnie. Strach jest jego ostrzem i on ostrzy je równo i cierpliwie. Ćwiczy swój kunszt najlepiej, jak potrafi. Alpy używają otoczenia, by zamykać w nim swoje ofiary, a teraz radzi sobie ziemią. Ale w końcu zajrzysz, a on spojrzy w górę, gotów na tę właśnie chwilę, i znajdziesz się w dole razem z nim. Nie ty, nie twoje ciało. Nie, ciało będzie oszczędzone. On zabierze twój umysł do tego dołu. I będzie tam. Ty i ta potworność, sami w całej ciemności, jaką ten świat ma do zaoferowania. Jak długo? Dni, tygodnie. Bardzo niebezpieczny alp potrafi uwięzić twój umysł na to, co wydaje się latami. Wyjdziesz z tego jako głupiec, złamany, śliniący się i błagający o śmierć, o ile do tego czasu zachowasz zdolność mówienia.%SPEECH_OFF%Pogromca bierze łuk od jednego ze strażników ciemiężyciela. Zakłada strzałę. Alp unosi wzrok, a jego paszcza rozkwita rzędami brzytwowych zębów. Pogromca strzela prosto w paszczę, zabijając go natychmiast. Oddaje łuk i rozwija swoją kartę czeladniczą.%SPEECH_ON%To zapłata, która mi się należy. Dodatkowa za uratowanie twojej duszy i umysłu przed wiecznym żniwem alpa. Wezmę też jego skórę. Zgoda?%SPEECH_OFF%Ciemiężyciel pośpiesznie kiwa głową.%SPEECH_ON%Tak, tak, oczywiście!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Podzielisz się tym z kompanią.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Beastslayer.getImagePath());
				local money = 25;
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Koron"
				});
				local item = this.new("scripts/items/misc/parched_skin_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
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

		if (this.World.getTime().Days < 30)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad || currentTile.Type == this.Const.World.TerrainType.Snow)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_beastslayer = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.beast_slayer")
			{
				candidates_beastslayer.push(bro);
			}
		}

		if (candidates_beastslayer.len() != 0)
		{
			this.m.Beastslayer = candidates_beastslayer[this.Math.rand(0, candidates_beastslayer.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"beastslayer",
			this.m.Beastslayer ? this.m.Beastslayer.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Beastslayer = null;
	}

});

