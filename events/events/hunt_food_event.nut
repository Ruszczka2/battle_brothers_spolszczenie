this.hunt_food_event <- this.inherit("scripts/events/event", {
	m = {
		Hunter = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.hunt_food";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 7.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_10.png[/img]{Gdy pomagasz %otherguy% wyciągnąć buta z błota, %hunter% wychodzi z krzaków z czymś, co musi być prawie tuzinem powiązanych królików. Odkłada je i zaczyna rozwiązywać. Te małe króliczki, z szeroko otwartymi oczami, przerażone w obliczu końca, wyglądają całkiem smakowicie. Łowca chwyta jednego za kark i skręca jego ciało w kółko, po czym jednym ruchem wypycha z niego wszystkie wnętrzności. Powtarza ten proces, aż każdy królik zostaje ubity. Gdy wyciera rękę o płaszcz %otherguy%, wskazuje na stertę oprawionych królików u swoich stóp.%SPEECH_ON%To jest stos do jedzenia.%SPEECH_OFF%Potem wskazuje na kupę króliczych wnętrzności.%SPEECH_ON%A to nie jest stos do jedzenia. Jasne? Dobrze.%SPEECH_OFF%  | %hunter% pobiegł naprzód kilka godzin temu i właśnie go doganiasz. Stoi z nogą opartą na martwym jeleniu, którego pierś przebiła pojedyncza strzała. Gdy się zbliżasz, uśmiecha się i schodzi z tuszy. Mówi, że jeśli kilku braci pomoże go zawiesić, on go oskóruje i przygotuje. | Leśne ptaki świergoczą i gwarzą ponad marszem kompanii. Słońce mruga między gałęziami korony, miękki blask rozsiewa na ziemi kropki światła. Dostrzegasz wiewiórkę odpoczywającą w jednym z promieni, delektującą się ciepłem, gdy gryzie żołądź. Zatrzymuje się, czując, że ją obserwujesz, po czym nagle szarpie się, a kropla jej krwi ląduje na twoim policzku. Wycierasz ją, odwracając się, by zobaczyć, że wiewiórka została przebita strzałą, a każdy kolejny śmiertelny pisk jest cichszy od poprzedniego, gdy jej życie powoli przygasa. %hunter% nagle wyłania się z krzaków z łukiem w dłoni i uśmiechem na twarzy. Łowca zabiera swój łup i dorzuca go do sterty innych, na długiej myśliwskiej lince, do której przywiązane są wszelkie stworzenia, wrogowie i przyjaciele.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobra wyżerka.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Hunter.getImagePath());
				local food = this.new("scripts/items/supplies/cured_venison_item");
				this.World.Assets.getStash().add(food);
				this.List = [
					{
						id = 10,
						icon = "ui/items/" + food.getIcon(),
						text = "Zyskujesz Dziczyznę"
					}
				];
				_event.m.Hunter.improveMood(0.5, "Has hunted successfully");

				if (_event.m.Hunter.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Hunter.getMoodState()],
						text = _event.m.Hunter.getName() + this.Const.MoodStateEvent[_event.m.Hunter.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.hunter" || bro.getBackground().getID() == "background.poacher" || bro.getBackground().getID() == "background.beast_slayer" || bro.getBackground().getID() == "background.barbarian")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Hunter = candidates[this.Math.rand(0, candidates.len() - 1)];

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Hunter.getID())
			{
				this.m.OtherGuy = bro;
				this.m.Score = candidates.len() * 10;
				break;
			}
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hunter",
			this.m.Hunter.getName()
		]);
		_vars.push([
			"otherguy",
			this.m.OtherGuy.getName()
		]);
	}

	function onClear()
	{
		this.m.Hunter = null;
		this.m.OtherGuy = null;
	}

});

