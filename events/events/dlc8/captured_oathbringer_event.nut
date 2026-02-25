this.captured_oathbringer_event <- this.inherit("scripts/events/event", {
	m = {
		Torturer = null
	},
	function create()
	{
		this.m.ID = "event.captured_oathbringer";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Jeden z ludzi wpada do twojego namiotu, krzycząc, że złapano kogoś, kto zakradał się do obozu. Pytasz, czy to złodziej. Mężczyzna kręci głową.%SPEECH_ON%Nie, gorzej. To Ślubodawca.%SPEECH_OFF%Skurczybyk. Zrywasz się na nogi i wybiegasz, znajdując intruza już związanego i bitego przez Świętobiorców. Przerywasz to i stajesz przed nim.%SPEECH_ON%Ślubodawco, gdzie jest szczęka Anselma?%SPEECH_OFF%Mężczyzna pluje ci na but i mówi, że nigdy jej nie odda, a Świętobiorcy mogą iść do piekła, gdzie ich miejsce, i że sam Anselm by ich tam zaprowadził, gdyby mógł. To bluźnierstwo w imię Młodego Anselma wywołuje westchnienia twoje i twoich ludzi. %randombrother% pochyla się.%SPEECH_ON%Daj tylko słowo, kapitanie, a pokażemy temu Ślubodawcy, jak bardzo się myli.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zabij go.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Torturuj go.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 80 ? "C" : "D";
					}

				},
				{
					Text = "Puszcz go.",
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
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Wyciągasz miecz i wbijasz go w serce mężczyzny.%SPEECH_ON%Anselm nie będzie na ciebie czekał w następnym życiu, heretyku.%SPEECH_OFF%Ciało mężczyzny opada na ostrze, oczy na chwilę szerokie, po czym gasną w półprzymkniętym spojrzeniu na ziemię. Wyciągasz miecz, a %companyname% wiwatuje.%SPEECH_ON%Śmierć wszystkim Ślubodawcom!%SPEECH_OFF%Świętobiorcy dobywają mieczy i wznoszą je ku niebu, gdy po kompanii przechodzi żarliwy zapał.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Sprawiedliwości stało się zadość.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local potential_loot = [
					"armor/adorned_mail_shirt",
					"helmets/heavy_mail_coif",
					"helmets/heavy_mail_coif"
				];
				local item = this.new("scripts/items/" + potential_loot[this.Math.rand(0, potential_loot.len() - 1)]);
				item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(10, 30) * 0.01));
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				this.World.Assets.getStash().add(item);
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.paladin" || !bro.getBackground().isOffendedByViolence() && this.Math.rand(1, 100) <= 75)
					{
						bro.improveMood(0.75, "Cieszy się, że zabiłeś heretyka Ślubodawcę");

						if (bro.getMoodState() > this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getBackground().isOffendedByViolence())
					{
						bro.worsenMood(0.5, "Nie spodobało mu się, że zabiłeś pojmanego z zimną krwią");

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
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Kiwasz głową.%SPEECH_ON%Torturuj go, aż jego język wskaże szczękę Młodego Anselma. Nie obchodzi mnie jak, po prostu to zrób.%SPEECH_OFF%Odwracając się, jeniec krzyczy, że Anselm by tego nie pochwalił. Potem zaczyna krzyczeć bez ładu i składu, aż w końcu wykrzykuje rzeczy, które nie mają większego sensu. Wracasz do namiotu, podrygując stopą w rytm krzyków, które teraz przybierają formę rytmicznego zawodzenia. W końcu %randombrother% wraca. Ma ze sobą broń i zbroję, o których wiesz, że nie było ich w ekwipunku.%SPEECH_ON%Zaprowadził nas do miejsca, gdzie to było ukryte, ale szczęka Anselma wciąż zaginiona. Obawiam się, że Ślubodawcy muszą ją mieć w swoim obozie, ale nie powiedział, gdzie to było. My, eee, mieliśmy pewne trudności z komunikacją po tym, jak wycięliśmy mu język.%SPEECH_OFF%Wzdychając, pytasz, gdzie jest jeniec. Mężczyzna odchrząkuje.%SPEECH_ON%No, zrobił się cały biały i się przewrócił. Nie żyje, panie.%SPEECH_OFF%Przynajmniej postąpiliśmy słusznie wobec Młodego Anselma.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jeszcze odnajdziemy szczękę.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local potential_loot = [
					"armor/adorned_warriors_armor",
					"helmets/adorned_closed_flat_top_with_mail",
					"helmets/adorned_closed_flat_top_with_mail"
				];
				local item = this.new("scripts/items/" + potential_loot[this.Math.rand(0, potential_loot.len() - 1)]);
				item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(10, 30) * 0.01));
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				this.World.Assets.getStash().add(item);
				potential_loot = [
					"weapons/arming_sword",
					"weapons/fighting_axe",
					"weapons/military_cleaver",
					"shields/heater_shield"
				];
				item = this.new("scripts/items/" + potential_loot[this.Math.rand(0, potential_loot.len() - 1)]);
				item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(10, 30) * 0.01));
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				this.World.Assets.getStash().add(item);
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.paladin" || !bro.getBackground().isOffendedByViolence() && this.Math.rand(1, 100) <= 75)
					{
						bro.improveMood(1.25, "Torturował heretyka Ślubodawcę");

						if (bro.getMoodState() > this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getBackground().isOffendedByViolence())
					{
						bro.worsenMood(0.75, "Jest przerażony, że kazałeś torturować pojmanego");

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
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Mówisz ludziom, by torturowali mężczyznę dla informacji. Jeśli jest coś, co każdy Ślubodawca wie, to gdzie znajduje się szczęka Młodego Anselma, a to jest coś, czego każdy Świętobiorca chce się dowiedzieć. Mężczyzna krzyczy, gdy go odciągają, a ty wracasz do namiotu, by zagłuszyć irytujące dźwięki wrzasków i płaczu, które psują ci nastrój. Chwilę później %torturer% wchodzi do namiotu z krwią na koszuli. Chce coś powiedzieć, po czym pada na ziemię. Inny Świętobiorca wchodzi i mówi, że jeniec uciekł, dźgając oprawcę nożem przed ucieczką. Każesz ludziom pomóc %torturer%, zanim się wykrwawi.%SPEECH_ON%Ci przeklęci Ślubodawcy nie mają honoru! Znajdziemy go i zabijemy, tak rzecze Młody Anselm, tak rzeczemy my wszyscy!%SPEECH_OFF%Mówisz to ze ściśniętymi zębami, teatralnym tonem. Prawda jest taka, że drań uciekł, a Ślubodawców trudno złapać, takie z nich szczury. Pozostaje mieć nadzieję, że %torturer% przeżyje.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cholerne Ślubodawcze scum.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Torturer.addHeavyInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Torturer.getName() + " odnosi poważne rany"
				});
				local injury = _event.m.Torturer.addInjury([
					{
						ID = "injury.cut_throat",
						Threshold = 0.0,
						Script = "injury/cut_throat_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Torturer.getName() + " odnosi " + injury.getNameOnly()
				});
				_event.m.Torturer.worsenMood(0.5, "Pozwolił uciec pojmanemu Ślubodawcy");
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Ten człowiek nie ma nic wartościowego. Mówisz ludziom, by go uwolnili. Protestują, twierdząc, że Ślubodawca ma tylko jeden wybór: podporządkować się Świętobiorcom i prawdziwej Ostatecznej Ścieżce albo umrzeć. Jest też miejsce dla tego, kto zwróci szczękę Młodego Anselma, ale zasady postępowania z takim Ślubodawcą wciąż nie zostały ustalone. Ale jeśli chodzi o tego człowieka, nie ma z niego pożytku, a ty nie masz ochoty na rozlew krwi. Gdy powtarzasz, by go uwolnili, %randombrother% podrzyna mu gardło, wywołując wiwaty pozostałych.%SPEECH_ON%Powiedziałeś, by go przeciąć, prawda, kapitanie? Prawda?%SPEECH_OFF%Zrozumiałeś, że Świętobiorca kryje ciebie, a dalsze zaprzeczanie, że Ślubodawca musiał zginąć, mogłoby postawić cię w niezręcznej sytuacji. Kiwasz głową.%SPEECH_ON%Tak, oczywiście, ten mały szczur musiał zginąć, jak wszyscy Ślubodawcy bez ścieżki! I wszyscy oni zginą!%SPEECH_OFF%Ludzie znów ryczą, choć masz przeczucie, że kilku zapamięta twoją niedorzeczną propozycję, by puścić Ślubodawcę wolno.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Powinienem uważać na to, co mówię.",
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
					if (bro.getBackground().getID() == "background.paladin" || this.Math.rand(1, 100) <= 75)
					{
						bro.worsenMood(0.75, "Prawie wypuściłeś pojmanego Ślubodawcę");

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
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		if (this.World.getTime().Days < 35)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local torturer_candidates = [];
		local haveSkull = false;

		foreach( bro in brothers )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && item.getID() == "accessory.oathtaker_skull_02")
			{
				haveSkull = true;
			}

			if (bro.getBackground().getID() == "background.paladin")
			{
				torturer_candidates.push(bro);
			}
		}

		if (!haveSkull)
		{
			local stash = this.World.Assets.getStash().getItems();

			foreach( item in stash )
			{
				if (item != null && item.getID() == "accessory.oathtaker_skull_02")
				{
					haveSkull = true;
					break;
				}
			}
		}

		if (haveSkull)
		{
			return;
		}

		if (torturer_candidates.len() == 0)
		{
			torturer_candidates.push(brothers[this.Math.rand(0, brothers.len() - 1)]);
		}

		this.m.Torturer = torturer_candidates[this.Math.rand(0, torturer_candidates.len() - 1)];
		this.m.Score = 7;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"torturer",
			this.m.Torturer.getName()
		]);
	}

	function onClear()
	{
		this.m.Torturer = null;
	}

});

