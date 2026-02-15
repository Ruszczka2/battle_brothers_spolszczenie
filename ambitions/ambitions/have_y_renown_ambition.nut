this.have_y_renown_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.have_y_renown";
		this.m.Duration = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Staliśmy się już rozpoznawalni w niektórych stronach, nadal jednak\ndaleko nam do legendarnej kompanii. Zwiększymy swoją sławę jeszcze bardziej!";
		this.m.UIText = "Osiągnij \'Wspaniałą\' sławę";
		this.m.TooltipText = "Stań się znany jako \'Wspaniały\' (2.750 sławy) w krainie. Swoją sławę możesz zwiększyć wypełniając kontrakty i wygrywając bitwy.";
		this.m.SuccessText = "[img]gfx/ui/events/event_82.png[/img]Maszerując przez lasy i równiny, banda rozbiła każdy opór, z którym ją posłano. Depcząc wrogów, rozbijając linie bitewne i posyłając głowy w powietrze, %companyname% odkrywa, że rzadko kroczy samotnie. Wrony krążą wysoko nad kompanią w marszu, kraczą, gdy ludzie jedzą wieczerzę, i częściej niż rzadziej ucztują sycie, gdy tylko skończą dzienną robotę.\n\nZa sobą ludzie zostawiają spaloną ziemię i dziwaczne plotki wszędzie tam, gdzie stąpały ich buty, a każda opowieść puchnie w przekazie, aż wszyscy, od mleczarek po kowali i burmistrzów, zdają się mówić o twoich wyczynach. Plotka to waluta ceniona w każdym zakątku krainy i ani szerokie rzeki, ani wysokie szczyty nie spowolnią wieści o twoich zwycięstwach, a wraz z nimi cen, jakich możesz teraz żądać za swoje usługi.";
		this.m.SuccessButtonText = "Ludzie teraz wiedzą co to %companyname%!";
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 30)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() >= 2650)
		{
			this.m.IsDone = true;
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getBusinessReputation() >= 2750)
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

