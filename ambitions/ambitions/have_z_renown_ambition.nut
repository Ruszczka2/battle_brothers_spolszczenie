this.have_z_renown_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.have_z_renown";
		this.m.Duration = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "W historii było kilka legendarnych kompanii najemników.\nJesteśmy blisko tego, by nasze imiona stały się nieśmiertelne!";
		this.m.UIText = "Osiągnij \'Niepokonaną\' sławę";
		this.m.TooltipText = "Stań się znany jako \'Niepokonany\' (8.000 sławy) i zapisz się w historii. Swoją sławę możesz zwiększyć wypełniając kontrakty i wygrywając bitwy.";
		this.m.SuccessText = "[img]gfx/ui/events/event_82.png[/img]Przy rzekach krwi, setkach spalonych fortec i dziesięciu tysiącach tłustych, ucztujących wron za twoimi plecami opowieści o dzielności twojej kompanii nigdy nie umrą. Imię %companyname% wybrzmiewa w triumfalnych okrzykach i cichym zachwycie w każdym zakątku znanego świata. Ojcowie nadają synom imiona po twoich najdzielniejszych ludziach, a ci chłopcy dorastają, odgrywając słynne bitwy, które stoczyłeś.\n\nTwoja sława jest już tak wielka, że stało się to niewygodne, by odwiedzać miejsca większe niż wioska. Gdziekolwiek jedziesz, nękają cię dniem i nocą. Panny rywalizujące o uwagę twoich ludzi kończą w bójkach. Sklepikarze, przekonani o twoim ogromnym bogactwie, nachodzą o każdej porze ze swymi towarami. A co najgorsze, każdy pyszałek w krainie chce rzucić wyzwanie twoim ludziom, a milicja czeka na wynik, licząc, że zwykła grzywna za bójkę na ulicy może urosnąć do długu krwi.\n\nAle osiągnąłeś to, co zamierzałeś, nawet jeśli rezultat nie jest do końca taki, jakiego się spodziewałeś. Jaki by nie był twój los, %companyname% już stało się nieśmiertelne w historii świata.";
		this.m.SuccessButtonText = "%companyname%! Będziemy żyć wiecznie!";
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 60)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() <= 4000 || this.World.Assets.getBusinessReputation() >= 7800)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getBusinessReputation() >= 8000)
		{
			return true;
		}

		return false;
	}

	function onReward()
	{
		if (!this.World.Assets.getOrigin().isFixedLook())
		{
			if (this.World.Assets.getOrigin().getID() == "scenario.southern_quickstart")
			{
				this.World.Assets.updateLook(15);
			}
			else
			{
				this.World.Assets.updateLook(3);
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

