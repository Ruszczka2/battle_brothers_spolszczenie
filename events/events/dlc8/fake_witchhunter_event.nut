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
			ID = "A",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Napotykasz mezczyzne otoczonego przez tlum wscieklych i pijanych chlopow. Otoczony mezczyzna nosi czarny kapelusz, ma kusze u boku i palec na spustie. Obok stoi stos z palem po srodku oraz liny, ktorymi kogos miano przykuc. Tlum krzyczy i wrzeszczy, a z ich piany i wrzaskow skladasz w calosc, co sie stalo: wioska wynajela lowce czarownic, a ten, jak tlumaczy jeden z awanturujacych sie chlopow, znalazl czarownice i uznal, ze wcale nie jest czarownica, po czym ja wypuscil. Chlop potyka sie, prawie placzac.%SPEECH_ON%I to nie w porzadku, to wcale nie w porzadku. Zbudowalismy ten stos i wszystko, zeby ogien ja dostal. To nie w porzadku, ale to naprawimy. Bo na pewno cos spalimy, prawda?%SPEECH_OFF%Tlum ryczy. Wyglada na to, ze ten rzekomy lowca czarownic popelnil jedna z najgorszych zbrodni: znudzil pospolstwo.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Musimy interweniowac.",
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
						Text = "%witchhunter%, czy znasz tego mezczyzne?",
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
					Text = "Co za dziwny czlowiek.",
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
			Text = "[img]gfx/ui/events/event_141.png[/img]{Wychodzisz naprzod, krzyczac i machajac rekami. Tlum powoli sie uspokaja i odwraca, by cie sluchac. Dobierajac ostroznie slowa, wyjasniasz, ze w uczciwych umowach jest porzadek, ze jesli ktos placi korony, by kogos wynajac, a potem odwraca sie od niego z powodu zmiany okolicznosci, to tworzy obraz wioski niewiarygodnej, z ktora nikt nie bedzie chcial robic interesow. Zanim konczysz wywod, ktos rzuca kamieniem tuz nad twoja glowa, a inny mezczyzna wpada, krzyczac, i wbija widly w piers lowcy czarownic. Wybucha totalny chaos, a ty i %companyname% odpieracie wscieklych chlopow i wynosicie sie stamtad tak szybko, jak to mozliwe.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cholerni chlopi.",
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
			Text = "[img]gfx/ui/events/event_141.png[/img]{%witchhunter% wychodzi naprzod. Mowi, ze mezczyzna w czarnym kapeluszu jest znanym oszustem w kregach lowcow czarownic.%SPEECH_ON%Szukamy go od dawna, bo jego klamstwa kalaja nasza profesje. Od dawna szukalem okazji, by zdobyc jego skalp.%SPEECH_OFF%Zanim zdazysz powiedziec slowo, %witchhunter% przechodzi przez tlum i po drugiej stronie chwyta widly jednego z chlopow, po czym natychmiast wbija je w noge falszywego lowcy. Mezczyzna zgina sie z krzykiem. Oszust podnosi kusze, ale %witchhunter% chwyta ja za lufe i odprowadza w gore, a strzal bezpiecznie leci w niebo. Wyrywa kusze, krzyczac, ze do niego nie nalezy, i oglasza tlumowi, ze to szarlatan. Rzuca go na ziemie, mowiac tlumowi, by zrobil, co zechce. Rzucaja sie na klamce, choc przez podekscytowane szeregi pospolstwa trudno dostrzec skale tortur. %witchhunter% wraca z kusza, obracajac ja w jedna i druga strone. To najwspanialsza bron, jaka widziales od dawna. Lowca czarownic wyjasnia.%SPEECH_ON%Nalezala do mistrza gildii w tym regionie. Wierzymy, ze ten glupiec go zamordowal, zabral mu ubrania i od tamtej pory udaje jego role. Jesli jego krzyki ci przeszkadzaja, kapitanie, pamietaj, ze spalil niezliczonych niewinnych i ukradl niezliczone korony zdesperowanym i zagubionym. Niech go diabli.%SPEECH_OFF%Patrzysz ponad mezczyzna i na tlum. Ledwo widzisz, jak wciagaja go na stos i jak unosi sie pierwszy dym.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wrocmy na droge.",
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
			Text = "[img]gfx/ui/events/event_43.png[/img]{Chociaz pijany lincz to ulubiona rozrywka chlopow, wyczuwasz w powietrzu zagrozenie i przesuwasz %companyname% na skraj miasta. Nigdy nie wiesz, kiedy takie sprawy wymykaja sie spod kontroli i pospolstwo zaczyna atakowac wszystkich, ktorzy znajda sie w zasiegu.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wynosmy sie stad.",
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

