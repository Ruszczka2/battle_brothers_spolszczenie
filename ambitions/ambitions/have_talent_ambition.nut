this.have_talent_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.have_talent";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Potrzebujemy prawdziwego talentu, by jeszcze bardziej wzmocnił nasze szeregi.\nZatrudnimy najbardziej utalentowanego i zrobimy z niego boga wojny!";
		this.m.UIText = "Miej postać z trzema gwiazdkami w trzech atrybutach";
		this.m.TooltipText = "Miej w swoich szeregach postać z trzema gwiazdkami w trzech różnych atrybutach. Podróżuj po krainie i szukaj najlepszego z najlepszych. Rozważ najęcie \'Rekrutera\' do swojej świty niewalczących towarzyszy.";
		this.m.SuccessText = "[img]gfx/ui/events/event_82.png[/img]Gdy górnik znajdzie w górach diament, czym prędzej trafia on do królewskich komnat. Gdy rybak wyciąga największy połów dnia, szlachcic bierze go dla siebie. Dobrych żołnierzy? Do panów jako generałów lub trenerów. Utalentowanych krawców? Najwspanialsze stroje wymagają najsprawniejszych palców, więc trafiają na służbę do możnych. Psiarz pokaże odrobinę umiejętności wykraczających poza pstrykanie po nosie i szczekanie rozkazów? Może szkolić psy bojowe dla armii wysokiego rodu. Tak to świat chwyta utalentowanych tak szybko, jak jastrząb porywa królika, który się zdradzi.\n\nAle teraz masz własny połów: %star%. To prawdziwy talent, wykazujący niezwykłe predyspozycje fizyczne, bojowe i odwagę. Nawet reszta %companyname% wyczuwa jego obecność tak samo pewnie, jak wyczuwa się przeznaczenie i wielkość. %star% to wszystko, czego można chcieć od najemnika, a gdyby cała kompania była uformowana z ludzi jego pokroju, cóż, robiłbyś coś więcej niż gonienie kontraktów, podbiłbyś cały świat!";
		this.m.SuccessButtonText = "Chyba że jakaś zabłąkana strzała trafi go w następnej bitwie.";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.getTime().Days <= 100)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 3)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax() - 1)
		{
			return;
		}

		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local n = 0;

			foreach( t in bro.getTalents() )
			{
				if (t == 3)
				{
					n = ++n;
					n = n;
				}
			}

			if (n >= 3)
			{
				return;
			}
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local n = 0;

			foreach( t in bro.getTalents() )
			{
				if (t == 3)
				{
					n = ++n;
					n = n;
				}
			}

			if (n >= 3)
			{
				return true;
			}
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		local roster = this.World.getPlayerRoster().getAll();
		local star;

		foreach( bro in roster )
		{
			local n = 0;

			foreach( t in bro.getTalents() )
			{
				if (t == 3)
				{
					n = ++n;
					n = n;
				}
			}

			if (n >= 3)
			{
				star = bro;
				break;
			}
		}

		_vars.push([
			"star",
			star.getName()
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

