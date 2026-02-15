this.have_z_crowns_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.have_z_crowns";
		this.m.Duration = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Korony to potęga i wpływy, a nam obu tych rzeczy nigdy za wiele.\nZbierzmy 50.000 koron i zdobądźmy miejsce pośród szlachty i królów!";
		this.m.UIText = "Posiadaj co najmniej 50.000 koron";
		this.m.TooltipText = "Posiadaj co najmniej 50.000 koron, aby zaliczano cię do zamożnych. Zarabiać możesz wykonując kontrakty, plądrując obozy i ruiny, albo0 handlując towarami.";
		this.m.SuccessText = "[img]gfx/ui/events/event_04.png[/img]Łup, łup i, owszem, jeszcze więcej łupów! Kompania zgromadziła bogactwa, które mogą się równać z hoardem smoka. Najlepsze zbroje i bronie stoją przed tobą na zawołanie. Jeśli zechcesz wynająć statek albo całą flotę, wystarczy pstryknąć palcami. Sprzedawcy wszelkiego rodzaju wystawiają najlepsze towary, gdy jesteś w mieście, najbardziej chętni, by pomóc ci znaleźć nowe sposoby wydawania złota.\n\nPonieważ twoje bogactwo dorównuje temu, które mają możni, nie musisz już się przed nimi korzyć. Możesz kupić własny tytuł szlachecki i ziemie albo zająć się karierą bankiera-kupca, jeśli kiedykolwiek znudzi ci się niańczenie tej bandy upartego, porywczego motłochu.";
		this.m.SuccessButtonText = "Doskonale.";
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 25)
		{
			return;
		}

		if (this.World.Assets.getMoney() >= 45000)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.World.Assets.getMoney() < 10000 && !this.World.Ambitions.getAmbition("ambition.have_y_crowns").isDone())
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getMoney() >= 50000)
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

