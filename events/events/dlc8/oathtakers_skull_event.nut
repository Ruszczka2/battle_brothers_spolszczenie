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
			Text = "[img]gfx/ui/events/event_183.png[/img]{Zastajesz %oathtaker% wpatrzonego w oczodoły czaszki Młodego Anselma, ciężar kości spoczywa na wyciągniętej dłoni. Od czasu do czasu kiwa głową i mamrocze do siebie coś w rodzaju szeptanej modlitwy. Gdy wyczuwa twoją obecność, Świętobiorca się odwraca.%SPEECH_ON%Martwiłem się, lecz mimo morza chaosu mamy tu Młodego Anselma, a on jest źródłem odwagi takiej, że mógłbym wpłynąć w ocean tego świata z pełną pewnością, że mnie przez niego przeprowadzi. Powinienem szerzyć nauki Młodego Anselma wśród innych.%SPEECH_OFF%Jak najbardziej. | Świętobiorcy jedzą dobry posiłek przy ognisku. %oathtaker% ma czaszkę Młodego Anselma na pniaku. Od czasu do czasu odwraca się, z łyżką skwarków w dłoni, i wygląda, jakby chciał nakarmić nimi kostne paszcze. Te chwile cię niepokoją, ale z jakiegoś powodu mała czaszka potrafi poprawiać nastrój Świętobiorców samą obecnością, na tyle, że pozwalasz tym jednocześnie dziewczęcym i ponurym dziwactwom przejść. | %oathtaker% przegląda tekst w filcowej oprawie i ze złoconym zakładnikiem. Obok niego czaszka Młodego Anselma spoczywa przy dogasającej świecy. Pytasz Świętobiorcę, co czyta. Mężczyzna podnosi wzrok.%SPEECH_ON%Zajmuję się sprawami Ślubów, tak jak Młody Anselm je spisał. Pamiętaj mądrą radę chłopaka: atrament jest najsilniejszym wspomnieniem, więc nie należy polegać wyłącznie na własnych możliwościach, by dotrzymywać Ślubów, tylko odświeżać źródła umysłu samymi zapisami. To też było częścią nauk Młodego Anselma. Wiedziałbyś, gdybyś dbał o teksty tak, jak radził.%SPEECH_OFF%Trochę zgryźliwie, ale nie myli się. | Widzisz %oathtaker% czyszczącego czaszkę Młodego Anselma. Chcąc wystawić wiarę mężczyzny na próbę, pytasz o coś, co już wiesz: jak zmarł Anselm. Świętobiorca prostuje się, patrząc na ciebie z szczerym oburzeniem.%SPEECH_ON%Kapitanie, nieważne jak zmarł, ani kiedy, ani dlaczego, ani przez kogo, a może nawet nie ma tu żadnego kto, lecz liczy się to, że był na Ślubie Ostatecznej Ścieżki, i my też z nim jesteśmy, i będziemy do końca. Nie jesteśmy tylko Świętobiorcami, lecz Ostatnimi Świętobiorcami.%SPEECH_OFF%Odwraca się, strzepa owada z kości i czyści czaszkę tak, jakby została zbezczeszczona krokami owada.%SPEECH_ON%To wielkie doświadczenie, które tu podejmujemy, kapitanie, ale czasem mam wrażenie, że tylko jedziesz z nami.%SPEECH_OFF%To przynajmniej wielkie doświadczenie w pogłębianiu twoich kieszeni. Na szczęście jedyny, kto zdaje się dostrzegać twoją bardziej cyniczną naturę, to rzekomo przenikliwa czaszka, oczodoły Młodego Anselma pusto wpatrzone w ciebie, gdy ślina Świętobiorcy poleruje kość. | %oathtaker% klęka przed czaszką Młodego Anselma.%SPEECH_ON%Daj mi siłę w naszych Ślubach, Młody Anselmie, bo sam nie dam rady, a już na pewno nie z samą pomocą kapitana.%SPEECH_OFF%Prawie mu mówisz, że nie jest sam, bo jest z %companyname% i ty też nie jesteś mieczakiem, ale uznajesz, że to raczej nie miejsce na taki realizm. Nagle mężczyzna podskakuje i kiwa głową.%SPEECH_ON%Takie wskazówki są bardzo cenne, Młody Anselmie.%SPEECH_OFF%Część ciebie chciałaby spojrzeć na czaszkę młodego chłopaka po wskazówki i faktycznie je znaleźć, ale jedyne, co wynosisz z kostnego oblicza Młodego Anselma, to puste spojrzenie. | Kompania miewała wzloty i upadki, lecz Młody Anselm wciąż uchodzi za główne źródło pobożności. Trzeba przyznać, że czasem wpatrujesz się w czaszkę z odrobiną pogardy. Mimo że to ty prowadzisz bandę, i to całkiem dobrze, wiele sukcesów kompanii przypisuje się czaszce. Gdy ludzie potrzebują pomocy, często idą do czaszki, omijając kapitana. %oathtaker% jest tego przykładem, bo ostatnio miał ciężkie dni, ale zamiast rozmawiać z tobą, widzisz, jak podnosi Młodego Anselma po kostną radę w sprawach Ślubów. Czasem marzysz, by wziąć czerep Pierwszego Świętobiorcy i rzucić nim przez jezioro jak kamieniem. | Czaszka Młodego Anselma jest punktem odniesienia dla najbardziej wiernych Świętobiorców, źródłem wiedzy, wskazówek i czegoś więcej, wypływającym z niemej, kostnej skorupy. %oathtaker%, który w ostatnich dniach był raczej przygnębiony, dostaje dostęp do czaszki. Nawet w tym krótkim obcowaniu odnawia wiarę w Śluby. | Ustawiasz czaszkę Młodego Anselma na kiju i zaczynasz nią kręcić; kość grzechocze, gdy kręci się w kółko, a pusty klekot jest straszliwie zabawny. %oathtaker% wychodzi z krzaków, pytając o coś, a ty natychmiast chwytasz czaszkę i odkładasz ją. Świętobiorca patrzy na ciebie, na kij, na czaszkę, potem znowu na ciebie. Chrząka i tłumaczy, że ostatnie dni były dla niego ciężkie. Dla wskazówek, i z lenistwa, podajesz mu czaszkę Młodego Anselma, mówiąc, by znalazł w Pierwszym Świętobiorcy ożywienie swojej witalności, odnowę wiary i powrót odwagi. Mężczyzna posłusznie kiwa głową.%SPEECH_ON%Młody Anselm może i jest Pierwszym Świętobiorcą, ale wciąż wierzę, że jesteś mądrzejszy niż wskazuje twój wiek, kapitanie. Powinienem był zająć się Anselmem od początku!%SPEECH_OFF% | Ustawiłeś czaszkę Młodego Anselma na pniaku i rzucasz kamyczkami przez oczodoły. Jeden przelatuje idealnie przez otwór i unosisz pięść. W tej chwili pojawia się %oathtaker%. Patrzy na ciebie, na zaciśniętą pięść i na Młodego Anselma. Świętobiorca kiwa głową.%SPEECH_ON%Skoro nawet cynik taki jak ty może otrzymać odwagę od Młodego Anselma, to zdolności Pierwszego Świętobiorcy muszą wykraczać poza to, co nawet ja uważałem. Zostawię cię samego, abyś mógł znaleźć dalsze wskazówki u Młodego Anselma.%SPEECH_OFF%Przytakujesz i dziękujesz Świętobiorcy, ale gdy odchodzi, wracasz do zabawy. Niestety, potrafisz już tylko stłuc kamyczek po kamyczku o czerep Anselma. Wygląda na to, że straciłeś wyczucie rzutu. | Masz w dłoni gruby kij i podrzucasz kamienie w powietrze, odbijając je daleko. Każde uderzenie jest głębokie i przyjemne, a widok lecących kamieni bardzo satysfakcjonuje. Gdy schylasz się po kolejny kamień, widzisz tam czaszkę Młodego Anselma, wpatrzoną w ciebie. Naturalnie podnosisz ją, ważąc w dłoni. Jest taka lekka. Podrzucasz ją i rozbijasz kijem, a odłamki czaszki wirują na wszystkie strony, a drobny pył kostny pyli powietrze jak po sztuczce magicznej. Nagle czujesz coś w boku, ten świat znika i mrugasz, budząc się na to, jak %oathtaker% szturcha cię stopą. Mrugając, zdajesz sobie sprawę, że przysnąłeś przy ognisku. Świętobiorca stawia czaszkę obok ciebie i kiwa głową.%SPEECH_ON%Szukałem rady u Młodego Anselma i ją znalazłem, kapitanie, ale widząc, że pociłeś się we śnie, pomyślałem, że może chciałbyś chwilę z Pierwszym Świętobiorcą.%SPEECH_OFF%Mężczyzna odchodzi i zostajesz sam z czaszką. Patrzy na ciebie ze zrozumieniem. Aż za bardzo. Odwracasz ją, by patrzyła gdzie indziej, i znowu zasypiasz. | %oathtaker% miał ciężkie dni przez ostatni czas. Przynosisz mu czaszkę Młodego Anselma i mówisz, by posiedział z myślami i zastanowił się nad Ślubami. Mężczyzna kiwa głową i po kilku minutach wraca do ciebie z czaszką w dłoni.%SPEECH_ON%Miałeś rację, kapitanie. Zszedłem ze ścieżki, ale dzięki przewodnictwu Pierwszego Świętobiorcy znalazłem ją znowu.%SPEECH_OFF% | Czaszka Młodego Anselma zaczyna wyglądać na nieco zniszczoną. Kawałki trawy, błota, parę robaków, wszystko to przylepione do kości. %oathtaker% podchodzi z jakimś głupim pytaniem o zapasy. Przerywasz mu, wręczasz czaszkę i każesz ją wyczyścić. Kiwa głową, wpatrując się w czaszkę jak w funt czystego złota. Kończy robotę w dziesięć minut, a gdy wraca, jego nastrój jest całkiem świeży, sam przyznając, że czas sam na sam z Młodym Anselmem go ożywił i przypomniał mu, dlaczego w ogóle dołączył do Świętobiorców. To wszystko pięknie, ale najważniejsze jest to, że zapomniał też pogadać z tobą o zapasach, co jest świetne.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cokolwiek cię uszczęśliwia.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Oathtaker.improveMood(1.35, "Młody Anselm odnowił jego wiarę w śluby");

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

