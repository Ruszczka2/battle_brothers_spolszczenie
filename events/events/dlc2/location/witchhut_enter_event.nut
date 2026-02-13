this.witchhut_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.witchhut_enter";
		this.m.Title = "Gdy się zbliżasz...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Zatrzymujesz się na leśnej polanie. Chata przed tobą stoi jak okruszek. Jest tak swojska i łatwa do zapomnienia, że zastanawiasz się, jak mogła przetrwać, ale może jej całkowita banalność i niepozorność są same w sobie rodzajem pancerza. Jednak jesteś na tym świecie wystarczająco długo, by ufać instynktowi, a teraz instynkt każe ci czekać.\n\n Wkrótce drzwi chaty otwierają się i wychodzi z niej starsza kobieta. Natychmiast macha w twoją stronę.%SPEECH_ON%Ty, i tylko ty.%SPEECH_OFF%Zdezorientowany pytasz, czemu tylko ty, albo dokładniej, czemu w ogóle miałbyś jej zaufać. Uśmiecha się.%SPEECH_ON%Bo wiem, o czym Fałszywy Król śni w nocy.%SPEECH_OFF%Najemnicy wokół ciebie odwracają się i pytają, co powiedziała. Unosisz dłoń i każesz im trzymać pozycję, podczas gdy ty pójdziesz porozmawiać z tajemniczą kobietą.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zostańcie tutaj i trzymajcie straż.",
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
			Text = "[img]gfx/ui/events/event_115.png[/img]{Wchodzisz z dobytym mieczem, by zobaczyć kobietę podającą ci miskę gulaszu. Sugeruje, że to tylko królik i ziemniaki, bardziej królik niż ziemniaki. Chowając miecz, bierzesz miskę i siadasz przy stole naprzeciw niej. W pobliżu płoną świece, na ścianach namalowano białe glify, a podobne kształty zwisają z sufitu jako łapacze snów. Kobieta opiera łokcie o stół. We włosy ma powplatane drobiazgi, klipsy z ptasich kości i piór. Ma twarz pooraną przez czas, choć jej oczy są zaskakująco młode, jak perły migoczące z głębin bagna.%SPEECH_ON%Wiedziałam, że wejdziesz, widmo przyjaciela, jak ćma do płomienia, szukając prawdy, której nie da się okiełznać.%SPEECH_OFF%Odsuwając miskę przez stół, pytasz, czy jest wiedźmą. Przytakuje i wpatruje się w ciebie, po czym kiwa raz jeszcze.%SPEECH_ON%Dobrze. Nie zabiłeś mnie, co znaczy, że myślisz. Jestem tak zwaną wiedźmą, ale jestem sama. Całkowicie sama. I ścigana przez inne. Możesz je nazwać moimi \'siostrami\', ale one wiedzą, kim jesteś, tak jak ja, i chcą twojej krwi. Czują ją, i dlatego chcę rozmawiać.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Czego chcesz?",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Kobieta wyciąga długi przedmiot owinięty w obrus i kładzie go na stole. Odsłania płótno, ukazując poszarpane obsydianowe ostrze z paskami skóry zamiast rękojeści.%SPEECH_ON%Przetnij ciało i krwaw na czerni. Heksy i ich marny kunszt przyjdą, a wtedy zabijesz je wszystkie. Potem będziemy rozmawiać. Najemnik i wiedźma, wiedźma i najemnik.%SPEECH_OFF%Pytasz, co z tego masz. Wiedźma rechocze.%SPEECH_ON%Ach, najemniku, nie zajmujesz się wiernością, tylko złotem, i przy sprytnym obrocie monetą wiesz, że przyjaciel może stać się wrogiem. Ale ja oferuję coś więcej. Prawdę, której nie widać, prawdę dla Fałszywego Króla.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Skoro już tu jesteśmy.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Czarne ostrze spoczywa w twojej dłoni, a twoje odbicie spoczywa poszarpane w jego kamiennych rowkach, rozciągnięte i wciągnięte w każdą szczelinę i krawędź. To zwykły kamień. Zwykły sztylet. Tylko tyle. Nie jest ciężki, a jednak czujesz wagę, jak kurz rzucony na grób; nie tyle ciężar tkwi w piasku, ile w samym geście. To ostrze jest albo stratą, albo zyskiem, i jest tylko jeden sposób, by się dowiedzieć, którym. Wiedźma kiwa głową. Ty kiwasz z powrotem i nacinasz ramię. Krew zbiera się na kamieniu, a twoje odbicie znika pod purpurą. Niemal warcząc, wiedźma pochyla się chciwie i dociska ostrze do skóry.%SPEECH_ON%Więcej. Więcej, najemniku. Więcej!%SPEECH_OFF%Tniesz ponownie i napinasz mięsień. Strumień uderza w kamień. Ona bierze nóż i przykłada na ranę nieskazitelnie czystą szmatę.%SPEECH_ON%Wystarczy, najemniku. Idź do swoich ludzi i przygotuj się.%SPEECH_OFF%Wstajesz i patrzysz na kobietę. Pytasz.%SPEECH_ON%A kiedy zabiję twoich wrogów, to znów porozmawiamy?%SPEECH_OFF%Uśmiecha się.%SPEECH_ON%W pewnym sensie, tak.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tak uczynię.",
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
			ID = "E",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Gdy wychodzisz na zewnątrz i informujesz kompanię, że nadchodzą wrogowie. Wkrótce widać, jak zgarbione kobiety idą między drzewami lasu, ich długie paznokcie drapią korę, a śliniące się wargi pociągają nosem i parskają rechotem. Pierwsza, która wychodzi, ma długą głowę w kształcie czółna. Z jej naszyjnika zwisa czaszka niemowlęcia, a skórzana torba podskakuje na biodrze, z sakiewki wystają dwie królicze łapy. Gapi się na chatę i węszy powietrze, po czym przenosi wzrok na ciebie.%SPEECH_ON%A więc zawarłeś przymierze z tą suką?%SPEECH_OFF%Kiwasz głową.%SPEECH_ON%Umowa została zawarta, tak, i skończy się tym, że zginiesz na końcu tego ostrza. A z tego, co wiem, woli być nazywana po prostu \'wiedźmą\'.%SPEECH_OFF%Inna heksa wychodzi naprzód.%SPEECH_ON%Wolimy nazywać ją kurwą. Zabić najemników. Kapitana wziąć żywcem, ale wydrzeć mu oczy i ten parszywy jęzor.%SPEECH_OFF%Gromada wiedźm rzuca się naprzód, część już przeistacza się w lubieżnie wyglądające młódki, podczas gdy inne kręcą ramionami w rytualnych obrządkach.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Do boju!",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setAttackable(true);
						}

						this.World.State.getLastLocation().setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.World.Events.showCombatDialog(true, true, true);
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

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
	}

});

