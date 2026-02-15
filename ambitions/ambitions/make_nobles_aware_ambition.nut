this.make_nobles_aware_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.make_nobles_aware";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Musimy przyciągnąć wzrok jednego z rodów szlacheckich dla lepiej płatnej pracy.\nOni toczą własne gierki, ale czy to ważne, skoro wypłata jest należyta?";
		this.m.RewardTooltip = "Odblokujesz całkowicie nowe kontrakty, zlecane przez szlachtę i lepiej płatne.";
		this.m.UIText = "Osiągnij \'Profesjonalną\' sławę";
		this.m.TooltipText = "Stań się znany jako \'Profesjonalista\' (1.050 sławy), aby przyciągnąć uwagę rodów szlacheckich. Swoją sławę możesz zwiększyć wypełniając kontrakty i wygrywając bitwy.";
		this.m.SuccessText = "[img]gfx/ui/events/event_31.png[/img]Chcąc sprawić, by imię %companyname% było na ustach wszystkich, a tym samym zwiększyć swoje szanse u szlachty, pchnąłeś ludzi do wielkich czynów, nadzwyczajnej odwagi i obfitego rozlewu krwi. Po kilku kontraktach i więcej niż paru potyczkach pracowaliście dość długo i dość ciężko, by niektórzy lordowie zwrócili uwagę na kompetencję kompanii.\n\nTo ci możni rządzą krajem dzięki temu, że ich dawno zmarły przodek podporządkował sobie grupę nieuzbrojonych chłopów. Jak ujmuje to %highestexperience_brother%, teraz ci rozpieszczeni, kazirodczy fircycy są wystarczająco pod wrażeniem, by wciągnąć kompanię w jeden ze swoich konfliktów. Jeśli umyjesz twarz i grzecznie poprosisz, od czasu do czasu raczą cię dochodowym kontraktem. Możesz sobie pogratulować!";
		this.m.SuccessButtonText = "Sięgniemy do głębokich kieszeni szlachty!";
	}

	function onUpdateScore()
	{
		if (this.World.Ambitions.getDone() < 2)
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 800)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.battle_standard").isDone())
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() >= 1050 && this.World.FactionManager.isGreaterEvil())
		{
			this.m.IsDone = true;
			return;
		}

		this.m.Score = 10;
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getBusinessReputation() >= 1050)
		{
			return true;
		}

		return false;
	}

	function onReward()
	{
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/icons/special.png",
			text = "Od teraz szlachta będzie dawać ci kontrakty"
		});

		if (!this.World.Assets.getOrigin().isFixedLook())
		{
			if (this.World.Assets.getOrigin().getID() == "scenario.southern_quickstart")
			{
				this.World.Assets.updateLook(14);
			}
			else
			{
				this.World.Assets.updateLook(2);
			}

			this.m.SuccessList.push({
				id = 10,
				icon = "ui/icons/special.png",
				text = "Twój wygląd na mapie świata został uaktualniony"
			});
		}
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

