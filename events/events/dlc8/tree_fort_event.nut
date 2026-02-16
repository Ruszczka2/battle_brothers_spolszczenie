this.tree_fort_event <- this.inherit("scripts/events/event", {
	m = {
		Witchhunter = null
	},
	function create()
	{
		this.m.ID = "event.tree_fort";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Natrafiasz na grupę dzieciaków siedzących w domku na drzewie. Z oczodołów wyglądają spojrzenia, a wokół drewnianego bastionu widzisz przygotowane proce. Gdy oceniasz fort, podciągają drabinę linową i każą ci spadać. Ciekawy, zastanawiasz się, co takiego wartościowego mogą mieć, skoro tak przesadnie reagują na grupę mężczyzn, która niemal na pewno by ich zniszczyła.\n\nPonieważ dzieci łatwo uginają się pod presją, pytasz, czy coś ukrywają. Jeden wykonuje gest onanizowania i każe ci spadać, a inny wali go w ramię i każe mu się zamknąć. To nie są odpowiedzi dzieciaków chowających słodycze czy ciastka. Na pewno mają tam coś cennego.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Szturm na fort!",
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
					Text = "Nie mamy na to czasu.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (this.World.Assets.getOrigin().getID() == "scenario.paladins")
				{
					this.Options.push({
						Text = "Świętobiorcy!",
						function getResult( _event )
						{
							return "D";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Rozkazujesz %companyname% szturmować fort. Nie mogąc wspiąć się na drzewo pod gradem kamieni i proc, każesz ludziom zbudować drabiny i przerzucić liny. Dzieci krzyczą i zrzucają kije i kamienie, sprawiając ból, którego nie da się zignorować, ale nie tak wielki jak ich obelgi, okropne słowa w rodzaju ptasich obserwatorów i świńskich kutasów, te małe gnojki. Kilku udaje się przecinać liny, gdy ludzie się wspinają, co prowadzi do kolejnych ran. Ale w końcu najemnicy wyganiają dzieci, zrzucając je z drzewa z wielkim zapałem. Nie jesteś zaskoczony, twoja intuicja była całkowicie trafna: dzieci schowały kilka sztuk uzbrojenia i gromadziły je w forcie. Zabierasz rzeczy i każesz spalić fort oraz drzewo, na którym stoi.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cholerne dzieciaki.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local weapons = [
					"weapons/military_pick",
					"weapons/morning_star",
					"weapons/hand_axe",
					"weapons/reinforced_wooden_flail",
					"weapons/scramasax"
				];
				local item = this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]);
				item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(10, 40) * 0.01));
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				item = this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]);
				item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(10, 40) * 0.01));
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				item = this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]);
				item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(10, 40) * 0.01));
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 25)
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
			ID = "C",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Wskazujesz dwoma palcami i rozkazujesz ludziom szturmować fort na drzewie. Dzieci odpowiadają procami i kamieniami. Udając, że kamienie nie bolą jak diabli, każesz dzieciakom się poddać. W odpowiedzi nazywają cię nieudolnym głupcem i bezmyślnym intrygantem. Te słowa bolą prawie tak bardzo jak kamienie.\n\nNagle fort dostaje posiłki, bo z gałęzi sąsiedniego drzewa do walki dołączają kolejne dzieci, te dranie wdzierają się jak korsarze na statek. Cały szturm idzie do piekła w wielu koszach, a kilku ludzi narzeka, że to zbyt irytujące przedsięwzięcie, by je kontynuować. Zastanawiasz się, czy nie chodzi im tylko o dumę. Wzdychasz i rozkazujesz przerwać szturm. Dzieci śmieją się i szydzą z ciebie, ale tak to jest.%SPEECH_ON%Pewnie i tak nic tam nie mieli. Nie warto zachodu.%SPEECH_OFF%Mówi jeden z ludzi. Nie zgadzasz się, ale nie ma sensu nad tym rozpamiętywać. Dzieci zbierają się w kurzy chór i wydają gdaczące dźwięki, gdy odchodzicie.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mogło pójść lepiej.",
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
					if (this.Math.rand(1, 100) <= 25)
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							local injury = bro.addInjury(this.Const.Injury.Brawl);
							this.List.push({
								id = 10,
								icon = injury.getIcon(),
								text = bro.getName() + " doznaje " + injury.getNameOnly()
							});
						}
						else
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
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_183.png[/img]{Bierzesz czaszkę Anselma i unosisz ją. Donośnym głosem opowiadasz o próbach i triumfach Młodego Anselma, pierwotnego Świętobiorcy. Dzieci są zachwycone, spoglądają na siebie, gdy raczysz je opowieściami o odwadze i honorze. W końcu dzieci wyciągają dość wystawną broń.%SPEECH_ON%Znaleźliśmy to w stawie.%SPEECH_OFF%Inne dziecko popycha drugie.%SPEECH_ON%Nie, to było w kamieniu! Pamiętasz, to ja to wyciągnąłem!%SPEECH_OFF%Dzieci sprzeczają się przez chwilę, ale w końcu mała dziewczynka bierze broń i wyrzuca ją przez okno fortu na drzewie. Ostrze wbija się w ziemię, a stal drży, gdy wygina się wte i wewte. Dziewczynka prycha.%SPEECH_ON%Może lepiej, żeby ktoś inny to wziął, bo oni tylko się o to kłócą!%SPEECH_OFF%Chwytasz rękojeść miecza, a jego stalowy śpiew cichnie. Wyciągasz go z ziemi i dziękujesz dzieciom za ich wkład w misję Świętobiorców. Dzieci spoglądają na siebie. Jedno pyta drugie.%SPEECH_ON%Czy mamy teraz jakiś cel?%SPEECH_OFF%}",
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
				local item = this.new("scripts/items/weapons/noble_sword");
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
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local currentTile = this.World.State.getPlayer().getTile();
		local foundTown = false;

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern() || t.getSize() > 2)
			{
				continue;
			}

			if (t.getTile().getDistanceTo(currentTile) <= 5)
			{
				foundTown = true;
				break;
			}
		}

		if (!foundTown)
		{
			return;
		}

		if (currentTile.HasRoad)
		{
			return;
		}

		this.m.Score = this.World.getTime().Days <= 25 ? 10 : 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

