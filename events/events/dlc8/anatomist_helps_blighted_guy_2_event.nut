this.anatomist_helps_blighted_guy_2_event <- this.inherit("scripts/events/event", {
	m = {
		MilitiaCaptain = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_helps_blighted_guy_2";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_58.png[/img]{Rzekomo chory mężczyzna, którego anatomowie wyrwali dosłownie z grobu, podchodzi do przodu. Wygląda lepiej niż kiedykolwiek. Dziękuje anatomom za ich pracę, choć ci ledwie zwracają na niego uwagę. Wydaje się, że był dla nich ciekawszy, gdy był chory, mogli go badać i uczyć się z tego, co go trapiło, a po cichu liczyli, że jednak umrze, by mogli dowiedzieć się jeszcze więcej. Widząc to, mężczyzna zwraca się do ciebie.%SPEECH_ON%Wiele to dla mnie znaczy, mam nadzieję, że przynajmniej o tym wiesz. Nie wiesz, jakie piekło przeżyłem z tamtymi, którzy chcieli mnie pogrzebać żywcem. Myślę, że wiedzieli, iż nie jestem skażony, po prostu chcieli mojej własności. Wiesz, kiedyś dowodziłem lokalną milicją, ale ta funkcja niesie ze sobą ciężar spisków i zazdrości.%SPEECH_OFF%Pociera tył głowy, po czym mówi wprost.%SPEECH_ON%Nie mam już nic, bo ci grabarze wszystko zabrali, więc bez względu na to, czy żyję, czy nie, i tak mogę być martwy. Tak więc powiem po prostu, że cieszę się, że mogę dla ciebie walczyć i ułożyć sobie tu nowe życie.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cieszę się, że czujesz się lepiej, %militiacaptain%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.MilitiaCaptain.getImagePath());
				local bg = this.new("scripts/skills/backgrounds/militia_background");
				bg.m.IsNew = false;
				_event.m.MilitiaCaptain.getSkills().removeByID("background.vagabond");
				_event.m.MilitiaCaptain.getSkills().add(bg);
				_event.m.MilitiaCaptain.getBackground().m.RawDescription = "Znalazłeś %name% grzebanego żywcem za rzekome noszenie nieznanej zarazy. Anatomowie zainteresowali się nim i uratowali go, przywracając do zdrowia. Teraz walczy dla ciebie, wykorzystując umiejętności, które w poprzednim życiu uczyniły go kapitanem straży.";
				_event.m.MilitiaCaptain.getBackground().buildDescription(true);
				_event.m.MilitiaCaptain.improveMood(1.0, "Wyzdrowiał z zarazy, która go dręczyła");

				if (_event.m.MilitiaCaptain.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.MilitiaCaptain.getMoodState()],
						text = _event.m.MilitiaCaptain.getName() + this.Const.MoodStateEvent[_event.m.MilitiaCaptain.getMoodState()]
					});
				}

				_event.m.MilitiaCaptain.getBaseProperties().MeleeDefense += 4;
				_event.m.MilitiaCaptain.getBaseProperties().RangedDefense += 4;
				_event.m.MilitiaCaptain.getBaseProperties().MeleeSkill += 8;
				_event.m.MilitiaCaptain.getBaseProperties().RangedSkill += 7;
				_event.m.MilitiaCaptain.getBaseProperties().Stamina += 3;
				_event.m.MilitiaCaptain.getBaseProperties().Initiative += 6;
				_event.m.MilitiaCaptain.getBaseProperties().Bravery += 12;
				_event.m.MilitiaCaptain.getBaseProperties().Hitpoints += 5;
				_event.m.MilitiaCaptain.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_defense.png",
					text = _event.m.MilitiaCaptain.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+4[/color] obrony w walce wręcz"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/ranged_defense.png",
					text = _event.m.MilitiaCaptain.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+4[/color] obrony dystansowej"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.MilitiaCaptain.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+8[/color] umiejętności walki wręcz"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/ranged_skill.png",
					text = _event.m.MilitiaCaptain.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+7[/color] umiejętności dystansowych"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/fatigue.png",
					text = _event.m.MilitiaCaptain.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+3[/color] maksymalnego zmęczenia"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.MilitiaCaptain.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+6[/color] inicjatywy"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.MilitiaCaptain.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+12[/color] determinacji"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/health.png",
					text = _event.m.MilitiaCaptain.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+5[/color] punktów zdrowia"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidate;

		foreach( bro in brothers )
		{
			if (!bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury) && !bro.getSkills().hasSkillOfType(this.Const.SkillType.SemiInjury) && bro.getDaysWithCompany() >= 5 && bro.getFlags().get("IsMilitiaCaptain"))
			{
				candidate = bro;
				break;
			}
		}

		if (candidate == null)
		{
			return;
		}

		this.m.MilitiaCaptain = candidate;
		this.m.Score = 20;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"militiacaptain",
			this.m.MilitiaCaptain.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.MilitiaCaptain = null;
	}

});

