this.helped_caravan_event <- this.inherit("scripts/events/event", {
	m = {
		LastCombatID = 0
	},
	function create()
	{
		this.m.ID = "event.helped_caravan";
		this.m.Title = "Po bitwie...";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Główny kupiec karawany przychodzi do ciebie z podziękowaniami za uratowanie go. Naturalnie, przynosi nie tylko słowa uznania: otrzymujesz różne towary, z których część na pewno się przyda. | %SPEECH_ON%Dziękuję ci, podróżniku, dziękuję!%SPEECH_OFF%Przywódca karawany złącza dłonie i trzęsie nimi w górę i w dół, jakby i dawnym bogom dziękował. Swe podziękowania wręcza także w formie dóbr materialnych, zaopatrując kompanię w asortyment nagród prosto z wozów. | To dość rzadkie na tym świecie, by nieznajomi okazywali sobie wzajemnie życzliwość, lecz nawet chytry kupiec rozumie, że będąc ocalonym przed niechybną zgubą, lepiej jest wynagrodzić swych wybawców. Karawana odciąża swój ładunek, nagradzając cię różnymi towarami. | Gdybyś nie przybył, tę karawanę zapewne czekałaby zguba. Kupcy nagradzają cię więc za twe niespodziewane \'usługi.\' | %SPEECH_ON%Och, bogowie nam cię zesłali, czy w nich wierzysz czy nie, to ich zasługa!%SPEECH_OFF%Kupiec bez wątpienia jest w szoku. I, jak każdy poruszony handlarz, przechodzi do jedynej rzeczy, o jakiej ma pojęcie.%SPEECH_ON%Słuchaj, mamy towary do zaoferowania, co powiesz na to? To w dowód naszej wdzięczności, za darmo.%SPEECH_OFF% | Mimo iż bitwa się skończyła, histeria ocalonych kupców jest równie głośna, co rzeź, która chwilę temu się skończyła.%SPEECH_ON%Najemnicy, najemnicy! Nasi wybawcy!%SPEECH_OFF%Nagle widzisz, jak kupcy zasypują cię towarami w ramach podziękowania za ocalenie im życia.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cieszę się, że mogliśmy pomóc.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local n = 1;

				if (this.World.Statistics.getFlags().getAsInt("LastCombatKills") > this.Math.rand(11, 14))
				{
					n = ++n;
					n = n;
				}

				for( local i = 0; i < n; i = i )
				{
					local item = this.new("scripts/items/" + this.World.Statistics.getFlags().get("LastCombatSavedCaravanProduce"));
					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "Zdobywasz " + item.getName()
					});
					i = ++i;
				}
			}

		});
	}

	function isValid()
	{
		if (this.World.Statistics.getFlags().get("LastCombatSavedCaravan") && this.World.Statistics.getFlags().get("LastCombatWasOngoingBattle") && this.World.Statistics.getFlags().get("LastCombatID") > this.m.LastCombatID && this.World.Statistics.getFlags().getAsInt("LastCombatKills") >= this.Math.rand(4, 6))
		{
			this.m.LastCombatID = this.World.Statistics.getFlags().getAsInt("LastCombatID");
			return true;
		}

		return false;
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

	function onSerialize( _out )
	{
		this.event.onSerialize(_out);
		_out.writeU32(this.m.LastCombatID);
	}

	function onDeserialize( _in )
	{
		this.event.onDeserialize(_in);

		if (_in.getMetaData().getVersion() >= 54)
		{
			this.m.LastCombatID = _in.readU32();
		}
	}

});

