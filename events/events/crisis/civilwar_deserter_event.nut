this.civilwar_deserter_event <- this.inherit("scripts/events/event", {
	m = {
		NobleHouse = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_deserter";
		this.m.Title = "Na drodze...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_02.png[/img]{Podczas drogi napotykasz dwóch żołnierzy armii %noblehouse%, którzy wieszają, jak się wydaje, jednego ze swoich. Głowę mężczyzny wsadzono w pętlę, lecz na twój widok woła.%SPEECH_ON%Chcieli, żebym zabijał dzieci! To mam za to, że nie wykonałem rozkazu?%SPEECH_OFF%%randombrother% spogląda na ciebie z miną \"może możemy coś zrobić\". | Znajdujesz dwóch ludzi z armii %noblehouse%, którzy wieszają człowieka z zawiązanymi oczami. Zaciekawiony pytasz, jaka była jego wina. Jeden z katów śmieje się.%SPEECH_ON%Kazano mu spalić małą wioskę i odmówił. Szlachcie się nie odmawia, bo kończy się tak.%SPEECH_OFF%Z zawiązanymi oczami spluwa.%SPEECH_ON%Do diabła z wami wszystkimi. Przynajmniej zachowam godność i honor do końca.%SPEECH_OFF% | Z boku drogi widzisz człowieka, który zarzuca linę na gałąź drzewa. Drugi popycha oślepionego więźnia do przodu, zakładając mu pętlę na szyję. Kaci widzą cię i unoszą ręce.%SPEECH_ON%Cofnąć się, najemnicy. Ten człowiek ma zostać stracony z rozkazu %noblehouse%. Wtrąćcie się, a spotka was podobny los.%SPEECH_OFF%Więzień warczy.%SPEECH_ON%Chcieli, żebym mordował kobiety i dzieci. Taka jest cena za zignorowanie rozkazów, ale przynajmniej opuszczę ten ohydny świat z honorem nienaruszonym.%SPEECH_OFF% | Ścieżka otwiera się na zakutego w kajdany mężczyznę siedzącego w trawie, podczas gdy dwóch ludzi gniewnie przeciąga linę przez gałąź drzewa. Sprawdzają ją kilkoma mocnymi szarpnięciami, po czym kiwają głowami i stawiają pod nią beczkę, zapewne dla więźnia. Więzień dostrzega cię i woła.%SPEECH_ON%Najemnicy, ratujcie mnie! Wszystko, co zrobiłem, to odmówiłem spalenia świątyni do fundamentów!%SPEECH_OFF%Jeden z katów kopie mężczyznę.%SPEECH_ON%Ta świątynia ukrywała buntowników, buntowników, którzy zabili naszego porucznika, głupcze! Zasługujesz na ten los bardziej niż ktokolwiek. Jeśli %noblehouse% ma wygrać tę wojnę, nie możemy mieć wśród siebie szczurów takich jak ty.%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Uwolnijcie tego człowieka!",
					function getResult( _event )
					{
						local roster = this.World.getTemporaryRoster();
						_event.m.Dude = roster.create("scripts/entity/tactical/player");
						_event.m.Dude.setStartValuesEx([
							"deserter_background"
						]);
						_event.m.Dude.setTitle("Czcigodny");
						_event.m.Dude.getBackground().m.RawDescription = "Niegdyś żołnierz armii szlacheckiej, %name% niemal został powieszony za odmowę wykonania rozkazów, aż uratowali go ty i %companyname%.";
						_event.m.Dude.getBackground().buildDescription(true);

						if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
						{
							_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
						}

						if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
						{
							_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
						}

						if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
						{
							_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
						}

						if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				},
				{
					Text = "To nie nasza sprawa.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_02.png[/img]{Rozkazujesz katom uwolnić człowieka. Śmieją się i dobywają mieczy, ale to ostatnia rzecz, jaką robią, bo %companyname% spada na nich z wyzwoleńczą furią, rąbiąc obu żołnierzy w kilka sekund. Więzień dziękuje ci i w zamian za ratunek oferuje służbę w walce. | Nie możesz pozwolić na taką egzekucję i rozkazujesz ludziom z %companyname% interweniować. Szybko dobywają broni i rzucają się na żołnierzy, mordując ich w mgnieniu oka. Uwolniony więzień pada przed tobą na kolana.%SPEECH_ON%Proszę, pozwól mi walczyć w twoich szeregach, to najmniej, co mogę zaoferować!%SPEECH_OFF% | Rozkazujesz %companyname% uratować więźnia. To dziwny ciąg widoków i dźwięków, gdy ludzie, którzy uważali się za katów, tak nagle padają od ostrza. Takie zwroty losu wyzwalają dziki, niemal kobiecy krzyk. Twoi ludzie zrobiliby to szybko, gdyby ci nie próbowali uciec, ale człowiek, który uparcie ratuje własną skórę, często ginie najwolniej. Więzień tymczasem pada ci do stóp i składa przysięgę.}",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Witaj w %companyname%!",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				},
				{
					Text = "Wracaj do rodziny, żołnierzu.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationUnitKilled);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_02.png[/img]{Rozkazujesz uwolnić człowieka. Jeden z żołnierzy dobywa miecza i natychmiast pada za swą zbytnią pewność siebie. Drugi, najwyraźniej bystrzejszy, już uciekł. Bez wątpienia powie %noblehouse%, co tu zrobiłeś. Uratowany więzień podchodzi do ciebie osobiście, przyklęka i kłania się.%SPEECH_ON%Dziękuję, najemniku. Masz moje ostrze od dziś aż po mój kres.%SPEECH_OFF% | Wiesz, że dwaj kaci raczej nie porzuciliby szlacheckich sztandarów, by do ciebie dołączyć. Ale jest całkiem prawdopodobne, że więzień walczyłby po twojej stronie, gdybyś go uwolnił. Rozkazujesz więc jego ratunek. Jeden z żołnierzy dobywa miecza i ślubuje wierność %noblehouse%. To ostatnia rzecz, jaką robi. Drugi żołnierz ucieka. Może dałoby się go zwerbować, ale raczej nie wróci po błyskawicznym zabiciu jego towarzysza. Najpewniej opowie przełożonym o twoich działaniach.\n\n Podchodzisz do uwolnionego więźnia. Pośpiesznie się kłania i oferuje walkę dla %companyname%. | Rozkazujesz żołnierzom uwolnić człowieka. Jeden śmieje się i po prostu zaciska pętlę na jego szyi, zaczynając go wieszać. %randombrother% rzuca się naprzód i przewraca jednego z katów na ziemię. Tłucze mu twarz kamieniem, podczas gdy drugi żołnierz ucieka. Bez wątpienia powie swoim dowódcom, co tu zrobiłeś.\n\n Uwolniony więzień podchodzi do ciebie osobiście i kłania się, oferując lojalność w zamian za ratunek.}",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Witaj w %companyname%!",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				},
				{
					Text = "Wracaj do rodziny, żołnierzu.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Killed one of their men");
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_02.png[/img]{Choć niekoniecznie możesz winić człowieka za zignorowanie rozkazów, decyzja była jego, nie twoja, tak jak kara będzie jego, a nie twoja. Rozkazujesz %companyname% maszerować dalej. | Nie masz powodu mieszać %companyname% w politykę skłóconej szlachty. Więzień rozumiejąco kiwa głową. Unosi wysoko głowę, zanim go powieszą. | Kaci spoglądają na ciebie, być może wyczuwając, że mógłbyś wkroczyć i całkowicie zepsuć im dzień. Zamiast tego mówisz więźniowi, że to jego wybór przywiódł go tutaj. Kiwając głową, przyjmuje to ze spokojem. Kaci spieszą się, by go powiesić, na wypadek gdyby ten niebezpieczny przechodzień nagle zmienił zdanie.}",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "To nie była nasza wojna.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.deserter")
					{
						bro.worsenMood(0.75, "You didn\'t help a deserting lieutenant");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isCivilWar())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local bestDistance = 9000;
		local bestTown;

		foreach( t in towns )
		{
			if (t.isSouthern())
			{
				continue;
			}

			local d = playerTile.getDistanceTo(t.getTile());

			if (d <= bestDistance)
			{
				bestDistance = d;
				bestTown = t;
				break;
			}
		}

		if (bestTown == null)
		{
			return;
		}

		this.m.NobleHouse = bestTown.getOwner();
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"noblehouse",
			this.m.NobleHouse.getName()
		]);
	}

	function onClear()
	{
		this.m.NobleHouse = null;
		this.m.Dude = null;
	}

});

