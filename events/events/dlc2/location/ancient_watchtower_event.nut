this.ancient_watchtower_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.ancient_watchtower";
		this.m.Title = "Gdy się zbliżasz...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_108.png[/img]{Iglica jest dwa razy wyższa niż jakikolwiek zamek, który widziałeś, i węższa niż jakakolwiek wieża. Jakby ktoś miał cały materiał na fortecę, a zamiast bastionu zbudował iglicę. %randombrother% mruży oczy, patrząc w górę.%SPEECH_ON%Jakby ciągnęła się bez końca, panie. Prawie aż do chmur.%SPEECH_OFF%Wchodzisz z mapą i kilkoma ludźmi. W środku znajdujesz szklaną kulę spoczywającą na wydrążonym pulpicie. W środku bańki są pylące szczątki. Być może ostatni ślad magii, nie wiesz. Twoja intuicja podpowiada, że ten, kto mieszkał w tej smukłej kryjówce, nie zawsze korzystał ze schodów. Ale ty musisz. Wspięcie się jest brutalne i długie. Na szczycie znajdujesz kolejną bańkę, tym razem poszarpaną i rozbitą, a pod szkłem szkielet. W pobliżu leży złamany kostur. Kręcisz głową i kierujesz się do blank. Widoki są tak odległe, że sam świat zdaje się zakrzywiać na horyzoncie, niewątpliwie dziwna sztuczka oka. Rysujesz geografię na mapie, odpoczywasz pięć minut, po czym schodzisz z powrotem na dół.\n\nGdy docierasz na dół, szkielet jest tam wraz ze swoim kosturem, a rozbita bańka spoczywa na pulpicie. Cała grupa ludzi wybiega przez drzwi, a ty pędzisz im po piętach. Oglądając się, widzisz, jak brama iglicy powoli się zamyka z potężnym metalicznym szczękiem.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cóż, przynajmniej mamy rozeznanie w terenie.",
					function getResult( _event )
					{
						local radius = 1900.0;
						this.World.uncoverFogOfWar(this.World.State.getPlayer().getPos(), radius);
						local entities = this.World.getAllEntitiesAtPos(this.World.State.getPlayer().getPos(), radius);

						foreach( entity in entities )
						{
							if (entity.isLocation() && entity.m.VisibilityMult > 0.0 && !entity.isDiscovered())
							{
								local location = entity.location;
								location.setDiscovered(true);
								location.onDiscovered();

								if (entity.isHiddenToPlayer() && location.getTypeID() != "location.battlefield")
								{
									this.World.Statistics.getFlags().increment("LocationsDiscovered");

									if (this.World.Retinue.hasFollower("follower.cartographer"))
									{
										this.World.Retinue.getFollower("follower.cartographer").onLocationDiscovered(location);
									}

									this.World.Ambitions.onLocationDiscovered(location);
								}
							}
						}

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
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
	}

});

