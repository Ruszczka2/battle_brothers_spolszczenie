this.holywar_outro_south_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.holywar_outro_south";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_84.png[/img]{Pamiętasz, że wyznawcy Gildera byli kiedyś zjednoczeni w dążeniu do zrównania starych bogów. Mylne przekonanie, że jeśli wystarczająco zadowolą swego Boga, ten skieruje swoje potężne oko na wszystkich wrogów wiernych i ich unicestwi. Zamiast tego Gilded odkrywają, że ich determinacja została wystawiona na ciężką próbę: przegrali świętą wojnę. Miasta i osady spłonęły, święte totemy zostały zbezczeszczone, a święte miejsca splądrowane.\n\n Tłumy ludzi bezwładnie kręcą się po ulicach, od czasu do czasu zawodząc, nie z powodu celu, lecz jakby utracili język, by wyrazić ból, który muszą teraz znosić. Niekiedy ciało spada z góry, albo widzisz strażników wyciągających zwłoki ze studni, tylko po to, by jakiś obserwator sam się do niej rzucił. Niektórzy kładą się plackiem przed złotymi relikwiami, pozwalając, by słońce gotowało ich w odbitym blasku, pogrążeni w żałobie pełzają pod skwierczącymi refleksami, aż ich skóra zamienia się w strup, a gardła dławią się własnym ciałem, i gdy słońce przychodzi i odchodzi, ciała leżą w śladzie jego spojrzenia. Jeśli chodzi o %companyname%, opowiedziałeś się po jednej ze stron, i niezależnie od zwycięzców lub przegranych, dorobiłeś się małej fortuny. Na przyszłość nie musisz nawet życzyć sobie takiej okazji ponownie: jeśli jest jedna rzecz, którą wiesz o człowieku wiary, to ta, że porażka jest tylko jednym uderzeniem w hartowane żelazo. Po tym, co osiągnąłeś, być może teraz jest dobry czas, by odłożyć miecz i cieszyć się koronami?\n\n%OOC%Wygrałeś! Battle Brothers zaprojektowano z myślą o powtarzalności i kampaniach, które gra się do momentu pokonania jednego lub dwóch kryzysów późnej gry. Rozpoczęcie nowej kampanii pozwoli ci spróbować innych rzeczy w innym świecie.\n\nMożesz też kontynuować kampanię tak długo, jak chcesz. Pamiętaj jednak, że kampanie nie są zaprojektowane tak, by trwać wiecznie, i w końcu prawdopodobnie zabraknie wyzwań.%OOC_OFF%}",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "%companyname% potrzebuje swojego dowódcy!",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "Czas zakończyć życie najemnika. (Zakończ kampanię)",
					function getResult( _event )
					{
						this.World.State.getMenuStack().pop(true);
						this.World.State.showGameFinishScreen(true);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Combat.abortAll();
				this.World.FactionManager.makeEveryoneFriendlyToPlayer();
				this.World.FactionManager.createAlliances();
				this.updateAchievement("CulturalMisunderstanding", 1, 1);

				if (this.World.Assets.isIronman())
				{
					this.updateAchievement("ManOfIron", 1, 1);
				}

				if (this.World.Assets.isIronman())
				{
					local defeated = this.getPersistentStat("CrisesDefeatedOnIronman");
					defeated = defeated | this.Const.World.GreaterEvilTypeBit.HolyWar;
					this.setPersistentStat("CrisesDefeatedOnIronman", defeated);

					if (defeated == this.Const.World.GreaterEvilTypeBit.All)
					{
						this.updateAchievement("Savior", 1, 1);
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_84.png[/img]{Wiara w Gildera została nagrodzona: święta wojna dobiegła końca, a południowcy stoją zwycięsko. Wezyr, radni i duchowieństwo pojawiają się na ulicach, każdy jadąc na wielkich wozach, które zamiast kół są niesione na plecach niewolników. Zwłaszcza niewolników z północy, zadłużonych u Gildera za swoje zbrodnie. Ledwo widzisz samych ludzi, tylko ich nogi czerniejące w cieniu, jakby ruszała procesja kołyszących się chrząszczy. Bogaci i rozrzutni mężczyźni biorą wielkie puchary i rozlewają coś, co wygląda jak złota woda, na wiwatujących wiernych. Sam nachylasz się pod jednym z tych plusków, ale okazuje się, że to tylko zabarwiona woda.\n\n Podczas gdy fałszywe bogactwa jedynie ugasiły twoje pragnienie, bardzo realna wojna między wyznawcami starych bogów a samymi Gilded napełniła skarbiec %companyname%. Jako Koronnik nigdy nie zaznasz szacunku odsłoniętych głów i pochylonych ciał, ani pokłonów chłopów, ani blasku złota zbyt ciężkiego, by unieść je samemu. Taka jest twoja rzeczywistość, ale nie powstrzyma to kompanii przed gotowością, gdy następnym razem pobożni zechcą pokłócić się o prawość. A może teraz jest dobry czas, by odłożyć miecz i cieszyć się koronami?\n\n%OOC%Wygrałeś! Battle Brothers zaprojektowano z myślą o powtarzalności i kampaniach, które gra się do momentu pokonania jednego lub dwóch kryzysów późnej gry. Rozpoczęcie nowej kampanii pozwoli ci spróbować innych rzeczy w innym świecie.\n\nMożesz też kontynuować kampanię tak długo, jak chcesz. Pamiętaj jednak, że kampanie nie są zaprojektowane tak, by trwać wiecznie, i w końcu prawdopodobnie zabraknie wyzwań.%OOC_OFF%}",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "%companyname% potrzebuje swojego dowódcy!",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "Czas zakończyć życie najemnika. (Zakończ kampanię)",
					function getResult( _event )
					{
						this.World.State.getMenuStack().pop(true);
						this.World.State.showGameFinishScreen(true);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Combat.abortAll();
				this.World.FactionManager.makeEveryoneFriendlyToPlayer();
				this.World.FactionManager.createAlliances();
				this.updateAchievement("CulturalMisunderstanding", 1, 1);

				if (this.World.Assets.isIronman())
				{
					this.updateAchievement("ManOfIron", 1, 1);
				}

				if (this.World.Assets.isIronman())
				{
					local defeated = this.getPersistentStat("CrisesDefeatedOnIronman");
					defeated = defeated | this.Const.World.GreaterEvilTypeBit.HolyWar;
					this.setPersistentStat("CrisesDefeatedOnIronman", defeated);

					if (defeated == this.Const.World.GreaterEvilTypeBit.All)
					{
						this.updateAchievement("Savior", 1, 1);
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.SquareCoords.Y > this.World.getMapSize().Y * 0.18)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.Contracts.getActiveContract() != null)
		{
			return;
		}

		if (this.World.Statistics.hasNews("crisis_holywar_end"))
		{
			this.m.Score = 6000;
		}
	}

	function onPrepare()
	{
		this.World.Statistics.popNews("crisis_holywar_end");
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		local north = 0;
		local south = 0;
		local sites = [
			"location.holy_site.oracle",
			"location.holy_site.meteorite",
			"location.holy_site.vulcano"
		];
		local locations = this.World.EntityManager.getLocations();

		foreach( v in locations )
		{
			foreach( i, s in sites )
			{
				if (v.getTypeID() == s && v.getFaction() != 0)
				{
					if (this.World.FactionManager.getFaction(v.getFaction()).getType() == this.Const.FactionType.NobleHouse)
					{
						north = ++north;
					}
					else
					{
						south = ++south;
					}
				}
			}
		}

		if (north >= south)
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
	}

});

