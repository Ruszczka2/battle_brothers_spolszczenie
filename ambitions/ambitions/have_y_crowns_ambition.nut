this.have_y_crowns_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.have_y_crowns";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Jeśli jakaś bitwa lub dwie pójdą nie po naszej myśli, możemy skończyć z pustymi\nsakiewkami i brakach w wyposażeniu. Zbudujmy sobie rezerwę 10.000 koron.";
		this.m.UIText = "Posiadaj co najmniej 10.000 koron.";
		this.m.TooltipText = "Posiadaj co najmniej 10.000 koron jako rezerwę, aby móc przetrwać w przyszłości czasy, gdy losy źle się potoczą. Zarabiać możesz wykonując kontrakty, plądrując obozy i ruiny, albo0 handlując towarami.";
		this.m.SuccessText = "[img]gfx/ui/events/event_04.png[/img]Większy zapas monet i kosztowności pozwala ci spać spokojniej. Ludzie także, wiedząc, że nie będą musieli gonić cię po stepie, gdy przyjdzie czas wypłaty. Nie będziesz już na gorszej pozycji w negocjacjach kontraktów, a gdy jedna czy dwie bitwy pójdą nie po twojej myśli, nie zabraknie ci ludzi ani wyposażenia.\n\nNowa rezerwa zaczyna też otwierać drzwi przed %companyname%. Kupcy, lichwiarze i możni mają jedną wspólną cechę: wolą zadawać się ze swoimi. Samo uzyskanie audiencji bywa trudne, jeśli podejrzewają, że masz puste kieszenie. Ale teraz, gdy dowiodłeś, że potrafisz gromadzić środki, kompania stała się bardziej atrakcyjna dla bogatych ludzi i tych, którzy podejmują decyzje.";
		this.m.SuccessButtonText = "Doskonale!";
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() > 9000)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 3)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.trader" && !this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getMoney() >= 10000)
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

