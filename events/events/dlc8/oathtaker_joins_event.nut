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
			Text = "[img]gfx/ui/events/event_180.png[/img]{Mężczyzna w zbroi zbliża się do kompanii. Wygląda całkiem zwyczajnie, aż do chwili gdy otwiera usta.%SPEECH_ON%Słuchajcie, słuchajcie, jestem dumnym Świętobiorcą! Widzę, że i wy bardzo cenicie czynienie tego, co słuszne. To sprawia, że wierzę, iż wy też jesteście Świętobiorcami. Zatem! Mam do was tylko jedno pytanie: ta czaszka wisząca na naszyjniku, jak ma na imię? Jeśli to ta, której szukam, macie moją rękę.%SPEECH_OFF% | Ludzie w zbrojach nie są na drogach niczym rzadkim, ale ten mężczyzna ma w sobie pewną pompę i teatralność, która przyciąga wzrok, podobnie jak to, że pewnie kroczy prosto do ciebie.%SPEECH_ON%Hulałem w lokalnej gospodzie, gdy dotarła do mnie wieść, że przez te ziemie przeszła banda Świętobiorców. Teraz albo to cmentarny przekręt wiszący u twej szyi, albo to... no właśnie, sam powiedz. Podaj mi właściwe imię tej czaszki, a dołączę do was tu i teraz.%SPEECH_OFF% | Spotykasz mężczyznę w zbroi. Stoi na drodze tak, jakby chciał zginąć z ręki najemnika albo ryzykował kark dla monety. Gdy się zbliżasz, macha do ciebie.%SPEECH_ON%Ach, ludzie, których szukam. Czy jesteście ze Świętobiorcami? Chcę dołączyć do was na ścieżce. Ścieżce...%SPEECH_OFF%Zawiesza głos, wskazując na kompanijną czaszkę. Aha, chodzi mu o... | Mężczyzna w zbroi wybiega na drogę. Kładziesz rękę na mieczu, ale on po prostu się kłania, jakbyś był katem.%SPEECH_ON%Modliłem się do starych bogów, by utwardzili moje cnoty i utrzymali mnie na ścieżce. Czyż, nieznajomy, czyż to nie jego czaszka wisząca u twej szyi? Jeśli tak, dołączę do was i do ślubów, na których jesteście, w tej chwili. Proszę, powiedz mi, czy to bezzuchwa czaszka naszego drogiego...naszego...%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Młody Anselm.",
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
			Text = "[img]gfx/ui/events/event_180.png[/img]{Mężczyzna pada na kolano, z opuszczoną głową.%SPEECH_ON%Zaprawdę, Młody Anselm mnie tu poprowadził! Dołączę do was na ścieżce, bracia Świętobiorcy!%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Witaj na pokładzie.",
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
			Text = "[img]gfx/ui/events/event_180.png[/img]{Mężczyzna wzdycha.%SPEECH_ON%A, rozumiem. Jest na tym świecie stanowczo za dużo Hugów, nie dziwi mnie, że pojawił się kolejny w stanie tak ponurej czaszki, choć nie wiem, czemu nosicie ją przy sobie.%SPEECH_OFF% | %SPEECH_ON%Hugo.%SPEECH_OFF%Mówi mężczyzna.%SPEECH_ON%Kolejny cholerny Hugo, co? Ilu ich tu jest? Co drugi facet, na którego trafiam, to Hugo.%SPEECH_OFF%Odwraca się i odchodzi, mrucząc ze złością o pospolitych ludziach i ich nieoryginalnych imionach. | Mężczyzna wzdycha.%SPEECH_ON%Hugo, co? Dobra. No to do zobaczenia.%SPEECH_OFF%}",
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

