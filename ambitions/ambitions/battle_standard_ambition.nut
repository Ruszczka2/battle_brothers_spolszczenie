this.battle_standard_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.battle_standard";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Potrzebujemy własnej chorągwi, aby można nas było z daleka rozpoznać!\nZlecenie wykonania takiej jest kosztowne, więc zbierzmy na ten cel 2.000 koron.";
		this.m.RewardTooltip = "Otrzymasz unikalny przedmiot, który dodaje stanowczości wszystkim osobom w pobliżu chorążego.";
		this.m.UIText = "Posiadaj co najmniej 2.000 koron";
		this.m.TooltipText = "Zbierz sumę 2.000 lub więcej koron, abyśmy mogli zamówić wykonanie chorągwi dla naszej kompanii. Zarabiać możesz wykonując kontrakty, plądrując obozy i ruiny, albo handlując towarami. Musisz też mieć miejsce w ekwipunku na nowy przedmiot.";
		this.m.SuccessText = "[img]gfx/ui/events/event_65.png[/img]Nikt nie lubi skąpców, a już zwłaszcza nie grupa wędrownej, złaknionej krwi hałastry, której główną motywacją są pieniądze. Nie każdy, a właściwe to nikt nie był zbyt zadowolony, gdy zasugerowałeś ograniczenie wydatków, by uzbierać na chorągiew kompanii.\n\nKiedy już kompania opłaciła sztandar i został on wzniesiony po raz pierwszy, aby zatrzepotać dumnie na rześkiej porannej bryzie, nikt nie śmiał stwierdzić, że nie było warto. Ludzie są wręcz dumni ze swej nowej chorągwi i wymyślają dla niej nawet różne nazwy przy ognisku, choć żadna z nich się nie przyjmuje.\n\nTeraz wszyscy jasno widzą, że to nie jakaś banda wynajętych zbirów, a prawdziwa kompania najemników. Kogóż spotka zaszczyt dzierżenia tej chorągwi?";
		this.m.SuccessButtonText = "Ludzie, od teraz to są nasze barwy!";
	}

	function onUpdateScore()
	{
		if (this.World.Ambitions.getDone() < 1)
		{
			return;
		}

		this.m.Score = 10;
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getMoney() >= 2000 && this.World.Assets.getStash().hasEmptySlot())
		{
			return true;
		}

		return false;
	}

	function onReward()
	{
		local item;
		local stash = this.World.Assets.getStash();
		this.World.Assets.addMoney(-1000);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/icons/asset_money.png",
			text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]1.000[/color] koron"
		});
		item = this.new("scripts/items/tools/player_banner");
		item.setVariant(this.World.Assets.getBannerID());
		stash.add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "Zdobywasz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
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

