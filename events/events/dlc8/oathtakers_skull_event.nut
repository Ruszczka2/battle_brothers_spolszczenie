this.oathtakers_skull_event <- this.inherit("scripts/events/event", {
	m = {
		Oathtaker = null
	},
	function create()
	{
		this.m.ID = "event.oathtakers_skull";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_183.png[/img]{Zastajesz %oathtaker% wpatrzonego w oczodoly czaszki Mlodego Anselma, ciezar kosci spoczywa na wyciagnietej dloni. Od czasu do czasu kiwa glowa i mamrocze do siebie cos w rodzaju szeptanej modlitwy. Gdy wyczuwa twoja obecnosc, Swietobiorca sie odwraca.%SPEECH_ON%Martwilem sie, lecz mimo morza chaosu mamy tu Mlodego Anselma, a on jest zrodlem odwagi takiej, ze moglbym wplynac w ocean tego swiata z pelna pewnoscia, ze mnie przez niego przeprowadzi. Powinienem szerzyc nauki Mlodego Anselma wsrod innych.%SPEECH_OFF%Jak najbardziej. | Swietobiorcy jedza dobry posilek przy ognisku. %oathtaker% ma czaszke Mlodego Anselma na pniaku. Od czasu do czasu odwraca sie, z lyzka skwarkow w dloni, i wyglada, jakby chcial nakarmic nimi kostna paszcze. Te chwile cie niepokoja, ale z jakiegos powodu mala czaszka potrafi poprawiac nastroj Swietobiorcow sama obecnoscia, na tyle, ze pozwalasz tym jednoczesnie dziewczecym i ponurym dziwactwom przejsc. | %oathtaker% przeglada tekst w filcowej oprawie i ze zloconym zakladnikiem. Obok niego czaszka Mlodego Anselma spoczywa przy dogasajacej swiecy. Pytasz Swietobiorce, co czyta. Mezczyzna podnosi wzrok.%SPEECH_ON%Zajmuje sie sprawami Slubow, tak jak Mlody Anselm je spisal. Pamietaj madra rade chlopaka: atrament jest najsilniejszym wspomnieniem, wiec nie nalezy polegac wylacznie na wlasnych mozliwosciach, by dotrzymywac Slubow, tylko odswiezac zrodla umyslu samymi zapisami. To tez bylo czescia nauk Mlodego Anselma. Wiedzialbys, gdybys dbal o teksty tak, jak radzil.%SPEECH_OFF%Troche zgryzliwie, ale nie myli sie. | Widzisz %oathtaker% czyszczacego czaszke Mlodego Anselma. Chcac wystawic wiare mezczyzny na probe, pytasz o cos, co juz wiesz: jak zmarl Anselm. Swietobiorca prostuje sie, patrzac na ciebie z szczerym oburzeniem.%SPEECH_ON%Kapitanie, niewazne jak zmarl, ani kiedy, ani dlaczego, ani przez kogo, a moze nawet nie ma tu zadnego kto, lecz liczy sie to, ze byl na Slubie Ostatecznej Sciezki, i my tez z nim jestesmy, i bedziemy do konca. Nie jestesmy tylko Swietobiorcami, lecz Ostatnimi Swietobiorcami.%SPEECH_OFF%Odwraca sie, strzepa owada z kosci i czysci czaszke tak, jakby zostala zbezczeszczona krokami owada.%SPEECH_ON%To wielkie doswiadczenie, ktore tu podejmujemy, kapitanie, ale czasem mam wrazenie, ze tylko jedziesz z nami.%SPEECH_OFF%To przynajmniej wielkie doswiadczenie w poglebianiu twoich kieszeni. Na szczescie jedyny, kto zdaje sie dostrzegac twoja bardziej cyniczna nature, to rzekomo przenikliwa czaszka, oczodoly Mlodego Anselma pusto wpatrzone w ciebie, gdy slina Swietobiorcy poleruje kosc. | %oathtaker% kleka przed czaszka Mlodego Anselma.%SPEECH_ON%Daj mi sile w naszych Slubach, Mlody Anselmie, bo sam nie dam rady, a juz na pewno nie z sama pomoca kapitana.%SPEECH_OFF%Prawie mu mowisz, ze nie jest sam, bo jest z %companyname% i ty tez nie jestes mieczakiem, ale uznajesz, ze to raczej nie miejsce na taki realizm. Nagle mezczyzna podskakuje i kiwa glowa.%SPEECH_ON%Takie wskazowki sa bardzo cenne, Mlody Anselmie.%SPEECH_OFF%Czesc ciebie chcialaby spojrzec na czaszke mlodego chlopaka po wskazowki i faktycznie je znalezc, ale jedyne, co wynosisz z kostnego oblicza Mlodego Anselma, to puste spojrzenie. | Kompania miewala wzloty i upadki, lecz Mlody Anselm wciaz uchodzi za glowne zrodlo poboznosci. Trzeba przyznac, ze czasem wpatrujesz sie w czaszke z odrobina pogardy. Mimo ze to ty prowadzisz bande, i to calkiem dobrze, wiele sukcesow kompani przypisuje sie czaszce. Gdy ludzie potrzebuja pomocy, czesto ida do czaszki, omijajac kapitana. %oathtaker% jest tego przykladem, bo ostatnio mial ciezkie dni, ale zamiast rozmawiac z toba, widzisz, jak podnosi Mlodego Anselma po kostna rade w sprawach Slubow. Czasem marzysz, by wziac czerep Pierwszego Swietobiorcy i rzucic nim przez jezioro jak kamieniem. | Czaszka Mlodego Anselma jest punktem odniesienia dla najbardziej wiernych Swietobiorcow, zrodlem wiedzy, wskazowek i czegos wiecej, wyplywajacym z niemej, kostnej skorupy. %oathtaker%, ktory w ostatnich dniach byl raczej przygnebiony, dostaje dostep do czaszki. Nawet w tym krotkim obcowaniu odnawia wiare w Sluby. | Ustawiasz czaszke Mlodego Anselma na kiju i zaczynasz nia krecic; kosc grzechocze, gdy kreci sie w kolko, a pusty klekot jest straszliwie zabawny. %oathtaker% wychodzi z krzakow, pytajac o cos, a ty natychmiast chwytasz czaszke i odkladasz ja. Swietobiorca patrzy na ciebie, na kij, na czaszke, potem znowu na ciebie. Chrzaka i tlumaczy, ze ostatnie dni byly dla niego ciezkie. Dla wskazowek, i z lenistwa, podajesz mu czaszke Mlodego Anselma, mowiac, by znalazl w Pierwszym Swietobiorcy ozywienie swojej witalnosci, odnowe wiary i powrot odwagi. Mezczyzna poslusznie kiwa glowa.%SPEECH_ON%Mlody Anselm moze i jest Pierwszym Swietobiorca, ale wciaz wierze, ze jestes madrzejszy niz wskazuje twoj wiek, kapitanie. Powinienem byl zajac sie Anselmem od poczatku!%SPEECH_OFF% | Ustawiles czaszke Mlodego Anselma na pniaku i rzucasz kamyczkami przez oczodoly. Jeden przelatuje idealnie przez otwor i unosisz piesc. W tej chwili pojawia sie %oathtaker%. Patrzy na ciebie, na zacisnieta piesc i na Mlodego Anselma. Swietobiorca kiwa glowa.%SPEECH_ON%Skoro nawet cynik taki jak ty moze otrzymac odwage od Mlodego Anselma, to zdolnosci Pierwszego Swietobiorcy musza wykraczac poza to, co nawet ja uwazalem. Zostawie cie samego, abys mogl znalezc dalsze wskazowki u Mlodego Anselma.%SPEECH_OFF%Przytakujesz i dziekujesz Swietobiorcy, ale gdy odchodzi, wracasz do zabawy. Niestety, potrafisz juz tylko stluc kamyczek po kamyczku o czerep Anselma. Wyglada na to, ze straciles wyczucie rzutu. | Masz w dloni gruby kij i podrzucasz kamienie w powietrze, odbijajac je daleko. Kazde uderzenie jest glebokie i przyjemne, a widok lecacych kamieni bardzo satysfakcjonuje. Gdy schylasz sie po kolejny kamien, widzisz tam czaszke Mlodego Anselma, wpatrzona w ciebie. Naturalnie podnosisz ja, wazac w dloni. Jest taka lekka. Podrzucasz ja i rozbijasz kijem, a odlamki czaszki wiruja na wszystkie strony, a drobny pyl kostny pyli powietrze jak po sztuczce magicznej. Nagle czujesz cos w boku, ten swiat znika i mrugasz, budzac sie na to, jak %oathtaker% szturcha cie stopa. Mrugajac, zdajesz sobie sprawe, ze przysnales przy ognisku. Swietobiorca stawia czaszke obok ciebie i kiwa glowa.%SPEECH_ON%Szukalem rady u Mlodego Anselma i ja znalazlem, kapitanie, ale widzac, ze pociles sie we snie, pomyslalem, ze moze chcialbys chwile z Pierwszym Swietobiorca.%SPEECH_OFF%Mezczyzna odchodzi i zostajesz sam z czaszka. Patrzy na ciebie ze zrozumieniem. Az za bardzo. Odwracasz ja, by patrzyla gdzie indziej, i znowu zasypiasz. | %oathtaker% mial ciezkie dni przez ostatni czas. Przynosisz mu czaszke Mlodego Anselma i mowisz, by posiedzial z myslami i zastanowil sie nad Slubami. Mezczyzna kiwa glowa i po kilku minutach wraca do ciebie z czaszka w dloni.%SPEECH_ON%Miales racje, kapitanie. Zszedlem ze sciezki, ale dzieki przewodnictwu Pierwszego Swietobiorcy znalazlem ja znowu.%SPEECH_OFF% | Czaszka Mlodego Anselma zaczyna wygladac na nieco zniszczona. Kawalki trawy, blota, pare robakow, wszystko to przylepione do kosci. %oathtaker% podchodzi z jakims glupim pytaniem o zapasy. Przerywasz mu, wrecasz czaszke i kazesz ja wyczyscic. Kiwa glowa, wpatrujac sie w czaszke jak w funt czystego zlota. Konczy robote w dziesiec minut, a gdy wraca, jego nastroj jest calkiem swiezy, sam przyznajac, ze czas sam na sam z Mlodym Anselmem go ozywil i przypomnial mu, dlaczego w ogole dolaczyl do Swietobiorcow. To wszystko pieknie, ale najwazniejsze jest to, ze zapomnial tez pogadac z toba o zapasach, co jest swietne.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cokolwiek cie uszczesliwia.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Oathtaker.improveMood(1.35, "Mlody Anselm odnowil jego wiare w sluby");

				if (_event.m.Oathtaker.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Oathtaker.getMoodState()],
						text = _event.m.Oathtaker.getName() + this.Const.MoodStateEvent[_event.m.Oathtaker.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Oathtaker.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local haveSkull = false;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.paladin" && bro.getMoodState() < this.Const.MoodState.Neutral)
			{
				candidates.push(bro);
			}

			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && (item.getID() == "accessory.oathtaker_skull_01" || item.getID() == "accessory.oathtaker_skull_02"))
			{
				haveSkull = true;
			}
		}

		if (!haveSkull)
		{
			local stash = this.World.Assets.getStash().getItems();

			foreach( item in stash )
			{
				if (item != null && (item.getID() == "accessory.oathtaker_skull_01" || item.getID() == "accessory.oathtaker_skull_02"))
				{
					haveSkull = true;
					break;
				}
			}
		}

		if (!haveSkull)
		{
			return;
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Oathtaker = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 5 * candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"oathtaker",
			this.m.Oathtaker.getName()
		]);
	}

	function onClear()
	{
		this.m.Oathtaker = null;
	}

});

