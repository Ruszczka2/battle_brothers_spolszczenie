this.defeat_kraken_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_kraken";
		this.m.Duration = 35.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Krążą plotki o kolosalnej bestii czającej się na bagnach.\nJeśli ją odnajdziemy i zabijemy, czeka nas wieczna sława!";
		this.m.UIText = "Pokonaj Krakena";
		this.m.TooltipText = "Pokonaj Krakena w bitwie. Znajdziesz go gdzieś tam w dziczy.";
		this.m.SuccessText = "[img]gfx/ui/events/event_89.png[/img]W snach w nim mieszka, śliska bulwiasta głowa opleciona liliami i kudzu, a oddech unosi bagno jak bulgot kotła. Macki wiją się w półmroku jak cienie na cieniach. Tak jest tutaj w dalekiej, dalekiej ciemności, w pustce, w której wyżłobił sobie miejsce i stał się uśpionym horrorem. Gdy pojawia się w twoich snach, jest tak, jakbyś sam do niego poszedł. Wchodzisz w czerń i robisz krok naprzód, dłoń wyciągnięta, lecz na tym się kończy. Nigdy naprawdę nie podchodzisz blisko. Czasem śnisz o czymś innym, ale wiesz, że bestia gdzieś tam jest, wystarczy otworzyć drzwi albo zejść po schodach i znowu trafisz do niej i jej domeny. Nie musisz rozmawiać z ludźmi, by wiedzieć, że im też się śni.\n\nŚwiat poznał twoje zabicie krakena, lecz widzi je z opowieści, jako coś, co matka szepce, by pogonić dziecko do łóżka, albo co ojciec przywołuje, by dodać otuchy rodzinie, mówiąc o triumfie człowieka nad trwogą. Ale oni tego nie widzą. Widzą plotkę, nie potwora, i traktują %companyname% jak żywe legendy. A jak to z legendami bywa, z każdym dniem ludzie kompanii bledną w opowieściach i są zastępowani przez prawdziwych bohaterów, w każdym zakątku świata powstaje odważniejszy zwycięzca nad bestią. Zwykły najemnik nigdy by się na to nie porwał, mówią. To byli rycerze wschodu. To była gwardia królewska północy. Próżność zajęła twoje miejsce. Ale bracia, z którymi walczyłeś, znają prawdę i nawet gasnąca prawda wystarczy, by iść dalej.\n\nTak więc w ciemności ona mieszka, i tam często do niej wracasz.";
		this.m.SuccessButtonText = "Jakiż inny myśliwy może pochwalić się takim wyczynem?";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.getTime().Days <= 100)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 20)
		{
			return;
		}

		if (this.World.Flags.get("IsKrakenDefeated"))
		{
			this.m.IsDone = true;
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Flags.get("IsKrakenDefeated"))
		{
			return true;
		}

		return false;
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

