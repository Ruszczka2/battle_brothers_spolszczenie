this.civilwar_trapped_soldiers_event <- this.inherit("scripts/events/event", {
	m = {
		NobleHouse = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_trapped_soldiers";
		this.m.Title = "W %town%";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_43.png[/img]Natrafiasz na duży tłum chłopów w wybuchu gniewu. Z bliższa okazuje się, że otoczyli mały oddział żołnierzy niosących sztandar %noblehouse%, do którego należy ta wioska. Każdy ma dobyte miecze, ale zostali wepchnięci w kąt i są całkowicie przeważeni liczebnie. Pospólstwo krzyczy i wskazuje palcami.%SPEECH_ON%Mordercy! Gwałciciele! Podpalacze!%SPEECH_OFF%W ruch idą plucie i rzucanie pomidorami. %randombrother% podchodzi do ciebie i pyta, czy ludzie mają interweniować, czy trzymać się z dala.",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Musimy to powstrzymać.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				},
				{
					Text = "To nie nasza wojna.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "D";
						}
						else
						{
							return "E";
						}
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_43.png[/img]Żaden człowiek, zwłaszcza z wojennego rodu, nie zasługuje na lincz. Rozkazujesz swoim ludziom wkroczyć, szczekając komendę na tyle głośno, by połowa tłumu odwróciła się i zobaczyła ciebie. Przez zgromadzonych przechodzi pomruk, a ty kiwasz pewnie głową.%SPEECH_ON%Odstąpcie, chłopi. Ci ludzie mogą zasługiwać na wiele, ale wasza nieokiełznana sprawiedliwość do tego nie należy.%SPEECH_OFF%Zaniedbany wieśniak krzyczy.%SPEECH_ON%Ale to mordercy i gorzej!%SPEECH_OFF%Posyłasz mu surowe spojrzenie.%SPEECH_ON%A moi ludzie też. Teraz zejdźcie z drogi.%SPEECH_OFF%Tłum robi, jak kazano. Ocaleni żołnierze mówią ci, że %noblehouse% usłyszy o twoich czynach.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Poszło całkiem dobrze. ",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationFavor, "Saved some of their men");
				this.World.Assets.addMoralReputation(1);
				_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationMinorOffense);
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_43.png[/img]Nie ma powodu, by żołnierzy linczować w ten sposób. Albo, z jakiegoś powodu, tak mówi nagły impuls sprawiedliwości w twoim wnętrzu. Głośnym głosem ogłaszasz się neutralną stroną, która ma mediować. Uczone procedury trwają nieco ponad sekundę, zanim chłopi, bardziej piskliwi i histeryczni niż kiedykolwiek, ogłaszają, że jesteś tylko kolejnymi żołnierzami %noblehouse%. Podnosisz ręce, by wyjaśnić, ale wybucha bijatyka.\n\n Możesz tylko skrzywić się, patrząc, jak twoi ludzie kładą chłopów jednego po drugim, jak silni rolnicy koszący najświeższe łany pszenicy. To makabryczny widok i kilku gapiów patrzy z przerażeniem, po czym ucieka, by zapewne opowiedzieć innym o tym, co tu zrobiłeś. Żołnierze, przeciwnie, dziękują twoim zakrwawionym i umazanym ludom.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Nie wiem, czego się spodziewałem.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Saved some of their men");
				this.World.Assets.addMoralReputation(-2);
				_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationOffense, "Killed some of their men");
				local brothers = this.World.getPlayerRoster().getAll();
				local candidates = [];

				foreach( bro in brothers )
				{
					if (!bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
					{
						candidates.push(bro);
					}
				}

				local numInjured = this.Math.min(candidates.len(), this.Math.rand(1, 3));

				for( local i = 0; i < numInjured; i = ++i )
				{
					local idx = this.Math.rand(0, candidates.len() - 1);
					local bro = candidates[idx];
					candidates.remove(idx);
					local injury = bro.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = bro.getName() + " cierpi na " + injury.getNameOnly()
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_43.png[/img]Wtrącenie się może tylko skomplikować sprawy - chłopi są kapryśni i niewykształceni, prorocy własnej samotności, handlarze złego losu i paranoi. Rozkazujesz swoim ludziom nie tylko stać z boku, ale i uczynić się niewidocznymi.\n\n Rzucony kamień rozpoczyna atak, a wkrótce potem nadciąga ściana wideł i maczet. Żołnierze próbują się bronić, ale najlepszym podsumowaniem ich obrony jest przeraźliwy krzyk. Jednego wyciąga się z tłumu, kopiącego i wrzeszczącego, a chłopi dźgają go raz po raz, aż milknie. Innego wiąże się liną i wciąga na drzewo, wieszając go wysiłkiem trzech wściekłych mężczyzn.\n\n Nasycony tłum cichnie. Dzieci tańczą wokół stóp martwego mężczyzny. Biedny, mamroczący człowiek podskakuje między zwłokami, grzebiąc w kieszeniach każdego z nich.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Tarcie wojny spotyka się z szaleństwem pospólstwa.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.World.Assets.addMoralReputation(-1);
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_43.png[/img]Postanawiasz nie mieszać się w to. To nie twoja walka, a ingerencja tylko skomplikowałaby sprawy. Stojąc z boku, patrzysz, jak tłum napiera na żołnierzy. Jest szamotanina, przenikliwe krzyki przebijają się przez zgiełk chaosu, wijące się wołania tych, którzy nie byli przygotowani na tak brutalny koniec. Lecz jeden mężczyzna przebija się przez tłum, odpychając ludzi i wbijając sztylet jednemu w oko. Udaje mu się dopędzić pobliskiego konia, dosiąść go i popędzić do galopu. Mężczyzna spogląda na sztandar %companyname%, gdy mija cię w biegu. Nie możesz się oprzeć myśli, że %noblehouse% może usłyszeć o twojej neutralności tego dnia...",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Na pewno nic nie powie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Refused to help their men");
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isCivilWar())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local bestDistance = 9000;
		local bestTown;

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern() || t.getSize() > 2)
			{
				continue;
			}

			local d = playerTile.getDistanceTo(t.getTile());

			if (d < bestDistance)
			{
				bestDistance = d;
				bestTown = t;
			}
		}

		if (bestTown == null || bestDistance > 3)
		{
			return;
		}

		this.m.NobleHouse = bestTown.getOwner();
		this.m.Town = bestTown;
		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"noblehouse",
			this.m.NobleHouse.getName()
		]);
		_vars.push([
			"town",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.NobleHouse = null;
		this.m.Town = null;
	}

});

