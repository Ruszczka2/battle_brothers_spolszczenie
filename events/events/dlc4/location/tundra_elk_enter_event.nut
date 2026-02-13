this.tundra_elk_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.tundra_elk_enter";
		this.m.Title = "Gdy się zbliżasz...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_142.png[/img]{Na jałowej tundrze znajdujesz doskonałe łowisko przy małym jeziorze, więc decydujesz się na krótki, jednodniowy wypad na zwierzynę.\n\nSzybko dostrzegasz sporego łosia skubiącego skąpą tundrową trawę. Gdy przygotowujesz strzał, szyja łosia sztywnieje, a pysk zastyga wprost. Kości trzaskają, kończyny wykrzywiają się w kabłąk, jakby ogarnęła je natychmiastowa śmierć, lecz zwierzę nie pada. Kłąb drży, po czym nabrzmiewa i przemieszcza się, jakby pod futrem toczyły się pięści. Nagle ciało rozdziera się i widzisz śliską, niebieską masę bulgoczącą między ranami. Nogi pękają, a tułów wznosi się wysoko, gdy długie, grube kości uderzają o ziemię, a robakowate, wężowate pasma mięśni owijają się wokół trzonów. Myślałeś, że łoś nie żyje, lecz jego paszcza jęczy dziko, gdy pysk rozdziera się od czubka do szczęki jak kwitnący kwiat. Wyłania się twarz zupełnie innego stworzenia, które wysuwa się naprzód, jakby zrodzone z samej krwi, którą przed chwilą zbierało. Gdy nowe monstrum odzyskuje siłę, unosi się na tylnych nogach i sięga dłońmi za siebie, by zedrzeć futro łosia niczym płaszcz. Krew i kości bryzgają.\n\nOhydna bestia trzy razy wyższa od człowieka obraca się i bada swoje kończyny, napina dłonie, trzaska kolanami i barkami, kręci głową na boki, a jej szerokie nozdrza falują jak u byka. Oczodoły są samą kością, a w środku pulsuje niebieska mgła jak trzaskające burze. Piękne poroże łosia zostało zastąpione potwornymi rogami. Z jego pyska wije się mroźne powietrze i widzisz, jak liście pobliskiego drzewa sztywnieją z zimna.\n\nMasz niepokojące wrażenie, że to monstrum wcale nie jest potworem, lecz ulotnym duchem, który objawia się, jak chce, rzeźbiąc się w świecie jako uosobienie chaosu i niewiele więcej. Gdy tak myślisz, bestia zwraca ku tobie głowę, zahacza długimi pazurami o kąciki kłowej paszczy i rozciąga wargi tak mocno, że kąciki mogłyby być jej uszami.%SPEECH_ON%Ach, to jest miejsce, w którym chcę być, to jest miejsce, w którym jestem szczęśliwy. Czemu patrzysz z takim strachem, czyż nie jestem tylko zwykłym jeleniem?%SPEECH_OFF%Przechyla głowę na bok, ślina spływa z dolnej wargi, a w oczach pojawiają się figlarne łzy. Słyszałeś opowieści o tej istocie, okrutnym koszmarze, którego północniacy nazywają Ijirokiem lub Bestią Zimy. Wiesz, że nie przyszedł tu recytować poezji i bawić się w gry. Dobijasz miecza, ale wtedy czyjaś dłoń klepie cię po ramieniu.%SPEECH_ON%Zawsze z tobą, kapitanie.%SPEECH_OFF%Odwracasz się i widzisz kompanię u swego boku, gotową do walki.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zniszczymy to!",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setAttackable(true);
							this.World.State.getLastLocation().setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						}

						this.World.Events.showCombatDialog(true, true, true);
						return 0;
					}

				},
				{
					Text = "Musimy stąd uciekać! Szybko!",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

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
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

