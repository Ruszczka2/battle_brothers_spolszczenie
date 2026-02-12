local gt = this.getroottable();

if (!("Strings" in gt.Const))
{
	gt.Const.Strings <- {};
}

gt.Const.Strings.PayTavernRoundIntro <- [
	"Ludzie wychwalają twoje imię podczas picia.",
	"Ludzie piją za poległych kompanów.",
	"Ludzie wychwalają nazwę kompanii podczas picia.",
	"Ludzie piją za kobiety i ich łona.",
	"Ludzie piją za lojalne psy wojenne.",
	"Śmiechy i lekkoduszne opowieści wypełniają gospodę, gdy twoi ludzie raczą się napitkami.",
	"Ciężkie życie najemnika schodzi na dalszy plan, gdy ludzie dzielą się opowieściami o ich minionych zajęciach, dobrze się przy tym bawiąc.",
	"\'Niech żyje dowódca!\', wykrzykują ludzie.",
	"Twoi ludzie podczas picia przechwalają się swymi dokonaniami.",
	"Mocne napitki sprawiają, że okropieństwa walki rozmywają się i bledną na jakiś czas.",
	"Twoi ludzie wiwatują i wznoszą toasty za bogactwa i długie życie.",
	"Piwo sprawia, że trudy dnia znikają."
];
gt.Const.Strings.PayTavernRumorsIntro <- [
	"Goście wykrzykują twe imię dzwoniąc kuflami. Napitek rozwiązuje im języki.",
	"Goście z aprobatą kiwają głowami.",
	"Ludzie wznoszą swe kufle w geście uznania.",
	"Ludzie szemrają z aprobatą.",
	"Szynkarz dzwoni dzwonkiem, by dać wszystkim znać, że następna kolejka jest na twój koszt."
];
gt.Const.Strings.RumorsLocation <- [
	"Jest pewne miejsce zwane %location% %terrain% na %direction% stąd. Większość ludzi o nim wie, ale niewielu się tam zapuszcza.",
	"%randomname% powiedział mi kiedyś o miejscu zwanym %location%. Mówił, że jest pełne bogactw i znajduje się %distance% na %direction% stąd. A może ja coś źle zapamiętałem.",
	"Jeśli przygód szukasz, to jest pewne miejsce zwane %location% %terrain% na %direction% stąd. Chociaż nie wiem kto obecnie tam pomieszkuje.",
	"Słyszałeś o tym miejscu, %location%? Ludzie mawiają, że jest nawiedzone: chodzące trupy i takie tam. Gdzieś na %direction% stąd. Może ktoś inny w %townname% powie ci więcej...",
	"Słyszałeś o... kurde, jak to się nazywało? Na %direction% %distance% stąd, %terrain%. Na śmierć zapomniałem, jak zwykliśmy to miejsce zwać...",
	"Widziałeś %location% po drodze? Jest %terrain% na %direction% stąd. Ktoś powinien cię nająć, by spalić to plugawe miejsce do gołej ziemi. Nic dobrego stamtąd nie przychodzi, to pewne.",
	"Zauważyliśmy coś, gdy tutaj podróżowaliśmy, ukryte z dala od drogi, %terrain% %distance% na %direction% od %townname%. Nie wiem jak miejscowi na to mówią, albo czy w ogóle wiedzą o tym miejscu, ale być może będzie warto tam wrócić."
];
gt.Const.Strings.RumorsContract <- [
	"Ponoć rada osady %settlement% chce zatrudnić najemników. Nie wiem jednak po co.",
	"Grupa młodych chłopców wyruszyła kilka dni temu do %settlement%. Najmują tam każdego, kto jest w stanie władać bronią, a do tego nieźle płacą. Mam tylko nadzieję, że wrócą cali i zdrowi.",
	"Jeśli roboty szukacie, ponoć %settlement% zatrudnia najemników.",
	"Słyszałeś, że w %settlement% potrzebują wojowników?",
	"Pewien typ z osady %settlement% był tu zaledwie wczoraj, chciał zatrudnić silnych chłopów w celu rozwiązania jakiegoś problemu, z którym się tam borykają. Ale chyba niewielu z nim poszło.",
	"Najemnicy, co? Coraz częściej takowych ostatnio widujemy. Zaledwie kilka dni temu banda zwąca się %randommercenarycompany% tędy przemierzała. Szli na %settlement%, mówili, bo można tam nieźle zarobić.",
	"Jeśli roboty szukasz, to trochę koron można zarobić w %settlement%, bo zatrudniają tam silnych chłopów.",
	"Słyszałem, że jakiś bogaty, tłusty kupiec czy ktoś podobny z %settlement% szuka ludzi do zbrojnej eskorty. Cóż, ja tam nie zamierzam za takiego ginąć, co to, to nie. Mam tu dom i żonę."
];
gt.Const.Strings.RumorsGeneral <- [
	"Jeśli chcesz drogo sprzedać swoje towary, przyjacielu, to powinieneś udać się do jednego z większych miast lub zamków, zamiast do jakichś nędznych wiosek na totalnym zadupiu.",
	"Napitki w %randomtown% są znacznie lepsze, niż te kocie szczyny, które serwują tutaj!",
	"Był tu kupiec dziś rano, który twierdził, że widział truposzy człapiących po wzgórzach niedaleko stąd. I niby ja mam uwierzyć w takie brednie?!",
	"W dziczy wiele jest miejsc dawno utraconych i zapomnianych, które skrywają w sobie wielkie bogactwa.",
	"Jeśli kiedykolwiek zawitasz do karczmy w %randomtown%, koniecznie skosztuj ich pieczonej koziny - takiego przysmaku nie znajdziesz nigdzie indziej!",
	"Najemnicy nie są zbyt popularni w tych stronach. Zabijają, grabią i plądrują jak pospolici zbójcy, więc nie oczekuj, że ludzie na twój widok będą wiwatować i witać cię kwiatami.",
	"Jeśli potrzebujesz zapasów, to odszukaj osobę imieniem %randomname% na targu tutaj w %townname%. Powiedz mu, że ja cię przysłałem!",
	"Jutro wieczorem sławny minstrel %randomname% {Skowronek | Grajek | Bajarz | Słowik | Poeta} ma zawitać to tejże właśnie gospody, lepiej tego nie przegap!",
	"Nie ufaj naparom golibrody! Przyjaciel wuja przyjaciela mojego kuzyna wypił taki jeden i został przemieniony w ropuchę, przysięgam!",
	"Słyszałem o tej wolnej kompanii zwącej się %randommercenarycompany% i ponoć kolekcjonują oni uszy swoich wrogów, robiąc sobie z nich naszyjniki!",
	"Nie pij wody w %randomtown%, tyle ci powiem. Od razu dostaniesz sraczki!",
	"Mój kuzyn z %randomname% wyruszył z miasta z kompanią najemników, podobną do twojej. %randommercenarycompany% chyba się zwali, czy jakoś tak. Od tamtego czasu słuch po nim zaginął...",
	"Powiem ci jak najemnik najemnikowi: Jeśli cenisz swoją najemniczą reputację, lepiej nie próbuj przechytrzać swoich zleceniodawców. Niektórzy z nich daleko się posuną, aby cię dopaść, zniesławić i ukarać.",
	"Rody szlacheckie zachowują się jak stare małżeństwo; ciągłe kłótnie i swary. A kto cierpi najbardziej przez te waśnie? Nie wysocy lordowie w swoich wieżach zamkowych, o nie, tylko oczywiście my, prosty lud!",
	"Na twoim miejscu trzymałbym się z dala od bagien i mokradeł. Jest tam straszliwa zaraza, która tylko czyha, by na ciebie przeskoczyć.",
	"Słyszałem, że w radzie osady %randomtown% mają maga, prawdziwego czarodzieja. Choć nie do końca w to wierzę.",
	"Uwielbiam kobiety! To jak wyglądają, jak chodzą. Nie wiem sam, co bym bez nich poczynił...",
	"A niech mnie, to ty i %companyname%! Pamiętasz mnie z osady %randomtown%? Rozmawialiśmy o... cóż, nie pamiętam już, ale znów się spotykamy! Napijmy się! Jak ci się wiedzie?",
	"Śmierć jest częścią życia. Im szybciej się z tym pogodzisz, tym dłużej będziesz się mógł cieszyć ze swego pobytu na tym świecie.",
	"Ostatnio wypadł mi jeden z zębów, widzisz? Wydaje mi się, że pozostałe są tak luźne, że niedługo też wypadną. Czujesz? Śmiało, dotknij. Ruszają się, prawda?",
	"Na bogów, muszę się odlać. Przypilnujesz mi piwa?"
];
gt.Const.Strings.RumorsCivilian <- [
	"Zawsze bądź sceptyczny wobec szlachty, przyjacielu. Nigdy nie wiadomo o co tak naprawdę im chodzi i jaki mają plan.",
	"Rozważałeś kiedyś odłożenie miecza i osiedlenie się gdzieś? Życie najemników zazwyczaj nie trwa zbyt długo.",
	"Onegdaj zauważono dym z miejsca, gdzie %randomname% ma swe gospodarstwo. Okazało się, że wszystko zostało spalone do gołej ziemi, zaś całą jego rodzinę znaleziono wiszącą na pobliskim dębie...",
	"Jako że jacyś zbójcy spalili gospodarstwo mojego tatula, zamieniłem widły na kufel piwa. Mam tylko nadzieję, że któregoś dnia dostaną to, na co zasłużyli.",
	"Nasza milicja jest w żałosnym stanie, wszędzie przerdzewiałe piki, zbutwiałe tarcze... Chciałaby, aby rada wzięła trochę koron w garść i kupiła tym biedakom jakąś porządną broń.",
	"Nie potrzebujemy tu takich najemników, jak ty! Sprawiacie tylko kłopoty. Nasza milicja się nami zaopiekuje. Zawsze tak było i zawsze będzie.",
	"Córka młynarza zaginęła ostatniej nocy. Odnaleziono ją całą i zdrową, ale dziewka nie za bardzo chce mówić o tym, co się stało.",
	"Chędożony %randomname% i jego chędożony pies. Ta śmierdząca kupa pcheł szczeka dniami i nocami, czy leje, czy świeci słońce. Dłużej już tego nie zniosę, poważnie...",
	"Słyszałem, że na starym cmentarzysku część nagrobków została przewrócona. Jednak nikt przy zdrowych zmysłach nie zapuszcza się obecnie w tamte strony.",
	"Kupiłem sobie kiedyś tego saksa od wędrującego kupca. Prawdziwa okazja, mówił. Trzeba mieć czym obronić siebie i swoją rodzinę, rozumiesz.",
	"Nie ufam tutejszej milicji. Pewnego razu, gdy zbliżyła się grupa banitów, ci z miejsca odwrócili się na pięcie i zwiali na wzgórza bez żadnej walki!",
	"Mieliśmy tu morderstwo. Jakiś łajdak z %randomtown% wbił nóż w plecy jednemu z kupców. W niedzielę czeka go stryczek, powinieneś przyjść popatrzeć!",
	"W zeszłym tygodniu %randomfemalename% spłonęła na stosie. To robota jakiegoś łowcy czarownic. Tak po prostu przybył któregoś dnia do miasta, oskarżył ją o czary i inne takie, a potem kazał spalić. Rada się nie sprzeciwiała, a typ opuścił miasto niedługo potem. Szkoda, ze nie wiem, kim był. To chyba dobrze, że ocalił nas przed tą wiedźmą..."
];
gt.Const.Strings.RumorsMilitary <- [
	"Walczyłeś kiedyś z orkiem? Mawiają, że są dwukrotnie wyższe i trzykrotnie silniejsze od ludzi, oraz że potrafią nas rozpłatać na pół pojedynczym ciosem!",
	"Przyjmowanie zdesperowanych rolników i rybaków do swojej kompani jest w porządku, jednak powinieneś poszukać rekrutów w takich zamkach, jak ten. Tutaj znajdziesz ludzi, którzy już wiedzą który koniec miecza skierować w stronę wroga.",
	"Powiem ci, że wytrzymała tarcza potrafi uratować życie. Nie pozwoliłbym swoim ludziom walczyć bez tarcz.",
	"Dowódca garnizonu walczył w Bitwie o Wielu Nazwach. Twierdzi, że jego ciosy wojennym toporem po prostu odbijały się bez efektu od głów wielkich orków, poważnie. Sam nie wiem co o tym myśleć.",
	"Na szlakach i w dziczy czają się rzeczy znacznie straszniejsze, niż jacyś zbójcy. Zrozumiesz, co mam na myśli, gdy zapuścisz się gdzieś dalej poza pogranicza.",
	"Zawsze polegam na swym toporze, którym z łatwością rozbijam tarcze wrogów. Nawet najroślejszy chłop szybko padnie, jeśli już nie będzie miał jak się obronić.",
	"Jeśli czegoś się nauczyłem podczas służby w wojsku to to, że dobrą pozycją wygrywa się bitwy. Zaufaj mi w tej kwestii.",
	"Kiedyś też byłem najemnikiem, ale dostałem strzałą w kolano.",
	"Widziałem, jak %randomnoble% ostatnio brał udział w turnieju. A niech mnie, ależ to był niesłychany widok, móc na niego patrzeć. Znaczy na to, jak walczył. Zgarnął główną nagrodę i serca wszystkich dam.",
	"Jestem już stary, ale nadal pamiętam swoją pierwszą bitwę. Zeszczałem się gacie jeszcze zanim wypuszczono pierwszą strzałę. Ha!",
	"Byłem w %randomtown% nie tak dawno temu i powiedziano mi o wilkach wielkości człowieka, z zębami długimi jak palce mojej dłoni. Nie chciałbym się na takie stwory natknąć.",
	"Wiedziałeś, że orkowie tworzą swe zbroje z tego, co pozyskają ze swych poległych wrogów? Poważnie, nie zmyślam. Noszą to jako trofeum, czy coś. Jeśli kiedyś natkniesz się na jednego z tych wielkich orków, sam się przekonasz. Wyglądają, jakby owinęli się rycerzem lub dwoma.",
	"1. Kompania %townname%. Najlepsza grupa półgłówków i nicponi z jaką dane mi było służyć. Nie zamieniłbym ich za nic w świecie.",
	"Tęsknię za swoją żoną i dwoma córeczkami. Już o wiele za długo stacjonujemy w %townname%, ale jakoś trzeba zarobić na jedzenie.",
	"Wkrótce znów wyruszymy patrolować gościńce. Czasami wydaje mi się, że wszystko by się zesrało, gdybyśmy nie pilnowali porządku w okolicy.",
	"Chędożona służba patrolowa. Ledwieśmy wrócili, szłapy całe w odciskach od tego całego maszerowania, a teraz znowu mamy ruszać. Dajcież nam konie, do cholery!",
	"Kilka miesięcy temu ciężko mnie raniono w potyczce przeciwko goblinom. Nie czułem nóg, ale chłopcy zataszczyli mnie z powrotem do %townname%. Niech im Bóg błogosławi.",
	"Poznasz tereny zielonoskórych po bożkach, które wznoszą z czaszek i kości. Ludzkich czaszek i kości.",
	"Czternastu. Tylu do tej pory zabiłem. Baby liczę osobno, trzy jak na razie. A ty?",
	"Zazwyczaj pełnię wartę na wieży przy głównej bramie. Szczerze mówiąc, plucie na niektórych podróżników to jedyna rozrywka, jaką mam w ciągu dnia.",
	"W garnizonie panuje dość kiepski nastrój. Mówią, że żołd już kilkakrotnie został opóźniony i wszyscy powoli tracą cierpliwość.",
	"Kiedy przeprowadzałem się do %townname%, nigdy nie sądziłem, że życie tutaj będzie takie nudne i ciężkie. Nadal chyba jednak lepsze to, niż praca na polach do upadłego...",
	"Preferuję walkę cepem. Ciężko się przed nim obronić i nie ma znaczenia, czy ktoś osłania się tarczą, bo cios po prostu ją ominie i zamieni jego głowę w papkę!",
	"Znalezienie w okolicy solidnej tarczy graniczy z cudem, te cholerstwa rozpadają się na pół. Teraz noszę na plecach zapasową, tak na wszelki wypadek. Powinienem liczyć sobie więcej za walkę przeciwko ludziom uzbrojonym w topory, ha!",
	"Kiedyś zostanę chorążym kompanii. Taki zaszczyt spotyka tylko najdzielniejszego z nas i trzeba być z kompanią przez długie lata, wiesz, ale to największy zaszczyt dla kogoś, kto wywodzi się z pospólstwa. Widziałem nawet kiedyś, jak rycerz uścisnął dłoń jednemu z chorążych.",
	"Szkoliłem już milicję i powiem ci, że włócznie to najlepsza broń dla żółtodziobów. Tania i łatwo nią trafić. Ustaw kilku ludzi w szeregu, by utworzyć ścianę włóczni, a ciężko się wrogowi będzie nawet zbliżyć nie zarobiwszy włóczni w bebechy.",
	"Walczyłeś kiedyś z goblinami? Paskudne małe gnojki, niech nie zwiedzie cię ich rozmiar. Na twoim miejscu wziąłbym duże tarcze, by osłonić swych ludzi przed ich strzałami. Oraz stado psów wojennych, o ile cię stać, aby zapolować na nich, gdy już się rozpierzchną."
];
gt.Const.Strings.RumorsMiningSettlement <- [
	"Niedawno złamałem kilof waląc w skałę. Odłamek rozciął mi policzek. Niewiele brakowało, a byłbym bez oka!",
	"Kopalnie to po prawdzie śmiertelna pułapka, każdego tygodnia tracimy ludzi. Nawet wyruszenie z tobą mogłoby się okazać bezpieczniejsze, ha!",
	"Wiesz, praca w kopalniach ma też swoje zalety. Nie marzniemy, nie leje nam na głowę, tylko ten pył, który ostatecznie cię zabije...",
	"W jednym z korytarzy kopalni %randomname% znalazł bryłę wielkości mojej pięści! Nadzorca jednak dopadł go, zanim biedak zdołał ją schować."
];
gt.Const.Strings.RumorsFarmingSettlement <- [
	"Nawet pomimo fatalnych tegorocznych żniw, gospodarz nie daje nam wytchnienia! Wiesz, ci na szczycie muszą mieć swoje uczty...",
	"Jeśli zamierzasz zaopatrzyć się w prowiant i zapasy, udaj się na targ i poszukaj człowieka imieniem %randomname%. Ma towar najlepszej jakości i najniższe ceny!",
	"Byłem parobkiem przez całe swoje życie i czasami żałuję, że nie skorzystałem z okazji i nie wyruszyłem z taką kompanią, jak twoja... cóż, teraz już na to za późno.",
	"Nie brakuje młodych i naiwnych chłopaków, szukających przygód. Mam nadzieję, że dobrze się nimi zaopiekujesz i że któregoś dnia cali i zdrowi wrócą do swoich rodzin."
];
gt.Const.Strings.RumorsFishingSettlement <- [
	"Morze to kapryśna pannica. W jednej chwili jest spokojne niczym lustro, a moment później walczysz o życie w środku potężnego sztormu.",
	"Nikt nie wie co żyje w głębokich czarnych wodach, ale starzy rybacy mówią o olbrzymiej rybie, większej aniżeli jakikolwiek okręt, o mackach, które miażdżą łodzie niczym skorupki orzecha, oraz o złowieszczych, martwych oczach łypiących nienawistnie pod taflą wody.",
	"Niektórzy starzy rybacy mawiają, że ci, którzy zaginęli na morzu, zmuszeni są do przechadzania się po jego dnie i swoją klątwę mogą przerwać tylko zaciągnąwszy jakąś inną osobę na swoje miejsce. Kapłan twierdzi, że to bujdy, ale sam już nie wiem. Bo w taki razie po co niby starsi by o tym opowiadali?",
	"Największą rybę z moich połowów zawsze kładę przed drzwiami tej dzierlatki o imieniu %randomfemalename%, aby się jej przypodobać. Któregoś dnia ujawnię się jako jej skryty wielbiciel i poproszą ją o rękę!"
];
gt.Const.Strings.RumorsForestSettlement <- [
	"Całe swe życie byłem drwalem, tak jak i mój tatunio. Jednak teraz młodym w głowach tylko przygody i zwiedzanie świata. Wokół rynku nieraz więc można spotkać takich, którzy bez chwili zawahania wyruszą z tobą na szlak.",
	"W lesie czają się różne istoty... w jego głębi, w mrocznych zakątkach. Nikt nie ośmiela się o nich mówić, ale zaufaj mi, to nie są zwierzęta...",
	"Rzeknij, interesujesz się snycerstwem? %randomname% tworzy z drewna istne dzieła sztuki, a nasze miasteczko dzięki niemu jest znane w całym królestwie!",
	"Moim zdaniem zatrudnienie człowieka z lasu mogłoby się okazać dobrym ruchem dla takiego najemnika, jak ty. Oni już wiedzą jak wprawnie machać tymi wielkimi toporami!",
	"Słyszałem jak ludziska mówią, że jakieś ślepia wpatrują się w nich ze skraju lasu. Wygląda na to, że to jakieś plugawe kreatury założyły sobie gniazda w tych kniejach. Być może obserwują swoją zwierzynę przed atakiem.",
	"Odkąd pamiętam tutejsze lasy pełne były zwierzyny. Jeleni, dzików, wilków i niedźwiedzi jest tu mnóstwo. Z tego też powodu tradycją rodzinną stała się nauka łucznictwa już od najmłodszych lat. Spróbuj zmierzyć się z którymś z naszych chłopaków na łuki, a tylko się ośmieszysz."
];
gt.Const.Strings.RumorsTundraSettlement <- [
	"Może ci się wydawać, że nasze ziemie są jałowe i nie warte uwagi, jednak gdy trochę tu pożyjesz to nauczysz się je kochać bardziej, niż jakiekolwiek inne!",
	"Klany i rody w tych stronach nadal są silne i definiują, kim jesteśmy. Ludziska z południa nigdy nie zrozumieją jak to wszystko u na północy działa.",
	"Jeśli szybko chcesz zarobić trochę grosza na handlu, to rozglądaj się za futrami. Te z tutejszych stron nie mają sobie równych jak świat długi i szeroki.",
	"Przybywasz do właściwego miejsca, jeśli szukasz zdolnych ludzi do zasilenia swojej kompanii. My, nordowie, jesteśmy silni, twardzi i uczciwi!"
];
gt.Const.Strings.RumorsSnowSettlement <- [
	"Najlepsze lekarstwo na kąsające wiatry i lodowate zimno można znaleźć tutaj: piwo i miód pitny!",
	"Dwa tygodnie temu %randomname% zaginął w drodze powrotnej z gospody do domu. Znaleziono go następnego ranka, zamarzniętego na kamień. Mogliśmy go sprzedać jakiemuś dostojnemu szlachcicowi jako posąg, haha!",
	"Krążą opowieści o dziwnych sylwetkach majaczących wśród zamieci i nieziemskim skowycie, mieszającym się z wyciem wiatru... nie chcę cię jednak niepokoić jakimiś bujdami rozpowiadanymi przez prosty lud.",
	"Powiedziano mi, że dawno temu te ziemie były pełne zieleni oraz dostojnych zamków z imponującymi wieżami. Większość z nich obróciła się już w ruinę i została zasypana śniegiem. Nadal jednak muszą gdzieś tam być...",
	"Cztery zimy. Cztery zimy minęły odkąd skusiłem się na rzekomo łatwy łup i napadłem na przydrożną kapliczkę. Kapłana, który próbował mnie powstrzymać, potraktowałem mieczem; nie ma takiej ilości koron, która mogła by spłacić ten dług, jaki ma teraz moja dusza."
];
gt.Const.Strings.RumorsSteppeSettlement <- [
	"Zapewne pocicie się jak wieprze pod całą tą zbroją. Może powinniście podróżować, gdy miesiączek świeci?",
	"Pozwolę sobie powiedzieć, że południowe wino nie ma sobie równych. Lepiej jednak zajmij się rozwalaniem łbów, czy czym tam innym się zajmujesz dla zarobku, by stać cię było na porządny towar, bo tani to on nie jest.",
	"W zeszłym tygodniu kupiec z dalekiej północy zaginął na stepie. W końcu się odnalazł, ale nie przestawał fantazjować o jakimś jeziorze, które rzekomo odnalazł, otoczonym przez bujną roślinność i dziwne zwierzęta.",
	"Powiedz swoim ludziom, by trzymali swe łapska z dala od córki oberżysty. Ostatni kochaś, który próbował się do niej dobierać, skończył z odciętym nochalem.",
	"Właściwie to pochodzę z północy, a do osady %townname% przybyłem kilka lat temu. Nigdy nie potrafiłem zdzierżyć tamtejszego zimna; śnieg i wiatr, w kółko to samo. Toteż któregoś dnia powiedziałem sobie, %randomname%, do jasnej cholery, zamieszkaj tam, gdzie słońce ogrzewa ziemię i nie trzęsiesz się z zimna za każdym razem, gdy idziesz po drewno na opał. Jak rzekłem, tak zrobiłem. I nie żałuję."
];
gt.Const.Strings.RumorsSwampSettlement <- [
	"Lubisz grzyby? Cóż, ja ich nienawidzę! Jednak w tych cuchnących bagnach niewiele więcej można znaleźć poza nimi, ślepakami i paskudnymi pająkami.",
	"Kupcy nieczęsto tu zaglądają. Ich wielkie wozy grzęzną w błocie i zgadnij kto musi im wtedy pomagać, gdy już się całkiem zakopią...",
	"Dawniej była tu kamienna droga, która przyciągała handlarzy, kupców i wszelaki lud. Jednak pewnego dnia całkowicie zatopiła się w grzęzawiskach i zobacz, jak to miejsce teraz wygląda...",
	"Nie szlajaj się nocami po moczarach! Można zabłądzić, owszem, jednak na bagnach po zmierzchu czyhają na człowieka rzeczy znacznie, znacznie gorsze. Zapytaj kogokolwiek stąd."
];
gt.Const.Strings.RumorsDesertSettlement <- [
	"Ci nordowie dobrze płacą za nasze jedwabie i przyprawy, toteż cały czas wysyłamy na północ karawany. A karawany potrzebują eskorty, jeśli wiesz co mam na myśli.",
	"Mogę dać ci jedną radę: nie zapuszczaj się zbyt głęboko na pustynię. Na krańcu świata są rzeczy o wiele gorsze, niż upał i rozżarzony piasek.",
	"Te psy z północy nie mają prawa przybywać na nasze ziemie! Powinni zostać tam, gdzie ich miejsce!"
];
gt.Const.Strings.RumorsItemsOrcs <- [
	[
		"Karawana transportująca jakąś cenną ceremonialną broń została napadnięta na %direction% stąd. Plotka głosi, że ofiary miały złamaną każdą jedną kość, a w powietrzu unosił się straszny smród.",
		"Klient mówił ostatnio o pewnej broni zwanej %item%, którą chciał sprzedać. Rzekł, że w drodze do miasta przestraszyły go jakieś zielonoskóre bestie i porzucił oręż %terrain% na %direction% stąd.",
		"Wędrowiec pewnego dnia powiedział mi, że na własne oczy widział największego człeka, jaki kiedykolwiek żył. Ów gigant dzierżył broń, którą zwał %item%. Moim zdaniem to bzdury, ale jeśli cię to interesuje, to wędrowiec wyruszył stąd na %direction%."
	],
	[
		"Kilka nocy temu był tu pewien poszukiwacz przygód ze śliczną buźką i wielkimi jajami. Zmierzał na %direction% stąd, chcąc zabić nieco zielonoskórych. Miał na plecach nietypową tarczę, wyglądał jak jakiś rycerz, choć mówił, że nim nie jest.",
		"Mawiają że słynna tarcza, zapomniałem jak ja zwali, raz zatrzymała potężny głaz przed stoczeniem się na dół i zmiażdżeniem obozu. Brzmi jak totalne pierdolenie. Pewnie nigdy się nie dowiemy, czy to prawda, ale tarcza robi teraz za trofeum wojenne orków, ukryta gdzieś %distance% na %direction% stąd.",
		"Nie wierz mi na słowo, ale podobno jakieś zielonoskóre łajzy na %direction% stąd paradują z niesamowitą tarczą zwaną po prostu %item%. Nie mam pojęcia, jak ją zdobyli.",
		"Kilka dni temu napadnięto na posiadłość pewnego szlachcica. Napastnicy zwiali z jakąś słynną tarczą czy relikwią. Podobno ci zielonoskórzy łajdacy zaszyli się gdzieś na %direction% stąd."
	],
	[
		"Kojarzysz orków? Masywne bestie, silne niczym woły! Parę tygodni temu banda najemników zwąca się %randommercenarycompany% przechodziła tędy i zmierzała na %direction%, aby na nich zapolować. Nigdy nie wrócili, ale ich przywódca nosił najbardziej imponujący pancerz, jaki w swym życiu widziałem!",
		"%item%, kojarzysz tę nazwę? Ponoć skradziono ten pancerz wieki temu podczas ostatniej inwazji orków. Podobno widziano go na %direction% stąd, niestety nie znam żadnych szczegółów. Wybacz, nie chciałem ci robić zbyt dużych nadziei.",
		"Jakiś słynny płatnerz został ubity kilka dni temu. Plotka głosi, że orkowie splądrowali jego dom i uciekli z najlepszym jego wyrobem gdzieś na %direction% stąd. Może ktoś inny będzie w stanie powiedzieć ci coś więcej.",
		"Wieść niesie, że %randomnoble% został ułożony do wiecznego snu przez bandę zielonoskórych na %direction% stąd. Był powszechnie znany z molestowania wszystkich swych sług, toteż nikt w okolicy płakać po nim nie będzie. Szkoda tylko tej jego wspaniałej zbroi, w której tak się puszył, bo można by za nią kupić mnóstwo świń i krów. I kurczaków!"
	]
];
gt.Const.Strings.RumorsItemsGoblins <- [
	[
		"Porządnie wkurzony szlachcic powiedział mi pewnego dnia, że jacyś przeklęci zielonoskórzy zwiali z jego rodową pamiątką po tym, jak wytruli jego zaufane strzegące psy. Przysięga, że schowali się %terrain% gdzieś na %distance% stąd, ale chyba nigdy nie udało mu się przekonać nikogo, by tę pamiątkę dla niego odzyskał. Ja z pewnością się na to nie piszę.",
		"Boisz się zielonoskórych? Pewien czas temu grupka mocno pobitych żołnierzy tędy przechodziła. Mówili, że chcieli wyrwać dobrze znaną broń z rąk goblinów na %direction% stąd, ale nie wszystko poszło zgodnie z planem i musieli się wycofać. Wygląda na to, że ich łup czeka na kolejnego śmiałka."
	],
	[
		"Rolnik skądś na %direction% stąd powiedział mi, że widział na swej ziemi jakieś małe, złowieszcze kreatury, które niosły wielką, lśniącą tarczę i wydawały diabelskie dźwięki. Mówił, że to gobliny, ale moim zdaniem dał się wystrychnąć na dudka przez jakichś małoletnich żartownisiów!",
		"Najlepszy wytwórca tarczy w naszym regionie został znaleziony martwy gdzieś na %direction% stąd, a z jego szyi sterczała strzałka. Ludzie mówią, że widzieli małe stwory uciekające z połową jego towarów.",
		"Gdzieś na %direction% stąd jest grupa goblinów. Wiem o tym tylko dlatego, że wędrowny fiut, który tu przybywa mówi o tym, jak ledwo uszedł ż życiem. Jeden nawet twierdził, że podczas ucieczki zgubił swoją mistrzowsko wykonaną tarczę."
	],
	[
		"Wieść niesie, że pewien mocno przeceniany i przewartościowany kawałek pancerza został ukradziony ze strażnicy przez jakieś małe diabelskie istoty, które zwiały na %direction%. %randomname% mówi, że to pewnikiem gobliny, choć tak naprawdę nikt nie wie, jak one wyglądają.",
		"Mówi się, że koboldy i gobliny lubują się w świecidełkach. Sam nigdy w to nie wierzyłem, jednak wiele razy widziałem coś połyskującego w słońcu %terrain% na %direction% stąd i słyszałem dziwne opowieści o małych i przysadzistych istotach wędrujących po okolicy.",
		"Być może zaciekawi cię, że nasz stary zielarz mieszkający nieopodal miasta został wczoraj w nocy obrabowany. Miało to miejsce zaraz po tym, jak odwiedził go bogaty rycerz. Napastnicy, jak twierdzi zielarz, będący małymi kreaturami, wyglądającymi jak zdeformowane dzieci, zabili rycerza i uciekli %terrain% na %direction%."
	]
];
gt.Const.Strings.RumorsItemsBandits <- [
	[
		"Wieść niesie, że szajka zbójów na %direction% stąd dorwała w swe łapy coś naprawdę przedniego i ostrego po bezczelnej kradzieży.",
		"Grupka bandziorów próbowała napaść na karawanę %terrain% %distance% stąd. Wszystkich ich wybito, ale plotka głosi, że jakaś cenna broń zaginęła podczas walki. Strażnicy karawany od tamtego czasu rozpaczliwie jej poszukują.",
		"Osłupiały klient powiedział mi, że był więziony przez jakichś łotrów %terrain% %distance% stąd. Mówił, że mieli ze sobą coś naprawdę ładnego. Jakąś dziwnie wyglądającą broń.",
		"Kapitan straży zdezerterował jakiś czas temu i dołączył do obozu najeźdźców ukrytego %terrain% na %direction% stąd. Mój wujek, który pod nim służył, twierdzi, że kapitan splądrował zbrojownię przed odejściem i zgarnął, co najlepsze."
	],
	[
		"Kapitan straży zdezerterował jakiś czas temu i dołączył do obozu najeźdźców ukrytego %terrain% na %direction% stąd. Mój wujek, który pod nim służył, twierdzi, że kapitan splądrował zbrojownię przed odejściem i zgarnął, co najlepsze.",
		"Ponoć sławna tarcza %item% się odnalazła. %randomname% twierdzi, że jest ona w rękach zatwardziałych najeźdźców obozujących na %direction% stąd. Z drugiej strony, %randomname% często gada o rzeczach, o który nie ma pojęcia.",
		"W tych okolicach wszyscy gadają li tylko o przeklętych bandytach. To chyba przez to, że ostatnio dorwali w swe łapy tarczę %item%, czy coś podobnego. Gdzie ich znaleźć? Och, ponoć są gdzieś %terrain%."
	],
	[
		"Przyjaciel mojego przyjaciela został niedawno okradziony na %direction% stąd przez grupę banitów. Twierdzi, że ich przywódca miał na sobie nad wyraz zadziwiającą zbroję!",
		"Kapitan straży zdezerterował jakiś czas temu i dołączył do obozu najeźdźców ukrytego %terrain% na %direction% stąd. Mój wujek, który pod nim służył, twierdzi, że kapitan splądrował zbrojownię przed odejściem i zgarnął, co najlepsze.",
		"Kilka dni temu przewędrował tędy arogancki młodzieniec, zapewne szlachcic, szukający starej rodzinnej pamiątki zwanej %item%. Ostatni raz go widziałem, jak zmierzał na %direction%."
	]
];
gt.Const.Strings.RumorsItemsUndead <- [
	[
		"Nie chciałbym rozpuszczać plotek, ale widziałem chodzącego umarlaka na %direction% stąd. Jego przegnite dłonie trzymały w trupim uścisku niezwykłą broń, ale w życiu nie odważyłbym się ponownie zbliżyć do tamtego miejsca!",
		"Jakiś pijany szabrownik był tu zeszłej nocy i mówił, że próbował wyrwać broń wysadzaną klejnotami z rąk truposza %distance% na %direction% stąd. Rzekł, że uścisk umarlaka był niczym imadło i gdy trup wydał z siebie dźwięk, postanowił zwiać. Bzdury jakieś, choć trza przyznać, że wyglądał na wystraszonego jak diabli.",
		"Sporo się mówi o umarłych, którzy wstali z grobów. %randomname% twierdzi, że na %direction% stąd jest ich trochę. Jak dla mnie to zwykłe bujdy."
	],
	[
		"Ponoć część grobów na %direction% stąd okazała się pusta. Ktoś powiedział, że to cmentarne hieny szukały sławnej tarczy, która miała tam być pochowana. Co dziwne, nikt tych rabusiów nie widział, więc może to jakieś bujdy.",
		"Przeglądałem księgę rządcy i natknąłem się na stare mapy, które opisywały starożytne miejsce pochówku szlachty %terrain% %distance% stąd. Jednak nit jak na razie go nie odnalazł. Cóż, widocznie niektóre rzeczy muszą pozostać nieodnalezione."
	],
	[
		"Ponoć %terrain% na %direction% stąd znajduje się miejsce ostatniego spoczynku mistycznego pancerza. Nie wiem jak się zowie, wiem tylko, że wielu poszukiwaczy przygód udaje się tam i nigdy nie wraca. Sam nie wiem, po co ci to mówię. Podoba mi się twoje zajęcie.",
		"Słyszałeś o miejscu zwanym %location%? Zapytaj kogokolwiek stąd, a dowiesz się, że od dawien dawna prześladuje ono %townname%. Ludzie mówią, że jakiś pancerz bogów jest tam zapieczętowany na wieki, z czasów gdy ludzie po raz pierwszy się tu osiedlili."
	]
];
gt.Const.Strings.RumorsItemsBarbarians <- [
	[
		"Dla tych barbarzyńskich dzikusów nie ma żadnej świętości! Całkowicie nagi kapłan dotarł tu skądś na %direction%. Miał dostarczyć czczoną relikwię do świątyni, ale mu ją odebrano.",
		"Przeszła tędy kompania najemników polująca na barbarzyńców. Ich przywódca dzierżył broń, jakiej nigdym wcześniej nie widział. Ruszyli na %direction% i słuch po nich zaginał.",
		"Gdzieś %terrain% na %direction% stąd grasuje zaciekła banda dzikusów. Miej na nich oko, a może doprowadzą cię do swych ukrytych łupów, wśród których ponoć znajduje się jakaś skradziona sławna broń."
	],
	[
		"Słuchajże! Widziano plemię niewychowanych barbarzyńców na %direction% stąd. Mieli w swych brudnych łapach tarczę zwaną %item%! Zgładź ich i odzyskaj ją!",
		"Przyjaciel mojego przyjaciela widział w oddali dzikusów %direction% stąd. Klął się na pamięć własnej babki, że mieli ze sobą wspaniale wykonaną tarczę. Moim zdaniem gówno prawda, bo wszyscy wiedzą, że oni nie używają tarcz tak, jak my!",
		"Mawiają, że tylko dobra obrona pozwala na silny atak. Plotka głosi, że grupa barbarzyńców %distance% na %direction% stąd ma w posiadaniu sławetną tarczę...",
		"Dawniej handlowałem z pewnymi nie-tak-dzikimi barbarzyńcami na %direction% stąd. Kiedy ostatnio ich odwiedziłem w jednym z ich szałasów wisiała zdumiewająca tarcza. Być może nadal siedzą tam %terrain%."
	],
	[
		"Wygląda na to, że przydałaby ci się lepsza zbroja, przyjacielu. Jeśli nie lękasz się stawić czoła zaciekłym barbarzyńcom, to %terrain% na %direction% stąd, w obozie zwanym %location%, jest do zdobycia pewien szalenie wyborny pancerz.",
		"Sławny pancerz, %item%, przez dziesięciolecia był pilnie strzeżony w zbrojowni, jednak gdy przybyli dzicy z północy, to zabrali ze sobą wszystko. Podobno obozują gdzieś %terrain% na %distance% stąd.",
		"Przybyłem tu by odebrać rodową pamiątkę od swego dawnego pradziada. Jak się okazało, została ona skradziona przez grasujących tu barbarzyńców. Ponoć kręcą się gdzieś %terrain% na %direction% stąd, choć obawiam się, że nigdy już jej nie odzyskam.",
		"Ty też jesteś tu by odnaleźć ten sławny pancerz, %item%, tak ci wszyscy inni głupcy? Ponoć znajduje się gdzieś %terrain% na %direction%. Moim zdaniem to tylko brednie..."
	]
];
gt.Const.Strings.RumorsItemsNomads <- [
	[
		"Koczownicy biorą co chcą, a później kryją się na pustyni. Strażnicy szukają ich %terrain% na %direction% stąd. Sądzę, że są %distance%.",
		"Dni tutaj na południu są równie jasne, co ciemne są noce. Potknąłem się o coś i zgubiłem moją drogocenną broń %distance% na %direction% stąd, ale już zaniechałem poszukiwań.",
		"Starożytni rzemieślnicy naprawdę wiedzieli jak wykonać niezwykłą broń. Plotka głosi, że jedna z takich broni jest w rękach koczowników, ukrywających się na %direction% stąd, ale któż im ją odbierze - ja? Ha!"
	],
	[
		"Tarcza odbijająca światło słoneczne niczym lustro, bardziej oślepiająca niźli środek dnia na pustyni! Gdzie ją widziałem? Jacyś koczownicy ją mieli na %direction% %distance% stąd, o ile dobrze pamiętam.",
		"Całe swe życie polowałem na koczowników na granicach %terrain%, ale nigdy wcześniej nie widziałem kogoś z taką tarczą. To było %distance% na %direction% stąd, w jednym z ich obozów.",
		"Koczownicy zabierają nie tylko żywym, ale też i umarłym! Krąży wieść, że ukradli tarczę zwaną %item% z grobowca na %direction% stąd i nadal mają tam swój obóz. Naprawdę nie mają w sobie krztyny godności."
	],
	[
		"Niegdyś byłem pierwszym kwatermistrzem Wezyra. Kiedy słynna zbroja, którą zamówiłem dla honorowego gościa nie dotarła na miejsce, wylano mnie. Jak się później dowiedziałem, przewożąca ją karawana została napadnięta przez koczowników gdzieś na %direction% stąd.",
		"Wykwintna zbroja jest ponoć ukryta gdzieś %terrain% na %direction% stąd. Wielu poszukiwaczy skarbów próbowało ją odzyskać, jednak nikomu się nie powiodło. Może ty będziesz mieć więcej szczęścia?",
		"Najbardziej uzdolniony w okolicy płatnerz, który akurat jest moim przyjacielem, został oszukany przez tych przeklętych koczowników i zwiali z jedną najlepszych zbroi. Jeśli natkniesz się na jakichś koczowników na %direction% stąd, przeszukaj ich ciała dokładnie!"
	]
];
gt.Const.Strings.RumorsGreaterEvil <- [
	[],
	[
		"Szlachcice znów się między sobą powadzili jak dwie stare jędze przy płocie. Po prostu nie są w stanie przełknąć swej dumy!",
		"Szlachta odbierze ci wszystkie twoje korony, a także twych synów i mężów, rzucając wszystko w ogień swych bezsensownych wojen - niech po tysiąckroć będą przeklęci!",
		"Odsłużyłem swoje w armii dwadzieścia lat temu. Straciłem ucho, widzisz? A teraz i mój chłopiec maszeruje. Porwali go wprost sprzed stajni i wcielili do pierwszych szeregów. Inna wojna, to samo gówno. Modlę się, aby się nie wychylał i trzymał tarczę wysoko."
	],
	[
		"Zielony przypływ zdaje się zmywać armię za armią! Wszyscyśmy zgubieni! Zgubieni!",
		"Wszyscy uciekają przed zielonoskórymi, ale nie ja! Będę stał dumnie, z maczugą w jednej i dzbankiem w drugiej dłoni! Dawajcie mi ich tu!",
		"Ledwie zdołaliśmy odeprzeć zielonoskórych ostatnim razem w Bitwie o Wielu Nazwach, cudem nam się wtedy udało, a teraz znów wrócili.",
		"Dochodzą nas codziennie wieści o coraz to większej ilości spalonych gospodarstw i przysiółków. To zielonoskórzy napadają na wiejskie tereny."
	],
	[
		"Niechaj Starzy Bogowie się nad nami zmiłują! Umarli w całej krainie wiercą się w swych grobach. W końcu przyjdą po żywych. Pokutujcie, pokutujcie i módlcie się!",
		"Szlachta jest w odwrocie i nikt nie wie jak powstrzymać to nieumarłe zagrożenie, które po nas idzie. Muszę przestać o tym myśleć - oberżysto! Jeszcze jeden!",
		"Może powinienem się po prostu powiesić, skończyć z tym wszystkim i dołączyć do maszerujących trupów. To czekanie doprowadza mnie do szaleństwa!",
		"Znaleziono martwego człeka przy głównym szlaku. Siedział prosto na wozie przyczepionym do osła, cały wysuszony, jak kukiełka ze skóry, włosów i kości. Osioł podobnież. Zupełnie jakby wyssano z nich krew.",
		"Puste groby, straszne duchy, wysuń głowę spod poduchy\nGolnij sobie, przeleć dziewkę i opróżnij swą sakiewkę!\nPij na umór, baluj wszędzie, jutro i tak po nas będzie!",
		"%randomnoble% miał niezłą przygodę, bo jego obiad nagle ożył. Miał właśnie wziąć solidnego gryza faszerowanej gęsi, gdy ta zeskoczyła z talerza i zaczęła biegać w kółko. Rozniosła pieczone jabłka po całych kwaterach mieszkalnych. To musiał być niezapomniany widok."
	],
	[
		"Słyszałeś wieści? Armie zbierają się pod osadą %randomtown%, aby wyruszyć na południe. Mam tylko nadzieję, że pozłociści któregoś dnia nie uderzą na nas w ramach zemsty...",
		"Jeśli szukasz zarobku to powinieneś ruszyć na południe i dać tym czcicielom słońca porządną nauczkę!",
		"Co.... CO!? Nie słyszę cię! Walczyłem przeciwko tym przeklętym czcicielom Pozłotnika pod Wyrocznią i coś głośnego wystrzeliło mi tuż przy uchu...",
		"Chcesz trochę zupy? Mam tam wołowinę i ziemniaki. jednak żadnych przypraw. Skończyły mi się przez tę całą wojnę.",
		"Kapłan mówi, że starzy bogowie wezmą cię do siebie, jeśli nie wrócisz żywy z krucjaty. Dobrze wiedzieć, co nie? Ci fanatycy Pozłotnika są dość niebezpieczni.",
		"Możesz w to uwierzyć? %randomnoble% zapłacił jakimś koczownikom, aby poprowadzili jego armie przez pustynię. Czyste szaleństwo, jeśli to prawda. Własnych szczyn bym tym przebiegłym wężom nie powierzył.",
		"Mój bratanek zginął na pustyni. Biedak. Wyruszył bronić wiary i został za to przebity włócznią. Łajdak, który to zrobił nadal żyje. Oby przyszło im za to zapłacić. Oby ci po trzykroć przeklęci gnoje za to zapłacili!"
	]
];

