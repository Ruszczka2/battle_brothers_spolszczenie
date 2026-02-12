this.mood_check <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "special.mood_check";
		this.m.Name = "Próba Nastroju";
		this.m.Icon = "skills/status_effect_02.png";
		this.m.IconMini = "";
		this.m.Type = this.Const.SkillType.Special | this.Const.SkillType.Trait;
		this.m.Order = this.Const.SkillOrder.Trait + 600;
		this.m.IsActive = false;
		this.m.IsHidden = false;
		this.m.IsSerialized = false;
		this.m.IsStacking = true;
	}

	function getTooltip()
	{
		local ret;

		switch(this.getContainer().getActor().getMoodState())
		{
		case this.Const.MoodState.Neutral:
			ret = [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = "Ta postać jest zadowolona z tego, jak sprawy się mają. Mogłoby być lepiej, mogłoby być gorzej.\n\nNastrój zawsze z czasem będzie dążył do tego stanu."
				}
			];
			break;

		case this.Const.MoodState.Concerned:
			ret = [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = "Nie jest to coś niezwykłego dla żyjących w trudach i znoju najemniczego życia, więc nikogo nie dziwi, że ta postać jest niezbyt zadowolona i liczy na to, że sytuacja niedługo się poprawi."
				},
				{
					id = 11,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Może mieć tylko [color=" + this.Const.UI.Color.NegativeValue + "]stabilne[/color] morale lub gorsze"
				}
			];
			break;

		case this.Const.MoodState.Disgruntled:
			ret = [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = "Ostatnie wydarzenia sprawiły, że ta postać niezadowolona i zawiedziona tym, jak sprawy się toczą. To może minąć, lub się pogorszyć, zależnie od przyszłych sytuacji."
				},
				{
					id = 11,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Może mieć tylko [color=" + this.Const.UI.Color.NegativeValue + "]wahające się[/color] morale lub gorsze"
				}
			];
			break;

		case this.Const.MoodState.Angry:
			ret = [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = "Ostatnie wydarzenia sprawiły, że ta postać jest wściekła i mściwa wobec otaczających ją osób. Jeśli sytuacja szybko się nie poprawi, to ta postać może zdezerterować z kompanii!"
				},
				{
					id = 11,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Może mieć tylko [color=" + this.Const.UI.Color.NegativeValue + "]łamiące się[/color] morale lub gorsze"
				}
			];
			break;

		case this.Const.MoodState.InGoodSpirit:
			ret = [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = "Ostatnie wydarzenia sprawiły, że ta postać jest w dobrym nastroju. To zapewne minie, gdy rzeczywistość znów da o sobie znać, jednak na razie sprawy wyglądają dobrze."
				},
				{
					id = 11,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Ma [color=" + this.Const.UI.Color.PositiveValue + "]25%[/color] szansy, by rozpocząć bitwę z wysokim morale"
				}
			];
			break;

		case this.Const.MoodState.Eager:
			ret = [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = "Ostatnie wydarzenia sprawiły, że ta postać nie może się doczekać walki w szeregach kompanii, jest zadowolona z tego jak sprawy się toczą i motywuje ludzi wokół niej."
				},
				{
					id = 11,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Ma [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] szansy, by rozpocząć bitwę z wysokim morale"
				}
			];
			break;

		case this.Const.MoodState.Euphoric:
			ret = [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = "Ostatnie wydarzenia sprawiły, że ta postać jest w stanie euforii, z radością służy w kompanii i jest pewna zwycięstwa nad każdym napotkanym wrogiem. To prawie irytujące, poważnie."
				},
				{
					id = 11,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Ma [color=" + this.Const.UI.Color.PositiveValue + "]75%[/color] szansy, by rozpocząć bitwę z wysokim morale"
				}
			];
			break;
		}

		local changes = this.getContainer().getActor().getMoodChanges();

		foreach( change in changes )
		{
			if (change.Positive)
			{
				ret.push({
					id = 11,
					type = "hint",
					icon = "ui/tooltips/positive.png",
					text = "" + change.Text + ""
				});
			}
			else
			{
				ret.push({
					id = 11,
					type = "hint",
					icon = "ui/tooltips/negative.png",
					text = "" + change.Text + ""
				});
			}
		}

		return ret;
	}

	function onCombatStarted()
	{
		local actor = this.getContainer().getActor();
		local mood = actor.getMoodState();
		local morale = actor.getMoraleState();
		local isDastard = this.getContainer().hasSkill("trait.dastard");

		switch(mood)
		{
		case this.Const.MoodState.Concerned:
			actor.setMaxMoraleState(this.Const.MoraleState.Steady);
			actor.setMoraleState(this.Const.MoraleState.Steady);
			break;

		case this.Const.MoodState.Disgruntled:
			actor.setMaxMoraleState(this.Const.MoraleState.Wavering);
			actor.setMoraleState(this.Const.MoraleState.Wavering);
			break;

		case this.Const.MoodState.Angry:
			actor.setMaxMoraleState(this.Const.MoraleState.Breaking);
			actor.setMoraleState(this.Const.MoraleState.Breaking);
			break;

		case this.Const.MoodState.Neutral:
			actor.setMaxMoraleState(this.Const.MoraleState.Confident);
			break;

		case this.Const.MoodState.InGoodSpirit:
			actor.setMaxMoraleState(this.Const.MoraleState.Confident);

			if (morale < this.Const.MoraleState.Confident && this.Math.rand(1, 100) <= 25 && !isDastard)
			{
				actor.setMoraleState(this.Const.MoraleState.Confident);
			}

			break;

		case this.Const.MoodState.Eager:
			actor.setMaxMoraleState(this.Const.MoraleState.Confident);

			if (morale < this.Const.MoraleState.Confident && this.Math.rand(1, 100) <= 50 && !isDastard)
			{
				actor.setMoraleState(this.Const.MoraleState.Confident);
			}

			break;

		case this.Const.MoodState.Euphoric:
			actor.setMaxMoraleState(this.Const.MoraleState.Confident);

			if (morale < this.Const.MoraleState.Confident && this.Math.rand(1, 100) <= 75 && !isDastard)
			{
				actor.setMoraleState(this.Const.MoraleState.Confident);
			}

			break;
		}
	}

	function onUpdate( _properties )
	{
		local mood = this.getContainer().getActor().getMoodState();
		local p = this.Math.round(this.getContainer().getActor().getMood() / (this.Const.MoodState.len() - 0.05) * 100.0);
		this.m.Name = this.Const.MoodStateName[mood] + " (" + p + "%)";

		switch(mood)
		{
		case this.Const.MoodState.Neutral:
			this.m.Icon = "skills/status_effect_64.png";
			break;

		case this.Const.MoodState.Concerned:
			this.m.Icon = "skills/status_effect_46.png";
			break;

		case this.Const.MoodState.Disgruntled:
			this.m.Icon = "skills/status_effect_45.png";
			break;

		case this.Const.MoodState.Angry:
			this.m.Icon = "skills/status_effect_44.png";
			break;

		case this.Const.MoodState.InGoodSpirit:
			this.m.Icon = "skills/status_effect_47.png";
			break;

		case this.Const.MoodState.Eager:
			this.m.Icon = "skills/status_effect_48.png";
			break;

		case this.Const.MoodState.Euphoric:
			this.m.Icon = "skills/status_effect_49.png";
			break;
		}
	}

});

