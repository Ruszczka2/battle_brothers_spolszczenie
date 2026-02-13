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
			Text = "[img]gfx/ui/events/event_97.png[/img]{Natrafiasz na grupe dzieciakow siedzacych w domku na drzewie. Z oczodolow wygladaja spojrzenia, a wokol drewnianego bastionu widzisz przygotowane proce. Gdy oceniasz fort, podciagaja drabine linowa i kaza ci spadac. Ciekawy, zastanawiasz sie, co takiego wartosciowego moga miec, skoro tak przesadnie reaguja na grupe mezczyzn, ktora niemal na pewno by ich zniszczyla.\n\nPoniewaz dzieci latwo uginaja sie pod presja, pytasz, czy cos ukrywaja. Jeden wykonuje gest onanizowania i kaze ci spadac, a inny wali go w ramie i kaze mu sie zamknac. To nie sa odpowiedzi dzieciakow chowajacych slodycze czy ciastka. Na pewno maja tam cos cennego.}",
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
						Text = "Swietobiorcy!",
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
			Text = "[img]gfx/ui/events/event_97.png[/img]{Rozkazujesz %companyname% szturmowac fort. Nie mogac wspiac sie na drzewo pod gradem kamieni i proc, kazesz ludziom zbudowac drabiny i przerzucic liny. Dzieci krzycza i zrzucaja kije i kamienie, sprawiajac bol, ktorego nie da sie zignorowac, ale nie tak wielki jak ich obelgi, okropne slowa w rodzaju ptasich obserwatorow i swinskich kutasow, te male gnojki. Kilku udaje sie przecinac liny, gdy ludzie sie wspinaja, co prowadzi do kolejnych ran. Ale w koncu najemnicy wyganiaja dzieci, zrzucajac je z drzewa z wielkim zapalem. Nie jestes zaskoczony, twoja intuicja byla calkowicie trafna: dzieci schowaly kilka sztuk uzbrojenia i gromadzily je w forcie. Zabierasz rzeczy i kazesz spalic fort oraz drzewo, na ktorym stoi.}",
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
			Text = "[img]gfx/ui/events/event_97.png[/img]{Wskazujesz dwoma palcami i rozkazujesz ludziom szturmowac fort na drzewie. Dzieci odpowiadaja procami i kamieniami. Udajac, ze kamienie nie bola jak diabli, kazesz dzieciakom sie poddac. W odpowiedzi nazywaja cie nieudolnym glupcem i bezmyslnym intrygantem. Te slowa bola prawie tak bardzo jak kamienie.\n\nNagle fort dostaje posilki, bo z galezi sasiedniego drzewa do walki dolacza kolejne dzieci, te dranie wdzieraja sie jak korsarze na statek. Caly szturm idzie do piekla w wielu koszach, a kilku ludzi narzeka, ze to zbyt irytujace przedsiewziecie, by je kontynuowac. Zastanawiasz sie, czy nie chodzi im tylko o dume. Wzdychasz i rozkazujesz przerwac szturm. Dzieci smieja sie i szydza z ciebie, ale tak to jest.%SPEECH_ON%Pewnie i tak nic tam nie mieli. Nie warto zachodu.%SPEECH_OFF%Mowi jeden z ludzi. Nie zgadzasz sie, ale nie ma sensu nad tym rozpamietywac. Dzieci zbieraja sie w kurzy chor i wydaja gdaczace dzwieki, gdy odchodzicie.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Moglo pojsc lepiej.",
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
			Text = "[img]gfx/ui/events/event_183.png[/img]{Bierzesz czaszke Anselma i unosisz ja. Donosnym glosem opowiadasz o probach i triumfach Mlodego Anselma, pierwotnego Swietobiorcy. Dzieci sa zachwycone, spogladaja na siebie, gdy raczysz je opowiesciami o odwadze i honorze. W koncu dzieci wyciagaja dosc wystawna bron.%SPEECH_ON%Znalezlismy to w stawie.%SPEECH_OFF%Inne dziecko popycha drugie.%SPEECH_ON%Nie, to bylo w kamieniu! Pamietasz, to ja to wyciagnalem!%SPEECH_OFF%Dzieci sprzeczaja sie przez chwile, ale w koncu mala dziewczynka bierze bron i wyrzuca ja przez okno fortu na drzewie. Ostrze wbija sie w ziemie, a stal drzy, gdy wygina sie wte i wewte. Dziewczynka prycha.%SPEECH_ON%Moze lepiej, zeby ktos inny to wzial, bo oni tylko sie o to kloca!%SPEECH_OFF%Chwytasz rekojesc miecza, a jego stalowy spiew cichnie. Wyciagasz go z ziemi i dziekujesz dzieciom za ich wklad w misje Swietobiorcow. Dzieci spogladaja na siebie. Jedno pyta drugie.%SPEECH_ON%Czy mamy teraz jakis cel?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wracajmy na droge.",
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

