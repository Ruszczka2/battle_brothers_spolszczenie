this.sellsword_retires_event <- this.inherit("scripts/events/event", {
	m = {
		Peddler = null
	},
	function create()
	{
		this.m.ID = "event.sellsword_retires";
		this.m.Title = "Wzdłuż drogi...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]{Idąc drogą, natrafiasz na człowieka siedzącego na poboczu. Ma na sobie poobijaną zbroję, a na kolanach jeszcze bardziej poobijaną broń. Spogląda na ciebie z najsłabszym możliwym machnięciem.%SPEECH_ON%Dobry wieczór. Jak wy nie najemnicy, to ja nigdy nie podpaliłem gaci starego.%SPEECH_OFF%To brzmi jak ciekawa historia sama w sobie, ale pytasz człowieka, co robi pośrodku drogi. Co ważniejsze, pytasz tego dość sprawnego faceta, czy szuka pracy.%SPEECH_ON%Pracy? Nie. Nie potrzebuję jej. Już swoje najemnicze odwaliłem i koniec. Wiesz co, trzymaj.%SPEECH_OFF%Zaczyna odpinać zbroję i rzuca ją przed ciebie.%SPEECH_ON%Weź. Nie potrzebuję już tego życia. Weź też broń. Zostawiam to całe gówno za sobą. Ty też powinieneś, ale wiem, że nie zrobisz tego. Przynajmniej nie zanim będzie za późno. Będę chodził po świecie, aż stopy zetrą mi się na kikutki. A tobie, powodzenia.%SPEECH_OFF%A potem, po prostu, nieznajomy odchodzi.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Powodzenia.",
					function getResult( _event )
					{
						if (_event.m.Peddler != null)
						{
							return "B";
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
				local item;
				local stash = this.World.Assets.getStash();
				item = this.new("scripts/items/weapons/arming_sword");
				item.setCondition(item.getConditionMax() / 2 - 1);
				stash.add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/armor/basic_mail_shirt");
				item.setArmor(item.getArmorMax() / 2 - 1);
				stash.add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_64.png[/img]{%peddler% handlarz, zawsze mający nosa do złota, pyta, czy człowiek zarobił jakieś korony, pracując jako najemnik. Gdy nieznajomy przytakuje, handlarz zauważa, że jeśli to prawda, to zawsze może sobie \'kupić\' drogę powrotną do tego życia. Najemnik myśli chwilę, po czym znów przytakuje.%SPEECH_ON%Wiesz co? Masz rację. Dopóki mam korony, mam też linę ratunkową do tego cholernego fachu. Trzymaj, weź to.%SPEECH_OFF%Odchodzący na emeryturę, a najwyraźniej przyszły pustelnik, sięga do kieszeni i z radością rzuca ci worek koron, jak człowiek pozbywający się starego ciężaru.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze to wykorzystamy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Peddler.getImagePath());
				local money = this.Math.rand(20, 100);
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] koron"
					}
				];
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.Assets.getStash().getNumberOfEmptySlots() < 2)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.peddler")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() != 0)
		{
			this.m.Peddler = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"peddler",
			this.m.Peddler != null ? this.m.Peddler.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Peddler = null;
	}

});

