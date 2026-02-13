this.collector_wants_trophy_event <- this.inherit("scripts/events/event", {
	m = {
		Peddler = null,
		Reward = 0,
		Item = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.collector_wants_trophy";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_01.png[/img]{Podczas przeglądania targu miasta podchodzi do ciebie mężczyzna w jedwabiu. Ma uśmiech bardziej błyszczący niż szczery, a każdy palec ozdobiony tak, by się mienił. | Kiedy oglądasz towary na miejscowym targu, podchodzi dziwny mężczyzna. U biodra zwisają mu fiolki z dziwnymi płynami, a większość zębów zastępuje dziwne drewno. | Nie ma prawdziwej wizyty na targu bez jakiegoś dziwaka, który cię zaczepi. Tym razem to mężczyzna o wielkiej twarzy, ustach jak pułapka na niedźwiedzie z poszarpanych zębów i policzkach osadzonych wysoko, jakby miały być półkami. Poza wyglądem kręci się jak ktoś wpływowy i bogaty.}%SPEECH_ON%{Ach, najemniku, widzę, że masz ciekawe trofea. Co powiesz, żebym wziął to %trophy% za, powiedzmy, %reward% koron? | To interesujące trofeum, %trophy%. Dam ci za nie %reward% koron, gotówka do ręki, łatwa kasa! | Hmm, widzę, żeś awanturniczego sortu. Nie zdobyłbyś %trophy% bez odrobiny sprytu. Mam trochę złota i dam ci %reward% za ten drobiazg.}%SPEECH_OFF%Rozważasz ofertę mężczyzny.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zgoda.",
					function getResult( _event )
					{
						if (_event.m.Peddler != null)
						{
							return "Peddler";
						}
						else
						{
							this.World.Assets.addMoney(_event.m.Reward);
							local stash = this.World.Assets.getStash().getItems();

							foreach( i, item in stash )
							{
								if (item != null && item.getID() == _event.m.Item.getID())
								{
									stash[i] = null;
									break;
								}
							}

							return 0;
						}
					}

				},
				{
					Text = "Nie ma mowy.",
					function getResult( _event )
					{
						if (_event.m.Peddler != null)
						{
							return "Peddler";
						}
						else
						{
							return 0;
						}
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Peddler",
			Text = "[img]gfx/ui/events/event_01.png[/img]{%peddler% podchodzi i odpycha cię, jakbyś był przypadkowym klientem, a nie kapitanem kompanii. Krzyczy do kupca i unosi dłoń, a kupiec odpowiada, i brzmi to jak dwa psy szczekające na siebie, wszystko tak szybko i z tyloma liczbami, że mogłoby to być innym językiem. Po chwili handlarz wraca.%SPEECH_ON%Dobra. Teraz oferuje %reward% koron. Idę obejrzeć garnki i patelnie, powodzenia.%SPEECH_OFF%Klepie cię po ramieniu i odchodzi.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zgoda.",
					function getResult( _event )
					{
						this.World.Assets.addMoney(_event.m.Reward);
						local stash = this.World.Assets.getStash().getItems();

						foreach( i, item in stash )
						{
							if (item != null && item.getID() == _event.m.Item.getID())
							{
								stash[i] = null;
								break;
							}
						}

						return 0;
					}

				},
				{
					Text = "Nie ma mowy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Peddler.getImagePath());
				_event.m.Reward = this.Math.floor(_event.m.Reward * 1.33);
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
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

		local stash = this.World.Assets.getStash().getItems();
		local candidates_items = [];

		foreach( item in stash )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Crafting) && item.getValue() >= 400)
			{
				candidates_items.push(item);
			}
		}

		if (candidates_items.len() == 0)
		{
			return;
		}

		this.m.Item = candidates_items[this.Math.rand(0, candidates_items.len() - 1)];
		this.m.Reward = this.m.Item.getValue();
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates_peddler = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.peddler")
			{
				candidates_peddler.push(bro);
			}
		}

		if (candidates_peddler.len() != 0)
		{
			this.m.Peddler = candidates_peddler[this.Math.rand(0, candidates_peddler.len() - 1)];
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
			"peddler",
			this.m.Peddler != null ? this.m.Peddler.getName() : ""
		]);
		_vars.push([
			"reward",
			this.m.Reward
		]);
		_vars.push([
			"trophy",
			this.m.Item.getName()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Peddler = null;
		this.m.Reward = 0;
		this.m.Item = null;
		this.m.Town = null;
	}

});

