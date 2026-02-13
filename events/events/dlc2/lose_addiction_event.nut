this.lose_addiction_event <- this.inherit("scripts/events/event", {
	m = {
		Addict = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.lose_addiction";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{%addict% wchodzi do twojego namiotu z rękami za plecami w pełnej szacunku postawie. Pyta, czy masz chwilę. Kiwasz głową, a on stwierdza, że pozbył się drżeń i dolegliwości. Pytasz, co ma na myśli. Przekręca dłoń nad ustami, jakby brał łyk.%SPEECH_ON%Mikstury, panie, już nie czuję do nich tak przytłaczającej skłonności. Jestem w porządku. Zdrowy. Całkiem zdrowy. Gotów walczyć jako ten człowiek, którym jestem.%SPEECH_OFF%Nie jesteś do końca pewien, do czego zmierza. Myślałeś, że większość ludzi ciągnie do alkoholu, ale to ci nie przeszkadza. Cokolwiek to było, wygląda na to, że to przezwyciężył. | Znajdujesz %addict%a siedzącego na ziemi i wpatrującego się w swoje dłonie. Śledzi rowki palcem.%SPEECH_ON%Słyszę cię, panie.%SPEECH_OFF%Kiwasz głową i pytasz, co robi. Uśmiecha się.%SPEECH_ON%Czuję się lepiej. Czuję, że nie muszę już rozluźniać się tymi miksturami. Czuję siebie, chyba. Gotów zabijać, jak rozkażesz, panie, i robić to z jasnością umysłu, wiedząc, co robię i dlaczego.%SPEECH_OFF%Świetnie. Nie jesteś pewien, o co dokładnie chodziło, ale życzysz mu powodzenia, by tak zostało.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobra robota, że jesteś sobą.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Addict.getImagePath());
				local trait = _event.m.Addict.getSkills().getSkillByID("trait.addict");
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.Addict.getName() + " nie jest już uzależniony"
				});
				_event.m.Addict.getSkills().remove(trait);
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_addict = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getFlags().get("PotionLastUsed") >= 14.0 * this.World.getTime().SecondsPerDay && bro.getSkills().hasSkill("trait.addict"))
			{
				candidates_addict.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_addict.len() == 0 || candidates_other.len() == 0)
		{
			return;
		}

		this.m.Addict = candidates_addict[this.Math.rand(0, candidates_addict.len() - 1)];
		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Score = 5 + candidates_addict.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"addict",
			this.m.Addict.getName()
		]);
		_vars.push([
			"other",
			this.m.Other.getName()
		]);
	}

	function onClear()
	{
		this.m.Addict = null;
		this.m.Other = null;
	}

});

