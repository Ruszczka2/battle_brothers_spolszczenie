local dagger_1h = "Sztylet, Broń jednoręczna";
local sword_1h = "Miecz, Broń jednoręczna";
local sword_2h = "Miecz, Broń dwuręczna";
local cleaver_1h = "Tasak, Broń jednoręczna";
local cleaver_2h = "Tasak, Broń dwuręczna";
local axe_1h = "Topór, Broń jednoręczna";
local axe_2h = "Topór, Broń dwuręczna";
local spear_1h = "Włócznia, Broń jednoręczna";
local spear_2h = "Włócznia, Broń dwuręczna";
local flail_1h = "Cep, Broń jednoręczna";
local flail_2h = "Cep, Broń dwuręczna";
local mace_1h = "Maczuga, Broń jednoręczna";
local mace_2h = "Maczuga, Broń dwuręczna";
local hammer_1h = "Młot, Broń jednoręczna";
local hammer_2h = "Młot, Broń dwuręczna";
local thrown_1h = "Broń miotana, Jednoręczna";
local thrown_2h = "Broń miotana, Dwuręczna";
local pole_2h = "Broń drzewcowa, Dwuręczna";
::mods_hookNewObject("items/weapons/shortsword", function ( o )
{
	o.m.Name = "Krótki Miecz";
	o.m.Description = "Krótki miecz z surowego żelaza, z odrobiną wgnieceń i szczerbów, łatwy do władania jedną ręką.";
	o.m.Categories = sword_1h;
});
::mods_hookNewObject("items/weapons/arming_sword", function ( o )
{
	o.m.Name = "Miecz Rycerski";
	o.m.Description = "Lekki i prosty miecz, dobry do pchnięć, cięć i szlachtowania ofiar.";
	o.m.Categories = sword_1h;
});
::mods_hookNewObject("items/weapons/falchion", function ( o )
{
	o.m.Name = "Falcjon";
	o.m.Description = "Zakrzywiony miecz, sprawdzający się najlepiej w rąbaniu i cięciu nieopancerzonych przeciwników.";
	o.m.Categories = sword_1h;
});
::mods_hookNewObject("items/weapons/fencing_sword", function ( o )
{
	o.m.Name = "Rapier";
	o.m.Description = "Lekkie i eleganckie ostrze, faworyzujące szybkie i mobilne style walki. Ulubiona broń szermierzy.";
	o.m.Categories = sword_1h;
});
::mods_hookNewObject("items/weapons/longsword", function ( o )
{
	o.m.Name = "Długi Miecz";
	o.m.Description = "Długie, dwuręczne ostrze, które jest bardzo wszechstronnym orężem.";
	o.m.Categories = sword_1h;
});
::mods_hookNewObject("items/weapons/noble_sword", function ( o )
{
	o.m.Name = "Szlachecki Miecz";
	o.m.Description = "Dobrze wyważony długi miecz z obosiecznym ostrzem.";
	o.m.Categories = sword_1h;
});
::mods_hookNewObject("items/weapons/scimitar", function ( o )
{
	o.m.Name = "Bułat";
	o.m.Description = "Egzotyczny zakrzywiony miecz, wywodzący się z południa. Doskonały do zadawania cięć, choć niezbyt się sprawdza przy pchnięciach i przebijaniu pancerza.";
	o.m.Categories = sword_1h;
});
::mods_hookNewObject("items/weapons/shamshir", function ( o )
{
	o.m.Name = "Szamszir";
	o.m.Description = "To świetnie wykonane egzotyczne ostrze z południa ma zakrzywioną klingę, która pozwala na łatwe zadawanie głębokich cięć, choć gorzej się nadaje do wyprowadzania pchnięć i przebijania pancerza. Rzadki okaz w tych stronach.";
	o.m.Categories = sword_1h;
});
::mods_hookNewObject("items/weapons/oriental/saif", function ( o )
{
	o.m.Name = "Saif";
	o.m.Description = "Zakrzywiony miecz, spotykany zazwyczaj tylko na południowych krańcach świata. Doskonały do cięć, choć słabo się sprawdza przy pchnięciach i przebijaniu pancerza.";
	o.m.Categories = sword_1h;
});
::mods_hookNewObject("items/weapons/ancient/broken_ancient_sword", function ( o )
{
	o.m.Name = "Złamany Starożytny Miecz";
	o.m.Description = "Starożytny miecz ze złamaną klingą, co znacznie ogranicza jego zasięg.";
	o.m.Categories = sword_1h;
});
::mods_hookNewObject("items/weapons/ancient/ancient_sword", function ( o )
{
	o.m.Name = "Starożytny Miecz";
	o.m.Description = "Proste ostrze o starożytnym rodowodzie. Rękojeść pokryta jest dziwacznymi zdobieniami, co może czynić miecz wartościowym dla historyków lub innych uczonych indywiduów";
	o.m.Categories = sword_1h;
});
::mods_hookNewObject("items/weapons/greenskins/goblin_falchion", function ( o )
{
	o.m.Name = "Okrutny Bułat";
	o.m.Description = "Lekki gobliński bułat stworzony do cięć.";
	o.m.Categories = sword_1h;
});
::mods_hookNewObject("items/weapons/warbrand", function ( o )
{
	o.m.Name = "Brzytwa Bojowa";
	o.m.Description = "Dwuręczna wersja miecza o długiej i wąskiej klindze, zaostrzonej tylko z jednej strony i pozbawionej jelca. Można jej użyć zarówno do szybkich cięć, jak i zamaszystych ciosów.";
	o.m.Categories = sword_2h;
});
::mods_hookNewObject("items/weapons/greatsword", function ( o )
{
	o.m.Name = "Miecz Dwuręczny";
	o.m.Description = "Długie, dwuręczne ostrze, nadające się tak do rąbania, jak i cięcia.";
	o.m.Categories = sword_2h;
});
::mods_hookNewObject("items/weapons/ancient/rhomphaia", function ( o )
{
	o.m.Name = "Rhomphaia";
	o.m.Description = "Długie, zakrzywione, jednostronne ostrze na długim trzonku. Broń używana zarówno do szybkich cięć, jak i zamaszystych ciosów.";
	o.m.Categories = sword_2h;
});
::mods_hookNewObject("items/weapons/battle_whip", function ( o )
{
	o.m.Name = "Bicz Bojowy";
	o.m.Description = "Długi bicz z kolczastym czubkiem, który potrafi rozrywać paskudnie krwawiące rany na znaczną odległość, choć jest nieskuteczny przeciwko pancerzowi.";
	o.m.Categories = cleaver_1h;
});
::mods_hookNewObject("items/weapons/butchers_cleaver", function ( o )
{
	o.m.Name = "Tasak Rzeźnika";
	o.m.Description = "Narzędzie z grubym, czworokątnym ostrzem, używane do rąbania mięsa i kości.";
	o.m.Categories = cleaver_1h;
});
::mods_hookNewObject("items/weapons/military_cleaver", function ( o )
{
	o.m.Name = "Wojskowy Tasak";
	o.m.Description = "Duży, zaostrzony kawał metalu, stworzony z myślą o zadawaniu niszczycielskich ciosów.";
	o.m.Categories = cleaver_1h;
});
::mods_hookNewObject("items/weapons/scramasax", function ( o )
{
	o.m.Name = "Saks";
	o.m.Description = "Długi i ciężki nóż z jednostronnym ostrzem, używany bardziej do siekania, niż cięcia.";
	o.m.Categories = cleaver_1h;
});
::mods_hookNewObject("items/weapons/ancient/falx", function ( o )
{
	o.m.Name = "Falks";
	o.m.Description = "Krótkie i ciężkie ostrze o zakrzywionej krawędzi, stworzone z myślą o rąbaniu i zadawaniu szarpanych, krwawiących ran. Przytępione przez upływ czasu.";
	o.m.Categories = cleaver_1h;
});
::mods_hookNewObject("items/weapons/ancient/khopesh", function ( o )
{
	o.m.Name = "Khopesh";
	o.m.Description = "Starożytny zakrzywiony miecz na długim trzonku z dziwnymi zdobieniami. Jego kształt sprawia, że jest szczególnie skuteczny przeciwko pancerzowi.";
	o.m.Categories = cleaver_1h;
});
::mods_hookNewObject("items/weapons/barbarians/thorned_whip", function ( o )
{
	o.m.Name = "Ciernisty Bicz";
	o.m.Description = "Wytrzymały ciernisty bicz. Używany przez barbarzyńców zarówno w bitwach, jak i do przeganiania stad dzikich bestii, gdyż nawet największe z nich kulą się na jego donośny trzask.";
	o.m.Categories = cleaver_1h;
});
::mods_hookNewObject("items/weapons/barbarians/blunt_cleaver", function ( o )
{
	o.m.Name = "Tępy Tasak";
	o.m.Description = "Ten tasak jest ciężki i tępy, choć nadal jest w stanie zadawać straszliwe rany.";
	o.m.Categories = cleaver_1h;
});
::mods_hookNewObject("items/weapons/barbarians/antler_cleaver", function ( o )
{
	o.m.Name = "Tasak z Poroża";
	o.m.Description = "Bardzo prymitywny tasak wykonany z zaostrzonego poroża. Ciężki i tępy, choć nadal niebezpieczny.";
	o.m.Categories = cleaver_1h;
});
::mods_hookNewObject("items/weapons/greenskins/orc_cleaver", function ( o )
{
	o.m.Name = "Odrąbywacz Czerepów";
	o.m.Description = "Ostry i prymitywny kawał metalu z owiniętą rękojeścią. Przypomina nieco miecz, lecz jest o wiele cięższy. Nie nadaje się zbytnio do rąk ludzkich.";
	o.m.Categories = cleaver_1h;
});
::mods_hookNewObject("items/weapons/oriental/two_handed_saif", function ( o )
{
	o.m.Name = "Dwuręczny Saif";
	o.m.Description = "Długa wersja saifa, dzierżona oburącz. Zakrzywione ostrze potrafi zadawać makabryczne rany.";
	o.m.Categories = cleaver_2h;
});
::mods_hookNewObject("items/weapons/oriental/two_handed_scimitar", function ( o )
{
	o.m.Name = "Dwuręczny Bułat";
	o.m.Description = "Wielki bułat dzierżony oburącz. Zakrzywiona klinga przerżnie się przez każdego wroga.";
	o.m.Categories = cleaver_2h;
});
::mods_hookNewObject("items/weapons/ancient/crypt_cleaver", function ( o )
{
	o.m.Name = "Tasak z Krypty";
	o.m.Description = "Ciężkie ostrze z dziwacznie zakrzywionym szpicem. Ten dwuręczny tasak łączy w sobie właściwości miecza i topora.";
	o.m.Categories = cleaver_2h;
});
::mods_hookNewObject("items/weapons/barbarians/rusty_warblade", function ( o )
{
	o.m.Name = "Zardzewiałe Wojenne Ostrze";
	o.m.Description = "Ciężkie ostrze z zakrzywionym szpicem, łączy w sobie cechy miecza i topora w tym niszczycielskim dwuręcznym tasaku.";
	o.m.Categories = cleaver_2h;
});
::mods_hookNewObject("items/weapons/fighting_axe", function ( o )
{
	o.m.Name = "Topór Bojowy";
	o.m.Description = "Topór stworzony z myślą o walce z opancerzonymi przeciwnikami. Dość wytrzymały.";
	o.m.Categories = axe_1h;
});
::mods_hookNewObject("items/weapons/hand_axe", function ( o )
{
	o.m.Name = "Toporek";
	o.m.Description = "Jednoręczny topór ze średnio długim trzonkiem i udoskonaloną głowicą.";
	o.m.Categories = axe_1h;
});
::mods_hookNewObject("items/weapons/hatchet", function ( o )
{
	o.m.Name = "Siekiera";
	o.m.Description = "Prymitywny topór z krótkim trzonkiem i żelazną głowicą.";
	o.m.Categories = axe_1h;
});
::mods_hookNewObject("items/weapons/barbarians/crude_axe", function ( o )
{
	o.m.Name = "Prymitywny Topór";
	o.m.Description = "Ten topór został wykonany prymitywnie, ale jest ciężki i postrzępiony.";
	o.m.Categories = axe_1h;
});
::mods_hookNewObject("items/weapons/greenskins/orc_axe", function ( o )
{
	o.m.Name = "Rozłupywacz Czerepów";
	o.m.Description = "Ciężki kawał metalu z ostrą głowicą. Nie nadaje się zbytnio do rąk ludzkich.";
	o.m.Categories = axe_1h;
});
::mods_hookNewObject("items/weapons/woodcutters_axe", function ( o )
{
	o.m.Name = "Topór Drwala";
	o.m.Description = "Długi, dwuręczny topór, uderzający ciężko z każdym zamachem. Dzierżony oburącz służy do powalania rosłych drzew, choć człowieka też bez problemu powali.";
	o.m.Categories = axe_2h;
});
::mods_hookNewObject("items/weapons/greataxe", function ( o )
{
	o.m.Name = "Wielki Topór";
	o.m.Description = "Ciężki i długi dwuręczny topór, stworzony do bitew. Trudny i męczący we władaniu, acz zdolny do rozłupania człowieka na pół.";
	o.m.Categories = axe_2h;
});
::mods_hookNewObject("items/weapons/bardiche", function ( o )
{
	o.m.Name = "Berdysz";
	o.m.Description = "Sporych rozmiarów topór z długą głowicą, którą można opuścić na wroga z niszczycielskim efektem.";
	o.m.Categories = axe_2h;
});
::mods_hookNewObject("items/weapons/longaxe", function ( o )
{
	o.m.Name = "Długi Topór";
	o.m.Description = "Względnie cienka głowica na bardzo długim drzewcu, używana do zadawania niszczycielskich cięć z pewnej odległości oraz do rozłupywania tarcz zza przedniej linii.";
	o.m.Categories = axe_2h;
});
::mods_hookNewObject("items/weapons/barbarians/heavy_rusty_axe", function ( o )
{
	o.m.Name = "Ciężki Zardzewiały Topór";
	o.m.Description = "Ten ciężki, zardzewiały topór działa bardziej dzięki swemu ciężarowi, niż swej ostrości, ale jak by nie było - swoją rolę spełnia.";
	o.m.Categories = axe_2h;
});
::mods_hookNewObject("items/weapons/greenskins/orc_axe_2h", function ( o )
{
	o.m.Name = "Rozłupywacz Ludzi";
	o.m.Description = "Ogromny i prymitywnie wykonany dwuręczny topór bojowy, zbyt ciężki, by przeciętny człowiek skutecznie się nim posługiwał.";
	o.m.Categories = axe_2h;
});
::mods_hookNewObject("items/weapons/pickaxe", function ( o )
{
	o.m.Name = "Kilof";
	o.m.Description = "Twarda metalowa głowica przymocowana do drewnianego trzonka. Kilof jest narzędziem górniczym, służącym do rozbijania skał. Jako improwizowana broń jest dość nieporęczny, choć potrafi zadawać groźne rany nawet przez pancerz.";
	o.m.Categories = hammer_1h;
});
::mods_hookNewObject("items/weapons/military_pick", function ( o )
{
	o.m.Name = "Nadziak";
	o.m.Description = "Drewniany trzonek z długą, szpiczastą metalową głowicą, stworzony do przebijania najtwardszych pancerzy.";
	o.m.Categories = hammer_1h;
});
::mods_hookNewObject("items/weapons/warhammer", function ( o )
{
	o.m.Name = "Młot Bojowy";
	o.m.Description = "Krótki żelazny młot bojowy, który z łatwością przebija się przez płyty pancerza.";
	o.m.Categories = hammer_1h;
});
::mods_hookNewObject("items/weapons/polehammer", function ( o )
{
	o.m.Name = "Młot na Drzewcu";
	o.m.Description = "Młot bojowy osadzony na długim drągu, używany przeciwko opancerzonym celom i na pewien dystans, lub zza przedniej linii.";
	o.m.Categories = hammer_2h;
});
::mods_hookNewObject("items/weapons/two_handed_wooden_hammer", function ( o )
{
	o.m.Name = "Dwuręczny Drewniany Młot";
	o.m.Description = "Wielki drewniany tłuczek, którego dzierży się oburącz. Potrafi zadawać niszczycielskie ciosy, które nawet opancerzonych przeciwników potrafią odrzucić, lub przybić do ziemi.";
	o.m.Categories = hammer_2h;
});
::mods_hookNewObject("items/weapons/two_handed_hammer", function ( o )
{
	o.m.Name = "Dwuręczny Młot";
	o.m.Description = "Wielki i ciężki młot, którego dzierży się oburącz. Swe braki w gracji nadrabia prymitywną siłą, gdyż używa się go do rozłupywania nawet najciężej opancerzonych linii wroga, odrzucając ludzi na boki, lub przybijając ich do ziemi.";
	o.m.Categories = hammer_2h;
});
::mods_hookNewObject("items/weapons/barbarians/skull_hammer", function ( o )
{
	o.m.Name = "Dwuręczny Czaszkowy Młot";
	o.m.Description = "Prymitywny metalowy młot używany oburącz, aby zmiażdżyć pancerz wraz z noszącą go osobą.";
	o.m.Categories = hammer_2h;
});
::mods_hookNewObject("items/weapons/wooden_stick", function ( o )
{
	o.m.Name = "Drewniana Pałka";
	o.m.Description = "Prosty drewniany kijek, zwykle broń improwizowana.";
	o.m.Categories = mace_1h;
});
::mods_hookNewObject("items/weapons/bludgeon", function ( o )
{
	o.m.Name = "Wekiera";
	o.m.Description = "Ćwiekowana metalowa głowica na drewnianym trzonku. Broń dość prymitywna, lecz skuteczna w rozwalaniu łbów.";
	o.m.Categories = mace_1h;
});
::mods_hookNewObject("items/weapons/morning_star", function ( o )
{
	o.m.Name = "Morgensztern";
	o.m.Description = "Drewniany trzonek z kolczastą metalową głowicą, używany by zadawać zarówno obrażenia obuchowe, jak i przebijające.";
	o.m.Categories = mace_1h;
});
::mods_hookNewObject("items/weapons/winged_mace", function ( o )
{
	o.m.Name = "Piernacz";
	o.m.Description = "W pełni metalowa buława z krótkim trzonkiem i przepierzeniami.";
	o.m.Categories = mace_1h;
});
::mods_hookNewObject("items/weapons/oriental/light_southern_mace", function ( o )
{
	o.m.Name = "Lekki Południowy Buzdygan";
	o.m.Description = "Metalowy buzdygan z szerokimi skrzydłami, aby dodać mu nieco skuteczności przeciwko pancerzom.";
	o.m.Categories = mace_1h;
});
::mods_hookNewObject("items/weapons/oriental/nomad_mace", function ( o )
{
	o.m.Name = "Buława Koczownika";
	o.m.Description = "Prosta buława z metalową głowicą. Tego typu broń jest popularna wśród koczowników na pustyniach.";
	o.m.Categories = mace_1h;
});
::mods_hookNewObject("items/weapons/oriental/heavy_southern_mace", function ( o )
{
	o.m.Name = "Ciężki Południowy Buzdygan";
	o.m.Description = "Ciężki buzdygan z przepierzeniami, powszechnie używany przez dobrze wyposażonych żołnierzy południowych krańców świata.";
	o.m.Categories = mace_1h;
});
::mods_hookNewObject("items/weapons/barbarians/claw_club", function ( o )
{
	o.m.Name = "Szponiasta Pałka";
	o.m.Description = "Masywne szpony jakiegoś dzikiego zwierza zostały przymocowane do tej sporej pałki.";
	o.m.Categories = mace_1h;
});
::mods_hookNewObject("items/weapons/greenskins/goblin_staff", function ( o )
{
	o.m.Name = "Sękata Laska";
	o.m.Description = "Sękaty kij, wyciosany ze starego i twardego drewna, przystrojony kościami i piórami. Może jakiś kolekcjoner się nim zainteresuje.";
	o.m.Categories = mace_1h;
});
::mods_hookNewObject("items/weapons/greenskins/orc_wooden_club", function ( o )
{
	o.m.Name = "Konar";
	o.m.Description = "Wielka i ciężka gałąź oderwana z drzewa. Niezbyt nadaje się do ludzkich rąk.";
	o.m.Categories = mace_1h;
});
::mods_hookNewObject("items/weapons/greenskins/orc_metal_club", function ( o )
{
	o.m.Name = "Obijak";
	o.m.Description = "Masywna drewniana pałka, wzmocniona metalowymi płytami. Nie nadaje się zbytnio do rąk ludzkich.";
	o.m.Categories = mace_1h;
});
::mods_hookNewObject("items/weapons/two_handed_mace", function ( o )
{
	o.m.Name = "Dwuręczna Maczuga";
	o.m.Description = "Masywna drewniana maczuga z kolcami na głowicy. Otrzymanie ciosu z tej broni oszołomi każdego, bez względu na to jak mocno jest opancerzony.";
	o.m.Categories = mace_2h;
});
::mods_hookNewObject("items/weapons/two_handed_flanged_mace", function ( o )
{
	o.m.Name = "Dwuręczny Buzdygan";
	o.m.Description = "Wielki i ciężki buzdygan, dzierżony oburącz. Otrzymanie ciosu z tej broni oszołomi każdego, bez względu na to jak mocno jest opancerzony.";
	o.m.Categories = mace_2h;
});
::mods_hookNewObject("items/weapons/oriental/polemace", function ( o )
{
	o.m.Name = "Buława na Drzewcu";
	o.m.Description = "Długa buława, której można użyć do zadawania ogłuszających ciosów na odległość.";
	o.m.Categories = mace_2h;
});
::mods_hookNewObject("items/weapons/barbarians/two_handed_spiked_mace", function ( o )
{
	o.m.Name = "Dwuręczna Kolczasta Maczuga";
	o.m.Description = "Ogromna maczuga z pokaźną czaszką na końcu. Otrzymanie ciosu z tej broni oszołomi każdego, bez względu na to jak mocno jest opancerzony.";
	o.m.Categories = mace_2h;
});
::mods_hookNewObject("items/weapons/boar_spear", function ( o )
{
	o.m.Name = "Włócznia Myśliwska";
	o.m.Description = "Krótka i ciężka włócznia z dwoma skrzydłami za swym graniastym grotem.";
	o.m.Categories = spear_1h;
});
::mods_hookNewObject("items/weapons/fighting_spear", function ( o )
{
	o.m.Name = "Włócznia Bojowa";
	o.m.Description = "Długa i wytrzymała włócznia, wykuta z myślą o walce.";
	o.m.Categories = spear_1h;
});
::mods_hookNewObject("items/weapons/militia_spear", function ( o )
{
	o.m.Name = "Włócznia Milicji";
	o.m.Description = "Prosta drewniana włócznia z metalowym grotem.";
	o.m.Categories = spear_1h;
});
::mods_hookNewObject("items/weapons/ancient/ancient_spear", function ( o )
{
	o.m.Name = "Starożytna Włócznia";
	o.m.Description = "Starożytna drewniana włócznia prostego wzoru. Czas odbił na niej swoje piętno.";
	o.m.Categories = spear_1h;
});
::mods_hookNewObject("items/weapons/greenskins/goblin_spear", function ( o )
{
	o.m.Name = "Gobliński Szpikulec";
	o.m.Description = "Długi drąg z ostrym metalowym szpicem na końcu.";
	o.m.Categories = spear_1h;
});
::mods_hookNewObject("items/weapons/spetum", function ( o )
{
	o.m.Name = "Spisa";
	o.m.Description = "Coś pomiędzy piką, a włócznią, dzięki czemu jest to dobra broń defensywna. Używana do pchnięć na pewną odległość i trzymania wroga na dystans.";
	o.m.Categories = spear_2h;
});
::mods_hookNewObject("items/weapons/warfork", function ( o )
{
	o.m.Name = "Widły Bojowe";
	o.m.Description = "Zwykłe widły przekute w broń bitewną, która jest czymś pomiędzy włócznią, a piką. Używane są do zadawania pchnięć na pewną odległość i trzymania wrogów na dystans.";
	o.m.Categories = spear_2h;
});
::mods_hookNewObject("items/weapons/billhook", function ( o )
{
	o.m.Name = "Gizarma";
	o.m.Description = "Podobna do piki broń z ostrzem do zadawania ciosów na dystans oraz hakiem do przyciągania celów.";
	o.m.Categories = pole_2h;
});
::mods_hookNewObject("items/weapons/hooked_blade", function ( o )
{
	o.m.Name = "Sierp Bojowy";
	o.m.Description = "Narzędzie rolnicze dostosowane do używania w bitwach. Ta broń drzewcowa ma zakrzywione ostrze do zadawania ciosów z pewnej odległości i do przyciągania celów.";
	o.m.Categories = pole_2h;
});
::mods_hookNewObject("items/weapons/pike", function ( o )
{
	o.m.Name = "Pika";
	o.m.Description = "Długa pika używana do zadawania pchnięć z pewnej odległości i trzymania wroga na dystans.";
	o.m.Categories = pole_2h;
});
::mods_hookNewObject("items/weapons/pitchfork", function ( o )
{
	o.m.Name = "Widły";
	o.m.Description = "Rolnicze narzędzie z długim trzonkiem i grubymi zaostrzonymi zębami, używane do przenoszenia i rozgarniania słomy. Jako broń improwizowana mogą być użyte do trzymania wroga na dystans, choć nie zadadzą potężnych obrażeń i słabo się sprawdzają przeciwko pancerzowi.";
	o.m.Categories = pole_2h;
});
::mods_hookNewObject("items/weapons/oriental/swordlance", function ( o )
{
	o.m.Name = "Glewia";
	o.m.Description = "Długi drąg przymocowany do ostrej, zakrzywionej klingi. Broń służąca do zadawania szerokich cięć z pewnej odległości.";
	o.m.Categories = pole_2h;
});
::mods_hookNewObject("items/weapons/ancient/broken_bladed_pike", function ( o )
{
	o.m.Name = "Złamana Starożytna Partyzana";
	o.m.Description = "Partyzana z ułamanym grotem. Nie każda broń pomyślnie przechodzi próbę czasu. Niegdyś używana do atakowania z pewnej odległości i trzymania wroga na dystans.";
	o.m.Categories = pole_2h;
});
::mods_hookNewObject("items/weapons/ancient/bladed_pike", function ( o )
{
	o.m.Name = "Starożytna Partyzana";
	o.m.Description = "Długa, starożytna pika o pociągłym grocie, używana do atakowania z pewnej odległości i trzymania wroga na dystans.";
	o.m.Categories = pole_2h;
});
::mods_hookNewObject("items/weapons/ancient/warscythe", function ( o )
{
	o.m.Name = "Kosa Bojowa";
	o.m.Description = "Długi drąg przymocowany do zakrzywionego ostrza, służący do wykonywania zamaszystych cięć z pewnej odległości.";
	o.m.Categories = pole_2h;
});
::mods_hookNewObject("items/weapons/greenskins/goblin_pike", function ( o )
{
	o.m.Name = "Strzępiasta Pika";
	o.m.Description = "Długa strzępiasta pika, która potrafi zadawać szarpane i paskudnie krwawiące rany oraz trzymać wrogów na dystans dzięki swemu sporemu zasięgowi.";
	o.m.Categories = pole_2h;
});
::mods_hookNewObject("items/weapons/knife", function ( o )
{
	o.m.Name = "Nóż";
	o.m.Description = "Krótki nóż, nie wykonany z myślą o walce.";
	o.m.Categories = dagger_1h;
});
::mods_hookNewObject("items/weapons/dagger", function ( o )
{
	o.m.Name = "Sztylet";
	o.m.Description = "Szpiczasty sztylet wykuty z myślą o walce w bardzo bliskim zwarciu.";
	o.m.Categories = dagger_1h;
});
::mods_hookNewObject("items/weapons/rondel_dagger", function ( o )
{
	o.m.Name = "Sztylet Tarczkowy";
	o.m.Description = "Długi, czworoboczny kolec, wykuty z myślą o przebijaniu się przez słabe punkty w pancerzu.";
	o.m.Categories = dagger_1h;
});
::mods_hookNewObject("items/weapons/oriental/qatal_dagger", function ( o )
{
	o.m.Name = "Sztylet Qatal";
	o.m.Description = "Zakrzywione ostrze notorycznie używane przez skrytobójców z południowych pustyń. Szczególnie skuteczne przeciwko celom już osłabionym.";
	o.m.Categories = dagger_1h;
});
::mods_hookNewObject("items/weapons/wooden_flail", function ( o )
{
	o.m.Name = "Drewniany Cep";
	o.m.Description = "Dwa duże kijki połączone kawałkiem łańcucha. Drewniany cep jest narzędziem rolnym, używanym do młócenia zboża. Jako improwizowana broń jest raczej nieprzewidywalny, choć użyteczny do uderzania nad lub wokół tarcz.";
	o.m.Categories = flail_1h;
});
::mods_hookNewObject("items/weapons/reinforced_wooden_flail", function ( o )
{
	o.m.Name = "Wzmocniony Drewniany Cep";
	o.m.Description = "Dwa duże kijki połączone kawałkiem łańcucha i wzmocnione metalem. Wzmocniony drewniany cep jest narzędziem rolnym przerobionym na broń. Raczej dość nieprzewidywalny, choć wystarczająco zabójczy, by położyć trupem po celnym trafieniu w głowę i użyteczny do uderzania nad lub wokół tarcz.";
	o.m.Categories = flail_1h;
});
::mods_hookNewObject("items/weapons/flail", function ( o )
{
	o.m.Name = "Cep bojowy";
	o.m.Description = "Metalowa głowica przytwierdzona do trzonka łańcuchem. Dość nieprzewidywalna broń, choć użyteczna do uderzania nad lub wokół tarcz.";
	o.m.Categories = flail_1h;
});
::mods_hookNewObject("items/weapons/three_headed_flail", function ( o )
{
	o.m.Name = "Korbacz";
	o.m.Description = "Trzy metalowe głowice przymocowane do trzonka łańcuchami. Każda z głowic oddzielnie może trafić lub chybić celu oraz uderzyć ponad lub wokół tarczy.";
	o.m.Categories = flail_1h;
});
::mods_hookNewObject("items/weapons/two_handed_wooden_flail", function ( o )
{
	o.m.Name = "Dwuręczny Drewniany Cep";
	o.m.Description = "Ciężki dwuręczny drewniany cep, który zdolny jest do uderzania ponad lub wokół tarczy.";
	o.m.Categories = flail_2h;
});
::mods_hookNewObject("items/weapons/two_handed_flail", function ( o )
{
	o.m.Name = "Dwuręczny Cep Bojowy";
	o.m.Description = "Duży i ciężki metalowy cep, który wymaga użycia obu rąk. Użyteczny do uderzania nad lub wokół tarcz.";
	o.m.Categories = flail_2h;
});
::mods_hookNewObject("items/weapons/greenskins/orc_flail_2h", function ( o )
{
	o.m.Name = "Łańcuch Berserkera";
	o.m.Description = "Masywny żelazny łańcuch z kolczastą, w pełni metalową głowicą na końcu. Zbyt ciężki, by przeciętny człowiek skutecznie się nim posługiwał.";
	o.m.Categories = flail_2h;
});
::mods_hookNewObject("items/weapons/goedendag", function ( o )
{
	o.m.Name = "Goedendag";
	o.m.Description = "Wzmocniona metalem maczuga ze szpikulcem na końcu. Można nią dźgać wrogów, lub wytłuc na nich posłuszeństwo.";
	o.m.Categories = "Włócznia/Maczuga, Broń dwuręczna";
});
::mods_hookNewObject("items/weapons/lute", function ( o )
{
	o.m.Name = "Lutnia";
	o.m.Description = "Instrument muzyczny, który w odpowiednich rękach jest zdolny do wydobywania z siebie miłych dźwięków poprzez swe wibrujące struny.";
	o.m.Categories = "Instrument muzyczny, Broń dwuręczna";
});
::mods_hookNewObject("items/weapons/barbarians/axehammer", function ( o )
{
	o.m.Name = "Toporomłot";
	o.m.Description = "Masywna, zardzewiała hybryda młota i topora. Przez swoje tępe krawędzie bardziej to pierwsze, niż to drugie";
	o.m.Categories = "Młot/Topór, Broń jednoręczna";
});
::mods_hookNewObject("items/weapons/barbarians/drum_item", function ( o )
{
	o.m.Name = "Bęben";
});
::mods_hookNewObject("items/weapons/greenskins/goblin_notched_blade", function ( o )
{
	o.m.Name = "Wyszczerbione Ostrze";
	o.m.Description = "Długi, zakrzywiony nóż z jednostronnym ostrzem, używany do cięcia, siekania i dźgania w słabe punkty.";
	o.m.Categories = "Miecz/Sztylet, Broń jednoręczna";
});
::mods_hookNewObject("items/weapons/oriental/firelance", function ( o )
{
	o.m.Name = "Lanca Ogniowa";
	o.m.Description = "Włócznia wykonana na południową modłę, z doczepionym ładunkiem wybuchowym, który po odpaleniu wypluwa z siebie ogień na dwa pola. Ładunku można użyć tylko raz na bitwę, ale po bitwie automatycznie się uzupełnia.";
	o.m.Categories = "Włócznia/Broń palna, Jednoręczna";
	o.setAmmo = function ( _a )
	{
		this.weapon.setAmmo(_a);

		if (this.m.Ammo > 0)
		{
			this.m.Name = "Lanca Ogniowa";
			this.m.IconLarge = "weapons/ranged/firelance_01.png";
			this.m.Icon = "weapons/ranged/firelance_01_70x70.png";
			this.m.ArmamentIcon = "icon_firelance_01";
		}
		else
		{
			this.m.Name = "Lanca Ogniowa (Zużyta)";
			this.m.IconLarge = "weapons/ranged/firelance_02.png";
			this.m.Icon = "weapons/ranged/firelance_02_70x70.png";
			this.m.ArmamentIcon = "icon_firelance_01_empty";
		}

		this.updateAppearance();
	};
});
::mods_hookNewObject("items/weapons/legendary/lightbringer_sword", function ( o )
{
	o.m.Name = "Wspomnienie Dawnych Bogów";
	o.m.Description = "Ten miecz wygina fiolety i pomarańcze tak, jakby niósł sam zmierzch w swym zbroczu. Ciężko powiedzieć, czy w dotyku klinga parzy czy chłodzi. Magia lub niebywałe wykonanie, cokolwiek by to nie było sprawia, że miecz lekko wibruje, jakby skrywał w sobie potęgę i że wystarczy zaledwie nim machnąć, aby poznać jego prawdziwą moc.";
	o.m.Categories = sword_1h;
	o.getTooltip = function ()
	{
		local result = this.weapon.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Zadaje maksymalnie trzem celom dodatkowe [color=" + this.Const.UI.Color.DamageValue + "]10[/color] - [color=" + this.Const.UI.Color.DamageValue + "]20[/color] obrażeń, które ignorują pancerz"
		});
		return result;
	};
});
::mods_hookNewObject("items/weapons/legendary/obsidian_dagger", function ( o )
{
	o.m.Name = "Sztylet z Obsydianu";
	o.m.Description = "Pustelnicza wiedźma dała ci ten kamienny sztylet po tym, jak zahartowała go twoją krwią. Odbicia na jego szklistej klindze zdają same się poruszać, ale to zapewne tylko złudzenie optyczne. Co jednak bardzo ciekawe, krew nigdy nie zdaje się zastygać, póki znajduje się na obsydianowym ostrzu.";
	o.m.Categories = dagger_1h;
	o.getTooltip = function ()
	{
		local result = this.weapon.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Wskrzesza każdego zabitego nim człowieka jako Wiedergangera, który będzie walczył po twojej stronie"
		});
		return result;
	};
});
::mods_hookNewObject("items/weapons/legendary/miasma_flail", function ( o )
{
	o.m.Name = "Kadzielnica Wróżbity";
	o.m.Description = "Ciężka kadzielnica, przerobiona na groźną głowicę cepa, z długim trzonem. Nie wiesz, jakiego kadzidła używał Wielki Wróżbita, by podsycać swoje szalone wizje, ale pali ono jak trucizna, a broń wytwarza je z jakiegoś nieznanego, niewyczerpalnego źródła.";
	o.m.Categories = flail_2h;
	o.onEquip = function ()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/censer_strike"));
		this.addSkill(this.new("scripts/skills/actives/censer_castigate_skill"));
	};
	o.onUpdateProperties = function ( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	};
});

