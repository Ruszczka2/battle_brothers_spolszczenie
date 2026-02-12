this.inadvertently_save_merchant_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null
	},
	function create()
	{
		this.m.ID = "event.inadvertently_save_merchant";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 130.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%townImage%Przechadzając się po %townname% z kilkoma najemnikami, skręcasz za róg i widzisz wystrojonego mężczyznę otoczonego przez złodziei i bandytów. Oglądają się przez ramię i szeroko otwierają oczy. Jeden rysuje kupca po policzku.%SPEECH_ON%Dobra, dopadniemy cię następnym razem, ty draniu!%SPEECH_OFF%Łotrzy szybko się ulatniają. Chwilę później pojawiają się ciężko uzbrojeni strażnicy kupca. Przytrzymując ranę, zaczyna na nich wrzeszczeć.%SPEECH_ON%Za co ja wam płacę, wy nędzne dranie? Wystarczy, że wpadnę w kłopoty i was nigdzie nie ma? Spójrzcie na tego człowieka, to jemu powinienem płacić! Hej, weź to za swoje kłopoty, nieznajomy.%SPEECH_OFF%Kupiec rzuca ci sakiewkę koron za twoje \"kłopoty\", choć jedyne co zrobiłeś, to skręciłeś za róg i trafiłeś na zbieg okoliczności.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "No dobrze.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(25);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]25[/color] koron"
				});
			}

		});
	}

	function onUpdateScore()
	{
		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getSize() <= 1 || t.isMilitary())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		this.m.Town = town;
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
	}

});

