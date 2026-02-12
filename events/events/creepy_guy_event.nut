this.creepy_guy_event <- this.inherit("scripts/events/event", {
	m = {
		Thief = null,
		Minstrel = null,
		Butcher = null,
		Killer = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.creepy_guy";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_43.png[/img]Spacerując ulicami %townname%, natykasz się na tłum zgromadzony wokół wisielca. Musiał być dość znany: ludzie przepychają się, byle tylko dostać się na moment i odciąć palec u stopy albo u ręki jako osobliwą pamiątkę po stryczku. Stary mężczyzna zostaje szybko wypchnięty z tłumu łokciami. Odwraca się do ciebie, głos ma chrapliwy, a kostniste palce składa jak chorowite żebra.%SPEECH_ON%Ach, jesteś najemnikiem? Oczywiście, czuję twój fach, te zakupy, które zrobiłeś. Powiedz, zrobiłbyś dla mnie drobną przysługę? Potrzebuję kilku palców u rąk i nóg tego trupa. To do mojej pracy, zobaczysz. Dam ci w zamian pięćset koron.%SPEECH_OFF%Pytasz, po co mu akurat te części ciała. Ten zawodzący, przygarbiony człowiek śmieje się, szyderczo, jeśli kiedykolwiek słyszałeś coś takiego.%SPEECH_ON%Tak, dobre pytanie. Ten człowiek zasłużył na spacer pod stryczek skłonnością do przemocy i niezawodną siłą, by doprowadzać swoje pragnienia do końca. Palce jakiegoś prostaka się nie nadają. Potrzebuję człowieka bez zaciśniętego sumienia, a jedynego, jakiego teraz widzę, kołysze tamta lina. No i co powiesz? Pięćset koron, pamiętaj.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Dobrze, pójdę ich poszukać.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 30 || this.World.Assets.getMoney() <= 1000)
						{
							return "Good";
						}
						else
						{
							return "Bad";
						}
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Thief != null)
				{
					this.Options.push({
						Text = "Nasz złodziej, %thief%, chyba ma pomysł.",
						function getResult( _event )
						{
							return "Thief";
						}

					});
				}

				if (_event.m.Minstrel != null)
				{
					this.Options.push({
						Text = "%minstrel% uśmiecha się od ucha do ucha...",
						function getResult( _event )
						{
							return "Minstrel";
						}

					});
				}

				if (_event.m.Butcher != null)
				{
					this.Options.push({
						Text = "Wygląda na to, że %butcher% chce ci pomóc.",
						function getResult( _event )
						{
							return "Butcher";
						}

					});
				}

				this.Options.push({
					Text = "Wolelibyśmy się w to nie mieszać.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Good",
			Text = "[img]gfx/ui/events/event_43.png[/img]Przepychasz się przez tłum, wypatrując palców i palców u stóp albo zakrwawionych kieszeni. Jeden mężczyzna ma wyraźne, bulwiaste wybrzuszenie w kieszeni. Zaganiasz go w kąt i przyciskasz sztylet do gardła.\n\n Za nim widzisz kobietę z chorobliwym uśmiechem na twarzy, podskakującą po bruku. Jeśli kiedykolwiek widziałeś wzgardliwą ladacznicę, to właśnie ją. Odsuwając ją na bok, szybko znajdujesz palec i palec u stopy w fałdach jej sukni. Kłamie, mówiąc, że to tylko składniki do gotowania. Mówisz jej, że jeśli tak, to zgłosisz ją strażnikom za kanibalizm. Oddaje je.\n\n Oddając odrażające kończyny starcowi, natychmiast dostajesz pięćset koron. Ledwie ci dziękuje za twoją \"pracę\", zanim pospiesznie odchodzi. Nigdy nie wyjaśnił, do czego dokładnie takie rzeczy są potrzebne. Nie obchodzi cię to. Pięćset koron to pięćset koron.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Łatwizna.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(500);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]500[/color] Crowns"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "Bad",
			Text = "[img]gfx/ui/events/event_43.png[/img]Zgadzasz się na zadanie obrzydliwego starca i zaczynasz przeczesywać tłum, uważnie wypatrując palców i palców u stóp tam, gdzie nie powinny być, albo świeżo, czerwono mokrych, wybrzuszonych kieszeni. Nie trwa to długo: kobieta kroczy drogą, a przód jej sukni dziwnie faluje od tego, co ma w kieszeni. Wciągasz ją w zaułek, dobywając sztyletu, by ją uciszyć. Znajdujesz palec i palec u stopy. Gdy chcesz je zabrać, ktoś nagle rzuca się na ciebie od tyłu. Korony z twojej sakiewki i te części ciała rozbiegają się po bruku. Dziecko chwyta jedno, szczur drugie, a gdzie uciekają, szybko ginie w zamieszaniu chłopów pędzących za twoimi monetami. Ten, który cię powalił, zamierza się do ciosu.%SPEECH_ON%Sukinsynu, chcesz ją, to płać!%SPEECH_OFF%Krzyżujesz ramiona, blokujesz uderzenie i skrętem ciała kładziesz go na ziemi. Ma coś jeszcze powiedzieć, ale na moment zastępujesz jego zęby swoimi kostkami i zapada cisza. Niestety, nie będziesz w stanie dokończyć tego, co zacząłeś, i straciłeś przy tym kilka monet.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cholera!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local money = this.Math.rand(200, 400);
				this.World.Assets.addMoney(-money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]" + money + "[/color] Crowns"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "Thief",
			Text = "[img]gfx/ui/events/event_43.png[/img]%thief% śmieje się.%SPEECH_ON%Cholera, to będzie łatwe.%SPEECH_OFF%Odchodzi do tłumu i tracisz go z oczu w mgnieniu oka. Starzec przez chwilę memle dziąsła, po czym podnosi głos.%SPEECH_ON%Temu jegomościowi można ufać?%SPEECH_OFF%Zanim zdążysz odpowiedzieć, %thief% wyłania się zza ramienia starca i wrzuca mu w dłonie zakrwawiony bandaż. Dziwny człowiek rozwija płótno i odkrywa świeżo pozyskane kończyny. Złodziej uśmiecha się z satysfakcją.%SPEECH_ON%Każdy złodziej wart swojej soli najpierw uczy się kieszonkowstwa. Zwykle biorę klucze, nie palce u stóp, ale robota to robota. Przy okazji \"podniosłem\" też parę innych ciekawostek tu i tam. Rzuć okiem.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobra robota.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Thief.getImagePath());
				this.World.Assets.addMoney(500);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]500[/color] Crowns"
					}
				];
				local initiative = this.Math.rand(2, 4);
				_event.m.Thief.getBaseProperties().Initiative += initiative;
				_event.m.Thief.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Thief.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiative + "[/color] Initiative"
				});
				_event.m.Thief.improveMood(1.0, "Has used his unique talents to great success");

				if (_event.m.Thief.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Thief.getMoodState()],
						text = _event.m.Thief.getName() + this.Const.MoodStateEvent[_event.m.Thief.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Minstrel",
			Text = "[img]gfx/ui/events/event_92.png[/img]%minstrel%, minstrel, chwyta starca za ramiona.%SPEECH_ON%Powiedz, jakie potężne mięśnie masz, mój krzepki przyjacielu. Nie będę pytał, po co ci palce u rąk i nóg tego wisielca...%SPEECH_OFF%Starzec kiwa głową i mówi, że i tak by nie powiedział. Minstrel ciągnie dalej.%SPEECH_ON%...ale jeśli chcesz dobrego, silnego i brutalnego mężczyzny, to czy nie patrzę właśnie na niego? To ty, starcze! Weź własne palce u rąk i nóg i idź z nimi dokończyć zadanie - echem, jakkolwiek dziwacznego gówna by to nie było, echem - a znajdziesz \"nagrodę\", której szukasz. Jesteś bohaterem tej historii, nie widzisz?%SPEECH_OFF%Starzec spluwa i kręci głową.%SPEECH_ON%Bierzesz mnie za głupca, co? Nasz interes tutaj dobiegł końca! Zejdź mi z drogi, żałosny najemniku.%SPEECH_OFF%Starzec odchodzi. Pytasz minstrela, co on do diabła wyprawia. Wzrusza ramionami i unosi sakiewkę z koronami.%SPEECH_ON%Zręczność dłoni.%SPEECH_OFF%Nieźle. Ale pytasz, gdzie jest twoja sakiewka. %minstrel% unosi drugi worek.%SPEECH_ON%Naprawdę, naprawdę niezła zręczność dłoni.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bardzo śmieszne. A teraz oddawaj.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Minstrel.getImagePath());
				this.World.Assets.addMoney(500);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]500[/color] Crowns"
				});
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]1000[/color] Crowns"
				});
				local initiative = this.Math.rand(2, 4);
				_event.m.Minstrel.getBaseProperties().Initiative += initiative;
				_event.m.Minstrel.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Minstrel.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiative + "[/color] Initiative"
				});
				_event.m.Minstrel.improveMood(1.0, "Has used his unique talents to great success");

				if (_event.m.Minstrel.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Minstrel.getMoodState()],
						text = _event.m.Minstrel.getName() + this.Const.MoodStateEvent[_event.m.Minstrel.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Butcher",
			Text = "[img]gfx/ui/events/event_19.png[/img]%butcher%, rzeźnik, spluwa i mówi, że to zrobi. Mówisz mu, że raczej nie jest typem złodzieja. Kręci głową.%SPEECH_ON%Nie. Chodzi o to, że dam mu palec. Tylko jeden, ale porządny i warty tyle co złoto w oczach tego starego pierdziela. A jeśli o ciebie chodzi, kapitanie, chcę połowę nagrody.%SPEECH_OFF%Dziwny obcy kiwa głową, a na jego wyschniętej, łuszczącej się skórze pojawia się uśmiech.%SPEECH_ON%Tak... tak! Człowiek, który by to zrobił, idealnie pasuje do profilu składników, których potrzebuję. Zrób to. Zrób to!%SPEECH_OFF%Zanim zdążysz się nawet zgodzić, rzeźnik chwyta kleszcze wiszące na pobliskiej ścianie, opiera je na kowadle, wkłada palec między szczęki i przyciska kolanem uchwyt, odcinając palec jednym ruchem. Opatruje dłoń, po czym oddaje kończynę nieznajomemu.%SPEECH_ON%Oto proszę: palec wyjątkowo okrutnego człowieka.%SPEECH_OFF%Obcy chwyta go tak, jakby był kluczem do świata. \"Cudowne!\" - jak sądzisz, mówi, ale trudno to usłyszeć, bo pośpiesznie wręcza ci trochę koron i ucieka. To w rzeczywistości więcej, niż pierwotnie ustaliliście. Rzeźnik z pewnością \"zarobił\" swoją połowę, więc mu ją przekazujesz.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Obłęd.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Butcher.getImagePath());
				this.World.Assets.addMoney(250);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]250[/color] Crowns"
				});
				_event.m.Butcher.improveMood(1.0, "Has made a tidy sum selling one of his fingers");

				if (_event.m.Butcher.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Butcher.getMoodState()],
						text = _event.m.Butcher.getName() + this.Const.MoodStateEvent[_event.m.Butcher.getMoodState()]
					});
				}

				local injury = _event.m.Butcher.addInjury([
					{
						ID = "injury.missing_finger",
						Threshold = 0.0,
						Script = "injury_permanent/missing_finger_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Butcher.getName() + " suffers " + injury.getNameOnly()
				});
				_event.m.Butcher.getBaseProperties().Bravery += 3;
				_event.m.Butcher.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Butcher.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+3[/color] Resolve"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getSize() >= 2 && t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
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

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_thief = [];
		local candidates_minstrel = [];
		local candidates_butcher = [];
		local candidates_killer = [];

		foreach( b in brothers )
		{
			if (b.getBackground().getID() == "background.thief")
			{
				candidates_thief.push(b);
			}
			else if (b.getBackground().getID() == "background.minstrel")
			{
				candidates_minstrel.push(b);
			}
			else if (b.getBackground().getID() == "background.butcher" && !b.getSkills().hasSkill("injury.missing_finger"))
			{
				candidates_butcher.push(b);
			}
			else if (b.getBackground().getID() == "background.killer_on_the_run")
			{
				candidates_killer.push(b);
			}
		}

		if (candidates_thief.len() != 0)
		{
			this.m.Thief = candidates_thief[this.Math.rand(0, candidates_thief.len() - 1)];
		}

		if (candidates_minstrel.len() != 0)
		{
			this.m.Minstrel = candidates_minstrel[this.Math.rand(0, candidates_minstrel.len() - 1)];
		}

		if (candidates_butcher.len() != 0)
		{
			this.m.Butcher = candidates_butcher[this.Math.rand(0, candidates_butcher.len() - 1)];
		}

		if (candidates_killer.len() != 0)
		{
			this.m.Killer = candidates_killer[this.Math.rand(0, candidates_killer.len() - 1)];
		}

		this.m.Town = town;
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"thief",
			this.m.Thief != null ? this.m.Thief.getName() : ""
		]);
		_vars.push([
			"minstrel",
			this.m.Minstrel != null ? this.m.Minstrel.getName() : ""
		]);
		_vars.push([
			"butcher",
			this.m.Butcher != null ? this.m.Butcher.getName() : ""
		]);
		_vars.push([
			"killer",
			this.m.Killer != null ? this.m.Killer.getName() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Thief = null;
		this.m.Minstrel = null;
		this.m.Butcher = null;
		this.m.Killer = null;
		this.m.Town = null;
	}

});

