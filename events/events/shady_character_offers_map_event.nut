this.shady_character_offers_map_event <- this.inherit("scripts/events/event", {
	m = {
		Historian = null,
		Thief = null,
		Peddler = null,
		Cost = 0,
		PricePaid = 0,
		Location = null
	},
	function create()
	{
		this.m.ID = "event.shady_character_offers_map";
		this.m.Title = "Przy drodze...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_41.png[/img]Podczas marszu na twojej drodze pojawia się samotny kupiec z koniem jucznym. Ma wyciągnięte ręce i widoczne dłonie.%SPEECH_ON%Dobry wieczór, podróżnicy. Może zainteresuje was jakiś towar?%SPEECH_OFF%Wylicza kilka rzeczy, z których %companyname% raczej nie zrobi użytku, ale potem wspomina o mapie. Musiałeś unieść brew, bo on unosi swoją i uśmiecha się przy tym.%SPEECH_ON%Ach, mapa was interesuje? Oto kartograficzna, topograficzna, geograficzna osobliwość niesiona przez człowieka, który, zapewniam, jest zupełnie przytomny! Ten papier podaje dokładne położenie słynnego \'%location%\'. Jestem pewien, że o tym słyszeliście, prawda? Miejsce skrywające niewyobrażalne skarby! Spoczynek niektórych z najlepszych oręży tego świata! A kosztuje was to jedyne marne %mapcost% koron!%SPEECH_OFF%Odwraca głowę z szerokim uśmiechem. Wygląda na to, że część zębów sprzedał kiedyś na drodze.%SPEECH_ON%A więc, podróżnicy, co na to powiecie?%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zaintrygowałeś mnie, kupimy mapę.",
					function getResult( _event )
					{
						this.World.Assets.addMoney(-_event.m.Cost);
						_event.m.PricePaid = _event.m.Cost;

						if (_event.m.Historian != null)
						{
							return "B";
						}
						else
						{
							return this.Math.rand(1, 100) <= 50 ? "C" : "D";
						}
					}

				},
				{
					Text = "Nie jesteśmy zainteresowani.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Peddler != null)
				{
					this.Options.push({
						Text = "%peddler%, byłeś kiedyś handlarzem. Utarguj dla nas lepszą cenę!",
						function getResult( _event )
						{
							return "E";
						}

					});
				}

				if (_event.m.Thief != null)
				{
					this.Options.push({
						Text = "%thief%, byłeś kiedyś złodziejem. Zdobądź dla nas tę mapę!",
						function getResult( _event )
						{
							return "F";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_45.png[/img]Po zdobyciu mapy przyglądasz się jej uważnie. Wyjmujesz własną mapę i zaczynasz porównywać obie. Na kupionej mapie nie ma niczego, co dałoby się zweryfikować. Co więcej, na krawędziach widnieją dziwne runy. To albo świeża podróbka, albo powstała w czasach, gdy powszechna mowa nie była twoją. Tak czy inaczej, wydaje się bezużyteczna.\n\n Właśnie gdy masz ją zgnieść i wyrzucić, podchodzi historyk %historian% i delikatnie ją zabiera. Patrzy na runy i kiwa głową, przeciągając palcem wzdłuż krawędzi, po czym przesuwa je do środka, między niezdarnie narysowane góry, rzeki i lasy.%SPEECH_ON%Hmmm... Och... A tak, czytałem o tym miejscu. Znam też te runy, choć nie ośmielę się ich wypowiedzieć na głos.%SPEECH_OFF%Zabiera mapę kompanii i, trzymając między palcami trzy pióra, powoli wyznacza i tłumaczy kierunki. Gdy kończy, kiwa głową i lekko uderza w mapę kompanii grzbietem dłoni.%SPEECH_ON%Tam, panie. Tam je znajdziemy.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze mieć kogoś o twoich umiejętnościach w kompanii.",
					function getResult( _event )
					{
						this.World.uncoverFogOfWar(_event.m.Location.getTile().Pos, 700.0);
						_event.m.Location.getFlags().set("IsEventLocation", true);
						_event.m.Location.setDiscovered(true);
						this.World.getCamera().moveTo(_event.m.Location);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());

				if (_event.m.PricePaid != 0)
				{
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.PricePaid + "[/color] koron"
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_45.png[/img]Bierzesz mapę i dokładnie ją studiujesz. Rozpoznajesz niektóre miejsca i z czasem przenosisz jej treść na własną mapę. %companyname% szepcze z ekscytacji o tym, co może się tam znajdować.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zgarnijmy to dla kompanii!",
					function getResult( _event )
					{
						this.World.uncoverFogOfWar(_event.m.Location.getTile().Pos, 700.0);
						_event.m.Location.getFlags().set("IsEventLocation", true);
						_event.m.Location.setDiscovered(true);
						this.World.getCamera().moveTo(_event.m.Location);
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (_event.m.PricePaid != 0)
				{
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.PricePaid + "[/color] koron"
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_45.png[/img]Patrzysz na mapę, wpatrujesz się w nią, niemal przesłuchujesz ją długim, długim spojrzeniem. Ale nic nie widzisz. %randombrother% zerka i kręci głową.%SPEECH_ON%Nie rozpoznaję ani kawałka, panie.%SPEECH_OFF%To podróbka albo mapa krainy, której nie uznajesz za swoją - tak czy inaczej, jest całkiem bezużyteczna.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zrobiono nas w konia.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (_event.m.PricePaid != 0)
				{
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.PricePaid + "[/color] koron"
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_41.png[/img]%peddler% handlarz robi krok naprzód, trzymając dłonie wyciągnięte tak samo, jak wędrowny kupiec. Najwyraźniej to powszechna taktyka wśród uczciwych złodziei.%SPEECH_ON%Panie, panie, proszę. No już. Ta cena jest skandaliczna.%SPEECH_OFF%Twarz kupca tężeje.%SPEECH_ON%Zapewniam, że nie ma w niej nic skandalicznego.%SPEECH_OFF%Ale twój handlarz nie ustępuje.%SPEECH_ON%Wyraźnie jest skandaliczna, bo właśnie to powiedziałem, prawda?%SPEECH_OFF%Kupiec kiwa głową. Handlarz ciągnie dalej.%SPEECH_ON%Zatem postanowiliśmy nie kupować jej za pierwotnie żądaną cenę. To jasne. Tak więc, przyjacielu, myślę, że kupimy ją za %newcost%. To uczciwe wobec wszystkich stron, a znakomity biznesmen, taki jak ty, z pewnością dostrzeże okazję! My sami biznesmenami nie jesteśmy, ale wiemy, że to dobry interes!%SPEECH_OFF%Kupiec drapie się po brodzie, po czym przytakuje.%SPEECH_ON%Dobrze, ta cena jest uczciwa.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Lepszy interes!",
					function getResult( _event )
					{
						this.World.Assets.addMoney(-_event.m.Cost / 2);
						_event.m.PricePaid = _event.m.Cost / 2;

						if (_event.m.Historian != null)
						{
							return "B";
						}
						else
						{
							return this.Math.rand(1, 100) <= 50 ? "C" : "D";
						}
					}

				},
				{
					Text = "Wciąż się nie opłaca.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Peddler.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_41.png[/img]Kiedy rozmawiasz z kupcem, złodziej %thief% przysuwa się obok, wyglądając na mocno zainteresowanego rozmową. Zerka na ciebie. Ty też zerkasz. On szczerzy zęby i kiwa głową. Szybko lustrujesz sprzedawcę, po czym zerkasz na złodzieja i przytakujesz. Kupiec jest w środku swojej przemowy i niczego nie zauważa. Mówi dalej, ale niewiele z tego słyszysz. Wiesz tylko, że masz kiwać głową, bo taki kupiec i tak powie ci wyłącznie to, co chcesz usłyszeć.\n\n Złodziej obchodzi go od tyłu i upuszcza broń w błoto.%SPEECH_ON%Ależ ze mnie niezdara.%SPEECH_OFF%Schyla się, zatrzymuje, jest ruch ledwie do wychwycenia, i już stoi wyprostowany. Mruga do ciebie. Mówisz kupcowi, że doceniasz ofertę, ale musisz odmówić. Kiedy odchodzi, %thief% podaje ci mapę i uśmiecha się szeroko.%SPEECH_ON%Mówią, że najlepsze rzeczy w życiu są za darmo.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To dopiero zniżka.",
					function getResult( _event )
					{
						if (_event.m.Historian != null)
						{
							return "B";
						}
						else
						{
							return this.Math.rand(1, 100) <= 50 ? "C" : "D";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Thief.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getTime().Days < 10)
		{
			return;
		}

		if (this.World.Assets.getMoney() <= 1500)
		{
			return;
		}

		if (this.World.State.getEscortedEntity() != null)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local bases = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getSettlements();
		local candidates_location = [];

		foreach( b in bases )
		{
			if (!b.getLoot().isEmpty() && !b.getFlags().get("IsEventLocation"))
			{
				candidates_location.push(b);
			}
		}

		if (candidates_location.len() == 0)
		{
			return;
		}

		this.m.Location = candidates_location[this.Math.rand(0, candidates_location.len() - 1)];
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_peddler = [];
		local candidates_thief = [];
		local candidates_historian = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.historian")
			{
				candidates_historian.push(bro);
			}
			else if (bro.getBackground().getID() == "background.thief")
			{
				candidates_thief.push(bro);
			}
			else if (bro.getBackground().getID() == "background.peddler")
			{
				candidates_peddler.push(bro);
			}
		}

		if (candidates_historian.len() != 0)
		{
			this.m.Historian = candidates_historian[this.Math.rand(0, candidates_historian.len() - 1)];
		}

		if (candidates_thief.len() != 0)
		{
			this.m.Thief = candidates_thief[this.Math.rand(0, candidates_thief.len() - 1)];
		}

		if (candidates_peddler.len() != 0)
		{
			this.m.Peddler = candidates_peddler[this.Math.rand(0, candidates_peddler.len() - 1)];
		}

		this.m.Cost = this.Math.rand(6, 14) * 100;
		this.m.Score = 7;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"historian",
			this.m.Historian != null ? this.m.Historian.getNameOnly() : ""
		]);
		_vars.push([
			"peddler",
			this.m.Peddler != null ? this.m.Peddler.getNameOnly() : ""
		]);
		_vars.push([
			"thief",
			this.m.Thief != null ? this.m.Thief.getNameOnly() : ""
		]);
		_vars.push([
			"location",
			this.m.Location.getName()
		]);
		_vars.push([
			"mapcost",
			this.m.Cost
		]);
		_vars.push([
			"newcost",
			this.m.Cost / 2
		]);
	}

	function onClear()
	{
		this.m.Historian = null;
		this.m.Thief = null;
		this.m.Peddler = null;
		this.m.Location = null;
	}

});

