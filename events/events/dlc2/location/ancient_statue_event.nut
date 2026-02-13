this.ancient_statue_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.ancient_statue";
		this.m.Title = "Gdy się zbliżasz...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_116.png[/img]{Złoty człowiek wielkości zamku siedzi na kamiennym tronie z tak dostojną postawą, że nawet on, choć nieożywiony, zdaje się powinien rządzić krainą. A może świat byłby od tego lepszy, ten niemy byt o tak imponującej prezencji byłby lepszym władcą niż ta banda skunksów, na którą ciągle wpadasz. Ciężar posągu spoczywa na ogromnym kręgu ze spiralnie ułożonych kwadratowych kamieni. Gdyby to były trumny, wystarczyłyby dwa ceglane bloki, by pomieścić całe %companyname%. %randombrother% unosi hełm.%SPEECH_ON%Jeśli to nie największa rzecz, jaką widziałem, to nie wiem, co jest.%SPEECH_OFF%%randombrother2% uśmiecha się szyderczo i sięga do krocza najemnika.%SPEECH_ON%Myślałem, że kobiety mówiły, iż ten mały robaczek to największa rzecz, jaką kiedykolwiek widziały!%SPEECH_OFF%Gdy kompania się śmieje, robisz krok do przodu i spoglądasz w górę. Nie jesteś skłonny do klękania, ale tutaj czujesz taką potrzebę. Posąg spogląda na świat z twardym autorytetem, a jego dłonie są rozłożone po bokach, jedna spoczywa na mieczu wbitym w ziemię, a druga jest odwrócona do góry, jakby ważyła samą sprawiedliwość. Kiwasz głową na złoty blask przed tobą. To, że nie ma ani jednej rysy po rabusiach, sugeruje, że jego surowa obecność wciąż ma jakiś eteryczny wpływ na świat. Ale to nie ma sensu. Każdy rozumny człowiek ukradłby choćby część złota z samych goleni posągu. Kilku najemników pyta, czy mogą spróbować zebrać trochę złota dla siebie.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie ma w tym nic złego.",
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
			Text = "[img]gfx/ui/events/event_116.png[/img]{Posąg jest tak ogromny, że być może odstraszył drobniejszych łotrów samą przesądnością. Nie masz powodu, by odpuścić coś dobrego, jak niemal niekończący się stos złota uformowany w coś 'ładnego'. Niech diabli wezmą historię i kunszt. Mówisz ludziom, by brali. Skaczą do roboty z dostępnymi narzędziami, ale w chwili, gdy %randombrother% dotyka posągu, bezwładnieje i osuwa się o niego. Inny najemnik próbuje mu pomóc, muskając ogromny palec u stopy, i pada na sprzedawcy miecza. Gdy kompania zaczyna panikować, obaj najemnicy zrywają się na nogi i zaczynają krzyczeć o niesamowitych widokach, widokach poza tym światem, widokach samej przyszłości!\n\n Ożywiona tym kompania z radością wpada w posąg, wszyscy uderzają w jego olbrzymie palce u stóp i przewracają się jak mimowie, którzy niespodziewanie trafili na bardzo prawdziwą ścianę. To najbardziej absurdalna rzecz, jaką widziałeś, ale każdy z mężczyzn zrywa się na nogi, opowiadając fantastyczne historie. Wzruszasz ramionami i sam podchodzisz do posągu, stając przed wielkim palcem u stopy z wielkim paznokciem. Ludzie zachęcają cię do przodu. Wzdychasz, wyciągasz rękę i dotykasz paznokcia. Nic. Nic się nie dzieje. Wkładasz pięść w szczelinę między paznokciem a złotym ciałem. Ze złością przykładasz obie dłonie do palca, jakby był ci winien pieniądze. Nic. No dobrze. Wygląda na to, że masz bogactwo do zebrania. Dobijasz miecza...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Czas dorwać złoto.",
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
			Text = "[img]gfx/ui/events/event_116.png[/img]{Zamachujesz się mieczem, ale w chwili, gdy stal dotyka złota, blask świata rozbłyskuje nad tobą, jakbyś uderzył w samo słońce i sprawił, że krwawi. Miecz leci dalej w ciemność jak gwiazda po nocnym niebie i rozcina własny świat w rzeczywistość, jakbyś odciął płachtę sztuczki maga, odsłaniając pokój z kolumnami w narożach i pięknymi jedwabnymi zasłonami. Miecz wciąż pędzi, aż uderza o drzewce włóczni. Spoglądasz w dół i widzisz mężczyznę w złoconej zbroi i czerwonych oczach, trzymającego gardę z grymasem. Przesuwa się po kafelkach w prawo, pozwalając twojemu impetowi opaść, po czym obraca włócznią za plecami i uderza nią do przodu. Rozrzucasz ramię i skracasz dystans z zabójcą, chwytając drzewce włóczni pod pachą i pchając do przodu, by dźgnąć go tuż pod naramiennikiem, wbijając miecz w serce. Czerwone oczy mężczyzny bledną do czystej bieli, a on wiotczeje i zsuwa się z ostrza.\n\n Gdy uderza o ziemię, szybko rozglądasz się. Przy dalekiej ścianie stoi ogromne łoże z marmurowymi narożami, każda figura ukształtowana na kobietę lub mężczyznę, każda ozdobiona posłusznie dla czegoś, co wygląda jak wschodzące słońce. Na łóżku leży starszy mężczyzna, który na ciebie patrzy. Brodaty. Oczy przygaszone, zmęczone. Znajomość w jego spojrzeniu. Uśmiecha się, ale szybko gaśnie. Krzyczy, lecz nie rozumiesz słów. Cień przesuwa się przez pokój, odwracasz się i widzisz wielkiego rycerza z ogniem w oczach, który naciera z dwuręcznym mieczem.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Paruj!",
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
			Text = "[img]gfx/ui/events/event_116.png[/img]{Cofasz się, obracasz miecz w poprzek i przykucasz w kolanach, by przyjąć uderzenie. Dwuręczny miecz zabójcy wali w twoją klingę i w tej samej chwili świat się urywa, a ty, wciąż zastygły w parze, czujesz, jak czas i przestrzeń przelatują obok ciebie jak pługowy wiatr, a także nieludzkie ilości cierpienia, krzyku, życia i śmierci, i w oddali punkt światła, który szybko się zbliża, aż wracasz do własnego ciała, a twój miecz uderza w posąg i odbija się tak mocno, że wylatuje z rąk i szybuje w powietrzu, aż wbija się w ziemię z bryłą gruntu. Ludzie spoglądają na siebie. Idziesz po miecz.%SPEECH_ON%Chyba go zepsułeś, panie.%SPEECH_OFF%Mówi %randombrother%, macając mały palec u stopy. Mówisz jemu i reszcie ludzi, by spakowali rzeczy, czas stąd odejść. Patrząc na posąg, widzisz, że jest teraz cały zardzewiałym brązem. Myślisz, by zapytać jednego z najemników, czy wcześniej był złoty, ale już znasz odpowiedź. Zamiast tego wpatrujesz się w głowę posągu. W twarz. W tę bardzo znajomą twarz.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie roztrząsajmy tego.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.improveMood(1.5, "Pod wrażeniem wspaniałego posągu z dawnych czasów");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
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

