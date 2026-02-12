this.contracts_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		ContractsToComplete = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.contracts";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Musimy pokazać, że jesteśmy najemnikami, na których można polegać.\nPracujmy ciężko, aby dowieść swej wartości ponad wszelką wątpliwość!";
		this.m.UIText = "Ukończ więcej kontraktów";
		this.m.TooltipText = "Ukończ jeszcze 8 kontraktów dowolnego rodzaju, aby dowieść, żeście godni zaufania ponad wszelką wątpliwość.";
		this.m.SuccessText = "[img]gfx/ui/events/event_62.png[/img]Kiedy zaczynaliście, świat miał was za to, czym byliście: za ambicję uzbrojoną w oręż. Każdy ma jakieś marzenie, a blisko połowa ludzi ma przy sobie broń. Nie byliście wyjątkowi, wybitni, a nawet zbyt niebezpieczni, gdy tak teraz wspominasz wasze dzieje. Ale daliście radę. Drzwi zamykane wam przed twarzami. Nieudane negocjacje, przez które straciliście dobre umowy. Opluwanie. Ciągłe opluwanie. To bezwzględny i chłodny świat, a wy mieliście śmiałość, by się ogrzać. I udało się wam.\n\nKontrakty w kieszeni, kontrakty na horyzoncie, wszystko się ze sobą zmywa. Zwycięstwo stało się nawykiem tej kompanii i masz solidne powody, by być dumnym ze swego dowodzenia.";
		this.m.SuccessButtonText = "Wyrabiamy sobie markę.";
	}

	function getUIText()
	{
		local d = 8 - (this.m.ContractsToComplete - this.World.Contracts.getContractsFinished());
		return this.m.UIText + " (" + this.Math.min(8, d) + "/8)";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 1)
		{
			return;
		}

		if (this.World.Contracts.getContractsFinished() >= 15)
		{
			this.m.IsDone = true;
			return;
		}

		this.m.ContractsToComplete = this.World.Contracts.getContractsFinished() + 8;
		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Contracts.getContractsFinished() >= this.m.ContractsToComplete)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeU16(this.m.ContractsToComplete);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
		this.m.ContractsToComplete = _in.readU16();
	}

});

