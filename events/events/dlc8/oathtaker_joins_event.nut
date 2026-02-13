this.oathtaker_joins_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.oathtaker_joins";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_180.png[/img]{Mezczyzna w zbroi zbliza sie do kompani. Wyglada calkiem zwyczajnie, az do chwili gdy otwiera usta.%SPEECH_ON%Sluchajcie, sluchajcie, jestem dumnym Swietobiorca! Widze, ze i wy bardzo cenicie czynienie tego, co sluszne. To sprawia, ze wierze, iz wy tez jestescie Swietobiorcami. Zatem! Mam do was tylko jedno pytanie: ta czaszka wiszaca na naszyjniku, jak ma na imie? Jesli to ta, ktorej szukam, macie moja reke.%SPEECH_OFF% | Ludzie w zbrojach nie sa na drogach niczym rzadkim, ale ten mezczyzna ma w sobie pewna pompe i teatralnosc, ktora przyciaga wzrok, podobnie jak to, ze pewnie kroczy prosto do ciebie.%SPEECH_ON%Hulalem w lokalnej gospodzie, gdy dotarla do mnie wiec, ze przez te ziemie przeszla banda Swietobiorcow. Teraz albo to cmentarny przekret wiszacy u twej szyi, albo to... no wlasnie, sam powiedz. Podaj mi wlasciwe imie tej czaszki, a dolacze do was tu i teraz.%SPEECH_OFF% | Spotykasz mezczyzne w zbroi. Stoi na drodze tak, jakby chcial zginac z reki najemnika albo ryzykowal kark dla monety. Gdy sie zblizasz, macha do ciebie.%SPEECH_ON%Ach, ludzie, ktorych szukam. Czy jestescie ze Swietobiorcami? Chce dolaczyc do was na sciezce. Sciezce...%SPEECH_OFF%Zawiesza glos, wskazujac na kompanijna czaszke. Aha, chodzi mu o... | Mezczyzna w zbroi wybiega na droge. Kladziesz reke na mieczu, ale on po prostu sie klania, jakbys byl katem.%SPEECH_ON%Modlilem sie do starych bogow, by utwardzili moje cnoty i utrzymali mnie na sciezce. Czyz, nieznajomy, czyz to nie jego czaszka wiszaca u twej szyi? Jesli tak, dolacze do was i do slubow, na ktorych jestescie, w tej chwili. Prosze, powiedz mi, czy to bezzuchwa czaszka naszego drogiego...naszego...%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Mlody Anselm.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Hugo.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"paladin_background"
				]);
				local dudeItems = _event.m.Dude.getItems();

				if (dudeItems.getItemAtSlot(this.Const.ItemSlot.Head) != null && dudeItems.getItemAtSlot(this.Const.ItemSlot.Head).getID() == "armor.head.adorned_full_helm")
				{
					dudeItems.unequip(dudeItems.getItemAtSlot(this.Const.ItemSlot.Head));
					dudeItems.equip(this.new("scripts/items/helmets/adorned_closed_flat_top_with_mail"));
				}

				if (dudeItems.getItemAtSlot(this.Const.ItemSlot.Body) != null && dudeItems.getItemAtSlot(this.Const.ItemSlot.Body).getID() == "armor.body.adorned_heavy_mail_hauberk")
				{
					dudeItems.unequip(dudeItems.getItemAtSlot(this.Const.ItemSlot.Body));
					dudeItems.equip(this.new("scripts/items/armor/adorned_warriors_armor"));
				}

				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_180.png[/img]{Mezczyzna pada na kolano, z opuszczona glowa.%SPEECH_ON%Zaprawde, Mlody Anselm mnie tu poprowadzil! Dolacze do was na sciezce, bracia Swietobiorcy!%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Witaj na pokladzie.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_180.png[/img]{Mezczyzna wzdycha.%SPEECH_ON%A, rozumiem. Jest na tym swiecie stanowczo za duzo Hugow, nie dziwi mnie, ze pojawil sie kolejny w stanie tak ponurej czaszki, choc nie wiem, czemu nosicie ja przy sobie.%SPEECH_OFF% | %SPEECH_ON%Hugo.%SPEECH_OFF%Mowi mezczyzna.%SPEECH_ON%Kolejny cholerny Hugo, co? Ilu ich tu jest? Co drugi facet, na ktorego trafiam, to Hugo.%SPEECH_OFF%Odwraca sie i odchodzi, mruczac ze zloscia o pospolitych ludziach i ich nieoryginalnych imionach. | Mezczyzna wzdycha.%SPEECH_ON%Hugo, co? Dobra. No to do zobaczenia.%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Powodzenia w drodze.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
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

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		if (this.World.getTime().Days <= 30)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local numOathtakers = 0;
		local haveSkull = false;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.paladin")
			{
				numOathtakers++;
			}

			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && (item.getID() == "accessory.oathtaker_skull_01" || item.getID() == "accessory.oathtaker_skull_02"))
			{
				haveSkull = true;
			}
		}

		if (!haveSkull)
		{
			local stash = this.World.Assets.getStash().getItems();

			foreach( item in stash )
			{
				if (item != null && (item.getID() == "accessory.oathtaker_skull_01" || item.getID() == "accessory.oathtaker_skull_02"))
				{
					haveSkull = true;
					break;
				}
			}
		}

		if (!haveSkull)
		{
			return;
		}

		local comebackBonus = numOathtakers < 2 ? 8 : 0;
		this.m.Score = 2 + comebackBonus;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

