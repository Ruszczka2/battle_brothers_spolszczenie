this.renown_tutorial_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.renown_tutorial";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_82.png[/img]Gdy kompania robi krótki postój, siadasz, by obejrzeć ranę po strzale, który niedawno przebił ci bok. Gojenie idzie powoli i wciąż boli, gdy poruszasz się zbyt szybko, ale sytuacja się poprawia. %bro1% siada obok, korzystając z okazji, by porozmawiać z kapitanem.%SPEECH_ON%Jak ja to widzę, nikt jeszcze nie zna %companyname%. Nie chcemy wiecznie ścigać po lasach byle jakich band zbójów, ale najpierw musimy wyrobić sobie nazwę jako rzetelne miecze do wynajęcia, które potrafią doprowadzać sprawy do końca, zanim zauważą nas rody szlacheckie. Wtedy będą chcieli wykorzystywać kompanię do o wiele lepiej płatnych zleceń, jestem pewien.%SPEECH_OFF%Poprawia pas z bronią i kontynuuje.%SPEECH_ON%Pamiętajmy też, że wielcy panowie grają w niebezpieczną grę i nie chcemy wejść im w drogę. Jest dość historii o ludziach, którzy im podpadli, a skończyli poćwiartowani i nakarmieni świniom, a oni mają środki, by zmiażdżyć nawet kompanię najemników.%SPEECH_OFF%Na chwilę milknie, po czym dodaje jeszcze jedną myśl.%SPEECH_ON%Mistrzowie cechów i rajcy rządzący wioskami oraz miastami też mają dobrą pamięć. Na razie polegamy na nich, by zatrudniali kompanię, ale posiadanie wpływowych przyjaciół może też pomóc nam w uzyskaniu lepszych układów z kupcami.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Będę o tym pamiętać.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local bro = this.World.getPlayerRoster().getAll()[0];
				this.Characters.push(bro.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Contracts.getContractsFinished() < 2)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.tutorial")
		{
			return;
		}

		this.m.Score = 5000;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"bro1",
			this.World.getPlayerRoster().getAll()[0].getName()
		]);
	}

	function onClear()
	{
	}

});

