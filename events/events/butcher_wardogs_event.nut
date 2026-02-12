this.butcher_wardogs_event <- this.inherit("scripts/events/event", {
	m = {
		Butcher = null
	},
	function create()
	{
		this.m.ID = "event.butcher_wardogs";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_27.png[/img]Otwierasz skrzynię z jedzeniem i znajdujesz ostatnie zapasy. Jabłko turla się po dnie, wydając dźwięk podobny do burczenia pustego żołądka. Kilka bochenków chleba towarzyszy mu, a obok leży kawałek mięsa owinięty w gruby liść. To wszystko.\n\nGdy zamykasz wieko i się odwracasz, stoi tam %butcher% rzeźnik.%SPEECH_ON%No hej, szefie. Widzę, że mamy problem. Może ja go... rozwiążę?%SPEECH_OFF%Wskazuje kciukiem za siebie, w kierunku dwóch psów bojowych przywiązanych do palika.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zrób, co konieczne.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Nie pozwolę, by nasze wierne psy zostały zarżnięte i zjedzone.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Butcher.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_14.png[/img]Psy siedzą dość grzecznie, dyszą i wyglądają na zadowolone - ich poczucie szczęścia jest trwałe. Ale masz gęby do wykarmienia i bitwy do stoczenia. Dajesz %butcher% zgodę, by zrobił to, co słuszne dla kompanii.\n\nRzeźnik podchodzi do kundli, wyciągając jedną rękę, by je pogłaskać, a drugą trzymając za plecami nóż. Nie zostajesz, by patrzeć, co stanie się dalej, ale krótki skowyt, po którym szybko następuje drugi, przewraca twój i tak pusty żołądek.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Przynajmniej ludzie nie będą dziś głodni.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Butcher.getImagePath());
				local numWardogsToSlaughter = 2;
				local stash = this.World.Assets.getStash().getItems();

				foreach( i, item in stash )
				{
					if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
					{
						numWardogsToSlaughter = --numWardogsToSlaughter;
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Tracisz " + item.getName()
						});

						if (numWardogsToSlaughter == 0)
						{
							break;
						}
					}
				}

				if (numWardogsToSlaughter != 0)
				{
					local brothers = this.World.getPlayerRoster().getAll();

					foreach( bro in brothers )
					{
						local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

						if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
						{
							numWardogsToSlaughter = --numWardogsToSlaughter;
							bro.getItems().unequip(item);
							this.List.push({
								id = 10,
								icon = "ui/items/" + item.getIcon(),
								text = "Tracisz " + item.getName()
							});

							if (numWardogsToSlaughter == 0)
							{
								break;
							}
						}
					}
				}

				local item = this.new("scripts/items/supplies/strange_meat_item");
				this.World.Assets.getStash().add(item);
				item = this.new("scripts/items/supplies/strange_meat_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_27.png[/img]Kręcisz głową.%SPEECH_ON%Absolutnie nie. Są częścią kompanii jak każdy człowiek, a niektórzy woleliby głodować, niż jeść swoich.%SPEECH_OFF%Rzeźnik wzrusza ramionami.%SPEECH_ON%To tylko psy, panie. Kundelki. Mieszańce. To nic więcej jak bestia, która zna swoje imię i niewiele poza tym. Gdy będziemy potrzebować, znajdziemy więcej szczeniąt.%SPEECH_OFF%Znowu kręcisz głową.%SPEECH_ON%Nie zabijemy psów, %butcher%. I nie myśl, że nie widzę błysku w twoim oku. W zarzynaniu tych zwierząt chodzi o coś więcej niż tylko o nakarmienie kilku gąb.%SPEECH_OFF%%butcher% tylko wzrusza ramionami.%SPEECH_ON%Nie mogę wybierać, co sprawia mi przyjemność, panie, ale wykonam rozkazy.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Znajdziemy coś innego.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Butcher.getImagePath());
				_event.m.Butcher.worsenMood(1.0, "Odmówiono mu prośby");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Butcher.getMoodState()],
					text = _event.m.Butcher.getName() + this.Const.MoodStateEvent[_event.m.Butcher.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getFood() > 25)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local numWardogs = 0;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.butcher")
			{
				candidates.push(bro);
			}

			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
			{
				numWardogs = ++numWardogs;
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		if (numWardogs < 2)
		{
			local stash = this.World.Assets.getStash().getItems();

			foreach( item in stash )
			{
				if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
				{
					numWardogs = ++numWardogs;

					if (numWardogs >= 2)
					{
						break;
					}
				}
			}
		}

		if (numWardogs < 2)
		{
			return;
		}

		this.m.Butcher = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"butcher",
			this.m.Butcher.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Butcher = null;
	}

});

