this.visit_settlements_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.visit_settlements";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Wiem, że aż rwiecie się do podróży, a musimy szerzyć wieść\no naszej kompanii. Odwiedźmy każdą osadę, jak świat długi i szeroki!";
		this.m.UIText = "Odwiedź każde miasto i fortyfikację na świecie";
		this.m.TooltipText = "Wejdź do każdej wioski, miasta, fortyfikacji i zamku, jakie są na świecie, aby dowiedzieć się o ich towarach i usługach, oraz by szerzyć wieść o swojej kompanii.";
		this.m.SuccessText = "[img]gfx/ui/events/event_16.png[/img]Wkrótce odkrywasz, że żądza drogi, o której śpiewają skaldi, nie jest tak powszechna, jak mówią. Twoja decyzja, by poszerzyć horyzonty kompanii, spotyka się z burczeniem o przymusowych marszach i nocach w drodze. Ale nie wszyscy biorą udział w narzekaniu.%SPEECH_ON%Jeśli marsz przez jeden dzień albo noc w deszczu cię wykańcza, jak stawisz czoło szarży orków?%SPEECH_OFF%%sergeantbrother% pyta ludzi, dostając jedynie oschłą odpowiedź.%SPEECH_ON%Sucho i czujnie.%SPEECH_OFF%Mimo to użyłeś bata i zmusiłeś ich do tego. W każdej wiosce i mieście zachęcałeś ludzi, by dawali o sobie znać, a oni wzięli to do serca, wdając się w bójki, padając pijani na rynku, grożąc kupcom i nękając córki osady. Cokolwiek biedni rzemieślnicy i rolnicy myślą o kompanii, przynajmniej szybko o tobie nie zapomną! Po podróży aż po krawędzie mapy imię %companyname% jest szerzej znane, a ty zdobyłeś lepsze rozeznanie w tej krainie.";
		this.m.SuccessButtonText = "Zapamiętajcie tę nazwę, \'%companyname%\'!";
	}

	function getTooltipText()
	{
		if (this.World.Ambitions.getActiveAmbition() == null)
		{
			return this.m.TooltipText;
		}
		else if (!this.onCheckSuccess())
		{
			local ret = this.m.TooltipText + "\n\nNadal zostało kilka osad do odwiedzenia.\n";
			local c = 0;
			local settlements = this.World.EntityManager.getSettlements();

			foreach( s in settlements )
			{
				if (!s.isVisited())
				{
					c = ++c;
					c = c;

					if (c <= 10)
					{
						ret = ret + ("\n- " + s.getName());
					}
					else
					{
						ret = ret + "\n... oraz inne!";
						break;
					}
				}
			}

			return ret;
		}
		else
		{
			local ret = this.m.TooltipText + "\n\nZrobiłeś to, co miałeś.\n";
			return ret;
		}
	}

	function onUpdateScore()
	{
		if (this.World.Ambitions.getDone() == 0 && (this.World.Assets.getOrigin().getID() != "scenario.deserters" || this.World.Assets.getOrigin().getID() != "scenario.raiders"))
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 2)
		{
			return;
		}

		local settlements = this.World.EntityManager.getSettlements();
		local notVisited = 0;

		foreach( s in settlements )
		{
			if (!s.isVisited())
			{
				notVisited = ++notVisited;
				notVisited = notVisited;
			}
		}

		if (notVisited < 4)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local settlements = this.World.EntityManager.getSettlements();
		local notVisited = 0;

		foreach( s in settlements )
		{
			if (!s.isVisited())
			{
				notVisited = ++notVisited;
				notVisited = notVisited;
			}
		}

		if (notVisited == 0)
		{
			return true;
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local bestBravery = 0;
		local bravest;

		if (brothers.len() > 1)
		{
			for( local i = 0; i < brothers.len(); i = i )
			{
				if (brothers[i].getSkills().hasSkill("trait.player"))
				{
					brothers.remove(i);
					break;
				}

				i = ++i;
			}
		}

		foreach( bro in brothers )
		{
			if (bro.getCurrentProperties().getBravery() > bestBravery)
			{
				bestBravery = bro.getCurrentProperties().getBravery();
				bravest = bro;
			}
		}

		_vars.push([
			"sergeantbrother",
			bravest.getName()
		]);
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

