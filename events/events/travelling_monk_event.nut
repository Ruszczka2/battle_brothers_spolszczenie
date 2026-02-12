this.travelling_monk_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.travelling_monk";
		this.m.Title = "Przy drodze...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A1",
			Text = "[img]gfx/ui/events/event_40.png[/img]Spotykasz na drodze mnicha, a z nim wóz ciągnięty przez osła, biedne zwierzę pociągowe niesie głowę nisko w niemej wyczerpaniu. Z jednej strony wozu zwisa słoma i zielony mech, oba skręcają się ochoczo na wietrze, który je wysuszył, a garnki i patelnie pobrzękują niczym rustykalne dzwonki, gdy skromne towary z łoskotem stają. Na krawędzi wozu chwieje się beczka, a kilka pszczół kołysze się, by nadążyć, szturchając i zaglądając w jej szczeliny z pragnącą ciekawością.\n\nMnich unosi wełniany kapelusz z twarzy, ale jego brzeg znowu opada mu na oczy. Zdejmuje go całkiem i przeciera czoło rękawem. Z wesołym uśmiechem zdaje się zupełnie nie przejmować żywą zbrojownią stojącą przed nim.%SPEECH_ON%Dobry wieczór, panowie. Nie sądzę, byście maszerowali pod chorągwią pana. Wyglądacie mi na najemników.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Co wozisz?",
					function getResult( _event )
					{
						return "A2";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "A2",
			Text = "[img]gfx/ui/events/event_40.png[/img]%SPEECH_ON%Ano, wiedziałem, że zapytasz. To Bessie, krowie imię dla oślego tyłka. Nie martw się, nie kopnie. Jest już wyjeżdżona, widzisz? A co niesie, no, to piwo. Dla ludzi stamtąd, żeby mogli pić za tych w górze. Jeśli nie masz nic przeciw, albo jeśli nie masz nic przeciw moim sprawom, chciałbym ruszyć dalej tam, dokąd idę.%SPEECH_OFF%Mnich chwyta lejce swojej oślicy, szykując się do drogi.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ile koron za rundę piwa?",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 70 ? "B" : "D";
					}

				},
				{
					Text = "Zasłużyliśmy, pilnując dróg - bierzcie piwo, chłopcy!",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_40.png[/img]Podnosisz dłoń, zatrzymując mnicha, nim ruszy dalej. Wzdycha, powoli opuszczając lejce. Czując, że mógł źle zrozumieć, szybko pytasz, czy ma piwo na sprzedaż dla twoich ludzi. Chętnie zapłacisz. Mnich zerka na zapasy, po czym się odwraca.%SPEECH_ON%Ano. Dam waszym ludziom łyka za koronę lub dwie. Nie przejmuj się pszczołami na górze, rozlecą się, gdy podejdziesz, ale jeśli ty się rozbiegniesz, gdy one się rozbiegną, to one rozbiegną się za tobą. Dziwne małe gnojki.%SPEECH_OFF%Pytasz, ile chce.%SPEECH_ON%Stawiam, że dziesięć koron od głowy wystarczy. Nie jestem kupcem, więc pewnie sam siebie oskubuję.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Runda dla całej kompanii!",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Za dużo żądasz.",
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
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_40.png[/img]Zgadzasz się zapłacić, ile zażądał, a on zaprasza gestem. Twoi ludzie zdejmują wieko z beczki i zanurzają kubki. Siadają w cieniu, sącząc kufle i podając piwo z rąk do rąk. Mnich żegna was serdecznie, a wszyscy mężczyźni wznoszą do niego kubki w głośnym, coraz bardziej bełkotliwym okrzyku.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Na zdrowie!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-10 * this.World.getPlayerRoster().getSize());
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]" + 10 * this.World.getPlayerRoster().getSize() + "[/color] koron"
					}
				];
				this.List.extend(_event.giveTraits(90));
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_40.png[/img]Podnosisz dłoń, zatrzymując mnicha, nim ruszy dalej. Wzdycha, powoli opuszczając lejce. Czując, że mógł źle zrozumieć, szybko pytasz, czy ma piwo na sprzedaż dla twoich ludzi. Chętnie zapłacisz. Mnich zerka na zapasy, po czym się odwraca.%SPEECH_ON%Ano. Niech mnie diabli, jeśli bogowie nie ucieszą się, że twoje pieniądze przejdą przez moje dłonie. Jeśli walczycie w słusznej sprawie, pozwalam wam wziąć trochę za darmo, ale nie wszystko, rzecz jasna.%SPEECH_OFF%Dziękujesz mnichowi za hojność i każesz ludziom pić z umiarem. Gdy kilku braci krąży wokół beczki, mnich podnosi ręce.%SPEECH_ON%Nie przejmujcie się pszczołami na górze, rozlecą się, gdy podejdziecie, ale jeśli wy się rozbiegniecie, gdy one się rozbiegną, to one rozbiegną się za wami. Dziwne małe gnojki.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Na zdrowie!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List = _event.giveTraits(90);
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_40.png[/img]Gdy wóz się toczy, chwytasz głowicę miecza i uderzasz nią w beczkę piwa, wybijając wieko i wprawiając kilka pszczół w szał. Mnich puszcza lejce, gdy na ciebie spogląda.%SPEECH_ON%Bałem się, że to zrobisz.%SPEECH_OFF%Mężczyzna znika pod ciosami, a jego ciało skręca się, gdy pada na ziemię. Kilku braci dopada go dla paru solidnych kopniaków, podczas gdy inni podnoszą piwo i niosą je w cień. Zanurzasz kufel w beczce, by się napić, po czym unosisz go w stronę wijącego się na ziemi mnicha.%SPEECH_ON%Do dna, chłopcy, i nie zapomnijmy podziękować naszemu hojnego przyjacielowi tam!%SPEECH_OFF%Mnich przewraca się, oczy mrużą się i szybko mrugają. Jedną ręką trzyma się za plecy, drugą powoli się podnosi. Zgarbiony, chwyta lejce osła i rusza naprzód. Próbuje naciągnąć kapelusz, ale ten spada i mężczyzna nawet po niego nie sięga. Postać maleje w oddali, rozmyta przez horyzont i alkohol, aż znika.\n\nWszyscy mężczyźni wznoszą do ciebie kubki w głośnym, coraz bardziej bełkotliwym okrzyku.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Na zdrowie!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-2);
				this.List = _event.giveTraits(66);
			}

		});
	}

	function giveTraits( _chance )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local result = [];

		foreach( bro in brothers )
		{
			if (this.Math.rand(1, 100) <= _chance)
			{
					bro.improveMood(1.0, "Świętował z kompanią");

				if (bro.getMoodState() >= this.Const.MoodState.Neutral)
				{
					result.push({
						id = 10,
						icon = this.Const.MoodStateIcon[bro.getMoodState()],
						text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
					});
				}
			}
		}

		return result;
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.Assets.getMoney() <= 10 * this.World.getPlayerRoster().getSize() + 250)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type == this.Const.World.TerrainType.Snow)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		this.m.Score = 8;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		return "A1";
	}

	function onClear()
	{
	}

});

