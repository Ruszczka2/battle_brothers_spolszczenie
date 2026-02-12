this.armor_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.armor";
		this.m.Duration = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Wyposażymy grupę co najmniej trzech ludzi w ciężki pancerz,\naby stanowili bastion wobec niebezpiecznych przeciwników.";
		this.m.UIText = "Posiadaj 3 sztuki zbroi i hełmów o wytrzymałości 230+";
		this.m.TooltipText = "Posiadaj 3 sztuki zbroi oraz 3 hełmy które mają 230 lub więcej wytrzymałości. Bez znaczenia czy je kupisz, czy zdobędziesz na polu bitwy, będą one chronić twoich ludzi równie skutecznie.";
		this.m.SuccessText = "[img]gfx/ui/events/event_35.png[/img]Nastroje się poprawiają po zdobyciu większej ilości ciężkich zbroi i hełmów dla kompanii.%SPEECH_ON%Czujesz to? To prawdziwe rzemiosło.%SPEECH_OFF%Mówi %randombrother%, stukając twardym trzonem w nowo opancerzoną głowę swego towarzysza broni.%SPEECH_ON%Pomyśl tylko o tych licznych, dobrze płatnych kontraktach, które przeszły nam koło nosa przez nasze wcześniejsze kiepskie zbroje i żałosny ekwipunek.%SPEECH_OFF%Od teraz drugi szereg nieco odetchnie z ulgą, gdy trzeba będzie ruszyć do boju, gdyż ich ciężko opancerzeni bracia przyjmą na siebie impet ataku. A jeśli polegną, to ich ciężka kupa złomu przynajmniej spowolni wroga, dając swym lżej opancerzonym kompanom szansę na szybką ucieczkę.";
		this.m.SuccessButtonText = "To się nam dobrze przysłuży w nadchodzących bitwach.";
	}

	function getArmor()
	{
		local ret = {
			Armor = 0,
			Helmet = 0
		};
		local items = this.World.Assets.getStash().getItems();

		foreach( item in items )
		{
			if (item != null)
			{
				if (item.isItemType(this.Const.Items.ItemType.Armor) && item.getArmorMax() >= 230)
				{
					++ret.Armor;
				}
				else if (item.isItemType(this.Const.Items.ItemType.Helmet) && item.getArmorMax() >= 230)
				{
					++ret.Helmet;
				}
			}
		}

		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Head);

			if (item != null)
			{
				if (item.getArmorMax() >= 230)
				{
					++ret.Helmet;
				}
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body);

			if (item != null)
			{
				if (item.getArmorMax() >= 230)
				{
					++ret.Armor;
				}
			}
		}

		return ret;
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days <= 40)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		local armor = this.getArmor();

		if (armor.Armor >= 3 || armor.Helmet >= 3)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local armor = this.getArmor();

		if (armor.Armor >= 3 && armor.Helmet >= 3)
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

