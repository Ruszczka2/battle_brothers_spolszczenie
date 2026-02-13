this.traveler_south_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.traveler_south";
		this.m.Title = "Wzdłuż drogi...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_171.png[/img]{Napotykasz mężczyznę wędrującego po pustyni z rodziną młodszych mężczyzn u boku. Zaprasza cię do ogniska i pyta, czy chciałbyś posłuchać opowieści o pustyni i południu w ogóle.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Chętnie dołączę do ogniska.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Nie, trzymajcie się z daleka.",
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
			ID = "B",
			Text = "[img]gfx/ui/events/event_26.png[/img]{Mężczyzna zaczyna mówić o Starożytnym Imperium - przynajmniej o tym, co o nim wie.%SPEECH_ON%Trudno powiedzieć, czym dokładnie było, wiesz? I trudno powiedzieć, co było przed nim. Miałem wgląd do bibliotek %randomcitystate% i byłem zdumiony tym, co znalazłem. Wiesz, jakie są najstarsze teksty, jakie mamy? Starożytne teksty. Wiesz, o czym piszą te starożytne teksty? O innych starożytnych tekstach. Nie mamy pojęcia, jak daleko sięga naprawdę nasza oś czasu. Istniejemy tu i teraz, a może kiedyś w przyszłości nasze potomstwo uzna, że to my jesteśmy tajemnicą, a te tajemnice, które były dla nas?%SPEECH_OFF%Przecina palcami powietrze.%SPEECH_ON%Znikną.%SPEECH_OFF% | Grzebie żelaznym pogrzebaczem w ognisku.%SPEECH_ON%Mówią, że ifryty są przejawami ludzkiego okrucieństwa. Że gdy jesteśmy źli dla siebie nawzajem, istnieje siła, niewidzialna siła, na którą naciskamy. Kiedy atakujemy i mordujemy na większą skalę, ta siła wygina się na całym szwie, ale gdy czynimy zło jednej osobie, do tak strasznych skutków, wtedy ta siła pęka. Powstaje dziura, a z tej dziury wychodzi korekta. Korekta, którą nazywamy ifrytem. Korekta, która próbuje naprawić, dosłownie zszywając te niewidzialne siły ciałami tych, którzy odważyli się je otworzyć.%SPEECH_OFF%Mężczyzna odkłada pogrzebacz. Uśmiecha się ponuro.%SPEECH_ON%Tak mówią, przynajmniej.%SPEECH_OFF% | Mimo że jest stary, zakłada nogę na nogę z gibkością i zwinnością młodszego. Z pewnością siedział przy niejednym ognisku. Mówi tak ciepło jak płomienie przed tobą.%SPEECH_ON%Spędziłem na tych piaskach wiele lat. Ale moi synowie, których przeżyłem, muszę ze smutkiem powiedzieć, pytali: jak mierzymy czas od sezonu do sezonu? Jakim znakiem oznaczamy lata?%SPEECH_OFF%Podnosi pomarszczony palec i wskazuje wyżej. Mruga do ciebie.%SPEECH_ON%Gwiazdy. Toczą się po niebie we wzorach, które można rozpoznać, jeśli tylko się uważa. Wyobrażam sobie też, że te gwiazdy mogą być istotami z innego eteru, z innego, niewyobrażalnego miejsca. Może gdzieś tam trafimy po śmierci, ale to tylko pogłoski, i tylko między nami, rozmyślającymi wędrowcami, tak?%SPEECH_OFF% | Mężczyzna popija napój z kubka o nieznanym pochodzeniu i materiale. Wącha napój i znów popija, po czym odstawia go i rozciąga się.%SPEECH_ON%Wiesz, nawet trochę czekam na koniec mojej Złoconej ścieżki. Była dla mnie dobra przez te wszystkie lata, ale czuję, że stąpam po kłębie tego okropnego świata i im szybciej odejdę, tym lepiej. Mam wrażenie, że jeśli zostanę zbyt długo, świat odkryje, że przemknąłem bokiem, z paragonem w ręku, i że żyłem dobrze, podczas gdy rzekomo na liście miałem cierpienie.%SPEECH_OFF%Pytasz, czemu tak sądzi. Wzrusza ramionami.%SPEECH_ON%Instynkt. Ty też go masz, Koroniarzu, jestem tego pewien. W końcu, jak docierasz tak daleko, gdy inni, tacy jak ty, toczą się przez trwogi i okropności, a w końcu śmierć? Gdzieś na świecie jest licznik, wielki księgowy, może to Gilder, może coś innego, ale życie nie jest stworzone do niekończącego się dobra. W pewnym momencie, w końcu, nadejdzie jedna wielka, zła chwila.%SPEECH_OFF% | Gdy się usadawiasz, stary człowiek odchyla się, jakbyś był starym przyjacielem, i zaczyna mówić.%SPEECH_ON%Ciekawe jest dla mnie widzieć cię tutaj, Koroniarzu, ubranego w regalia rozbójnictwa, że tak powiem. Tu są prości ludzie w prostych czasach. Ale zakładam, że jesteś świadomy znacznie większej przeszłości, tak jak ja. Poczucie, że przed nami był długi, długi ciąg wydarzeń.%SPEECH_OFF%Przytakujesz. To wydaje się oczywiste. Mężczyzna przytakuje w odpowiedzi.%SPEECH_ON%To dobrze. Pokazuje ciekawską naturę w tobie, nawet jeśli tylko w uznaniu, że wiele przemierzało te piaski przed nami. Wielu... wielu w ogóle tego nie rozważa. Żyją tu i teraz. W pewnym sensie im zazdroszczę. Jak to musi być istnieć jako ktoś, i tylko ktoś, z całym światem u stóp.%SPEECH_OFF%Kładzie się i patrzy w niebo.%SPEECH_ON%Myślę, że większość ludzi naprawdę nie wierzy, że umrze.%SPEECH_OFF% | Siadasz, a stary człowiek odchyla się z księgą w dłoni, częściowo zwoje, częściowo oprawa. Czyta, od czasu do czasu podnosząc wzrok. Nie masz pojęcia, czy mówi z tekstu, czy jego natura potrafi prowadzić jednocześnie dwie różne myśli.%SPEECH_ON%Wiesz, jak upadło Starożytne Imperium? Mówią, że to był wielki wybuch z samej ziemi.%SPEECH_OFF%Naśladuje rękami eksplozję z piasków.%SPEECH_ON%Wulkan. Ale to brzmi zbyt prosto, prawda? Jeden wulkan wymazuje całe imperium?%SPEECH_OFF%Mówisz, że najlepszy najemnik, jakiego masz, mógłby zostać okaleczony przez niewielkie nacięcie z tyłu pięt. Nie mógłby już dobrze chodzić, skręcać, obracać się ani dźwigać ciężaru na stopach, rozpadłby się od dołu. Stary człowiek patrzy na ciebie.%SPEECH_ON%Hmm, to może być racja. Być może ten wulkan zniszczył to, jak niewielką kontrolę to imperium miało nad sobą. A potem... kto wie, co się stało. Chaos, zapewne. To słodkie małe coś.%SPEECH_OFF% | Siadasz, a mężczyzna zaczyna mówić niemal natychmiast.%SPEECH_ON%Słyszałem pogłoski o krążącym kulcie. Coś o \'Davkulu\'. Cóż, powiem tak: brzmią na szczerą bandę.%SPEECH_OFF%Pytasz, czy ma jakąś wiedzę poza pogłoskami. Wzrusza ramionami.%SPEECH_ON%Tylko tyle, że to kult śmierci i nie powstał tutaj. Przynajmniej nigdy nie usłyszysz, by południowiec przyznał, że to tworzenie Davkula zaczęło się tutaj. Nie, nie, musieli to wymyślić ci łajdacy z północy, żeby stworzyć tak makabryczną ideę boga śmierci.%SPEECH_OFF%Uśmiecha się figlarnie. Wnioskujesz, że nie ma osobistej stawki w tym temacie i rzucił to tylko po to, by zobaczyć twoją reakcję. | %SPEECH_ON%Tak, tak, usiądź już.%SPEECH_OFF%Siadasz, a mężczyzna zaczyna mówić od razu.%SPEECH_ON%Jedną z dziwnych natur pustyni jest to, że jednocześnie zachowuje i wymazuje wszystko. Rozumiesz, co mam na myśli? Gdybyś umarł, piaski połknęłyby cię w całości, ale ty, twoje ciało, nigdy by naprawdę nie zniknęło. Byłbyś pogrzebany. Gdybyśmy zaczęli drapać się w piasek wokół nas, na pewno znaleźlibyśmy ciała i skarby, a niektórzy mówią nawet o całych miastach.%SPEECH_OFF%Machasz ręką, ale mężczyzna podnosi palec.%SPEECH_ON%Tsk tsk tsk, nie bądź tak pobłażliwy, Koroniarzu. To głodny świat i, niech moja ścieżka będzie Złocona, całkiem możliwe, że wszystkie te miasta, które znamy dziś, wkrótce znikną.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Niech twoja ścieżka zawsze będzie Złocona.",
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
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.SquareCoords.Y >= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 6)
			{
				return;
			}
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
	}

});

