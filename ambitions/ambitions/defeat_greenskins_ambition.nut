this.defeat_greenskins_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_greenskins";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Inwazja Zielonoskórych zagraża zmieceniem naszego świata.\nStaniemy do boju i odeprzemy ją, bowiem tak rodzą się legendy!";
		this.m.UIText = "Pokonaj Inwazję Zielonoskórych";
		this.m.TooltipText = "Pokonaj Inwazję Zielonoskórych! Każdy wykonany przeciwko nim kontrakt, każda zniszczona armia lub lokacja, przybliżą cię do ocalenia ludzkiego świata.";
		this.m.SuccessText = "[img]gfx/ui/events/event_81.png[/img]To było zadanie jak żadne inne, jakie kiedykolwiek podejmowali ludzie kompanii: odeprzeć całą inwazję jednych z najzacieklejszych wrogów, z jakimi mierzył się człowiek. Wroga, z którym nie da się pertraktować, którego obcy umysł nie zna litości ani współczucia, a jedynie wojnę. Orkowie i gobliny zjednoczyli się w dzikiej zielonej fali, która groziła zmyciem rasy ludzkiej.\n\nPod bezlitosnym słońcem za dnia i w świetle płonących miast w nocy kompania prowadziła kampanię przeciw zielonemu zagrożeniu na pograniczach, wykorzeniając je wszędzie tam, gdzie podnosiło swoje szpetne, poorane bliznami łby. Ludzie stoczyli niejedną ciężką bitwę i złożyli niejedną ofiarę, ale wszystko było tego warte.\n\n%companyname% zwyciężyło. Po wielu dzikich zmaganiach, po niezliczonych dniach, gdy życie każdego człowieka zdawało się wisieć na rzucie kością, zielona fala wreszcie zaczęła opadać. Gdy orkowie i gobliny rozpraszają się z powrotem w dziczy, wiesz, że świat ludzi został ocalony. Na razie.";
		this.m.SuccessButtonText = "Bardowie będą teraz śpiewać o nas pieśni. O ile jacyś jeszcze zostali.";
	}

	function getUIText()
	{
		local f = this.World.FactionManager.getGreaterEvil().Strength / this.Const.Factions.GreaterEvilStartStrength;
		local text;

		if (f >= 0.95)
		{
			text = "Losing";
		}
		else if (f >= 0.5)
		{
			text = "Undecided";
		}
		else if (f >= 0.25)
		{
			text = "Winning Slightly";
		}
		else
		{
			text = "Winning";
		}

		return this.m.UIText + " (" + text + ")";
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isGreenskinInvasion())
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 1500)
		{
			return;
		}

		this.m.Score = 10;
	}

	function onCheckSuccess()
	{
		if (this.World.FactionManager.getGreaterEvil().Type == 0 && this.World.FactionManager.getGreaterEvil().LastType == 2)
		{
			return true;
		}

		this.World.Ambitions.updateUI();
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

