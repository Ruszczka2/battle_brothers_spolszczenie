this.no_food_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.no_food";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_52.png[/img]{Zapasy żywności się skończyły! Mimo okropności tego świata, %companyname% nie może wystawić kompanii szkieletów! Musisz szybko zdobyć jedzenie, zanim słusznie odejdą. | Nawet najbardziej lojalny człowiek wytrzyma tylko jakieś pięć czy sześć opuszczonych posiłków. Potem każdy woli odejść i się najeść. Zdobądź jedzenie - i to szybko, zanim kompania się rozpadnie! | Źle obliczyłeś zapasy i wpakowałeś %companyname% w wyjątkowe niebezpieczeństwo - głód. Nawet najgroźniejsza kompania rozpadłaby się po kilku dniach bez jedzenia, a ta nie będzie inna, jeśli szybko czegoś nie zrobisz!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Muszę zdobyć dla ludzi coś do jedzenia.",
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
		if (this.World.Assets.getFood() > 0)
		{
			return;
		}

		this.m.Score = 150;
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

