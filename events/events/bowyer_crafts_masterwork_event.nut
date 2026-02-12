this.bowyer_crafts_masterwork_event <- this.inherit("scripts/events/event", {
	m = {
		Bowyer = null,
		OtherGuy1 = null,
		OtherGuy2 = null
	},
	function create()
	{
		this.m.ID = "event.bowyer_crafts_masterwork";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%bowyer% łukmistrz przychodzi do ciebie z prośbą: chce zbudować broń na wieki. Najwyraźniej od lat próbuje stworzyć łuk o legendarnych właściwościach, ale teraz, będąc w drodze, podłapał kilka rzeczy, które uzupełniły luki w jego wiedzy. Naprawdę wierzy, że tym razem zrobi to dobrze. Potrzebuje tylko kilku zasobów, by zdobyć elementy niezbędne do konstrukcji. Pokornie prosi o 500 koron oraz o dobre drewno, które ze sobą nosisz.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zbuduj mi legendarny łuk!",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 60 ? "B" : "C";
					}

				},
				{
					Text = "Nie mamy na to czasu.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bowyer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Łuk nie jest całkiem legendarny, ale jest bardzo dobry. Dobrze leży w dłoni, łatwo obraca się na boki, a w ruchu świszcze powietrze. Sprawdzasz naciąg. Na pewno trzeba do tego silnego człowieka. Gdy wypuszczasz strzałę, drzewce leci niewiarygodnie prosto, a strzał niemal sam się naprowadza. Genialna broń, jeśli kiedykolwiek taką widziałeś! | Łuk powstał z mieszanki gatunków drewna, których nazw nie znasz. Barwy tego i tamtego drzewa spiralnie oplatają łuk, tworząc drzewny damast. Sprawdzając naciąg, cięciwa okazuje się potężna. Nie jesteś strzelcem, ale gdy wypuszczasz strzałę, wydaje się ona sama prowadzić do celu. Wspaniała broń, jeśli nie z innego powodu, to dlatego, że sprawia, iż wyglądasz lepiej, niż jesteś w rzeczywistości. Gratulujesz łukmistrzowi.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Arcydzieło!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bowyer.getImagePath());
				this.World.Assets.addMoney(-500);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]500[/color] koron"
				});
				local stash = this.World.Assets.getStash().getItems();

				foreach( i, item in stash )
				{
					if (item != null && item.getID() == "misc.quality_wood")
					{
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Tracisz " + item.getName()
						});
						break;
					}
				}

				local item = this.new("scripts/items/weapons/masterwork_bow");
				item.m.Name = _event.m.Bowyer.getNameOnly() + "\'s " + item.m.Name;
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				_event.m.Bowyer.improveMood(2.0, "Stworzył arcydzieło");

				if (_event.m.Bowyer.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Bowyer.getMoodState()],
						text = _event.m.Bowyer.getName() + this.Const.MoodStateEvent[_event.m.Bowyer.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]Czy to dziki eksperyment? Drewno skrzypi i trzeszczy przy zginaniu, cięciwa strzępi się i sztywnieje przy każdym naciągu, a mógłbyś przysiąc, że widziałeś termita wystawiającego łebek z drzewca. Każda testowana strzała wariuje, leci to tu, to tam, byle nie tam, gdzie powinna.\n\nŁagodzisz ból łukmistrza, zrzucając winę na własną niecelność, ale %otherguy1% i %otherguy2% też próbują i wychodzi jeszcze gorzej. W końcu łukmistrz odchodzi, tuląc swój wyrób, po czym rzuca go na stos broni, gdzie chciałbyś, by wyglądał jak każdy inny łuk, ale jego ohydna brzydota sprawia, że odstaje jak żarzący się węgiel na stosie siana. Na pewno nikt przypadkiem nie sięgnie po to paskudztwo!",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Teraz rozumiem, czemu już nie pracujesz jako łukmistrz.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bowyer.getImagePath());
				this.World.Assets.addMoney(-500);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]500[/color] koron"
				});
				local stash = this.World.Assets.getStash().getItems();

				foreach( i, item in stash )
				{
					if (item != null && item.getID() == "misc.quality_wood")
					{
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Tracisz " + item.getName()
						});
						break;
					}
				}

				local item = this.new("scripts/items/weapons/wonky_bow");
				item.m.Name = _event.m.Bowyer.getNameOnly() + "\'s " + item.m.Name;
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				_event.m.Bowyer.worsenMood(1.0, "Nie udało się stworzyć arcydzieła");

				if (_event.m.Bowyer.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Bowyer.getMoodState()],
						text = _event.m.Bowyer.getName() + this.Const.MoodStateEvent[_event.m.Bowyer.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img]Mówisz łukmistrzowi, że %companyname% nie ma zasobów na zbyciu. Mężczyzna zgrzyta zębami i, cokolwiek miał powiedzieć, nie mówi nic, odwraca się na pięcie i odchodzi. Z oddali wreszcie słyszysz, jaką uprzejmość miał dla ciebie w zanadrzu - litanię przekleństw i złorzeczeń, a w końcu jęk rozczarowania.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Weź się w garść.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bowyer.getImagePath());
				_event.m.Bowyer.worsenMood(2.0, "Odmówiono mu prośby");

				if (_event.m.Bowyer.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Bowyer.getMoodState()],
						text = _event.m.Bowyer.getName() + this.Const.MoodStateEvent[_event.m.Bowyer.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() < 2000)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 6 && bro.getBackground().getID() == "background.bowyer")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local numWood = 0;

		foreach( item in stash )
		{
			if (item != null && item.getID() == "misc.quality_wood")
			{
				numWood = ++numWood;
				break;
			}
		}

		if (numWood == 0)
		{
			return;
		}

		this.m.Bowyer = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 4;
	}

	function onPrepare()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Bowyer.getID())
			{
				this.m.OtherGuy1 = bro;
				break;
			}
		}

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Bowyer.getID() && bro.getID() != this.m.OtherGuy1.getID())
			{
				this.m.OtherGuy2 = bro;
				break;
			}
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"bowyer",
			this.m.Bowyer.getNameOnly()
		]);
		_vars.push([
			"otherguy1",
			this.m.OtherGuy1.getName()
		]);
		_vars.push([
			"otherguy2",
			this.m.OtherGuy2.getName()
		]);
	}

	function onClear()
	{
		this.m.Bowyer = null;
		this.m.OtherGuy1 = null;
		this.m.OtherGuy2 = null;
	}

});

