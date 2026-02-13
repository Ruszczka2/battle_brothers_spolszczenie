this.incense_trade_event <- this.inherit("scripts/events/event", {
	m = {
		Dancer = null
	},
	function create()
	{
		this.m.ID = "event.incense_trade";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_143.png[/img]{Gdy torujesz droge przez sniezne pustkowia, na szose wychodzi dziwna postac. Widzisz sznury przywiazane do ramion, a wysoko nad nim leca czarne latawce, wirujace jakby uczynil z nich marionetki wlasnego pomyslu. Jego twarz wyglada na twarz czlowieka zdolnego do takiej rzeczy, skrzywiona obledem, wyszczerzona jak do zartu, z ktorego smieje sie od lat. Ciemna karnacja nie jest tu zwykla, a gdy mowi, zna twoj jezyk.%SPEECH_ON%Masz przy sobie dziwnosci, dziwnosci, ktore pieknie pachna. Co to jest, co? To nie mieso. To nie delikatne ludzkie mieso. To nie mieso ptakow, ani szczeniakow, co idą pod lod. To... czy to w ogole mieso? Ojej, to kadzidlo! Daj mi powachac tej slodkiej przyprawy, a dam ci cos w zamian. Tylko odrobina zapachu, tyle, nawet zaplace.%SPEECH_OFF%Kladziesz reke na mieczu.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Eee, dobra.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 66 ? "B" : "C";
					}

				},
				{
					Text = "Raczej nie.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Dancer != null)
				{
					this.Options.push({
						Text = "%bellydancer% tancerz brzucha, znasz tego czlowieka?",
						function getResult( _event )
						{
							return "D";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_143.png[/img]{Mowisz mu, ze moze powachac to, czego pragnie, o ile potem ci za to zaplaci. Zgadza sie i podchodzi do wozu, a jego dlugie latawce podazaja nad nim jak wieczne sępy, migoczac wsrod snieznej zawiei. Pochyla sie do wozu i wciaga zapach, a jego zimny, czerwony nos chrapie z kazdym oddechem. Dociera do slojow z kadzidlem i na jego twarzy pojawia sie usmiech.%SPEECH_ON%Ach tak. Nie czulem takiej wspanialosci od wielu, wielu lat.%SPEECH_OFF%Podnosi polę kurtki i z hukiem kladzie na burcie duza sakiewke monet. Liczysz je, widzac znacznie wiecej, niz dostalbys za sprzedaz tego kadzidla gdziekolwiek. Odwraca sie do ciebie, kadzidlo tulac w ramionach.%SPEECH_ON%Uczciwa umowa?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Czlowiek wie, co kocha.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local crowns = 0;
				local stash = this.World.Assets.getStash().getItems();
				local incense_lost = 3;

				foreach( i, item in stash )
				{
					if (item != null && item.getID() == "misc.incense")
					{
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Tracisz " + item.getName()
						});
						crowns = crowns + item.getValue() * 2;
						stash[i] = null;
						incense_lost--;

						if (incense_lost <= 0)
						{
							break;
						}
					}
				}

				this.World.Assets.addMoney(crowns);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + crowns + "[/color] Koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_143.png[/img]{Odsuwasz dlon od miecza i zgadzasz sie na sprytna, choc pozornie nieszkodliwa prosbe. Mowisz, ze moze powachac twoj woz, jesli zaplaci z gory. Mezczyzna kiwa glowa i daje kilka koron, po czym obchodzi woz od tylu. Wklada bulwiasty nos do srodka, prycha jak swinia ryjaca w ziemi.\n\nNagle chwyta kilka slojow kadzidla i zrywa pokrywki. Pyl i proszek rozlatuja sie, sniezne pustkowia na chwile staja sie barwne, a chichoczacy mezczyzna tanczy w obłoku. Chcesz go ogluszyc, ale rzuca na ciebie linki latawcow, petajac cie w ich druciane uchwyty, sam zas robiąc brawurowa ucieczke, rechoczac, gdy kadzidlo splywa z jego ramion jak zbłąkany wloczega przechodzacy przez niebieski południk. Wsciekly, rozcinajac te przeklete latawce, sprawdzasz straty.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Co do diabla.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local stash = this.World.Assets.getStash().getItems();
				local incense_lost = 3;

				foreach( i, item in stash )
				{
					if (item != null && item.getID() == "misc.incense")
					{
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Tracisz " + item.getName()
						});
						stash[i] = null;
						incense_lost--;

						if (incense_lost <= 0)
						{
							break;
						}
					}
				}

				this.World.Assets.addMoney(15);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]15[/color] Koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_143.png[/img]{%bellydancer% tancerz brzucha wychodzi naprzod, wpatruje sie w snieg i niespodziewanie zastanawia sie na glos, czy to jego ojciec. Szalony mezczyzna podchodzi, a jego czarne latawce podazaja za nim jak sępy na ogonie skazanca. Jego twarz rozjasnia sie i obaj sie obejmuja. Mezczyzna okazuje sie dawno zaginionym ojcem %bellydancer%, kupcem kadzidla, ktory poszedl daleko na polnoc, tylko po to, by zostac napadnietym i zniewolonym przez dzikich barbarzyncow, od ktorych teraz uciekl. Usmiecha sie obłednie.%SPEECH_ON%Tak dawno nie widzialem dobrego kadzidla, ze czulem wasz woz z wielu mil. Moja zona, twoja matka, %bellydancer%, jak sie trzyma?%SPEECH_OFF%Usmiech tancerza blednie. Mowi, ze wytrwala z nadzieja tak dlugo, jak mogla. Czlowiek z latawcami kiwa glowa, ponuro, ale i z oczekiwaniem. Mowi, ze nie byloby w porzadku, gdyby byla zona widmem tego, co kiedys bylo, a on sam, bez nadziei na powrot do domu, rowniez poszedl dalej. Mezczyzna wyciaga ozdobna bron z ostrzem niepodobnym do niczego, co kiedykolwiek widziales. Mowi, ze to długo przechowywana rodzinna relikwia i ze przez cale lata na polnocy trzymal ja zakopana i bezpieczna.%SPEECH_ON%Lepiej to wez i zrob z tego uzytek, zanim jeden z tych dzikusow mnie zje i uzyje tego jako wykałaczki.%SPEECH_OFF%Mezczyzna usmiecha sie czule, a obaj obejmuja sie przez chwile. Zaciekawiony pytasz, po co te latawce. Odpowiada, ze to narzedzia strachu, majace odstraszac niebezpieczne zwierzeta i podobne, w tym bardziej przesadnych barbarzyncow. Zegnasz mezczyzne i sugerujesz %bellydancer%, ze moze odejsc, jesli musi, ale ten kreci glowa.%SPEECH_ON%Syn i ojciec nie powinni dzielic pozlacanej sciezki, bo wiemy, ze spotkamy sie na jej koncu, jak spotkalismy sie na jej poczatku.%SPEECH_OFF%Mowi kilka slow do ojca w swoim jezyku, po czym obaj odchodza i na tym koniec.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cholera, to kadzidlo jest swietne.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dancer.getImagePath());
				local item = this.new("scripts/items/weapons/named/named_qatal_dagger");
				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_143.png[/img]{Kazesz mezczyznie odejsc albo inaczej. Robi, co kazesz, choc stoi z wyciagnietymi rekami, a palce bezradnie drapia powietrze za zapachem, ktory wylapal jego nos. Kilka razy ogladzasz sie za siebie, upewniajac sie, ze nie idzie za wami. Stoi na snieznym pustkowiu i wpatruje sie w twoj woz. Potem jest juz tylko czarnym punktem. Potem znika, a jego latawce tancza nad miejscem, w ktorym wiesz, ze stoi, a potem i one znikaja.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie da sie uciec od tych dziwakow.",
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
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local candidates_items = [];

		foreach( item in stash )
		{
			if (item != null && item.getID() == "misc.incense")
			{
				candidates_items.push(item);
			}
		}

		if (candidates_items.len() < 3)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Snow)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_dancer = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.belly_dancer")
			{
				candidates_dancer.push(bro);
			}
		}

		if (candidates_dancer.len() != 0)
		{
			this.m.Dancer = candidates_dancer[this.Math.rand(0, candidates_dancer.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"bellydancer",
			this.m.Dancer != null ? this.m.Dancer.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Dancer = null;
	}

});

