this.greenskins_warnings_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.greenskins_warnings";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 3.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_49.png[/img]Wychodzisz z namiotu i widzisz płonące pustkowie. Co nie jest ogniem, jest sczerniałe po jego przejściu, co nie jest martwe, krzyczy, gdy płomienie pożerają ciało. Wśród smogu tej ruiny maszeruje strumień tęgich orków, a u ich boków ciągną się skuci ludzcy niewolnicy, zaś rój goblinów skacze dookoła, rozkoszując się chaosem. I... %randombrother%? Najemnik szturcha cię i ten płonący świat znika w jednej chwili. Zostaje tylko stojący nad tobą najemnik.%SPEECH_ON%Przepraszam, że budzę, panie, ale twoje posłanie zajęło się od dogasającej świecy. Ugasiłem je, zanim zrobiło krzywdę. Hej, wszystko w porządku?%SPEECH_OFF%Kiwasz głową i mówisz mu, by się oddalił i przygotował ludzi na kolejny dzień marszu. Próbujesz wyrzucić z głowy wspomnienie snu, ale ono trwa, jakby nie miało zostać zapomniane. | [img]gfx/ui/events/event_76.png[/img]Z linii drzew obok ścieżki wybiega mężczyzna. Ma na sobie łachmany, a połowa policzka jest rozszarpana, język bezwładnie podskakuje i nie potrafi wydobyć nic poza gardłowymi krzykami i desperackimi błaganiami. %randombrother% odskakuje, gdy mężczyzna próbuje się na niego rzucić. Dobywasz miecza, ale obcy po prostu pada na ziemię, jego plecy są naszpikowane strzałkami, a skóra wokół grotów już pulsuje zielenią trucizny.\n\n Kompania przez jakiś czas pozostaje czujna, ale nic więcej się nie pojawia. Panuje ogólna zgoda, że to musiała być robota zielonoskórych, choć widać ślady zarówno orków, jak i goblinów... | [img]gfx/ui/events/event_97.png[/img]Podchodzi młody chłopak, a obok niego kłusuje pies. Zatrzymuje się przed kompanią, klepiąc kundelka po łbie.%SPEECH_ON%Wy żołnierze po zielonych? Wysokich trudno zabić, tak słyszałem, a niscy to sprytna zgraja.%SPEECH_OFF%Pytasz, skąd pochodzi. Wzrusza ramionami.%SPEECH_ON%Daleko, daleko stąd. Jestem wędrowcem, panowie, ja i mój pies. Ale sporo widziałem w podróżach.%SPEECH_OFF%%randomname% wychodzi do przodu.%SPEECH_ON%Mówisz, że widziałeś orków i gobliny działające razem?%SPEECH_OFF%Chłopak kiwa głową.%SPEECH_ON%Tak! A czemu nie? Heh, no cóż, nie jesteście tymi, za których was brałem. Niech wasze dni będą długie, noce krótkie, a sny tak długie, jak chcecie.%SPEECH_OFF%Wchodzi w stojące zarośla. Ruszasz za nim, ale gdy przebijasz się na drugą stronę, chłopak i pies zniknęli. | [img]gfx/ui/events/event_94.png[/img]Najpierw słyszysz muchy, zanim zobaczysz spustoszenie, które obsiadły. Mała chatka, proste drewniane podpory, ładny strzechowy dach, kilka garnków wiszących na sznurkach, łapacz snów kręcący się na wietrze, drewniane dzwonki, które miały przynieść odrobinę radości, i trzy okaleczone ciała w trawie, chmura owadów kłębiąca się na zwłokach. %randombrother% kuca przy jednym, dłubiąc w kościach wystających z krwawej masy.%SPEECH_ON%To musiały być orki. Ślady zdecydowanie na to wskazują.%SPEECH_OFF%Kiwasz głową, ale zauważasz kilka strzałek wbitych w drzwi chaty. Zdejmujesz jedną i wąchasz.%SPEECH_ON%Trucizna. Było tu więcej niż tylko orki.%SPEECH_OFF%%randombrother% wącha jedną ze strzałek i kiwa głową.%SPEECH_ON%Tak, orki i gobliny. Współpracują? Mam nadzieję, że nie.%SPEECH_OFF%Byłaby to katastrofa, ale na razie zadowalasz się myślą, że wszystkie te dowody są tylko zbiegiem okoliczności. | [img]gfx/ui/events/event_02.png[/img]Patrzysz na mapę, a potem na scenę przed tobą.%SPEECH_ON%Tu powinna być osada.%SPEECH_OFF%%randombrother% mija cię, chrupiąc jabłko z satysfakcją.%SPEECH_ON%Mhm, może warto nanieść poprawki, panie.%SPEECH_OFF%Wioska to już tylko popiół. Jej mieszkańcy wiszą na drewnianych palach albo na drzewach, które jeszcze stoją. Kości tych, których nie powieszono, leżą w stercie pośrodku tego, co zapewne było rynkiem. Wpatrując się w ziemię, widzisz ślady stóp prowadzące od rzezi. Małe i duże. Gobliny, orki. %randombrother% kręci głową.%SPEECH_ON%Na pewno nie współpracują, prawda?%SPEECH_OFF%Wzruszasz ramionami i odpowiadasz.%SPEECH_ON%Jestem pewien, że orki przeszły tędy, a potem gobliny przyszły i ogołociły resztki, albo odwrotnie.%SPEECH_OFF%Najemnik kiwa głową, uspokojony twoim wyjaśnieniem, choć obaj głęboko wiecie, że zebrane ślady najpewniej nie są przypadkiem. | [img]gfx/ui/events/event_97.png[/img]Spotykasz dzieciaka kucającego przy korycie strumienia. Patykiem rysuje w błocie postacie - małych ludzików z wielkimi rogatymi hełmami i mniejszych obok nich, choć nawet te mniejsze wyglądają na dobrze uzbrojone i opancerzone. %randombrother% pyta szkraba, co właściwie robi.%SPEECH_ON%Rysuję zielonych. Widziałem ich dużo, biegają i rozłażą się po wzgórzach, jak szczury w otwartej spiżarni, jak mówi mój tata.%SPEECH_OFF%Pytasz, gdzie mieszka. Wskazuje na zalesione zbocza pobliskiego wzgórza.%SPEECH_ON%Tam. Mam dobry widok na to, co nadchodzi. Pewnie wy też z czasem będziecie mieć.%SPEECH_OFF%Stary mężczyzna woła dzieciaka, a ten posłusznie porzuca swoje prymitywne narzędzia sztuki i rusza ku wzgórzu.%SPEECH_ON%Muszę do roboty. Bawcie się dobrze! I nie depczcie moich rysunków!%SPEECH_OFF%Dopiero teraz uświadamiasz sobie, że patyczkowe postacie to orki i gobliny, ale może dzieciak po prostu bawi się w fantazję. | [img]gfx/ui/events/event_36.png[/img]Znajdujesz faceta przy drodze, który obejmuje ramiona na piersi. Obie dłonie wyglądają na utracone. Patrzy na ciebie, a impet pcha go do tyłu, biedak pada na plecy i patrzy w niebo, machając kikutami przedramion.%SPEECH_ON%Współpracują. Zabijali... Zabili wszystkich. Nie mogłem w to uwierzyć. Zawsze mówiłem, że jeśli przyjdą, będę gotów, na jednych albo drugich. Ale byli tam. Razem.%SPEECH_OFF%Pytasz, o kim lub o czym mówi. Klatka piersiowa mężczyzny ściska się, ból krzywo przesuwa się po jego twarzy i bierze ostatni oddech. Odbite niebo łukiem lśni w jego otwartych oczach, wszystko do zobaczenia w ślepocie śmierci. %randombrother% sprawdza ciało, ale nie ma nic do zabrania. | [img]gfx/ui/events/event_95.png[/img]Totem z czaszek, skórzane płaty trzepoczące na segmentach, każda głowa nosi pelerynę, upiornie wykonaną z własnej skóry. Krew pryska i zalewa ziemię. Więcej kości. Mięśnie i ścięgna, rzeczy nieużyte lub niepożarte. Spalona ziemia, gdzie stało ognisko, i rozsypany popiół tam, gdzie dogasło. %randombrother% krąży po miejscu, szukając wskazówek. Podnosi drzewce topornej broni i kilka strzałek znalezionych w torbie z koziej skóry.%SPEECH_ON%To jest za duże na ludzką dłoń, a to są wyraźnie goblińskie strzały z, hmm, tak, trucizną. Zielonoskórni bez wątpienia tu byli i działali razem.%SPEECH_OFF%Razem? To przerażająca myśl, ale wygląda na prawdziwą. Czy dzikie plemiona coś knują? | [img]gfx/ui/events/event_71.png[/img]Docierasz do spalonych resztek chaty. Wśród rumowiska leżą szkielety, kości poszarpane i powykręcane w ostatnich, bolesnych spazmach. Kłódka leży w stercie popiołu obok tego, co miało być drzwiami, sugerując, że ludzie zabarykadowali się w środku, a napastnicy po prostu spalili wszystko. %SPEECH_ON%Panie, powinieneś to zobaczyć.%SPEECH_OFF%%randombrother% przywołuje cię. Stoi przed drzewem. Opiera się o nie martwy goblin, dłonie wyciągnięte i puste, z brzydkim wyrazem twarzy, a w piersi tkwi widły. Obok leży martwy ork z łopatą wystającą z czaszki. %randombrother% zastanawia się, czy pozabijali się nawzajem. Masz nadzieję, że tak, ale ich śmiertelne rany wyglądają raczej na dzieło człowieka, a jeśli to dzieło człowieka, możliwe, że zielonoskórni działali razem. Ta myśl przeraża cię do głębi. | [img]gfx/ui/events/event_59.png[/img]Uchodźcy na drodze, strumień ich, kobiety z niemowlętami owiniętymi i przywiązanymi na plecach i brzuchach, mężczyźni z widłami jako laski, bosi mnisi kreślący palcami w powietrzu obrzędy i szeptem odmawiający modlitwy. Próbujesz porozmawiać, ale oni cofają się z szeroko otwartymi oczami. W końcu starszy mężczyzna odzywa się cicho.%SPEECH_ON%Nie próbuj, panie, widzieli za dużo. Zielonoskórni... przyszli w nocy. Orki w wiosce, gobliny na zewnątrz, czekające, by urządzić zasadzkę na wszystkich uciekających. Milicja została wyrżnięta. Przeżyli tylko my, tchórzliwi, i to jedynie najszybsi z nas.%SPEECH_OFF%Pytasz mężczyznę, czy właśnie powiedział, że gobliny i orki działały razem. Kiwając głową, klepie cię po ramieniu.%SPEECH_ON%Tak, powiedziałem. Bezpiecznej drogi, nieznajomy.%SPEECH_OFF% | [img]gfx/ui/events/event_76.png[/img]Mężczyzna ubrany na pokaz i dla przyjemności stoi obok drogi. Wpatruje się przed siebie, dłonie rozstawione na boki, być może aby zrównoważyć zbyt dużo alkoholu w systemie. Chwytasz go i odwracasz. Jego twarz opada do przodu, oczodoły są puste, a strzępy jego wzroku zwisają po policzkach jak zgniłe raki. Dwie bezdłonne ręce uderzają cię po ramionach, gdy próbuje cię chwycić. Jego twarz wykrzywia się w gardłowym krzyku, który odzwierciedla barbarzyństwa, jakich doświadczył.\n\n %randombrother% błyskawicznie działa i ścina mężczyznę. Nieznajomy opada do tyłu, jego elegancki płaszcz z norek rozchyla się, ukazując zmasakrowane nagie ciało, i teraz uświadamiasz sobie, że wolałbyś widzieć męskie części, niż widzieć, że ich brakuje. Gdy uderza o ziemię, okaleczenia stają się jego zgubą, cięcia i rozdarcia otwierają ciało jak rozkładana układanka. Jego wnętrzności wybuchają przez szczeliny, rozwijając się w fioletowych sznurach i workach. Mężczyzna krzyczy.%SPEECH_ON%Orki! Gobliny! Orki! Gobliny! Orki! Gob... gobliny...%SPEECH_OFF%Uchodzi z niego oddech. Nie żyje, chwała starym bogom. Czy coś wynika z jego ostatnich słów?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To niepokojące...",
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
		if (this.World.FactionManager.getGreaterEvilType() == this.Const.World.GreaterEvilType.Greenskins && this.World.FactionManager.getGreaterEvilPhase() == this.Const.World.GreaterEvilPhase.Warning)
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
	}

	function onClear()
	{
	}

});

