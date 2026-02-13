this.undead_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.undead_intro";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_84.png[/img]Kładziesz głowę, by zdrzemnąć się.\n\n Jedwabna pościel zsuwa się z twojego ciała, gdy obracasz się na bok. Ptaki trzepoczą obok smukłego okna w kościanej oprawie. Głos spływa ci do ucha, a razem z nim nuta zapachu, którego nigdy wcześniej nie czułeś.%SPEECH_ON%Obudziłeś się.%SPEECH_OFF%Kobieta obraca się, przesuwając palcem po twojej piersi, po czym wraca do góry i chwyta cię za brodę. Smukła, piękna, słońce rozświetla jej gładką twarz i rozjaśnia szmaragdowe oczy. Pochyla się do pocałunku. Szybko wysuwasz się z łóżka i nerwowo rozglądasz. Chwyta prześcieradło i klęka, zdezorientowana.%SPEECH_ON%Co się stało? Dokąd idziesz, mój Cesarzu?%SPEECH_OFF%Patrząc w górę, widzisz sufit tak wysoko, że ledwo dostrzegasz misternie wyszyte na nim dzieła. Otwierasz drzwi i wychodzisz na balkon. Niewiarygodnie wysokie budynki, czerwone, białe i złote sztandary, horyzont usiany czarnymi kształtami, sięgający tak daleko, jak okiem sięgnąć. Kopuły, fontanny, wielkie łuki, posągi tak wysokie, że zdają się dowodzić budowlami jak żołnierzami. Na dachu każdego budynku jest ogród większy i bujniejszy niż wszystko, co widziałeś w wiecznych wiosnach natury. Nagle po twoich bokach pojawiają się dwaj mężczyźni z klatkami gołębi i wypuszczają je. Ptaki w popłochu rozpraszają się, a wtedy pod tobą wybucha ryk. Wielkie tłumy ludzi skaczą i machają sztandarami.%SPEECH_ON%Kochają swojego Cesarza.%SPEECH_OFF%Kobieta mówi z progu.%SPEECH_ON%Idź do nich.%SPEECH_OFF%Patrzysz w dół i widzisz strumień żołnierzy maszerujących środkiem drogi, każdy z nich stawia krok w rytmie z bratem, w stałym, stukającym staccato butów. Ich twarze są surowe pod złoconymi hełmami, długie drzewca błyszczą w górze, jakby zamierzali pokonać wrogów samym przepychem.%SPEECH_ON%Idą na wojnę. By stawić czoła Wielkiemu Poza i je pokonać.%SPEECH_OFF%Kobieta stoi obok. Uśmiecha się ciepło, biorąc cię pod ramię. Czujesz, że jesteś gotów się na to zgodzić, na tę nową rzeczywistość, czymkolwiek by była. Dotykasz jej policzka, gotów wpaść w jej ramiona, ale krzyk z dołu przebija się głośno i wyraźnie ponad wszystko. Spoglądasz w dół i widzisz, jak żołnierze, niegdyś doskonale zgrani, łamią szyk. W oddali wielka góra wybucha, wyrzucając potężne strugi czerwonego ognia i ogromną chmurę gorącego popiołu, która szybko spływa na miasto. Budynki rozpadają się, ogrody stają w płomieniach, a ludzie... ludzie krzyczą. Odwracają się, lecz nie ma ucieczki od żaru. Żołnierze upadają i krzyczą. Narasta palący żar, a wkrótce widzisz, jak mieszkańcy się w nim topią, żołnierze stają się metalowymi golemami, przypaleni do pancerzy, które miały ich chronić, a nieopancerzone tłumy po prostu płoną. Kobieta płacze u twego boku.%SPEECH_ON%Och, to okropne! Okropne! Popatrz na to! Ale to w porządku, rozumiesz? Jest całkiem dobrze. Spójrz na mnie. Spójrz na mnie!%SPEECH_OFF%Kobieta chwyta cię i obraca. Jej niegdyś miękkie rysy stwardniały w zwęglone płatki, czubek głowy już wypalony do łysa, zęby wypadają z cieknących dziąseł. A jednak się uśmiecha.%SPEECH_ON%Powstaniemy ponownie, Cesarzu! My... powstaniemy... znów!%SPEECH_OFF%Jej czaszka pęka, a ciało zapada się w stertę płonących kości.\n\n Szarpiesz się z przebudzenia i widzisz %randombrother% potrząsającego tobą.%SPEECH_ON%Panie, pobudka! Mamy tu grupę uchodźców mówiących, że umarli wstają z ziemi i zabijają wszystko, co spotkają!%SPEECH_OFF%Twarz kobiety miga ci przed oczami. Jest przeraźliwie oszpecona, ale to nie powstrzymuje jej od uśmiechu.%SPEECH_ON%Imperium powstaje.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wojna jest u naszych bram.",
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
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.Statistics.hasNews("crisis_undead_start"))
		{
			this.m.Score = 6000;
		}
	}

	function onPrepare()
	{
		this.World.Statistics.popNews("crisis_undead_start");
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

