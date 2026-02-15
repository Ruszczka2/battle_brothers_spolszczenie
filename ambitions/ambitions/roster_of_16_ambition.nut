this.roster_of_16_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.roster_of_16";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Podniesiemy siłę kompanii do szesnastu ludzi! Staniemy się wówczas\nznaczącą siłą i będziemy mieć dostęp do bardziej dochodowej pracy.";
		this.m.UIText = "Miej w swych szeregach co najmniej 16 ludzi";
		this.m.TooltipText = "Najmij wystarczająco dużo rekrutów, aby mieć w szeregach co najmniej 16 ludzi. Odwiedzaj osady w różnych stronach, by znaleźć ochotników, którzy najbardziej ci się przysłużą. Posiadanie pełnych szeregów pozwoli ci podejmować niebezpieczniejsze i lepiej płatne kontrakty.";
		this.m.SuccessText = "[img]gfx/ui/events/event_80.png[/img]Gdy wreszcie zebrałeś monety i ekwipunek, zdołałeś skompletować pełny oddział szesnastu zdolnych ludzi. Kiedy następnym razem idziesz główną ulicą %currenttown%, ludzie wybuchają donośną pieśnią marszową. Kilku mieszczan mamrocze pod nosem o brudnych najemnikach przejmujących miasto, ale inni idą obok i wykrzykują słowa razem z tobą. %SPEECH_ON%Trzymajcie się prosto, bracia. Ludzie widzą, że to prawdziwa kompania najemników, a nie garść hołoty.%SPEECH_OFF%%highestexperience_brother% oznajmia.%SPEECH_ON%Handlujemy siłą, a skoro nasze liczby wzrosły, wzrośnie też cena.%SPEECH_OFF%Wygląda na to, że ma rację. Zauważasz jednego szczególnie grubego kupca, który mierzy kompanię wzrokiem, jakby już miał w głowie zlecenie. %companyname% to teraz siła, z którą trzeba się liczyć. Gdy ludzie ułożą się po uczcie, może warto przejść się jeszcze raz po mieście i sprawdzić, czy nie ma bardziej dochodowych kontraktów.";
		this.m.SuccessButtonText = "Dobrze nam idzie.";
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getOrigin().getID() != "scenario.militia")
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= 16)
		{
			this.m.IsDone = true;
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.getPlayerRoster().getSize() >= 16)
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

