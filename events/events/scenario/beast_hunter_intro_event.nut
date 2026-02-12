this.beast_hunter_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.beast_hunters_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_124.png[/img]Spotkałeś się z mężczyzną w jego własnym domu. Zaproponował ci jadło, napitek i robotę. Zabij leśną wiedźmę, a dostaniesz należytą sumkę. Ruszyłeś wiec wraz ze swymi ludźmi i zrobiłeś, jak kazano, przynosząc na dowód łeb podłego babsztyla.\n\nJednak twój pracodawca tylko was wyśmiał. Powiedział, że to była wiedźma, która dała mu władzę, a wy uwolniliście go od długu, który wobec niej musiałby spłacić. I że przechytrzył też ciebie oraz twych głupich ludzi. Jego pachołkowie wyszli z cieni, w których się skrywali, od razu z mieczami w dłoniach. Zasadzka zaczęła się od arogancji przestępcy, a skończyła się, gdy jego odrąbana od reszty ciała głowa spadła na posadzkę. Niestety kosztowało to życie kilku twoich kompanów i ocalałeś tylko ty, %bs1%, %bs2%, oraz %bs3%.\n\n Potwory tego świata często kryją się poza zasięgiem wzroku: okrucieństwa człowieka ukrywają się za jego lojalnością, a horrory bestii za starymi legendami. Jako przywódca grupy pogromców bestii z biegiem czasu coraz wyraźniej przekonywałeś się, że nie da się już rozdzielić jednego od drugiego. Jeśli masz zarabiać na życie polując na potwory, to równie dobrze możesz zainkasować nieco więcej grosza dodając ludzi do swej listy.",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Najpodlejsze bestie to te, które uważają się za lepsze.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "Pogromcy Bestii";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		_vars.push([
			"bs1",
			brothers[0].getNameOnly()
		]);
		_vars.push([
			"bs2",
			brothers[1].getNameOnly()
		]);
		_vars.push([
			"bs3",
			brothers[2].getNameOnly()
		]);
	}

	function onClear()
	{
	}

});

