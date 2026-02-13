this.manhunters_origin_capture_prisoner_event <- this.inherit("scripts/events/event", {
	m = {
		LastCombatID = 0,
						Text = "Weź go jako dłużnika Gildera, aby mógł zasłużyć na zbawienie.",
	},
	function create()
	{
		this.m.ID = "event.manhunters_origin_capture_prisoner";
		this.m.Title = "Po bitwie...";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "Nobles",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Ocalały mężczyzna odczołguje się od ciebie. Coś mamrocze. Nie słyszysz go, ale język jest czytelny: wie, kim jesteś i czym jesteś. | Po bitwie znajdujesz na polu jednego ocalałego. Jest trochę poturbowany, ale może się przydać. | %SPEECH_ON%Niewolnicze ścierwo, rób co chcesz.%SPEECH_OFF%Mimo że został ostatni na nogach, północniak wciąż ma w sobie trochę walki. Może się przydać w %companyname%. | Znajdujesz ostatniego stojącego, rannego, ale żywego. To północniak i dobrze wyglądałby w łańcuchach. Może da się go sprzedać za solidną cenę na południu, albo niech służy jako mięso armatnie na froncie? | Północny oddział został zredukowany do ostatniego, bladego człowieka, który nie zamierza długo znosić porażki.%SPEECH_ON%Południowe ścierwa, wasz \'Gilder\' może mi naskoczyć. Dawaj broń, pokażę wam, jak umiera północniak!%SPEECH_OFF%Nie możesz nie polubić jego zapału. Zamiast karmić robaki w grobie, może mógłby służyć kompanii jako jeden z dłużników?}",
			Image = "",
			List = [],
			Characters = [],
						Text = "Nie jest nam potrzebny.",
				{
					Text = "Weź go jako dłużnika Gildera, aby mógł zasłużyć na zbawienie.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.0, "Przegrał bitwę i został wzięty do niewoli");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "Nie jest nam potrzebny.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"slave_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "Dawniej żołnierz wierny szlacheckim panom, jego kompania została wybita przez twoich ludzi, a %name% został wzięty jako dłużnik. Nie trzeba było wiele, by złamać jego ducha i zmusić go do walki dla ciebie.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Civilians",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Ocalały mężczyzna odczołguje się od ciebie. Coś mamrocze. Nie słyszysz go, ale język jest czytelny: wie, kim jesteś i czym jesteś. | Po bitwie znajdujesz na polu jednego ocalałego. Jest trochę poturbowany, ale może się przydać.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Weź go jako dłużnika Gildera, aby mógł zasłużyć na zbawienie.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.0, "Przegrał bitwę i został wzięty do niewoli");
						_event.m.Dude.worsenMood(2.0, "Przegrał bitwę i został wzięty do niewoli");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "Nie jest nam potrzebny.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"slave_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "%name% został wzięty jako dłużnik po ledwie przeżytej bitwie z twoimi ludźmi. Złamano jego ducha i zmuszono go do walki dla ciebie, aby spłacił dług wobec Gildera.";
				_event.m.Dude.getBackground().m.RawDescription = "%name% został wzięty jako dłużnik po ledwie przeżytej bitwie z twoimi ludźmi. Złamano jego ducha i zmuszono go do walki dla ciebie, aby spłacił dług wobec Gildera.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Bandits",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Ocalały mężczyzna odczołguje się od ciebie. Coś mamrocze. Nie słyszysz go, ale język jest czytelny: wie, kim jesteś i czym jesteś. | Po bitwie znajdujesz na polu jednego ocalałego. Jest trochę poturbowany, ale może się przydać. | Jedyny ocalały bandyta woła do starych bogów, gdy ważysz łańcuch w dłoni, zastanawiając się, jak będzie pasował na jego szyję. | %SPEECH_ON%To kara za bandyctwo?%SPEECH_OFF%Pyta północniak, gdy ważysz łańcuch w dłoni. Wciąż nie wiesz, co z nim zrobisz, ale odpowiadasz.%SPEECH_ON%To wcale nie kara, to po prostu interes.%SPEECH_OFF% | Bandyta próbuje się ukryć, ale jako ostatni ocalały jest łatwy do wypatrzenia jak biały królik na krwawym polu bitwy. Krzyczy, że starzy bogowie nie zniosą ludzi takich jak ty. Wzruszasz ramionami.%SPEECH_ON%Starzy bogowie nie stoją tam, gdzie stoję ja, prawda?%SPEECH_OFF%I wyciągasz łańcuch, przymierzając go do jego szyi.%SPEECH_ON%Ciekawi mnie jednak, ile byś oddał, żeby zamienić się miejscem z jednym ze swoich bogów, hm?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Weź go jako dłużnika Gildera, aby mógł zasłużyć na zbawienie.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.0, "Przegrał bitwę i został wzięty do niewoli");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "Nie jest nam potrzebny.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"slave_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "%name% został wzięty jako dłużnik po ledwie przeżytej bitwie z twoimi ludźmi. Złamano jego ducha i zmuszono go do walki dla ciebie, aby spłacił dług wobec Gildera.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Nomads",
			Text = "[img]gfx/ui/events/event_172.png[/img]{Ocalały mężczyzna odczołguje się od ciebie. Coś mamrocze. Nie słyszysz go, ale język jest czytelny: wie, kim jesteś i czym jesteś. | Po bitwie znajdujesz na polu jednego ocalałego. Jest trochę poturbowany, ale może się przydać. | Wyciągasz łańcuch do nomady, z dystansu mierząc jego głowę wahadłem zamkniętej pętli.%SPEECH_ON%Czasem na piaskach człowiek spotyka tych, z którymi nie powinien zadzierać. Czasem odchodzi.%SPEECH_OFF%Mocno chwytasz łańcuch.%SPEECH_ON%Czasem tylko idzie dalej.%SPEECH_OFF% | Piasek przesuwa się i osuwa, gdy ranny nomada próbuje uciec. Łatwo dociskasz go butem i przytrzymujesz, a drugą ręką mierzysz jego szyję łańcuchem niewolnika. | Nomada modli się o przebaczenie.%SPEECH_ON%Rozdzielając nasze cienie, blask Gildera rozświetli nas obu!%SPEECH_OFF%Unosisz łańcuch i mówisz mu, że nie każdy cień rodzi się częścią nas.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Weź go jako dłużnika Gildera, aby mógł zasłużyć na zbawienie.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.0, "Przegrał bitwę i został wzięty do niewoli");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "Nie jest nam potrzebny.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"slave_southern_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "%name% został wzięty jako dłużnik po ledwie przeżytej bitwie z twoimi ludźmi. Złamano jego ducha i zmuszono go do walki dla ciebie, aby spłacił dług wobec Gildera.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "CityState",
			Text = "[img]gfx/ui/events/event_172.png[/img]{Ocalały mężczyzna odczołguje się od ciebie. Coś mamrocze. Nie słyszysz go, ale język jest czytelny: wie, kim jesteś i czym jesteś. | Po bitwie znajdujesz na polu jednego ocalałego. Jest trochę poturbowany, ale może się przydać. | %SPEECH_ON%Gilder by na to nie pozwolił.%SPEECH_OFF%To ostatni z południowego oddziału, ranny, żałosny człowiek błagający o życie. Podnosisz łańcuch.%SPEECH_ON%To, że to spadło na ciebie, nie znaczy, że twoja ścieżka jest zacieniona, wędrowcze. To znaczy tylko, że moja jest trochę jaśniejsza.%SPEECH_OFF% | %SPEECH_ON%Ach, proszę, nie!%SPEECH_OFF%Masz but na ostatnim z południowego oddziału i mierzysz go, by dołączył do dłużników. Błaga o życie, o wolność, a w końcu po prostu o śmierć na wolności. Kręcisz głową.%SPEECH_ON%Złoto nie może żyć ani umrzeć, wędrowcze, można je tylko ważyć. Ciężkie. Albo lekkie. Moje rozważania ciebie nie dotyczą. Błagasz o coś, co straciłeś w chwili, gdy spotkałeś mnie na drodze.%SPEECH_OFF% | Ostatni z południowego oddziału leży u twoich stóp. Modli się do Gildera, by rozświetlił jego ścieżkę. Niestety jedynym, który ma tu głos, jesteś ty, i masz miejsce w łańcuchach dla tego człowieka, jeśli zechcesz, by \'dołączył\' do %companyname%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Weź go jako dłużnika Gildera, aby mógł zasłużyć na zbawienie.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.0, "Przegrał bitwę i został wzięty do niewoli");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "Nie jest nam potrzebny.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"slave_southern_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "%name% został wzięty jako dłużnik po ledwie przeżytej bitwie z twoimi ludźmi. Złamano jego ducha i zmuszono go do walki dla ciebie, aby spłacił dług wobec Gildera.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Barbarians",
			Text = "[img]gfx/ui/events/event_145.png[/img]{Ocalały mężczyzna odczołguje się od ciebie. Coś mamrocze. Nie słyszysz go, ale język jest czytelny: wie, kim jesteś i czym jesteś. | Po bitwie znajdujesz na polu jednego ocalałego. Jest trochę poturbowany, ale może się przydać. | Ach, ostatni ocalały. To wielki człowiek, barbarzyńca, i może się tobie przydać. W łańcuchach, oczywiście. | %companyname% rzadko trafia na taką zwierzynę jak północni barbarzyńcy. Z jednym ocalałym na polu zastanawiasz się, czy wzięcie go jako dłużnika będzie dla ciebie korzystne. | Ostatni stojący barbarzyńca. Mówi do ciebie w języku, którego nigdy nie miałbyś czasu się nauczyć. Pomruki, warknięcia, rzeczy, które inne języki uznałyby za groźby, ale tutaj wiesz, że artykułuje coś ważnego. Lecz wszystko, czym możesz odpowiedzieć, to łańcuch, a ten barbarzyńca może okazać się bardzo dobrym dłużnikiem dla %companyname%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Weź go jako dłużnika Gildera, aby mógł zasłużyć na zbawienie.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.0, "Przegrał bitwę i został wzięty do niewoli");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "Nie jest nam potrzebny.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"slave_barbarian_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "%name% został wzięty jako dłużnik po ledwie przeżytej bitwie z twoimi ludźmi. Złamano jego ducha i zmuszono go do walki dla ciebie, aby spłacił dług wobec Gildera.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function isValid()
	{
		if (!this.Const.DLC.Desert)
		{
			return false;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.manhunters")
		{
			return;
		}

		if (this.World.Statistics.getFlags().getAsInt("LastCombatID") <= this.m.LastCombatID)
		{
			return;
		}

		if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() > 5.0 || this.World.Statistics.getFlags().getAsInt("LastCombatResult") != 1)
		{
			return false;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return false;
		}

		local f = this.World.FactionManager.getFaction(this.World.Statistics.getFlags().getAsInt("LastCombatFaction"));

		if (f == null)
		{
			return false;
		}

		if (f.getType() != this.Const.FactionType.NobleHouse && f.getType() != this.Const.FactionType.Settlement && f.getType() != this.Const.FactionType.Bandits && f.getType() != this.Const.FactionType.Barbarians && f.getType() != this.Const.FactionType.OrientalCityState && f.getType() != this.Const.FactionType.OrientalBandits)
		{
			return false;
		}

		this.m.LastCombatID = this.World.Statistics.getFlags().get("LastCombatID");
		return true;
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		local f = this.World.FactionManager.getFaction(this.World.Statistics.getFlags().getAsInt("LastCombatFaction"));

		if (f.getType() == this.Const.FactionType.NobleHouse)
		{
			return "Nobles";
		}
		else if (f.getType() == this.Const.FactionType.Settlement)
		{
			return "Civilians";
		}
		else if (f.getType() == this.Const.FactionType.Bandits)
		{
			return "Bandits";
		}
		else if (f.getType() == this.Const.FactionType.Barbarians)
		{
			return "Barbarians";
		}
		else if (f.getType() == this.Const.FactionType.OrientalCityState)
		{
			return "CityState";
		}
		else if (f.getType() == this.Const.FactionType.OrientalBandits)
		{
			return "Nomads";
		}
		else
		{
			return "Civilians";
		}
	}

	function onClear()
	{
		this.m.Dude = null;
	}

	function onSerialize( _out )
	{
		this.event.onSerialize(_out);
		_out.writeU32(this.m.LastCombatID);
	}

	function onDeserialize( _in )
	{
		this.event.onDeserialize(_in);

		if (_in.getMetaData().getVersion() >= 54)
		{
			this.m.LastCombatID = _in.readU32();
		}
	}

});

