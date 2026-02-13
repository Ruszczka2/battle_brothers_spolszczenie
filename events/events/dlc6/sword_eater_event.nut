this.sword_eater_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null,
		Wildman = null
	},
	function create()
	{
		this.m.ID = "event.sword_eater";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Po placu w %townname% tańczy połykacz mieczy. Wyciąga ostrze grubości twojego małego palca.%SPEECH_ON%Niech Gilder patrzy, pożrę tę stal!%SPEECH_OFF%Mężczyzna ogłasza zamiar i natychmiast go spełnia: wygina plecy, chwyta ostrze i wsadza je do ust, dalej i głębiej, a jego usta zaciskają się wokół stali, jakby zasysał makaron. Tłum najpierw wzdycha z grozy, ale potem połykacz pokazuje dwa kciuki w górę i widzowie wiwatują.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Options.push({
					Text = "Brawo! Oto kilka monet.",
					function getResult( _event )
					{
						return "B";
					}

				});

				if (_event.m.Wildman != null)
				{
					this.Options.push({
						Text = "Brawo! Daj mu ode mnie kilka monet, %wildman%.",
						function getResult( _event )
						{
							return "C";
						}

					});
				}

				this.Options.push({
					Text = "Ciekawy sposób na zarobek.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Rzucasz mu kilka koron. Wyciąga miecz i kładzie jego czubek na czole. Tłum znów wiwatuje. Uśmiechając się, mężczyzna mówi, balansując mieczem.%SPEECH_ON%Widzę wasz sztandar, Koroniarzu. Nie jestem wojownikiem, ale jestem podróżnikiem i niezłym mówcą. Choć zabiegam o poklask dla własnej korzyści, czasem zadbam o dobre słowo o waszej kompanii szukających monet wyrzutków.%SPEECH_OFF%Połykacz rozkłada ramiona i szybko przytakuje. Ostrze spada z jego czaszki i wpada zgrabnie do pochwy na biodrze. Znów tłum ryczy z zachwytu, a ty nie możesz oprzeć się myśli, że ten artysta dotrzymuje słowa.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mój miecz nie jest tak ostry, a panie i tak tego nie potrafią?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-5);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]5[/color] koron"
					}
				];
				_event.m.Town.getOwner().addPlayerRelation(5.0, "Lokalni artyści roznoszą wieść o tobie");
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Wręczasz %wildman% kilka koron i każesz mu dać napiwek artyście. Warczy i idzie, a ty uświadamiasz sobie, że to nie byle który najemnik, lecz %wildman%, Dziki! Zanim zdążysz go powstrzymać, przewraca połykacza mieczy. Są krzyki, wrzaski i konanie z bulgotem krwi, ale tłum wdziera się przed miejsce zdarzenia i zasłania widok. Z relacji wynika, że ostrze wyszło z przodu połykacza, z pasmami przełyku lub żołądka zwisającymi z niego. Wiesz to, bo Dziki dopilnował, by przynieść miecz, a ty musiałeś go czyścić.\n\n Jak dokładnie odzyskał ostrze w tamtych chwilach rzezi, tego nie pojmujesz, choć wyobrażasz sobie, że uciekł przed wściekłością tłumu dzięki czystej woli, determinacji i całkowitemu brakowi osądów moralnych, co przeraża ludzi o zwykłych obyczajach. Prosisz kilku najemników, by ukryli Dzika, bo przez jakiś czas będzie musiał się nie wychylać.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobra robota, ale też kiepska.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
				this.World.Assets.addMoney(-5);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]5[/color] koron"
					}
				];
				local item = this.new("scripts/items/weapons/fencing_sword");
				item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(10, 40) * 0.01));
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				_event.m.Town.getOwner().addPlayerRelation(-10.0, "Krążą pogłoski, że lokalny artysta został zabity przez jednego z twoich ludzi");
				this.World.Flags.set("IsSwordEaterWildmanDone", true);
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert || !this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		if (this.World.Assets.getMoney() < 100)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local currentTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() && t.getTile().getDistanceTo(currentTile) <= 4 && t.isAlliedWithPlayer())
			{
				this.m.Town = t;
				break;
			}
		}

		if (this.m.Town == null)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_wildman = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (this.Const.DLC.Wildmen && !this.World.Flags.get("IsSwordEaterWildmanDone") && bro.getBackground().getID() == "background.wildman")
			{
				candidates_wildman.push(bro);
			}
		}

		if (candidates_wildman.len() != 0)
		{
			this.m.Wildman = candidates_wildman[this.Math.rand(0, candidates_wildman.len() - 1)];
		}

		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"wildman",
			this.m.Wildman != null ? this.m.Wildman.getNameOnly() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
		this.m.Wildman = null;
	}

});

