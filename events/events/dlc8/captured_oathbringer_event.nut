this.captured_oathbringer_event <- this.inherit("scripts/events/event", {
	m = {
		Torturer = null
	},
	function create()
	{
		this.m.ID = "event.captured_oathbringer";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_05.png[/img]{Jeden z ludzi wpada do twojego namiotu, krzyczac, ze zlapano kogos, kto zakradal sie do obozu. Pytasz, czy to zlodziej. Mezczyzna kreci glowa.%SPEECH_ON%Nie, gorzej. To Slubodawca.%SPEECH_OFF%Skurczybyk. Zrywasz sie na nogi i wybiegasz, znajdujac intruza juz zwiazanego i bitego przez Swietobiorcow. Przerywasz to i stajesz przed nim.%SPEECH_ON%Slubodawco, gdzie jest szczeka Anselma?%SPEECH_OFF%Mezczyzna pluje ci na but i mowi, ze nigdy jej nie odda, a Swietobiorcy moga isc do piekla, gdzie ich miejsce, i ze sam Anselm by ich tam zaprowadzil, gdyby mogl. To bluznierstwo w imie Mlodego Anselma wywoluje westchnienia twoje i twoich ludzi. %randombrother% pochyla sie.%SPEECH_ON%Daj tylko slowo, kapitanie, a pokazemy temu Slubodawcy, jak bardzo sie myli.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zabij go.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Torturuj go.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 80 ? "C" : "D";
					}

				},
				{
					Text = "Puszcz go.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "{[img]gfx/ui/events/event_05.png[/img]{Wyciagasz miecz i wbijasz go w serce mezczyzny.%SPEECH_ON%Anselm nie bedzie na ciebie czekal w nastepnym zyciu, heretyku.%SPEECH_OFF%Cialo mezczyzny opada na ostrze, oczy na chwile szerokie, po czym gasna w polprzymknietym spojrzeniu na ziemie. Wyciagasz miecz, a %companyname% wiwatuje.%SPEECH_ON%Smierc wszystkim Slubodawcom!%SPEECH_OFF%Swietobiorcy dobywaja mieczy i wznosza je ku niebu, gdy po kompanii przechodzi żarliwy zapał.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Sprawiedliwosci stalo sie zadość.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local potential_loot = [
					"armor/adorned_mail_shirt",
					"helmets/heavy_mail_coif",
					"helmets/heavy_mail_coif"
				];
				local item = this.new("scripts/items/" + potential_loot[this.Math.rand(0, potential_loot.len() - 1)]);
				item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(10, 30) * 0.01));
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				this.World.Assets.getStash().add(item);
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.paladin" || !bro.getBackground().isOffendedByViolence() && this.Math.rand(1, 100) <= 75)
					{
						bro.improveMood(0.75, "Cieszy sie, ze zabiles heretyka Slubodawce");

						if (bro.getMoodState() > this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getBackground().isOffendedByViolence())
					{
						bro.worsenMood(0.5, "Nie spodobalo mu sie, ze zabiles pojmanego z zimna krwia");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "{[img]gfx/ui/events/event_05.png[/img]{Kiwasz glowa.%SPEECH_ON%Torturuj go, az jego jezyk wskaze szczeke Mlodego Anselma. Nie obchodzi mnie jak, po prostu to zrob.%SPEECH_OFF%Odwracajac sie, jeniec krzyczy, ze Anselm by tego nie pochwalil. Potem zaczyna krzyczec bez ladu i skladu, az w koncu wykrzykuje rzeczy, ktore nie maja wiekszego sensu. Wracasz do namiotu, podrygujac stopa w rytm krzykow, ktore teraz przybieraja formę rytmicznego zawodzenia. W koncu %randombrother% wraca. Ma ze soba bron i zbroje, o ktorych wiesz, ze nie bylo ich w ekwipunku.%SPEECH_ON%Zaprowadzil nas do miejsca, gdzie to bylo ukryte, ale szczeka Anselma wciaz zaginiona. Obawiam sie, ze Slubodawcy musza ja miec w swoim obozie, ale nie powiedzial, gdzie to bylo. My, eee, mielismy pewne trudnosci z komunikacja po tym, jak wycielismy mu jezyk.%SPEECH_OFF%Wzdychajac, pytasz, gdzie jest jeniec. Mezczyzna odchrząkuje.%SPEECH_ON%No, zrobil sie caly bialy i sie przewrocil. Nie zyje, panie.%SPEECH_OFF%Przynajmniej postapilismy slusznie wobec Mlodego Anselma.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jeszcze odnajdziemy szczeke.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local potential_loot = [
					"armor/adorned_warriors_armor",
					"helmets/adorned_closed_flat_top_with_mail",
					"helmets/adorned_closed_flat_top_with_mail"
				];
				local item = this.new("scripts/items/" + potential_loot[this.Math.rand(0, potential_loot.len() - 1)]);
				item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(10, 30) * 0.01));
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				this.World.Assets.getStash().add(item);
				potential_loot = [
					"weapons/arming_sword",
					"weapons/fighting_axe",
					"weapons/military_cleaver",
					"shields/heater_shield"
				];
				item = this.new("scripts/items/" + potential_loot[this.Math.rand(0, potential_loot.len() - 1)]);
				item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(10, 30) * 0.01));
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				this.World.Assets.getStash().add(item);
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.paladin" || !bro.getBackground().isOffendedByViolence() && this.Math.rand(1, 100) <= 75)
					{
						bro.improveMood(1.25, "Torturowal heretyka Slubodawce");

						if (bro.getMoodState() > this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getBackground().isOffendedByViolence())
					{
						bro.worsenMood(0.75, "Jest przerazony, ze kazales torturowac pojmanego");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "{[img]gfx/ui/events/event_05.png[/img]{Mowisz ludziom, by torturowali mezczyzne dla informacji. Jesli jest cos, co kazdy Slubodawca wie, to gdzie znajduje sie szczeka Mlodego Anselma, a to jest cos, czego kazdy Swietobiorca chce sie dowiedziec. Mezczyzna krzyczy, gdy go odciagaja, a ty wracasz do namiotu, by zagluszyc irytujace dzwieki wrzaskow i placzu, które psuja ci nastroj. Chwile pozniej %torturer% wchodzi do namiotu z krwia na koszuli. Chce cos powiedziec, po czym pada na ziemie. Inny Swietobiorca wchodzi i mowi, ze jeniec uciekl, dźgajac oprawce nozem przed ucieczka. Kazesz ludziom pomoc %torturer%, zanim sie wykrwawi.%SPEECH_ON%Ci przekleci Slubodawcy nie maja honoru! Znajdziemy go i zabijemy, tak rzecze Mlody Anselm, tak rzeczemy my wszyscy!%SPEECH_OFF%Mowisz to ze scisnietymi zebami, teatralnym tonem. Prawda jest taka, ze drań uciekł, a Slubodawcow trudno zlapac, takie z nich szczury. Pozostaje miec nadzieje, ze %torturer% przezyje.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cholerne Slubodawcze scum.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Torturer.addHeavyInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Torturer.getName() + " odnosi powazne rany"
				});
				local injury = _event.m.Torturer.addInjury([
					{
						ID = "injury.cut_throat",
						Threshold = 0.0,
						Script = "injury/cut_throat_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Torturer.getName() + " odnosi " + injury.getNameOnly()
				});
				_event.m.Torturer.worsenMood(0.5, "Pozwolil uciec pojmanemu Slubodawcy");
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "{[img]gfx/ui/events/event_05.png[/img]{Ten czlowiek nie ma nic wartosciowego. Mowisz ludziom, by go uwolnili. Protestuja, twierdzac, ze Slubodawca ma tylko jeden wybor: podporzadkowac sie Swietobiorcom i prawdziwej Ostatecznej Sciezce albo umrzec. Jest tez miejsce dla tego, kto zwroci szczeke Mlodego Anselma, ale zasady postepowania z takim Slubodawca wciaz nie zostaly ustalone. Ale jesli chodzi o tego czlowieka, nie ma z niego pozytku, a ty nie masz ochoty na rozlew krwi. Gdy powtarzasz, by go uwolnili, %randombrother% podrzyna mu gardlo, wywolujac wiwaty pozostalych.%SPEECH_ON%Powiedziales, by go przeciac, prawda, kapitanie? Prawda?%SPEECH_OFF%Zrozumiales, ze Swietobiorca kryje ciebie, a dalsze zaprzeczanie, ze Slubodawca musial zginac, mogloby postawic cie w niezrecznej sytuacji. Kiwasz glowa.%SPEECH_ON%Tak, oczywiscie, ten maly szczur musial zginac, jak wszyscy Slubodawcy bez sciezki! I wszyscy oni zginą!%SPEECH_OFF%Ludzie znow rycza, choc masz przeczucie, ze kilku zapamieta twoja niedorzeczna propozycje, by puscić Slubodawce wolno.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Powinienem uwazac na to, co mowie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.paladin" || this.Math.rand(1, 100) <= 75)
					{
						bro.worsenMood(0.75, "Prawie wypusciles pojmanego Slubodawce");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		if (this.World.getTime().Days < 35)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local torturer_candidates = [];
		local haveSkull = false;

		foreach( bro in brothers )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && item.getID() == "accessory.oathtaker_skull_02")
			{
				haveSkull = true;
			}

			if (bro.getBackground().getID() == "background.paladin")
			{
				torturer_candidates.push(bro);
			}
		}

		if (!haveSkull)
		{
			local stash = this.World.Assets.getStash().getItems();

			foreach( item in stash )
			{
				if (item != null && item.getID() == "accessory.oathtaker_skull_02")
				{
					haveSkull = true;
					break;
				}
			}
		}

		if (haveSkull)
		{
			return;
		}

		if (torturer_candidates.len() == 0)
		{
			torturer_candidates.push(brothers[this.Math.rand(0, brothers.len() - 1)]);
		}

		this.m.Torturer = torturer_candidates[this.Math.rand(0, torturer_candidates.len() - 1)];
		this.m.Score = 7;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"torturer",
			this.m.Torturer.getName()
		]);
	}

	function onClear()
	{
		this.m.Torturer = null;
	}

});

