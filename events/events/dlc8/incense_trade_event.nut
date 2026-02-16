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
			Text = "[img]gfx/ui/events/event_143.png[/img]{Gdy torujesz drogę przez śnieżne pustkowia, na szosę wychodzi dziwna postać. Widzisz sznury przywiązane do ramion, a wysoko nad nim lecą czarne latawce, wirujące jakby uczynił z nich marionetki własnego pomysłu. Jego twarz wygląda na twarz człowieka zdolnego do takiej rzeczy, skrzywiona obłędem, wyszczerzona jak do żartu, z którego śmieje się od lat. Ciemna karnacja nie jest tu zwykła, a gdy mówi, zna twój język.%SPEECH_ON%Masz przy sobie dziwności, dziwności, które pięknie pachną. Co to jest, co? To nie mięso. To nie delikatne ludzkie mięso. To nie mięso ptaków, ani szczeniaków, co idą pod lód. To... czy to w ogóle mięso? Ojej, to kadzidło! Daj mi powąchać tej słodkiej przyprawy, a dam ci coś w zamian. Tylko odrobina zapachu, tyle, nawet zapłacę.%SPEECH_OFF%Kładziesz rękę na mieczu.",
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
						Text = "%bellydancer% tancerz brzucha, znasz tego człowieka?",
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
			Text = "[img]gfx/ui/events/event_143.png[/img]{Mówisz mu, że może powąchać to, czego pragnie, o ile potem ci za to zapłaci. Zgadza się i podchodzi do wozu, a jego długie latawce podążają nad nim jak wieczne sępy, migocząc wśród śnieżnej zawiei. Pochyla się do wozu i wciąga zapach, a jego zimny, czerwony nos chrapie z każdym oddechem. Dociera do słojów z kadzidłem i na jego twarzy pojawia się uśmiech.%SPEECH_ON%Ach tak. Nie czułem takiej wspaniałości od wielu, wielu lat.%SPEECH_OFF%Podnosi poły kurtki i z hukiem kładzie na burcie dużą sakiewkę monet. Liczysz je, widząc znacznie więcej, niż dostałbyś za sprzedaż tego kadzidła gdziekolwiek. Odwraca się do ciebie, kadzidło tuląc w ramionach.%SPEECH_ON%Uczciwa umowa?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Człowiek wie, co kocha.",
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
			Text = "[img]gfx/ui/events/event_143.png[/img]{Odsuwasz dłoń od miecza i zgadzasz się na sprytną, choć pozornie nieszkodliwą prośbę. Mówisz, że może powąchać twój wóz, jeśli zapłaci z góry. Mężczyzna kiwa głową i daje kilka koron, po czym obchodzi wóz od tyłu. Wkłada bulwiasty nos do środka, prycha jak świnia ryjąca w ziemi.\n\nNagle chwyta kilka słojów kadzidła i zrywa pokrywki. Pył i proszek rozlatują się, śnieżne pustkowia na chwilę stają się barwne, a chichoczący mężczyzna tańczy w obłoku. Chcesz go ogłuszyć, ale rzuca na ciebie linki latawców, pętając cię w ich druciane uchwyty, sam zaś robiąc brawurową ucieczkę, rechocząc, gdy kadzidło spływa z jego ramion jak zbłąkany włóczęga przechodzący przez niebieski południk. Wściekły, rozcinając te przeklęte latawce, sprawdzasz straty.",
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
			Text = "[img]gfx/ui/events/event_143.png[/img]{%bellydancer% tancerz brzucha wychodzi naprzód, wpatruje się w śnieg i niespodziewanie zastanawia się na głos, czy to jego ojciec. Szalony mężczyzna podchodzi, a jego czarne latawce podążają za nim jak sępy na ogonie skazańca. Jego twarz rozjaśnia się i obaj się obejmują. Mężczyzna okazuje się dawno zaginionym ojcem %bellydancer%, kupcem kadzidła, który poszedł daleko na północ, tylko po to, by zostać napadniętym i zniewolonym przez dzikich barbarzyńców, od których teraz uciekł. Uśmiecha się obłędnie.%SPEECH_ON%Tak dawno nie widziałem dobrego kadzidła, że czułem wasz wóz z wielu mil. Moja żona, twoja matka, %bellydancer%, jak się trzyma?%SPEECH_OFF%Uśmiech tancerza blednie. Mówi, że wytrwała z nadzieją tak długo, jak mogła. Człowiek z latawcami kiwa głową, ponuro, ale i z oczekiwaniem. Mówi, że nie byłoby w porządku, gdyby była żona widmem tego, co kiedyś było, a on sam, bez nadziei na powrót do domu, również poszedł dalej. Mężczyzna wyciąga ozdobną broń z ostrzem niepodobnym do niczego, co kiedykolwiek widziałeś. Mówi, że to długo przechowywana rodzinna relikwia i że przez całe lata na północy trzymał ją zakopaną i bezpieczną.%SPEECH_ON%Lepiej to weź i zrób z tego użytek, zanim jeden z tych dzikusów mnie zje i użyje tego jako wykałaczki.%SPEECH_OFF%Mężczyzna uśmiecha się czule, a obaj obejmują się przez chwilę. Zaciekawiony pytasz, po co te latawce. Odpowiada, że to narzędzia strachu, mające odstraszać niebezpieczne zwierzęta i podobne, w tym bardziej przesadnych barbarzyńców. Żegnasz mężczyznę i sugerujesz %bellydancer%, że może odejść, jeśli musi, ale ten kręci głową.%SPEECH_ON%Syn i ojciec nie powinni dzielić pozłacanej ścieżki, bo wiemy, że spotkamy się na jej końcu, jak spotkaliśmy się na jej początku.%SPEECH_OFF%Mówi kilka słów do ojca w swoim języku, po czym obaj odchodzą i na tym koniec.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cholera, to kadzidło jest świetne.",
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
			Text = "[img]gfx/ui/events/event_143.png[/img]{Każesz mężczyźnie odejść albo inaczej. Robi, co każesz, choć stoi z wyciągniętymi rękami, a palce bezradnie drapią powietrze za zapachem, który wyłapał jego nos. Kilka razy oglądasz się za siebie, upewniając się, że nie idzie za wami. Stoi na śnieżnym pustkowiu i wpatruje się w twój wóz. Potem jest już tylko czarnym punktem. Potem znika, a jego latawce tańczą nad miejscem, w którym wiesz, że stoi, a potem i one znikają.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie da się uciec od tych dziwaków.",
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

