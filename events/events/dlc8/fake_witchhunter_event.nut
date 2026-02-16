this.fake_witchhunter_event <- this.inherit("scripts/events/event", {
	m = {
		Witchhunter = null
	},
	function create()
	{
		this.m.ID = "event.fake_witchhunter";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Wychodzisz naprzód i wyjaśniasz zasady umowy, tłumacząc, że wioska wynajęła mężczyznę do zabicia czarownicy, a jeśli osoba, na którą go skierowali, nie była czarownicą, to nie może jej zabić. Gdyby mimo to to zrobił, działałby jedynie dla koron. Jeśli zdecydował się jej nie zabijać, a wioska zerwała umowę, to później byłby zmuszony robić to, czego chce każda wioska, by do takiej sytuacji nie doszło ponownie. Serią łagodnych wyjaśnień pokazujesz, że wioska ryzykuje opinię niewiarygodnej, a przykład, jaki daje, przyciągnie tylko szarlatanów i oszustów celujących w ich złoto, a nie w wykonanie zleconego zadania. Poza tym odmowa spalenia niewinnej osoby pokazuje siłę charakteru łowcy.\n\nGdy kończysz, tłum w większości się zgadza, ale ktoś krzyczy: \"spalić go mimo wszystko!\" i wszyscy znów wpadają w wściekłość. Kiedy się odwracają, widzą, że łowca czarownic zniknął, gdy prowadziłeś wywód. Chłopi zaczynają obwiniać się nawzajem, że go nie dopilnowali. Spory szybko przeradzają się w bijatykę, a ty odchodzisz. Gdy docierasz na skraj miasta, spotykasz mężczyznę dnia. Dziękuje ci garstką koron. Wydaje ci się to dziwne, że człowiek oddaje pieniądze, skoro mógł po prostu odejść. Podnosi czarny kapelusz i mówi, że nie zajmuje się łowieniem czarownic dla pieniędzy.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Musimy interweniować.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Witchhunter != null)
				{
					this.Options.push({
						Text = "%witchhunter%, czy znasz tego mężczyznę?",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				this.Options.push({
					Text = "To nas nie dotyczy.",
					function getResult( _event )
					{
						return "E";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Wychodzisz naprzod i wyjasniasz zasady umowy, tlumaczac, ze wioska wynajela mezczyzne do zabicia czarownicy, a jesli osoba, na ktora go skierowali, nie byla czarownica, to nie moze jej zabic. Gdyby mimo to to zrobil, dzialalby jedynie dla koron. Jesli zdecydowal sie jej nie zabijac, a wioska zerwala umowe, to pozniej bylby zmuszony robic to, czego chce kazda wioska, by do takiej sytuacji nie doszlo ponownie. Seria lagodnych wyjasnien pokazujesz, ze wioska ryzykuje opinie niewiarygodnej, a przyklad, jaki daje, przyciagnie tylko szarlatanow i oszustow celujacych w ich zloto, a nie w wykonanie zleconego zadania. Poza tym odmowa spalenia niewinnej osoby pokazuje sila charakteru lowcy.\n\nGdy konczysz, tlum w wiekszosci sie zgadza, ale ktos krzyczy: \"spalic go mimo wszystko!\" i wszyscy znów wpadaja w wscieklosc. Kiedy sie odwracaja, widza, ze lowca czarownic zniknal, gdy prowadziles wywod. Chlopi zaczynaja obwiniac sie nawzajem, ze go nie dopilnowali. Spory szybko przeradzaja sie w bijatyke, a ty odchodzisz. Gdy docierasz na skraj miasta, spotykasz mezczyzne dnia. Dziekuje ci garstka koron. Wydaje ci sie to dziwne, ze czlowiek oddaje pieniadze, skoro mogl po prostu odejsc. Podnosi czarny kapelusz i mowi, ze nie zajmuje sie lowieniem czarownic dla pieniedzy.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Co za dziwny człowiek.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(75);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]75[/color] Koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_141.png[/img]{Wychodzisz naprzód, krzycząc i machając rękami. Tłum powoli się uspokaja i odwraca, by cię słuchać. Dobierając ostrożnie słowa, wyjaśniasz, że w uczciwych umowach jest porządek, że jeśli ktoś płaci korony, by kogoś wynająć, a potem odwraca się od niego z powodu zmiany okoliczności, to tworzy obraz wioski niewiarygodnej, z którą nikt nie będzie chciał robić interesów. Zanim kończysz wywód, ktoś rzuca kamieniem tuż nad twoją głową, a inny mężczyzna wpada, krzycząc, i wbija widły w pierś łowcy czarownic. Wybucha totalny chaos, a ty i %companyname% odpieracie wściekłych chłopów i wynosicie się stamtąd tak szybko, jak to możliwe.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cholerni chłopi.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 33)
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " odnosi lekkie rany"
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_141.png[/img]{%witchhunter% wychodzi naprzód. Mówi, że mężczyzna w czarnym kapeluszu jest znanym oszustem w kręgach łowców czarownic.%SPEECH_ON%Szukamy go od dawna, bo jego kłamstwa kalają naszą profesję. Od dawna szukałem okazji, by zdobyć jego skalp.%SPEECH_OFF%Zanim zdążysz powiedzieć słowo, %witchhunter% przechodzi przez tłum i po drugiej stronie chwyta widły jednego z chłopów, po czym natychmiast wbija je w nogę fałszywego łowcy. Mężczyzna zgina się z krzykiem. Oszust podnosi kuszę, ale %witchhunter% chwyta ją za lufę i odprowadza w górę, a strzał bezpiecznie leci w niebo. Wyrywa kuszę, krzycząc, że do niego nie należy, i ogłasza tłumowi, że to szarlatan. Rzuca go na ziemię, mówiąc tłumowi, by zrobił, co zechce. Rzucają się na kłamcę, choć przez podekscytowane szeregi pospólstwa trudno dostrzec skalę tortur. %witchhunter% wraca z kuszą, obracając ją w jedną i drugą stronę. To najwspanialsza broń, jaką widziałeś od dawna. Łowca czarownic wyjaśnia.%SPEECH_ON%Należała do mistrza gildii w tym regionie. Wierzymy, że ten głupiec go zamordował, zabrał mu ubrania i od tamtej pory udaje jego rolę. Jeśli jego krzyki ci przeszkadzają, kapitanie, pamiętaj, że spalił niezliczonych niewinnych i ukradł niezliczone korony zdesperowanym i zagubionym. Niech go diabli.%SPEECH_OFF%Patrzysz ponad mężczyzna i na tłum. Ledwo widzisz, jak wciągają go na stos i jak unosi się pierwszy dym.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wróćmy na drogę.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Witchhunter.getImagePath());
				local item = this.new("scripts/items/weapons/named/named_crossbow");
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
			Text = "[img]gfx/ui/events/event_43.png[/img]{Chociaż pijany lincz to ulubiona rozrywka chłopów, wyczuwasz w powietrzu zagrożenie i przesuwasz %companyname% na skraj miasta. Nigdy nie wiesz, kiedy takie sprawy wymykają się spod kontroli i pospólstwo zaczyna atakować wszystkich, którzy znajdą się w zasięgu.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wynośmy się stąd.",
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

		local towns = this.World.EntityManager.getSettlements();
		local currentTile = this.World.State.getPlayer().getTile();
		local foundTown = false;

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern() || t.getSize() > 2)
			{
				continue;
			}

			if (t.getTile().getDistanceTo(currentTile) <= 3)
			{
				foundTown = true;
				break;
			}
		}

		if (!foundTown)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.getTime().Days <= 25)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_witchhunter = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.witchhunter" && bro.getLevel() >= 4)
			{
				candidates_witchhunter.push(bro);
			}
		}

		if (candidates_witchhunter.len() != 0)
		{
			this.m.Witchhunter = candidates_witchhunter[this.Math.rand(0, candidates_witchhunter.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"witchhunter",
			this.m.Witchhunter != null ? this.m.Witchhunter.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Witchhunter = null;
	}

});

