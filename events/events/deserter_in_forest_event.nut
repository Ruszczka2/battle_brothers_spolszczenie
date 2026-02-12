this.deserter_in_forest_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.deserter_in_forest";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 200.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img]Gdy przedzierasz się przez las, ptaki nagle rozlatują się po niebie, potrząsając drzewami i gałęziami z przerażającą gwałtownością. Chwilę później przez krzaki wpada mężczyzna, bardziej jak wezbrana fala niż człowiek z krwi i kości. Zatrzymuje się, ten ziemisty golem, i błaga, byś go ukrył.%SPEECH_ON%Słuchaj, będę całkiem szczery. Jestem dezerterem. Tyle. Nie, znaczy, dobra, nie mam naprawdę żadnej obrony. Ale spójrz, kim jesteście? Najemnikami? Świetnie! Ukryjcie mnie, a będę walczył dla was do końca świata!%SPEECH_OFF%W połowie błagalnego wywodu słyszysz w oddali szczekanie psów. Mężczyzna instynktownie chowa się w leśnej jamce i szybko obsypuje ziemią. Kiwając głową, jakbyście już doszli do porozumienia.\n\n Łowcy nagród wychodzą zza linii drzew, a ich psy już węszą w pobliżu. Ich porucznik rozgląda się.%SPEECH_ON%Nawet nie próbuj mnie nabrać, najemniku. Wiem, że dezerter tędy przeszedł. Dwieście koron za jego głowę. Gdzie on jest?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jest tam, bierzcie go.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Co? Kto? Gdzie?",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_25.png[/img]Spluwasz i kręcisz głową.%SPEECH_ON%Nie mam zielonego pojęcia, o czym mówisz, łowco nagród.%SPEECH_OFF%Porucznik mierzy cię wzrokiem, patrząc na ciebie z mądrością starego człowieka.%SPEECH_ON%Dobrze, najemniku. Niech będzie. Wiem, że kłamiesz, ale niewiele mogę z tym zrobić.%SPEECH_OFF%Łowca nagród gwiżdże ostro i rozkazuje swoim ludziom ruszać. Psy krótko szczekają przy jamce, gdzie ukrył się dezerter. Śmiejąc się, porucznik szyderczo życzy ci powodzenia.\n\n Gdy łowcy odchodzą, dezerter wychodzi z kryjówki.%SPEECH_ON%Dziękuję, najemniku. Zawdzięczam ci życie! Nie pożałujesz tego, nigdy!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Lepiej, żebym tego nie żałował. Witamy w kompanii.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				},
				{
					Text = "Uciekaj dalej. Nie ma u nas miejsca dla dezertera.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"deserter_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "Znalazłeś dezertera %name%, ściganego przez las. Choć łowcy nagród deptali mu po piętach, postanowiłeś go bronić, a on za to złożył ci przysięgę.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_25.png[/img]Kiwasz głową w stronę kryjówki dezertera. Musiał trzymać na tobie jedno nieufne oko, bo natychmiast wyskakuje z jamy i ucieka. Psy bez trudu go dopadają, rzucają się na niego z psim okrucieństwem i wleką jego wrzeszczący tyłek po ziemi. Zanim zdążysz się choćby zaśmiać, łowca nagród wciska ci do dłoni worek koron.%SPEECH_ON%To połowa mojego udziału, ale gdyby nie to, że się tu napatoczyłeś, nie jestem pewien, czy złapalibyśmy tego przebiegłego drania.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Po prostu robię swoje.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(200);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Otrzymujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]200[/color] Koron"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.deserter")
					{
						bro.worsenMood(0.5, "You gave up a deserter to bounty hunters");

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
		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

