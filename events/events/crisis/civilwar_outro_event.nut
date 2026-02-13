this.civilwar_outro_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_outro";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_96.png[/img]Siedzisz w swoim namiocie, gdy %dude% wchodzi. Mówi wprost.%SPEECH_ON%Szlachta gada. Tam stoi wielki, ozdobny namiot, siedzą w nim.%SPEECH_OFF%Odkładając pióro, odpowiadasz.%SPEECH_ON%Tylko gadają?%SPEECH_OFF%Najemnik wzrusza ramionami.%SPEECH_ON%Cisza. Więc albo gadają, albo się po cichu wyżynają.%SPEECH_OFF%Wstajesz i wychodzisz na zewnątrz. Uderza cię rześkie powietrze, niosące zapach przypraw i smaków. Patrząc pod wiatr, dostrzegasz namiot. Kucharze i kuchmistrze krzątają się z rozkazami i składnikami. Służba niesie półmiski mięsa, warzyw i owoców. W środku, w okazałym namiocie czarnym z złotym haftem, biesiaduje szlachta. Chorążowie stoją na zewnątrz. Nie biorą udziału w ucztach. Przeważnie grają w karty, od czasu do czasu spoglądając na siebie. Niektórzy mają bandaże poplamione krwią. Jeden stoi o kulach z zgarbionym, półzgiętym kolanem. Pytasz %dude%, co słychać. Kiwając głową wskazuje scenę.%SPEECH_ON%Cóż, zjechali tu godzinę temu, kiedy sprawdzałeś mapy. Nie chcieliśmy cię niepokoić, ale, no wiesz, wyglądali na zdecydowanych zostać.%SPEECH_OFF%Przyglądasz się namiotowi szlachty. Przez wejście widać słaby połysk koronowanych głów, krążących tam i z powrotem. %dude% spluwa i pyta.%SPEECH_ON%A jak myślisz, kto wygrał wojnę?%SPEECH_OFF%Chrząkasz, spluwasz i kręcisz głową.%SPEECH_ON%A kogo to obchodzi?%SPEECH_OFF%Jedyne, co się dla ciebie liczy, to że pokój oznacza mniej kontraktów. Może teraz to dobry czas, by odłożyć miecz i cieszyć się koronami? A może posłać do diabła cały ten sentymentalny bełkot i iść dalej, prowadząc kompanię ku jeszcze większym sprawom?\n\n%OOC%Wygrałeś! Battle Brothers jest zaprojektowane z myślą o regrywalności i kampaniach, które trwają do momentu pokonania jednego lub dwóch kryzysów późnej fazy gry. Rozpoczęcie nowej kampanii pozwoli ci spróbować różnych rzeczy w innym świecie.\n\nMożesz też kontynuować kampanię tak długo, jak chcesz. Pamiętaj tylko, że kampanie nie są pomyślane jako wieczne i z czasem prawdopodobnie zabraknie ci wyzwań.%OOC_OFF%",
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
					Text = "Czas przejść na emeryturę z życia najemnika. (Zakończ kampanię)",
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
				this.Characters.push(_event.m.Dude.getImagePath());
				this.World.Combat.abortAll();
				this.World.FactionManager.makeEveryoneFriendlyToPlayer();
				this.World.FactionManager.createAlliances();
				this.updateAchievement("Kingmaker", 1, 1);

				if (this.World.Assets.isIronman())
				{
					this.updateAchievement("ManOfIron", 1, 1);
				}

				if (this.World.Assets.isIronman())
				{
					local defeated = this.getPersistentStat("CrisesDefeatedOnIronman");
					defeated = defeated | this.Const.World.GreaterEvilTypeBit.CivilWar;
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
		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		if (this.World.Statistics.hasNews("crisis_civilwar_end"))
		{
			local brothers = this.World.getPlayerRoster().getAll();
			local most_days_with_company = -9000.0;
			local most_days_with_company_bro;

			foreach( bro in brothers )
			{
				if (bro.getDaysWithCompany() > most_days_with_company)
				{
					most_days_with_company = bro.getDaysWithCompany();
					most_days_with_company_bro = bro;
				}
			}

			this.m.Dude = most_days_with_company_bro;
			this.m.Score = 6000;
		}
	}

	function onPrepare()
	{
		this.World.Statistics.popNews("crisis_civilwar_end");
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"dude",
			this.m.Dude.getNameOnly()
		]);
		local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		_vars.push([
			"randomnoblehouse",
			nobles[this.Math.rand(0, nobles.len() - 1)].getName()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

