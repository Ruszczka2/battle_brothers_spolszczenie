this.civilwar_warnings_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_warnings";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 3.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_76.png[/img]Spotykasz na ścieżce nieznajomego. Patrzy na ciebie stalowym wzrokiem, a obok niego stoją owce i psy.%SPEECH_ON%Hmm, nie szykujesz się czasem do walki dla %noblehouse%? Słyszałem, że oni i inne rody się kłócą. Nie wiem o co. Wiem tylko, że wpadną do mnie i powiedzą: '%randomname%, czemu nie pójdziesz walczyć dla nas, albo cię powiesimy', a ja powiem 'dobra', bo banda szlachciurów w złotych portkach rujnujących mi rok to część życia, a życie nie jest sprawiedliwe.%SPEECH_OFF% | [img]gfx/ui/events/event_91.png[/img]Kobieta na drodze staje przy kompani, gdy mijasz ją w marszu. Przygląda się twojemu sygnetowi.%SPEECH_ON%Hm, nie poznaję. Pewnie szlachta wkrótce wezwie was do usług.%SPEECH_OFF%Pytasz, co ma na myśli. Wzrusza ramionami.%SPEECH_ON%Jak słyszę, napuszone paniska wścieły się przez nieudaną królewską ślubną sprawę. Dużo gadania, że to znaczy wojnę czy inne gówno. Ci szlachcice zawsze o coś się żrą, tylko kwestia czasu, aż skrzyżują miecze, albo każą nam, biedakom, zrobić to za nich.%SPEECH_OFF% | [img]gfx/ui/events/event_17.png[/img]Stary człowiek siedzący i palący fajkę patrzy na twoją kompanię długim, mglistym spojrzeniem.%SPEECH_ON%Najemnicy, co? Będzie dla was sporo dobrej roboty w nadchodzących dniach.%SPEECH_OFF%Pytasz, co ma na myśli. Czyści fajkę, stukając nią o piętę.%SPEECH_ON%No wiesz. Szlachta w piórach znów się puszy. Wojna nadchodzi, bez dwóch zdań - nie można zmarnować takiej pogody.%SPEECH_OFF% | [img]gfx/ui/events/event_75.png[/img]Posłaniec mija ścieżkę, z pustą torbą na listy.%SPEECH_ON%Ach, nie mam już nowin, ale mam plotki, jeśli cię interesują.%SPEECH_OFF%Kiwasz głową. Uśmiecha się.%SPEECH_ON%Tak myślałem. Czasem szlachta wzywa mnie, by dać mi pisma do rozesłania. Czasem taki maluczki ja podsłuchuję ich rozmowy. A to, co słyszę, to dużo gadania o wojsku, dużo gadania w stylu 'musimy podbić tych skurczybyków'. Więc, najemniku, szykuj się na niezły interes już niedługo.%SPEECH_OFF% | [img]gfx/ui/events/event_97.png[/img]%SPEECH_ON%Psst. Psst! Hej!%SPEECH_OFF%Odwracasz się i widzisz chłopaka wyglądającego z krzaków. Uśmiecha się do ciebie.%SPEECH_ON%Hej, mam coś do powiedzenia. Nadchodzi wojna.%SPEECH_OFF%Uważając, że ten zadziorny smarkacz nie jest wysoko na twojej liście spraw, pytasz, skąd to wie. Uśmiecha się znowu.%SPEECH_ON%Noszę wodę dla faceta w jedwabnych portkach. Powiedział: 'Mogę dać ci słodycze albo coś do myślenia.' Powiedziałem, żeby mi powiedział coś dobrego. Powiedział: 'szlachta będzie walczyć między sobą.' To właśnie ci mówię.%SPEECH_OFF%Chłopak robi pauzę.%SPEECH_ON%Powiedz, nie masz może słodyczy? Hej... hej!%SPEECH_OFF%Wpychasz jego głowę z powrotem w krzaki. | [img]gfx/ui/events/event_75.png[/img]Na drodze spotyka cię stary mężczyzna i jasnoskóra dziewczyna. Kręci warkocz na ramieniu, zerkając uwodzicielsko na kilku twoich przystojniejszych ludzi. Zanim zdążysz coś powiedzieć, pyta, czy będziesz walczył dla %noblehouse% czy %noblehouse2%.%SPEECH_ON%Mówią, że książę uciekł z księżniczką, powiedział, że to z miłości. Czyż to nie marzenie?%SPEECH_OFF%Wzruszasz ramionami. Starszy mężczyzna odchrząkuje i spluwa.%SPEECH_ON%Nie zawracaj najemnikom głowy swoimi fantazjami, kobieto. Wybacz, najemniku, przychodzą jej te pomysły do głowy i nie wiem skąd. Rody mówią o wojnie, ale to, do cholery, nie o jakiegoś tańczącego księcia czy jakiegoś fajtłapowatego księżniczka. Ekonomia! O to chodzi. Wieloletnie umowy handlowe sypią się jak papier, na którym je zapisano. Powiem ci, byłem tam, kiedy oni...%SPEECH_OFF%Stary pierdziel ciągnie bez końca. Wolałeś historię dziewczyny, jakkolwiek absurdalna by była. | [img]gfx/ui/events/event_75.png[/img]Spotykasz człowieka siedzącego na drogowskazie. Naciąga struny lutni i sprawdza brzmienie.%SPEECH_ON%Mhm, to było lepsze, prawda? Po prostu przytaknij.%SPEECH_OFF%Kiwasz głową i pytasz, co robi. Zeskakuje z drogowskazu i ląduje z rozłożonymi rękami i nogami jak błazen na końcu występu.%SPEECH_ON%Ćwiczę! Wojna nadchodzi, słyszałem to na wietrze, a z wojną przychodzi potrzeba... potrzeba... potrzeba... no dalej, dasz radę, rozrywki! Właśnie! A każde wezwanie do nocnych uciech to wezwanie dla mnie - i na więcej niż jeden sposób, mówię ci.%SPEECH_OFF%Kręci piruet i uśmiecha się. Nigdy nie widziałeś człowieka z bielszym uśmiechem i masz silną ochotę go bardzo przyciemnić. Minstrel podskakuje ścieżką.%SPEECH_ON%Nie martw się, najemniku, gdy szlachta walczy między sobą, nigdy nie zabraknie pracy dla ludzi o twoich, eee, talentach. Bądź zdrów!%SPEECH_OFF% | [img]gfx/ui/events/event_16.png[/img]Coraz częściej spotykasz chłopów i kupców, którzy szepczą o wojnie między rodami. Jako najemnik słyszysz pytania, po której stronie zamierzasz nieść swój sztandar. Jeśli te plotki są prawdziwe, %companyname% może zbić niezłą monetę na nieszczęściu zadawanym przez napuszonych możnych. | [img]gfx/ui/events/event_45.png[/img]Na drodze spotykasz grupę hazardzistów. Ustawili małe flagi przedstawiające wszystkie szlacheckie rody krainy. Bukmacher zapisuje notatki i zagląda w zwój.%SPEECH_ON%Pamiętajcie, wynik tej wojny między rodami przez jakiś czas nie będzie oczywisty. Do diabła, większość z was zostanie wcielona. Ale wszyscy, którzy przeżyją, wrócą do mnie za rok. Wtedy wypłacimy pieniądze tym, którzy postawili na zwycięski ród. Umowa?%SPEECH_OFF%Chłopi o krzywych twarzach i obwisłych szczękach wzruszają ramionami.%SPEECH_ON%Brzmi jak umowa!%SPEECH_OFF%Bukmacher szczerzy zęby, złoty siekacz lśni ledwie zauważalnie.%SPEECH_ON%Świetnie!%SPEECH_OFF%Zbiera zakłady do sakwy i rusza w drogę, najpewniej już nigdy nie wracając. Szkoda, w jakie brednie potrafią wpakować się niskorodni. | [img]gfx/ui/events/event_75.png[/img]W trakcie podróży wciąż słyszysz szczególnie interesującą plotkę: rody szykują się do wojny. Jeśli to prawda, %companyname% może zarobić dużo monet, szczególnie jeśli wybierze zwycięską stronę. | [img]gfx/ui/events/event_23.png[/img]Chłop za chłopem powtarza ostatnio tę samą historię. Właściwie wydaje się, że powtarzają ją za każdym razem, gdy ich spotykasz...\n\n Wojna. Wojna jest na ich ustach. Rody szlacheckie kłócą się o coś, co mało cię obchodzi, ale to znaczy wojnę, a wojna to korony dla najemnika, a korony są dobre, więc wojna jest dobra. Jeśli te plotki są prawdziwe, %companyname% powinno rozważyć swoje opcje i wybrać ród, który wesprze w nadchodzącym konflikcie. | [img]gfx/ui/events/event_80.png[/img]Zauważyłeś, że rekruterzy rodów są w ruchu, wyciągając młodych, świeżych mężczyzn z domów. Pobór nie jest niczym niezwykłym, ale zwykle wciąż potrzebujesz chłopów do uprawy pól. Jeśli możni zostawiają to kobietom, oznacza to, że coś innego ma większe znaczenie, a tym czymś jest niewątpliwie nadciągająca wojna. %companyname% powinno przygotować się na najgorsze - cóż, najgorsze dla wszystkich innych. Wojna między bogatymi dupkami to najlepszy czas, by być najemnikiem!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze wiedzieć.",
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
		if (this.World.FactionManager.getGreaterEvilType() == this.Const.World.GreaterEvilType.CivilWar && this.World.FactionManager.getGreaterEvilPhase() == this.Const.World.GreaterEvilPhase.Warning)
		{
			local playerTile = this.World.State.getPlayer().getTile();

			if (!playerTile.HasRoad)
			{
				return;
			}

			if (this.Const.DLC.Desert && playerTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
			{
				return;
			}

			local towns = this.World.EntityManager.getSettlements();

			foreach( t in towns )
			{
				if (t.isSouthern())
				{
					continue;
				}

				if (t.getTile().getDistanceTo(playerTile) <= 4)
				{
					return;
				}
			}

			this.m.Score = 80;
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		_vars.push([
			"noblehouse",
			nobles[0].getName()
		]);
		_vars.push([
			"noblehouse1",
			nobles[0].getName()
		]);
		_vars.push([
			"noblehouse2",
			nobles[1].getName()
		]);
	}

	function onClear()
	{
	}

});

