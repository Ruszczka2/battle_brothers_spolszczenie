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
			Text = "[img]gfx/ui/events/event_35.png[/img]{Popijasz trunek w jednej z przytulnych karczm %townname%. Oczywiście ten komfort nie trwa długo, bo do środka wchodzi mężczyzna, a jego zbroja brzęczy i klekocze. Popełniasz błąd, spoglądając na niego i łapiesz jego wzrok. Natychmiast podchodzi. Wzdychasz, kładziesz drugą dłoń na mieczu i czekasz, co z tego będzie. Mężczyzna dochodzi do końca twojego stołu i prostuje się.%SPEECH_ON%Pozwól, że się przedstawię, jeśli pogłoski i legendy jeszcze tego nie zrobiły. Jestem %dragonslayer%. Moim powołaniem jest polowanie na smoki i ich zabijanie.%SPEECH_OFF%Upijasz i odstawiasz kubek, mówiąc mu, że smoki nie istnieją. Uśmiecha się.%SPEECH_ON%To dlatego, że mój ojciec je wszystkie zabił. Prawda jest taka, że jestem zabójcą lindwurmów i słyszałem, że jesteś kapitanem %companyname%, formacji o pewnej sławie, niemal tak wielkiej jak moja. Co powiesz na połączenie naszych umiejętności i talentów, hm? Byłbym gotów dołączyć za %price% koron.%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Dobrze, zapłacę twoje %price% koron.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Nie, dzięki, poradzimy sobie.",
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
			Text = "[img]gfx/ui/events/event_35.png[/img]{Ty i Świętobiorcy idziecie ulicami %townname%, gdy nagle pojawia się mężczyzna w błyszczącej zbroi godnej Świętobiorcy. Idzie prosto ku tobie i mimo że kompani połowicznie dobywają broni w ramach ostrzeżenia, mężczyzna idzie dalej i wyciąga rękę.%SPEECH_ON%Witaj! Jestem %dragonslayer%, syn najbardziej znanego pogromcy smoków w całej krainie.%SPEECH_OFF%Twoi ludzie chowają broń, a wszyscy się rozglądają. Ściskasz mu dłoń i pytasz, czego chce. Robi krok w tył, prostuje się jak do prezentacji i przechwala się swoimi czynami: że zabił potwory wszelkich rozmiarów, i kobiety wszelkich rozmiarów, i że ma szczególne upodobanie do zabijania smoków, a także do większych dziewek, bo przypominają mu- przerywasz mu, mówiąc, że smoki już nie istnieją. Kiwał głową.%SPEECH_ON%Zgadza się! Smoki już nie istnieją, bo mój ojciec zabił ostatniego. Powiem szczerze, jestem pogromcą lindwurmów i jestem w tym całkiem dobry. Szukałem was, Świętobiorców, ze względu na sławę i uznanie, które zdobyliście, i oczywiście dlatego, że chcę być tego częścią.%SPEECH_OFF%Ten rzekomo sławny pogromca lindwurmów oferuje dołączenie do %companyname% za darmo.",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Dobrze, dołącz do nas.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Nie, dzięki, poradzimy sobie.",
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
			Text = "[img]gfx/ui/events/event_35.png[/img]{Sięgasz do kieszeni i kładziesz sakiewkę na stole. Mężczyzna bierze ją i przebiera monety. Kiwał głową i zaciska sznurek.%SPEECH_ON%Bardzo dobrze. Masz moje usługi, kapitanie %companyname%, i na dobre imię mojego ojca nie pożałujesz.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_35.png[/img]{Ten mężczyzna albo udowodni, że zasługuje na swoje chwalebne czyny, albo skończy jako padlina. Skoro chce dołączyć bez żadnych kosztów z góry, co szkodzi sprawdzić, jak sobie radzi? Wyciągasz rękę, a mężczyzna ją ściska. Jego zbroja brzęczy i klekocze, gdy jego ramię unosi się i opada.%SPEECH_ON%Twoi Świętobiorcy nie będą rozczarowani, mogę to obiecać.%SPEECH_OFF%}",
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

