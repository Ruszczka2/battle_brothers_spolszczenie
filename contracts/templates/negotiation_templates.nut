local gt = this.getroottable();

if (!("Contracts" in gt.Const))
{
	gt.Const.Contracts <- {};
}

gt.Const.Contracts.Overview <- [
	{
		ID = "Overview",
		Title = "Podgląd",
		Text = "Wynegocjowany kontrakt brzmi następująco. Czy zgadzasz się na te warunki?",
		Image = "",
		List = [],
		Options = [
			{
				Text = "Akceptuję ten kontrakt.",
				function getResult()
				{
					this.Contract.setState("Running");
					return 0;
				}

			},
			{
				Text = "Potrzebuję trochę czasu, by się nad tym zastanowić.",
				function getResult()
				{
					this.World.State.getTownScreen().updateContracts();
					return 0;
				}

			},
			{
				Text = "Przemyślawszy sprawę, nie przyjmę tego kontraktu.",
				function getResult()
				{
					this.World.Contracts.removeContract(this.Contract);
					this.World.State.getTownScreen().updateContracts();
					return 0;
				}

			}
		],
		ShowObjectives = true,
		ShowPayment = true,
		ShowEmployer = true,
		ShowDifficulty = true,
		function start()
		{
			this.Contract.m.IsNegotiated = true;
		}

	}
];
gt.Const.Contracts.NegotiationDefault <- [
	{
		ID = "Negotiation",
		Title = "Negocjacje",
		Text = "",
		Image = "",
		List = [],
		ShowEmployer = true,
		ShowDifficulty = true,
		Options = [],
		function start()
		{
			this.Options = [];
			this.Options.push({
				Text = "Przyjmuję twoją propozycję.",
				function getResult()
				{
					this.Contract.m.BulletpointsPayment = [];

					if (this.Contract.m.Payment.Advance != 0)
					{
						this.Contract.m.BulletpointsPayment.push("Otrzymasz " + this.Contract.m.Payment.getInAdvance() + " koron z góry");
					}

					if (this.Contract.m.Payment.Completion != 0)
					{
						this.Contract.m.BulletpointsPayment.push("Otrzymasz " + this.Contract.m.Payment.getOnCompletion() + " koron po wykonaniu zlecenia");
					}

					return "Overview";
				}

			});
			this.Options.push({
				Text = "Musimy otrzymać wyższą zapłatę za takie zadanie.",
				function getResult()
				{
					if (!this.World.Retinue.hasFollower("follower.negotiator"))
					{
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelationEx(-0.5);
					}

					this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

					if (this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
					{
						return "Negotiation.Fail";
					}

					if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
					{
						this.Contract.m.Payment.IsFinal = true;
					}
					else
					{
						this.Contract.m.Payment.IsFinal = false;
						this.Contract.m.Payment.Pool = this.Contract.m.Payment.Pool * (1.0 + this.Math.rand(3, 10) * 0.01);
					}

					return "Negotiation";
				}

			});

			if (this.Contract.m.Payment.Advance < 1.0)
			{
				this.Options.push({
					Text = this.Contract.m.Payment.Advance == 0 ? "Potrzebujemy zapłaty z góry." : "Potrzebujemy wyższej zapłaty z góry.",
					function getResult()
					{
						this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

						if (this.Contract.m.Payment.Advance >= this.World.Assets.m.AdvancePaymentCap || this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
						{
							return "Negotiation.Fail";
						}

						if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
						{
							this.Contract.m.Payment.IsFinal = true;
						}
						else
						{
							this.Contract.m.Payment.IsFinal = false;
							this.Contract.m.Payment.Advance = this.Math.minf(1.0, this.Contract.m.Payment.Advance + 0.25);
							this.Contract.m.Payment.Completion = this.Math.maxf(0.0, this.Contract.m.Payment.Completion - 0.25);
						}

						return "Negotiation";
					}

				});
			}

			if (this.Contract.m.Payment.Completion < 1.0)
			{
				this.Options.push({
					Text = this.Contract.m.Payment.Completion == 0 ? "Potrzebujemy zapłaty po wykonaniu zlecenia." : "Potrzebujemy wyższej zapłaty po wykonaniu zlecenia.",
					function getResult()
					{
						this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

						if (this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
						{
							return "Negotiation.Fail";
						}

						if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
						{
							this.Contract.m.Payment.IsFinal = true;
						}
						else
						{
							this.Contract.m.Payment.IsFinal = false;
							this.Contract.m.Payment.Advance = this.Math.maxf(0.0, this.Contract.m.Payment.Advance - 0.25);
							this.Contract.m.Payment.Completion = this.Math.minf(1.0, this.Contract.m.Payment.Completion + 0.25);
						}

						return "Negotiation";
					}

				});
			}

			this.Options.push({
				Text = "Zapomnij, to nie jest tego warte.",
				function getResult()
				{
					this.World.Contracts.removeContract(this.Contract);
					this.World.State.getTownScreen().updateContracts();
					return 0;
				}

			});

			if (!this.Contract.m.Payment.IsNegotiating)
			{
				this.Text = "[img]gfx/ui/events/event_04.png[/img]{Przytakuje.%SPEECH_ON%Tak. Dobrze. Już wcześniej myślałem o zapłacie za twoje zadanie. | Uśmiecha się.%SPEECH_ON%Dzięki temu staniesz się bogaty, przyjacielu. | Bierze głęboki wdech.%SPEECH_ON%W porządku, oto co mogę ci zaproponować. | Kładzie ci rękę na ramieniu, uśmiechając się potwierdzająco.%SPEECH_ON%Chyba wiem jaka powinna być stosowana rekompensata za twoje usługi. | Gestykuluje rękoma, wskazując na palce, jakby coś przeliczał, ale nic ci to nie mówi.%SPEECH_ON%Z doświadczenia sądzę, że to będzie należyta zapłata za to zadanie. | Kiwa głową. %SPEECH_ON%Wyglądacie na umiejętnych, więc jestem gotowy zapłacić całkiem sporo. | Dzwoni sakiewką.%SPEECH_ON%To będzie należeć do ciebie, jeśli mi w tej sprawie pomożesz. | Otwiera dłonie.%SPEECH_ON%Krucho ostatnio stoję z koronami, więc zanim zapytasz, to wszystko, co obecnie mam. | %SPEECH_ON%Możesz być pewien, że to co teraz oferuję, to uczciwa zapłata za twoją pracę.}  ";
				this.Contract.m.Payment.IsNegotiating = true;
			}
			else if (this.Contract.m.Payment.IsFinal)
			{
				this.Text = "[img]gfx/ui/events/event_04.png[/img]{%SPEECH_START%Nie zapłacę wam więcej za to zadanie.  | %SPEECH_START%Bądźże rozsądny.  | %SPEECH_START%Nie, nie i jeszcze raz nie.  | %SPEECH_START%Za kogo ty się masz? To ja ustalam ile ci zapłacę.  | Po prostu patrzy na ciebie surowo i potrząsa głową.%SPEECH_ON% | %SPEECH_START%Nie ma mowy!%SPEECH_OFF%Krzyczy, wybuchając gniewem.%SPEECH_ON% | %SPEECH_START%Nie, i tak proponuję wam więcej, niż jesteście warci.  | %SPEECH_START%Nie. I nie denerwuj mnie!  | %SPEECH_START%Chyba nie do końca rozumiesz jak to działa. Musimy dojść do porozumienia, jeśli chcesz otrzymać zapłatę. Moja propozycja nadal obowiązuje. }";
			}
			else
			{
				this.Text = "[img]gfx/ui/events/event_04.png[/img]{%SPEECH_START%A co powiesz na to?  | Bierze głęboki wdech.%SPEECH_ON% | Wzdycha.%SPEECH_ON% | %SPEECH_START%W porządku.  | %SPEECH_START%Dobrze, dobrze.  | %SPEECH_START%Skoro tak być musi.  | %SPEECH_START%W porządku. Co powiesz na to?  | %SPEECH_START%Pewnie, pewnie. Rozumiem.  | %SPEECH_START%Rozsądne.  | %SPEECH_START%Ciekawe. Zatem może to będzie bardziej odpowiednie.  | %SPEECH_START%Może zatem zgodzisz się na to?  | %SPEECH_START%Pozwól, że złożę ci następującą ofertę.  | %SPEECH_ON%Uczciwie. A co powiesz na to w zamian?  | %SPEECH_START%W porządku. Biorąc pod uwagę twoje wymagania, proponuję ci to.  | %SPEECH_START%Miejmy to jak najszybciej za sobą. Oto moja nowa propozycja.  | %SPEECH_START%Wszyscy jesteśmy tu przyjaciółmi, prawda? Zobaczmy... }";
			}

			if (this.Contract.m.Payment.Completion != 0 && this.Contract.m.Payment.Advance == 0)
			{
				this.Text += "{Otrzymasz | Masz otrzymać | Zostanie ci wypłacone | Zapłata to} %reward_completion% koron po wykonaniu zadania.%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion == 0 && this.Contract.m.Payment.Advance != 0)
			{
				this.Text += "{Otrzymasz | Masz otrzymać | Zostanie ci wypłacone} całe %reward_advance% koron z góry.%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion != 0 && this.Contract.m.Payment.Advance != 0)
			{
				this.Text += "{Otrzymasz | Masz otrzymać | Zostanie ci wypłacone | Zapłata to} %reward_advance% koron z góry oraz %reward_completion%, gdy robota zostanie wykonana.%SPEECH_OFF%";
			}
			else
			{
				this.Text += "Nie otrzymasz żadnej zapłaty. Czy tego właśnie chcesz?%SPEECH_OFF%";
			}
		}

	},
	{
		ID = "Negotiation.Fail",
		Title = "Negocjacje",
		Text = "[img]gfx/ui/events/event_74.png[/img]{%SPEECH_START%Zachowujecie się, jakbyście byli jedynymi, którzy oferują swe miecze za monety. Chyba gdzie indziej poszukam ludzi, których potrzebuję. Dobrego dnia.%SPEECH_OFF% | %SPEECH_START%Moja cierpliwość też ma swoje granice, i chyba tracę z wami swój czas.%SPEECH_OFF% | %SPEECH_START%Dosyć tego! Z pewnością znajdę kogoś innego do wykonania zadania!%SPEECH_OFF% | %SPEECH_START%Nie ubliżaj mojej inteligencji! Możecie zapomnieć o tym kontrakcie. Skończyliśmy.%SPEECH_OFF% | Jego twarz czerwienieje od złości.%SPEECH_ON%Wynoście się, nie mam zwyczaju dobijania targu z chciwymi czortami!%SPEECH_OFF% | Wzdycha. %SPEECH_ON%Cóż... zapomnijcie o sprawie. Nie powinienem był w ogóle wam ufać. Zostawcie mnie, bym mógł poszukać innych, rozsądniejszych ludzi.%SPEECH_OFF% | %SPEECH_START%Naprawdę sądziłem, że mamy tu dobre relacje. Wiedzcie jednak, że nie dam sobie wejść na głowę. Nie sądzę, byśmy doszli do porozumienia. Pójdę już.%SPEECH_OFF% | %SPEECH_START%To była dla mnie kompletna strata czasu. Nie wracajcie, dopóki nie nabierzecie nieco ogłady i rozumu.%SPEECH_OFF%}",
		Image = "",
		List = [],
		ShowEmployer = true,
		ShowDifficulty = true,
		Options = [
			{
				Text = "Nie będziemy ryzykować życia za tak nędzną zapłatę...",
				function getResult()
				{
					this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationContractNegotiationsFail, "Negocjacje kontraktu poszły kiepsko");
					this.World.Contracts.removeContract(this.Contract);
					return 0;
				}

			}
		]
	}
];
gt.Const.Contracts.NegotiationPerHead <- [
	{
		ID = "Negotiation",
		Title = "Negocjacje",
		Text = "",
		Image = "",
		List = [],
		ShowEmployer = true,
		ShowDifficulty = true,
		Options = [],
		function start()
		{
			this.Options = [];
			this.Options.push({
				Text = "Przyjmuję twoją propozycję.",
				function getResult()
				{
					this.Contract.m.BulletpointsPayment = [];

					if (this.Contract.m.Payment.Advance != 0)
					{
						this.Contract.m.BulletpointsPayment.push("Otrzymasz " + this.Contract.m.Payment.getInAdvance() + " koron z góry");
					}

					if (this.Contract.m.Payment.Count != 0)
					{
						this.Contract.m.BulletpointsPayment.push("Otrzymasz " + this.Contract.m.Payment.getPerCount() + " koron za każdą przyniesioną głowę, do " + this.Contract.m.Payment.MaxCount + " maksymalnie");
					}

					if (this.Contract.m.Payment.Completion != 0)
					{
						this.Contract.m.BulletpointsPayment.push("Otrzymasz " + this.Contract.m.Payment.getOnCompletion() + " koron po wykonaniu zlecenia");
					}

					return "Overview";
				}

			});
			this.Options.push({
				Text = "Musimy otrzymać wyższą zapłatę za takie zadanie.",
				function getResult()
				{
					if (!this.World.Retinue.hasFollower("follower.negotiator"))
					{
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelationEx(-0.5);
					}

					this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

					if (this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
					{
						return "Negotiation.Fail";
					}

					if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
					{
						this.Contract.m.Payment.IsFinal = true;
					}
					else
					{
						this.Contract.m.Payment.IsFinal = false;
						this.Contract.m.Payment.Pool = this.Contract.m.Payment.Pool * (1.0 + this.Math.rand(3, 10) * 0.01);
					}

					return "Negotiation";
				}

			});

			if (this.Contract.m.Payment.Count < 1.0)
			{
				this.Options.push({
					Text = this.Contract.m.Payment.Count == 0 ? "Musimy otrzymać zapłatę za każdą przyniesioną głowę." : "Musimy otrzymać wyższą zapłatę za każdą przyniesioną głowę.",
					function getResult()
					{
						this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

						if (this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
						{
							return "Negotiation.Fail";
						}

						if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
						{
							this.Contract.m.Payment.IsFinal = true;
						}
						else
						{
							this.Contract.m.Payment.IsFinal = false;

							if (this.Contract.m.Payment.Completion > 0 && this.Contract.m.Payment.Advance > 0)
							{
								this.Contract.m.Payment.Advance = this.Math.maxf(0.0, this.Contract.m.Payment.Advance - 0.125);
								this.Contract.m.Payment.Completion = this.Math.maxf(0.0, this.Contract.m.Payment.Completion - 0.125);
							}
							else if (this.Contract.m.Payment.Advance > 0)
							{
								this.Contract.m.Payment.Advance = this.Math.maxf(0.0, this.Contract.m.Payment.Advance - 0.25);
							}
							else
							{
								this.Contract.m.Payment.Completion = this.Math.maxf(0.0, this.Contract.m.Payment.Completion - 0.25);
							}

							this.Contract.m.Payment.Count = this.Math.minf(1.0, this.Contract.m.Payment.Count + 0.25);
						}

						return "Negotiation";
					}

				});
			}

			if (this.Contract.m.Payment.Advance < 1.0)
			{
				this.Options.push({
					Text = this.Contract.m.Payment.Advance == 0 ? "Potrzebujemy zapłaty z góry." : "Potrzebujemy wyższej zapłaty z góry.",
					function getResult()
					{
						this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

						if (this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
						{
							return "Negotiation.Fail";
						}

						if (this.Contract.m.Payment.Advance >= this.World.Assets.m.AdvancePaymentCap || this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
						{
							this.Contract.m.Payment.IsFinal = true;
						}
						else
						{
							this.Contract.m.Payment.IsFinal = false;

							if (this.Contract.m.Payment.Completion > 0 && this.Contract.m.Payment.Count > 0)
							{
								this.Contract.m.Payment.Completion = this.Math.maxf(0.0, this.Contract.m.Payment.Completion - 0.125);
								this.Contract.m.Payment.Count = this.Math.maxf(0.0, this.Contract.m.Payment.Count - 0.125);
							}
							else if (this.Contract.m.Payment.Count > 0)
							{
								this.Contract.m.Payment.Count = this.Math.maxf(0.0, this.Contract.m.Payment.Count - 0.25);
							}
							else
							{
								this.Contract.m.Payment.Completion = this.Math.maxf(0.0, this.Contract.m.Payment.Completion - 0.25);
							}

							this.Contract.m.Payment.Advance = this.Math.minf(1.0, this.Contract.m.Payment.Advance + 0.25);
						}

						return "Negotiation";
					}

				});
			}

			if (this.Contract.m.Payment.Completion < 1.0)
			{
				this.Options.push({
					Text = this.Contract.m.Payment.Completion == 0 ? "Potrzebujemy zapłaty po wykonianiu zadania." : "Potrzebujemy wyższej zapłaty po wykonaniu zadania.",
					function getResult()
					{
						this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

						if (this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
						{
							return "Negotiation.Fail";
						}

						if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
						{
							this.Contract.m.Payment.IsFinal = true;
						}
						else
						{
							this.Contract.m.Payment.IsFinal = false;

							if (this.Contract.m.Payment.Advance > 0 && this.Contract.m.Payment.Count > 0)
							{
								this.Contract.m.Payment.Advance = this.Math.maxf(0.0, this.Contract.m.Payment.Advance - 0.125);
								this.Contract.m.Payment.Count = this.Math.maxf(0.0, this.Contract.m.Payment.Count - 0.125);
							}
							else if (this.Contract.m.Payment.Count > 0)
							{
								this.Contract.m.Payment.Count = this.Math.maxf(0.0, this.Contract.m.Payment.Count - 0.25);
							}
							else
							{
								this.Contract.m.Payment.Advance = this.Math.maxf(0.0, this.Contract.m.Payment.Advance - 0.25);
							}

							this.Contract.m.Payment.Completion = this.Math.minf(1.0, this.Contract.m.Payment.Completion + 0.25);
						}

						return "Negotiation";
					}

				});
			}

			this.Options.push({
				Text = "Zapomnij, to nie jest tego warte.",
				function getResult()
				{
					this.World.Contracts.removeContract(this.Contract);
					this.World.State.getTownScreen().updateContracts();
					return 0;
				}

			});

			if (!this.Contract.m.Payment.IsNegotiating)
			{
				this.Text = "[img]gfx/ui/events/event_04.png[/img]{Przytakuje.%SPEECH_ON%Tak. Dobrze. Już wcześniej myślałem o zapłacie za twoje zadanie. | Uśmiecha się.%SPEECH_ON%Dzięki temu staniesz się bogaty, przyjacielu. | Bierze głęboki wdech.%SPEECH_ON%W porządku, oto co mogę ci zaproponować. | Kładzie ci rękę na ramieniu, uśmiechając się potwierdzająco.%SPEECH_ON%Chyba wiem jaka powinna być stosowana rekompensata za twoje usługi. | Gestykuluje rękoma, wskazując na palce, jakby coś przeliczał, ale nic ci to nie mówi.%SPEECH_ON%Z doświadczenia sądzę, że to będzie należyta zapłata za to zadanie. | Kiwa głową. %SPEECH_ON%Wyglądacie na umiejętnych, więc jestem gotowy zapłacić całkiem sporo. | Dzwoni sakiewką.%SPEECH_ON%To będzie należeć do ciebie, jeśli mi w tej sprawie pomożesz. | Otwiera dłonie.%SPEECH_ON%Krucho ostatnio stoję z koronami, więc zanim zapytasz, to wszystko, co obecnie mam. | %SPEECH_ON%Możesz być pewien, że to co teraz oferuję, to uczciwa zapłata za twoją pracę.}  ";
				this.Contract.m.Payment.IsNegotiating = true;
			}
			else if (this.Contract.m.Payment.IsFinal)
			{
				this.Text = "[img]gfx/ui/events/event_04.png[/img]{%SPEECH_START%Nie zapłacę wam więcej za to zadanie.  | %SPEECH_START%Bądźże rozsądny.  | %SPEECH_START%Nie, nie i jeszcze raz nie.  | %SPEECH_START%Za kogo ty się masz? To ja ustalam ile ci zapłacę.  | Po prostu patrzy na ciebie surowo i potrząsa głową.%SPEECH_ON% | %SPEECH_START%Nie ma mowy!%SPEECH_OFF%Krzyczy, wybuchając gniewem.%SPEECH_ON% | %SPEECH_START%Nie, i tak proponuję wam więcej, niż jesteście warci.  | %SPEECH_START%Nie. I nie denerwuj mnie!  | %SPEECH_START%Chyba nie do końca rozumiesz jak to działa. Musimy dojść do porozumienia, jeśli chcesz otrzymać zapłatę. Moja propozycja nadal obowiązuje. }";
			}
			else
			{
				this.Text = "[img]gfx/ui/events/event_04.png[/img]{%SPEECH_START%A co powiesz na to?  | Bierze głęboki wdech.%SPEECH_ON% | Wzdycha.%SPEECH_ON% | %SPEECH_START%W porządku.  | %SPEECH_START%Dobrze, dobrze.  | %SPEECH_START%Skoro tak być musi.  | %SPEECH_START%W porządku. Co powiesz na to?  | %SPEECH_START%Pewnie, pewnie. Rozumiem.  | %SPEECH_START%Rozsądne.  | %SPEECH_START%Ciekawe. Zatem może to będzie bardziej odpowiednie.  | %SPEECH_START%Może zatem zgodzisz się na to?  | %SPEECH_START%Pozwól, że złożę ci następującą ofertę.  | %SPEECH_ON%Uczciwie. A co powiesz na to w zamian?  | %SPEECH_START%W porządku. Biorąc pod uwagę twoje wymagania, proponuję ci to.  | %SPEECH_START%Miejmy to jak najszybciej za sobą. Oto moja nowa propozycja.  | %SPEECH_START%Wszyscy jesteśmy tu przyjaciółmi, prawda? Zobaczmy... }";
			}

			if (this.Contract.m.Payment.Completion != 0 && this.Contract.m.Payment.Advance == 0 && this.Contract.m.Payment.Count == 0)
			{
				this.Text += "{Otrzymasz | Masz otrzymać | Zostanie ci wypłacone | Zapłata to} %reward_completion% koron po wykonaniu kontraktu.%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion == 0 && this.Contract.m.Payment.Advance != 0 && this.Contract.m.Payment.Count == 0)
			{
				this.Text += "{Otrzymasz | Masz otrzymać | Zostanie ci wypłacone} całe %reward_advance% koron z góry.%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion == 0 && this.Contract.m.Payment.Advance == 0 && this.Contract.m.Payment.Count != 0)
			{
				this.Text += "{Otrzymasz | Masz otrzymać | Zostanie ci wypłacone | Zapłata to} %reward_count% koron za każdą dostarczoną głowę, {maksymalnie do %maxcount% głów | a zapłacę za maksymalnie %maxcount% głów | %maxcount% głów maksymalnie}.%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion != 0 && this.Contract.m.Payment.Advance != 0 && this.Contract.m.Payment.Count == 0)
			{
				this.Text += "{Otrzymasz | Masz otrzymać | Zostanie ci wypłacone | Zapłata to} %reward_advance% koron z góry oraz kolejne %reward_completion%, gdy robota zostanie wykonana.%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion == 0 && this.Contract.m.Payment.Advance != 0 && this.Contract.m.Payment.Count != 0)
			{
				this.Text += "{Otrzymasz | Masz otrzymać | Zostanie ci wypłacone | Zapłata to} %reward_advance% koron z góry oraz kolejne %reward_count% koron za każdą dostarczoną głowę, {maksymalnie do %maxcount% głów | a zapłacę za maksymalnie %maxcount% głów | %maxcount% głów maksymalnie}.%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion != 0 && this.Contract.m.Payment.Advance == 0 && this.Contract.m.Payment.Count != 0)
			{
				this.Text += "{Otrzymasz | Masz otrzymać | Zostanie ci wypłacone | Zapłata to} %reward_count% koron za każdą dostarczoną głowę, {maksymalnie do %maxcount% głów | a zapłacę za maksymalnie %maxcount% głów | %maxcount% głów maksymalnie}, a także %reward_completion% po wykonaniu roboty.%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion != 0 && this.Contract.m.Payment.Advance != 0 && this.Contract.m.Payment.Count != 0)
			{
				this.Text += "{Otrzymasz | Masz otrzymać | Zostanie ci wypłacone | Zapłata to} %reward_advance% koron z góry, %reward_count% koron za każdą dostarczoną głowę, {maksymalnie do %maxcount% głów | a zapłacę za maksymalnie %maxcount% głów | %maxcount% głów maksymalnie}, a także %reward_completion% po wykonaniu roboty.%SPEECH_OFF%";
			}
			else
			{
				this.Text += "Nie otrzymasz żadnej zapłaty. Czy tego właśnie chcesz?%SPEECH_OFF%";
			}
		}

	},
	{
		ID = "Negotiation.Fail",
		Title = "Negocjacje",
		Text = "[img]gfx/ui/events/event_74.png[/img]{%SPEECH_START%Zachowujecie się, jakbyście byli jedynymi, którzy oferują swe miecze za monety. Chyba gdzie indziej poszukam ludzi, których potrzebuję. Dobrego dnia.%SPEECH_OFF% | %SPEECH_START%Moja cierpliwość też ma swoje granice, i chyba tracę z wami swój czas.%SPEECH_OFF% | %SPEECH_START%Dosyć tego! Z pewnością znajdę kogoś innego do wykonania zadania!%SPEECH_OFF% | %SPEECH_START%Nie ubliżaj mojej inteligencji! Możecie zapomnieć o tym kontrakcie. Skończyliśmy.%SPEECH_OFF% | Jego twarz czerwienieje od złości.%SPEECH_ON%Wynoście się, nie mam zwyczaju dobijania targu z chciwymi czortami!%SPEECH_OFF% | Wzdycha. %SPEECH_ON%Cóż... zapomnijcie o sprawie. Nie powinienem był w ogóle wam ufać. Zostawcie mnie, bym mógł poszukać innych, rozsądniejszych ludzi.%SPEECH_OFF% | %SPEECH_START%Naprawdę sądziłem, że mamy tu dobre relacje. Wiedzcie jednak, że nie dam sobie wejść na głowę. Nie sądzę, byśmy doszli do porozumienia. Pójdę już.%SPEECH_OFF% | %SPEECH_START%To była dla mnie kompletna strata czasu. Nie wracajcie, dopóki nie nabierzecie nieco ogłady i rozumu.%SPEECH_OFF%}",
		Image = "",
		List = [],
		ShowEmployer = true,
		ShowDifficulty = true,
		Options = [
			{
				Text = "Nie będziemy ryzykować życia za tak nędzną zapłatę...",
				function getResult()
				{
					this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationContractNegotiationsFail, "Negocjacje kontraktu poszły kiepsko");
					this.World.Contracts.removeContract(this.Contract);
					return 0;
				}

			}
		]
	}
];
gt.Const.Contracts.NegotiationPerHeadAtDestination <- [
	{
		ID = "Negotiation",
		Title = "Negocjacje",
		Text = "",
		Image = "",
		List = [],
		ShowEmployer = true,
		ShowDifficulty = true,
		Options = [],
		function start()
		{
			this.Options = [];
			this.Options.push({
				Text = "Przyjmuję twoją ofertę.",
				function getResult()
				{
					this.Contract.m.BulletpointsPayment = [];

					if (this.Contract.m.Payment.Advance != 0)
					{
						this.Contract.m.BulletpointsPayment.push("Otrzymasz " + this.Contract.m.Payment.getInAdvance() + " koron z góry");
					}

					if (this.Contract.m.Payment.Count != 0)
					{
						this.Contract.m.BulletpointsPayment.push("Otrzymasz " + this.Contract.m.Payment.getPerCount() + " koron za każdą głowę, którą dostarczysz, aż do " + this.Contract.m.Payment.MaxCount + " łącznie");
					}

					if (this.Contract.m.Payment.Completion != 0)
					{
						this.Contract.m.BulletpointsPayment.push("Otrzymasz " + this.Contract.m.Payment.getOnCompletion() + " koron po ukończeniu zadania");
					}

					return "Overview";
				}

			});
			this.Options.push({
				Text = "Musimy otrzymać wyższą zapłatę za takie zadanie.",
				function getResult()
				{
					if (!this.World.Retinue.hasFollower("follower.negotiator"))
					{
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelationEx(-0.5);
					}

					this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

					if (this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
					{
						return "Negotiation.Fail";
					}

					if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
					{
						this.Contract.m.Payment.IsFinal = true;
					}
					else
					{
						this.Contract.m.Payment.IsFinal = false;
						this.Contract.m.Payment.Pool = this.Contract.m.Payment.Pool * (1.0 + this.Math.rand(3, 10) * 0.01);
					}

					return "Negotiation";
				}

			});

			if (this.Contract.m.Payment.Count < 1.0)
			{
				this.Options.push({
					Text = this.Contract.m.Payment.Count == 0 ? "Musimy otrzymać zapłatę za każdą przyniesioną głowę." : "Musimy otrzymać wyższą zapłatę za każdą przyniesioną głowę.",
					function getResult()
					{
						this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

						if (this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
						{
							return "Negotiation.Fail";
						}

						if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
						{
							this.Contract.m.Payment.IsFinal = true;
						}
						else
						{
							this.Contract.m.Payment.IsFinal = false;

							if (this.Contract.m.Payment.Completion > 0 && this.Contract.m.Payment.Advance > 0)
							{
								this.Contract.m.Payment.Advance = this.Math.maxf(0.0, this.Contract.m.Payment.Advance - 0.125);
								this.Contract.m.Payment.Completion = this.Math.maxf(0.0, this.Contract.m.Payment.Completion - 0.125);
							}
							else if (this.Contract.m.Payment.Advance > 0)
							{
								this.Contract.m.Payment.Advance = this.Math.maxf(0.0, this.Contract.m.Payment.Advance - 0.25);
							}
							else
							{
								this.Contract.m.Payment.Completion = this.Math.maxf(0.0, this.Contract.m.Payment.Completion - 0.25);
							}

							this.Contract.m.Payment.Count = this.Math.minf(1.0, this.Contract.m.Payment.Count + 0.25);
						}

						return "Negotiation";
					}

				});
			}

			if (this.Contract.m.Payment.Advance < 1.0)
			{
				this.Options.push({
					Text = this.Contract.m.Payment.Advance == 0 ? "Potrzebujemy zapłaty z góry." : "Potrzebujemy wyższej zapłaty z góry.",
					function getResult()
					{
						this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

						if (this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
						{
							return "Negotiation.Fail";
						}

						if (this.Contract.m.Payment.Advance >= this.World.Assets.m.AdvancePaymentCap || this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
						{
							this.Contract.m.Payment.IsFinal = true;
						}
						else
						{
							this.Contract.m.Payment.IsFinal = false;

							if (this.Contract.m.Payment.Completion > 0 && this.Contract.m.Payment.Count > 0)
							{
								this.Contract.m.Payment.Completion = this.Math.maxf(0.0, this.Contract.m.Payment.Completion - 0.125);
								this.Contract.m.Payment.Count = this.Math.maxf(0.0, this.Contract.m.Payment.Count - 0.125);
							}
							else if (this.Contract.m.Payment.Count > 0)
							{
								this.Contract.m.Payment.Count = this.Math.maxf(0.0, this.Contract.m.Payment.Count - 0.25);
							}
							else
							{
								this.Contract.m.Payment.Completion = this.Math.maxf(0.0, this.Contract.m.Payment.Completion - 0.25);
							}

							this.Contract.m.Payment.Advance = this.Math.minf(1.0, this.Contract.m.Payment.Advance + 0.25);
						}

						return "Negotiation";
					}

				});
			}

			if (this.Contract.m.Payment.Completion < 1.0)
			{
				this.Options.push({
					Text = this.Contract.m.Payment.Completion == 0 ? "Potrzebujemy zapłaty po wykonianiu zadania." : "Potrzebujemy wyższej zapłaty po wykonaniu zadania.",
					function getResult()
					{
						this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

						if (this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
						{
							return "Negotiation.Fail";
						}

						if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
						{
							this.Contract.m.Payment.IsFinal = true;
						}
						else
						{
							this.Contract.m.Payment.IsFinal = false;

							if (this.Contract.m.Payment.Advance > 0 && this.Contract.m.Payment.Count > 0)
							{
								this.Contract.m.Payment.Advance = this.Math.maxf(0.0, this.Contract.m.Payment.Advance - 0.125);
								this.Contract.m.Payment.Count = this.Math.maxf(0.0, this.Contract.m.Payment.Count - 0.125);
							}
							else if (this.Contract.m.Payment.Count > 0)
							{
								this.Contract.m.Payment.Count = this.Math.maxf(0.0, this.Contract.m.Payment.Count - 0.25);
							}
							else
							{
								this.Contract.m.Payment.Advance = this.Math.maxf(0.0, this.Contract.m.Payment.Advance - 0.25);
							}

							this.Contract.m.Payment.Completion = this.Math.minf(1.0, this.Contract.m.Payment.Completion + 0.25);
						}

						return "Negotiation";
					}

				});
			}

			this.Options.push({
				Text = "Zapomnij, to nie jest tego warte.",
				function getResult()
				{
					this.World.Contracts.removeContract(this.Contract);
					this.World.State.getTownScreen().updateContracts();
					return 0;
				}

			});

			if (!this.Contract.m.Payment.IsNegotiating)
			{
				this.Text = "[img]gfx/ui/events/event_04.png[/img]{Przytakuje.%SPEECH_ON%Tak. Dobrze. Już wcześniej myślałem o zapłacie za twoje zadanie. | Uśmiecha się.%SPEECH_ON%Dzięki temu staniesz się bogaty, przyjacielu. | Bierze głęboki wdech.%SPEECH_ON%W porządku, oto co mogę ci zaproponować. | Kładzie ci rękę na ramieniu, uśmiechając się potwierdzająco.%SPEECH_ON%Chyba wiem jaka powinna być stosowana rekompensata za twoje usługi. | Gestykuluje rękoma, wskazując na palce, jakby coś przeliczał, ale nic ci to nie mówi.%SPEECH_ON%Z doświadczenia sądzę, że to będzie należyta zapłata za to zadanie. | Kiwa głową. %SPEECH_ON%Wyglądacie na umiejętnych, więc jestem gotowy zapłacić całkiem sporo. | Dzwoni sakiewką.%SPEECH_ON%To będzie należeć do ciebie, jeśli mi w tej sprawie pomożesz. | Otwiera dłonie.%SPEECH_ON%Krucho ostatnio stoję z koronami, więc zanim zapytasz, to wszystko, co obecnie mam. | %SPEECH_ON%Możesz być pewien, że to co teraz oferuję, to uczciwa zapłata za twoją pracę.}  ";
				this.Contract.m.Payment.IsNegotiating = true;
			}
			else if (this.Contract.m.Payment.IsFinal)
			{
				this.Text = "[img]gfx/ui/events/event_04.png[/img]{%SPEECH_START%Nie zapłacę wam więcej za to zadanie.  | %SPEECH_START%Bądźże rozsądny.  | %SPEECH_START%Nie, nie i jeszcze raz nie.  | %SPEECH_START%Za kogo ty się masz? To ja ustalam ile ci zapłacę.  | Po prostu patrzy na ciebie surowo i potrząsa głową.%SPEECH_ON% | %SPEECH_START%Nie ma mowy!%SPEECH_OFF%Krzyczy, wybuchając gniewem.%SPEECH_ON% | %SPEECH_START%Nie, i tak proponuję wam więcej, niż jesteście warci.  | %SPEECH_START%Nie. I nie denerwuj mnie!  | %SPEECH_START%Chyba nie do końca rozumiesz jak to działa. Musimy dojść do porozumienia, jeśli chcesz otrzymać zapłatę. Moja propozycja nadal obowiązuje. }";
			}
			else
			{
				this.Text = "[img]gfx/ui/events/event_04.png[/img]{%SPEECH_START%A co powiesz na to?  | Bierze głęboki wdech.%SPEECH_ON% | Wzdycha.%SPEECH_ON% | %SPEECH_START%W porządku.  | %SPEECH_START%Dobrze, dobrze.  | %SPEECH_START%Skoro tak być musi.  | %SPEECH_START%W porządku. Co powiesz na to?  | %SPEECH_START%Pewnie, pewnie. Rozumiem.  | %SPEECH_START%Rozsądne.  | %SPEECH_START%Ciekawe. Zatem może to będzie bardziej odpowiednie.  | %SPEECH_START%Może zatem zgodzisz się na to?  | %SPEECH_START%Pozwól, że złożę ci następującą ofertę.  | %SPEECH_ON%Uczciwie. A co powiesz na to w zamian?  | %SPEECH_START%W porządku. Biorąc pod uwagę twoje wymagania, proponuję ci to.  | %SPEECH_START%Miejmy to jak najszybciej za sobą. Oto moja nowa propozycja.  | %SPEECH_START%Wszyscy jesteśmy tu przyjaciółmi, prawda? Zobaczmy... }";
			}

			if (this.Contract.m.Payment.Completion != 0 && this.Contract.m.Payment.Advance == 0 && this.Contract.m.Payment.Count == 0)
			{
				this.Text += "{Otrzymasz | Masz otrzymać | Zostanie ci wypłacone | Zapłata to} %reward_completion% koron, gdy robota zostanie wykonana.%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion == 0 && this.Contract.m.Payment.Advance != 0 && this.Contract.m.Payment.Count == 0)
			{
				this.Text += "{Otrzymasz | Masz otrzymać | Zostanie ci wypłacone} całe %reward_advance% koron z góry.%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion == 0 && this.Contract.m.Payment.Advance == 0 && this.Contract.m.Payment.Count != 0)
			{
				this.Text += "{Otrzymasz | Masz otrzymać | Zostanie ci wypłacone | Zapłata to} %reward_count% koron za każdą dostarczoną głowę, {maksymalnie do %maxcount% głów | a zapłacę za maksymalnie %maxcount% głów | %maxcount% głów maksymalnie}.%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion != 0 && this.Contract.m.Payment.Advance != 0 && this.Contract.m.Payment.Count == 0)
			{
				this.Text += "{Otrzymasz | Masz otrzymać | Zostanie ci wypłacone | Zapłata to} %reward_advance% koron z góry oraz kolejne %reward_completion%, gdy robota zostanie wykonana.%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion == 0 && this.Contract.m.Payment.Advance != 0 && this.Contract.m.Payment.Count != 0)
			{
				this.Text += "{Otrzymasz | Masz otrzymać | Zostanie ci wypłacone | Zapłata to} %reward_advance% koron z góry oraz kolejne %reward_count% koron za każdą dostarczoną głowę, {maksymalnie do %maxcount% głów | a zapłacę za maksymalnie %maxcount% głów | %maxcount% głów maksymalnie}.%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion != 0 && this.Contract.m.Payment.Advance == 0 && this.Contract.m.Payment.Count != 0)
			{
				this.Text += "{Otrzymasz | Masz otrzymać | Zostanie ci wypłacone | Zapłata to} %reward_count% koron za każdą dostarczoną głowę, {maksymalnie do %maxcount% głów | a zapłacę za maksymalnie %maxcount% głów | %maxcount% głów maksymalnie}, a także %reward_completion% po wykonaniu roboty.%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion != 0 && this.Contract.m.Payment.Advance != 0 && this.Contract.m.Payment.Count != 0)
			{
				this.Text += "{Otrzymasz | Masz otrzymać | Zostanie ci wypłacone | Zapłata to} %reward_advance% koron z góry, %reward_count% koron za każdą dostarczoną głowę, {maksymalnie do %maxcount% głów | a zapłacę za maksymalnie %maxcount% głów | %maxcount% głów maksymalnie}, a także %reward_completion% po wykonaniu roboty.%SPEECH_OFF%";
			}
			else
			{
				this.Text += "Nie otrzymasz żadnej zapłaty. Czy tego właśnie chcesz?%SPEECH_OFF%";
			}
		}

	},
	{
		ID = "Negotiation.Fail",
		Title = "Negocjacje",
		Text = "[img]gfx/ui/events/event_74.png[/img]{%SPEECH_START%Zachowujecie się, jakbyście byli jedynymi, którzy oferują swe miecze za monety. Chyba gdzie indziej poszukam ludzi, których potrzebuję. Dobrego dnia.%SPEECH_OFF% | %SPEECH_START%Moja cierpliwość też ma swoje granice, i chyba tracę z wami swój czas.%SPEECH_OFF% | %SPEECH_START%Dosyć tego! Z pewnością znajdę kogoś innego do wykonania zadania!%SPEECH_OFF% | %SPEECH_START%Nie ubliżaj mojej inteligencji! Możecie zapomnieć o tym kontrakcie. Skończyliśmy.%SPEECH_OFF% | Jego twarz czerwienieje od złości.%SPEECH_ON%Wynoście się, nie mam zwyczaju dobijania targu z chciwymi czortami!%SPEECH_OFF% | Wzdycha. %SPEECH_ON%Cóż... zapomnijcie o sprawie. Nie powinienem był w ogóle wam ufać. Zostawcie mnie, bym mógł poszukać innych, rozsądniejszych ludzi.%SPEECH_OFF% | %SPEECH_START%Naprawdę sądziłem, że mamy tu dobre relacje. Wiedzcie jednak, że nie dam sobie wejść na głowę. Nie sądzę, byśmy doszli do porozumienia. Pójdę już.%SPEECH_OFF% | %SPEECH_START%To była dla mnie kompletna strata czasu. Nie wracajcie, dopóki nie nabierzecie nieco ogłady i rozumu.%SPEECH_OFF%}",
		Image = "",
		List = [],
		ShowEmployer = true,
		ShowDifficulty = true,
		Options = [
			{
				Text = "Nie będziemy ryzykować życia za tak nędzną zapłatę...",
				function getResult()
				{
					this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationContractNegotiationsFail, "Negocjacje kontraktu poszły kiepsko");
					this.World.Contracts.removeContract(this.Contract);
					return 0;
				}

			}
		]
	}
];

