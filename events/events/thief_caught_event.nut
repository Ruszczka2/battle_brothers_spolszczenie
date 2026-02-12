this.thief_caught_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.thief_caught";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]Podczas krótkiego odpoczynku twoi ludzie złapali mężczyznę, który próbował zwiać z częścią zapasów. Jego ubrania to same łachmany, a on wygląda bardziej na szkielet niż człowieka. Co z nim zrobisz?",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Daj temu biedakowi trochę jedzenia i wody.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Daj mu porządną nauczkę.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Poślij go pod miecz.",
					function getResult( _event )
					{
						return "F";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_33.png[/img]Pod osłoną nocy jakiś złodziej zdołał ukraść część zapasów. Pewnie zaoferuje ci je z powrotem w następnym osiedlu...",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Przeklęci złodzieje!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local r = this.Math.rand(1, 4);

				if (r == 1)
				{
					local food = this.World.Assets.getFoodItems();
					food = food[this.Math.rand(0, food.len() - 1)];
					this.World.Assets.getStash().remove(food);
					this.List = [
						{
							id = 10,
							icon = "ui/items/" + food.getIcon(),
							text = "Tracisz " + food.getName()
						}
					];
				}
				else if (r == 2)
				{
					local amount = this.Math.rand(20, 50);
					this.World.Assets.addAmmo(-amount);
					this.List = [
						{
							id = 10,
							icon = "ui/icons/asset_ammo.png",
							text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] amunicji"
						}
					];
				}
				else if (r == 3)
				{
					local amount = this.Math.rand(5, 10);
					this.World.Assets.addArmorParts(-amount);
					this.List = [
						{
							id = 10,
							icon = "ui/icons/asset_supplies.png",
							text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] narzędzi i zapasów"
						}
					];
				}
				else if (r == 4)
				{
					local amount = this.Math.rand(5, 10);
					this.World.Assets.addMedicine(-amount);
					this.List = [
						{
							id = 10,
							icon = "ui/icons/asset_medicine.png",
							text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] zapasów medycznych"
						}
					];
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_33.png[/img]%randombrother% daje złodziejowi porządną lanie krótką laską. Kij uderza wyjątkowo mocno, a ty słyszysz dźwięk ciosów przechodzących przez niemal pusty tułów mężczyzny. Wiotczeje, obraca się i próbuje uciec, ale najemnik uparcie wymierza karę. Gdy wszystko się kończy, zostawiasz pobitego człowieka, szlochającego i ściskającego ziemię w swoich wątłych palcach.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Niech to będzie dla ciebie nauczką!",
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
			ID = "D",
			Text = "[img]gfx/ui/events/event_33.png[/img]Współczując słabemu człowiekowi, postanawiasz dać mu trochę wody i jedzenia. Niemal wyrywa ci posiłek i wciska w niego wygłodniałą twarz. Złodziej dziękuje ci między każdym kęsem.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie każdy będzie tak pobłażliwy...",
					function getResult( _event )
					{
						if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax() || this.Math.rand(1, 100) <= 25)
						{
							return 0;
						}
						else
						{
							return "E";
						}
					}

				}
			],
			function start( _event )
			{
				local food = this.World.Assets.getFoodItems();
				food = food[this.Math.rand(0, food.len() - 1)];
				food.setAmount(this.Math.maxf(0.0, food.getAmount() - 5.0));
				this.List = [
					{
						id = 10,
						icon = "ui/items/" + food.getIcon(),
						text = "Tracisz trochę " + food.getName()
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_33.png[/img]Mówisz ludziom, by wrócili do marszu. Złodziej wyciera usta i wstaje, chwiejąc się na słabych nogach, gdy robi kilka kroków za tobą. Pyta, czy mógłby dołączyć do kompanii. Odda za ciebie życie, jeśli będzie trzeba, byle już nie musieć kraść.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze, możesz do nas dołączyć.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				},
				{
					Text = "Potrzebujemy wojowników, nie niedożywionych złodziei.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx(this.Const.CharacterThiefBackgrounds);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_33.png[/img]Gdy złodziej kulczy się ze strachu, dobywasz miecza. Błaga o litość, a jego odbite oblicze faluje na zbroczu i krawędziach ostrza. Unosisz broń. Mężczyzna krzyczy, że będzie dla ciebie pracował, że zrobi to za darmo, cokolwiek, byle ocalić życie. Wahasz się, a miecz wciąż wisi w powietrzu.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wreszcie umrzyj z odrobiną godności.",
					function getResult( _event )
					{
						return "G";
					}

				},
				{
					Text = "Dobrze. Daruję ci życie, jeśli będziesz dla mnie pracował.",
					function getResult( _event )
					{
						return "H";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_33.png[/img]%SPEECH_ON%Kara za kradzież to śmierć.%SPEECH_OFF%Wbijasz miecz, przerywając ostatnie słowa złodzieja szybkim pchnięciem w pierś. Zastyga, niemy, poza drapaniem cienkich rąk chwytających to, co go zabija, po czym osuwa się, martwy w jednej chwili. Wyciągasz broń i czyścisz ją w zgięciu łokcia. Głowa martwego mężczyzny opada na bok, a pod nim cicho zbiera się krew.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tak będzie lepiej.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.refugee" || bro.getBackground().getID() == "background.beggar")
					{
						if (bro.getSkills().hasSkill("trait.bloodthirsty"))
						{
							continue;
						}

						bro.worsenMood(1.0, "Współczuł złodziejowi zabitemu przez ciebie");

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
			ID = "H",
			Text = "[img]gfx/ui/events/event_05.png[/img]Opuszczasz broń, a mężczyzna podpełza i obejmuje ci nogi. Całuje cię po stopach, aż się odsuwasz.\n\nŻeby sprawę wyjaśnić, dajesz mu długą listę rozkazów i zasad pracy w kompanii. Dajesz mu też kontrakt, który podpisuje koślawym \'x\'. Kilku braci spędza potem resztę dnia, ucząc go podstaw i przedstawiając reszcie kompanii. Pod koniec nocy wygląda na to, że już zaczyna pasować. Następnego ranka budzisz się i widzisz, że brakuje sporej ilości zapasów, a nowego człowieka nigdzie nie ma. Wygląda na to, że choć darowałeś złodziejowi egzekucję, i tak ukradł rzeczy. Niech to będzie dla ciebie nauczką.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ten przeklęty łajdak!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local r = this.Math.rand(1, 4);

				if (r == 1)
				{
					local food = this.World.Assets.getFoodItems();
					food = food[this.Math.rand(0, food.len() - 1)];
					this.World.Assets.getStash().remove(food);
					this.List = [
						{
							id = 10,
							icon = "ui/items/" + food.getIcon(),
							text = "Tracisz " + food.getName()
						}
					];
				}
				else if (r == 2)
				{
					local amount = this.Math.rand(20, 50);
					this.World.Assets.addAmmo(-amount);
					this.List = [
						{
							id = 10,
							icon = "ui/icons/asset_ammo.png",
							text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] amunicji"
						}
					];
				}
				else if (r == 3)
				{
					local amount = this.Math.rand(5, 10);
					this.World.Assets.addArmorParts(-amount);
					this.List = [
						{
							id = 10,
							icon = "ui/icons/asset_supplies.png",
							text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] narzędzi i zapasów"
						}
					];
				}
				else if (r == 4)
				{
					local amount = this.Math.rand(5, 10);
					this.World.Assets.addMedicine(-amount);
					this.List = [
						{
							id = 10,
							icon = "ui/icons/asset_medicine.png",
							text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] zapasów medycznych"
						}
					];
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getFood() < 25 || this.World.Assets.getMedicine() < 10 || this.World.Assets.getArmorParts() < 10 || this.World.Assets.getAmmo() <= 50)
		{
			return;
		}

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 10)
			{
				nearTown = true;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		this.m.Score = this.isSomethingToSee() && this.World.getTime().Days >= 7 ? 50 : 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		if (!this.isSomethingToSee() && this.Math.rand(1, 100) <= 75)
		{
			return "A";
		}
		else
		{
			return "B";
		}
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

