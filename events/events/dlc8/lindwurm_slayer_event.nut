this.lindwurm_slayer_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.crisis.lindwurm_slayer";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_35.png[/img]{Popijasz trunek w jednej z przytulnych karczm %townname%. Oczywiscie ten komfort nie trwa dlugo, bo do srodka wchodzi mezczyzna, a jego zbroja brzeczy i klekocze. Popelniasz blad, spogladajac na niego i lapiesz jego wzrok. Natychmiast podchodzi. Wzdychasz, kladziesz druga dlon na mieczu i czekasz, co z tego bedzie. Mezczyzna dochodzi do konca twojego stolu i prostuje sie.%SPEECH_ON%Pozwol, ze sie przedstawie, jesli pogloski i legendy jeszcze tego nie zrobily. Jestem %dragonslayer%. Moim powolaniem jest polowanie na smoki i ich zabijanie.%SPEECH_OFF%Upijasz i odstawiasz kubek, mowiac mu, ze smoki nie istnieja. Usmiecha sie.%SPEECH_ON%To dlatego, ze moj ojciec je wszystkie zabil. Prawda jest taka, ze jestem zabojca lindwurmow i slyszalem, ze jestes kapitanem %companyname%, formacji o pewnej slawie, niemal tak wielkiej jak moja. Co powiesz na polaczenie naszych umiejetnosci i talentow, hm? Bylbym gotow dolaczyc za %price% koron.%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Dobrze, zaplace twoje %price% koron.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Nie, dzieki, poradzimy sobie.",
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
				_event.m.Dude.setStartValuesEx([
					"lindwurm_slayer_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "{%name% is a supposedly famous monster hunter with a particular talent for slaying lindwurms. He says he is the son of Dirk the Dragonslayer, the monster hunter who ostensibly slew the last living dragon.}";
				_event.m.Dude.getBackground().buildDescription(true);

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).removeSelf();
				}

				_event.m.Dude.getItems().equip(this.new("scripts/items/weapons/fighting_spear"));
				_event.m.Dude.getItems().equip(this.new("scripts/items/shields/buckler_shield"));
				_event.m.Dude.getItems().equip(this.new("scripts/items/helmets/heavy_mail_coif"));
				_event.m.Dude.getItems().equip(this.new("scripts/items/armor/named/lindwurm_armor"));
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_35.png[/img]{Ty i Swietobiorcy idziecie ulicami %townname%, gdy nagle pojawia sie mezczyzna w blyszczacej zbroi godnej Swietobiorcy. Idzie prosto ku tobie i mimo ze kompani polowicznie dobywaja broni w ramach ostrzezenia, mezczyzna idzie dalej i wyciaga reke.%SPEECH_ON%Witaj! Jestem %dragonslayer%, syn najbardziej znanego pogromcy smokow w calej krainie.%SPEECH_OFF%Twoi ludzie chowaja bron, a wszyscy sie rozgladaja. Sciskasz mu dlon i pytasz, czego chce. Robi krok w tyl, prostuje sie jak do prezentacji i przechwala sie swoimi czynami: ze zabil potwory wszelkich rozmiarow, i kobiety wszelkich rozmiarow, i ze ma szczegolne upodobanie do zabijania smokow, a takze do wiekszych dziewek, bo przypominaja mu- przerywasz mu, mowiac, ze smoki juz nie istnieja. Kiwal glowa.%SPEECH_ON%Zgadza sie! Smoki juz nie istnieja, bo moj ojciec zabil ostatniego. Powiem szczerze, jestem pogromca lindwurmow i jestem w tym calkiem dobry. Szukalem was, Swietobiorcow, ze wzgledu na slawe i uznanie, ktore zdobyliscie, i oczywiscie dlatego, ze chce byc tego czescia.%SPEECH_OFF%Ten rzekomo slawny pogromca lindwurmow oferuje dolaczenie do %companyname% za darmo.",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Dobrze, dolacz do nas.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Nie, dzieki, poradzimy sobie.",
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
				_event.m.Dude.setStartValuesEx([
					"lindwurm_slayer_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "{%name% is a supposedly famous monster hunter with a particular talent for slaying lindwurms. He says he is the son of Dirk the Dragonslayer, the monster hunter who ostensibly slew the last living dragon.}";
				_event.m.Dude.getBackground().buildDescription(true);

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).removeSelf();
				}

				_event.m.Dude.getItems().equip(this.new("scripts/items/weapons/fighting_spear"));
				_event.m.Dude.getItems().equip(this.new("scripts/items/shields/buckler_shield"));
				_event.m.Dude.getItems().equip(this.new("scripts/items/helmets/heavy_mail_coif"));
				_event.m.Dude.getItems().equip(this.new("scripts/items/armor/named/lindwurm_armor"));
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_35.png[/img]{Siegasz do kieszeni i kladziesz sakiewke na stole. Mezczyzna bierze ja i przebiera monety. Kiwal glowa i zaciska sznurek.%SPEECH_ON%Bardzo dobrze. Masz moje uslugi, kapitanie %companyname%, i na dobre imie mojego ojca nie pozalujesz.%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Witamy w kompanii!",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				this.World.Assets.addMoney(-5000);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]5000[/color] Koron"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_35.png[/img]{Ten mezczyzna albo udowodni, ze zasluguje na swoje chwalebne czyny, albo skonczy jako padlina. Skoro chce dolaczyc bez zadnych kosztow z gory, co szkodzi sprawdzic, jak sobie radzi? Wyciagasz reke, a mezczyzna ja sciska. Jego zbroja brzeczy i klekocze, gdy jego ramie unosi sie i opada.%SPEECH_ON%Twoi Swietobiorcy nie beda rozczarowani, moge to obiecac.%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Witaj w kompanii, %dragonslayer%.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 2000)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		if (this.World.Assets.getMoney() < 6000 && this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
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
		this.m.Score = 7;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"dragonslayer",
			this.m.Dude.getNameOnly()
		]);
		_vars.push([
			"price",
			"5000"
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		if (this.World.Assets.getOrigin().getID() == "scenario.paladins")
		{
			return "B";
		}

		return "A";
	}

	function onClear()
	{
		this.m.Dude = null;
		this.m.Town = null;
	}

});

