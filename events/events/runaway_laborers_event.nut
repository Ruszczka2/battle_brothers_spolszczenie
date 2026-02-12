this.runaway_laborers_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.runaway_laborers";
		this.m.Title = "Na drodze...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_59.png[/img]Gdy idziesz drogą, obok ciebie pędzi tłum obdartych mężczyzn. Zbiegają z traktu i skaczą w nasyp, kryjąc się za ścianą krzaków.\n\nGdy krzaki wciąż się kołyszą, pojawia się druga grupa mężczyzn. Zanim pierwszy z nich zdąży się odezwać, już wiesz, o co chodzi. Najwyraźniej kilku robotników uzgodniło wspólnie porzucenie projektu z powodu tego, co goniący nadzorcy nazywają po prostu \"problemami\". Pytają, czy widziałeś tych niegodziwców.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Są tam, o!",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Nie widzieliśmy tu nikogo.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);

						if (this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
						{
							return this.Math.rand(1, 100) <= 70 ? "C" : "D";
						}
						else
						{
							return this.Math.rand(1, 100) <= 70 ? "E" : "D";
						}
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_59.png[/img]Nadzorcy kiwają głowami i dobywają pałek, wideł, a nawet kilku sieci. Zbiegają z drogi i wpadają w krzaki jak banda raiderów na wóz. To dzika, choć jednostronna walka. Ludzie są okładani jak ryby w krzakach. Nawet wysoko na zboczu słychać wyraźne łupanie drewna o czaszki. Widzisz jednego mężczyznę śmiertelnie ugodzonego włócznią, być może rozstrzygnięcie bardziej osobistego konfliktu. Gdy walka się kończy, główny nadzorca wraca do ciebie, a za nim idzie szereg jeńców wyglądających na mocno poturbowanych. Wręcza ci sakiewkę monet, klepie po ramieniu i dziękuje za utrzymanie \"porządku\".",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Łatwe korony.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
				this.World.Assets.addMoney(50);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]50[/color] koron"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_59.png[/img]Gdy twój palec wciąż wskazuje złą stronę, nadzorcy ruszają w drogę. Ich gniewne szczekanie cichnie w oddali. Gdy znikają, robotnicy powoli wychodzą z kryjówki. Wyglądają na dość zdziwionych, że najemnik nie sprzedał informacji o nich w krzakach. Jeden po drugim zdejmują czapki i błogosławią cię za okazaną litość. Jeden nazywa to nawet \"sprawiedliwością\", słowem dziwnym dla ucha najemnika.\n\nGdy większość odchodzi, jeden mężczyzna pozostaje z tyłu. Pyta, czy może dołączyć do kompanii, jeśli, no wiesz, masz dla niego miejsce.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Witaj w %companyname%!",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				},
				{
					Text = "To nie miejsce dla ciebie.",
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
				_event.m.Dude.setStartValuesEx(this.Const.CharacterLaborerBackgrounds);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_59.png[/img]Wszyscy nadzorcy ruszają w złym kierunku - poza jednym. Staje przy drodze, spoglądając w dół nasypu. Przez chwilę rozważasz, by chłodnym ostrzem przeciąć mu gardło i wydobyć słowa z tchawicy, a nie z ust. Mężczyzna szybko odwraca się do swoich towarzyszy, krzyczy i wskazuje zbocze. Czując, że zostali zauważeni, robotnicy wyskakują z krzaków i biegną we wszystkich kierunkach. Muszą być niedożywieni, bo większość porusza się z prędkością szkieletu wspinającego się po schodach.\n\nNastępująca walka jest dość makabryczna i zupełnie niepotrzebna, a nadzorcy są w swoim pojmaniu wyjątkowo surowi. Gdy wszystko się kończy, odchodzą równie szybko, jak przyszli, a robotnicy są już związani linami i mają worki na głowach. Zanim odejdzie, główny nadzorca rzuca ci pogardliwe słowo. Powoli wysuwasz ostrze z pochwy i pytasz, czy ma coś jeszcze do dodania. Pluje i kręci głową.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To znikaj mi z oczu!",
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
			ID = "E",
			Text = "[img]gfx/ui/events/event_59.png[/img]Gdy twój palec wciąż wskazuje złą stronę, nadzorcy ruszają w drogę. Ich gniewne szczekanie cichnie w oddali. Gdy znikają, robotnicy powoli wychodzą z kryjówki. Wyglądają na dość zdziwionych, że najemnik nie sprzedał informacji o nich w krzakach. Jeden po drugim zdejmują czapki i błogosławią cię za okazaną litość. Jeden nazywa to nawet \"sprawiedliwością\", słowem dziwnym dla ucha najemnika.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Żegnajcie.",
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
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		this.m.Score = 7;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

