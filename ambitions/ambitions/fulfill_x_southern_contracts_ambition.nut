this.fulfill_x_southern_contracts_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		ContractsToFulfill = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.fulfill_x_southern_contracts";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Państwa-miasta południa obfitują w korony.\nWzbogacimy się pod gorejącym słońcem pustyni!";
		this.m.UIText = "Wypełnij kontrakty dla państw-miast";
		this.m.TooltipText = "Wyrusz na południe, odwiedź południowe państwa-miasta i znajdź tam zatrudnienie. Weź i ukończ kontakty dla tamtejszej rządzącej elity.";
		this.m.SuccessText = "[img]gfx/ui/events/event_150.png[/img]Mimo całej swojej uczoności i nienagannych manier południowcy nie mają złudzeń co do twojej roli jako najemnika. Na północy nazwaliby cię mieczem do wynajęcia, tutaj mówią na ciebie koroniarz. Nie przywiązujesz wielkiej wagi do żadnej z tych etykiet, uznając jedynie twardą prawdę, że choć tobą gardzą, szukają twojej pracy, doceniają twoją kompetencję i pamiętają o zapłacie, gdy nadchodzą kolejne kryzysy.\n\nI tu leży fundament północy i południa: sama potężna korona. Języki, religie, ludy, niech to wszystko diabli. Odrobina złota nie potrzebuje tłumaczenia, dostosowania ani arbitrażu. Pogoń za koroną pokazała południowcom, że mogą na tobie polegać, a twoja sława urosła tak głęboko, jak ich kieszenie.";
		this.m.SuccessButtonText = "Złoto to złoto.";
	}

	function getUIText()
	{
		local d = 5 - (this.m.ContractsToFulfill - this.World.Statistics.getFlags().getAsInt("CityStateContractsDone"));
		return this.m.UIText + " (" + this.Math.min(5, d) + "/5)";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 2)
		{
			return;
		}

		if (this.World.Statistics.getFlags().getAsInt("CityStateContractsDone") > 15)
		{
			return;
		}

		this.m.ContractsToFulfill = this.World.Statistics.getFlags().getAsInt("CityStateContractsDone") + 5;
		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Statistics.getFlags().getAsInt("CityStateContractsDone") >= this.m.ContractsToFulfill)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeU16(this.m.ContractsToFulfill);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
		this.m.ContractsToFulfill = _in.readU16();
	}

});

