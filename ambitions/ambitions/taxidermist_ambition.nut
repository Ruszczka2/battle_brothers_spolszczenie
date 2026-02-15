this.taxidermist_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.taxidermist";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Nic tak nie dodaje szacunku, co trofeum z olbrzymiej bestii z mroźnych pustkowi.\nRuszajmy na polowanie i zaprzęgnijmy taksydermistę do pracy!";
		this.m.UIText = "Wytwórz przedmioty u taksydermisty";
		this.m.TooltipText = "Wytwórz u taksydermisty co najmniej 12 przedmiotów z trofeów po bestiach. Taksydermistę można głównie znaleźć w osadach w pobliżu lasów i bagien. Jest on w stanie wytworzyć użyteczne przedmioty z trofeów po bestiach, takich jak np. niezwykle wielkie wilcze skóry Wilkorów.";
		this.m.SuccessText = "[img]gfx/ui/events/event_97.png[/img]Młody chłopak zatrzymuje cię i pyta, czy jesteś dowódcą %companyname%. Oceniając go wzrokiem, pytasz, co mu do tego. Wzrusza ramionami.%SPEECH_ON%Nie mam nic złego na myśli, panie. Jak go znajdę i przyprowadzę, dostanę trzy złote monety. Tyle.%SPEECH_OFF%Zaintrygowany pytasz, kto wyznaczył tę nagrodę. Chłopak dłubie w nosie i zerka w górę.%SPEECH_ON%Co? A, jeszcze nie widziałem złota! Muszę najpierw znaleźć tego gościa!%SPEECH_OFF%Wzdychasz, odciągasz jego rękę, smark i wszystko, i pytasz jeszcze raz. Chłopak prycha, myśli, wpatruje się w ziemię i robaki. Kiwka głową.%SPEECH_ON%To był poborca. Nie od złota. Ten by mi nie zapłacił ani grosza, taki z niego diabeł o długich palcach, tak mówi mój stary. Mam na myśli poborcę od zwierząt. Skóruje bestie i robi z nich coś groźnego, płaszcze, koce, trucizny, mikstury. Taki poborca. No, oni wszyscy ze sobą gadają. Mówią, że robota %companyname% to najlepszy interes w całej krainie i wszyscy aż swędzą, żeby spotkać was znowu!%SPEECH_OFF%Aha, czyli chodzi o taksydermistów. Uśmiechasz się, klepiesz chłopaka po głowie i życzysz mu powodzenia w polowaniu. Prycha i spluwa.%SPEECH_ON%Szczęście nie ma tu wiele do rzeczy, ja mam zamiar znaleźć tego gościa po rozumnemu. Oczy szeroko otwarte, uszy nastawione, a gacie wysoko i ciasno.%SPEECH_OFF%";
		this.m.SuccessButtonText = "Nasza kompania dumnie prezentuje swoje trofea.";
	}

	function getUIText()
	{
		return this.m.UIText + " (" + this.Math.min(12, this.World.Statistics.getFlags().get("ItemsCrafted")) + "/12)";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.World.Statistics.getFlags().get("ItemsCrafted") >= 12)
		{
			this.m.IsDone = true;
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		return this.World.Statistics.getFlags().get("ItemsCrafted") >= 12;
	}

	function onPrepareVariables( _vars )
	{
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
	}

});

