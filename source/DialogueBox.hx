package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	var portraitA:FlxSprite;
	var portraitB:FlxSprite;
	var portraitC:FlxSprite;
	var portraitD:FlxSprite;
	var portraitE:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'take-back':
				FlxG.sound.playMusic(Paths.music('ThwokOne'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'rocket':
				FlxG.sound.playMusic(Paths.music('ThwokTwo'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'hope-seeker':
				FlxG.sound.playMusic(Paths.music('ThwokThree'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);

			case 'take-back':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal', [4], "", 24);
				box.y = 400;
				box.x = 0;
			
			case 'rocket':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal', [4], "", 24);
				box.y = 400;
				box.x = 0;
				
			case 'hope-seeker':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal', [4], "", 24);
				box.y = 400;
				box.x = 0;
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		if (PlayState.SONG.song.toLowerCase()=='senpai' || PlayState.SONG.song.toLowerCase()=='roses' || PlayState.SONG.song.toLowerCase()=='thorns')
		{
		portraitLeft = new FlxSprite(-20, 40);
		portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
		portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(0, 40);
		portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
		portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;

		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		portraitLeft.screenCenter(X);
		}

		if (PlayState.SONG.song.toLowerCase()=='take-back' || PlayState.SONG.song.toLowerCase()=='rocket' || PlayState.SONG.song.toLowerCase()=='hope-seeker')
		{
		portraitLeft = new FlxSprite(-100, 0);
		portraitLeft.frames = Paths.getSparrowAtlas('rockconcert/expressions/punkneutral');
		portraitLeft.animation.addByPrefix('enter', 'Punk Girl Portrait', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.3));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitA = new FlxSprite(-100, 0);
		portraitA.frames = Paths.getSparrowAtlas('rockconcert/expressions/punkupset');
		portraitA.animation.addByPrefix('enter', 'Punk Girl Portrait', 24, false);
		portraitA.setGraphicSize(Std.int(portraitA.width * PlayState.daPixelZoom * 0.3));
		portraitA.updateHitbox();
		portraitA.scrollFactor.set();
		add(portraitA);
		portraitA.visible = false;

		portraitB = new FlxSprite(-100, 0);
		portraitB.frames = Paths.getSparrowAtlas('rockconcert/expressions/punkangry');
		portraitB.animation.addByPrefix('enter', 'Punk Girl Portrait', 24, false);
		portraitB.setGraphicSize(Std.int(portraitB.width * PlayState.daPixelZoom * 0.3));
		portraitB.updateHitbox();
		portraitB.scrollFactor.set();
		add(portraitB);
		portraitB.visible = false;

		portraitC = new FlxSprite(-100, 0);
		portraitC.frames = Paths.getSparrowAtlas('rockconcert/expressions/punkclosed');
		portraitC.animation.addByPrefix('enter', 'Punk Girl Portrait', 24, false);
		portraitC.setGraphicSize(Std.int(portraitC.width * PlayState.daPixelZoom * 0.3));
		portraitC.updateHitbox();
		portraitC.scrollFactor.set();
		add(portraitC);
		portraitC.visible = false;

		portraitD = new FlxSprite(-100, 0);
		portraitD.frames = Paths.getSparrowAtlas('rockconcert/expressions/punkshocked');
		portraitD.animation.addByPrefix('enter', 'Punk Girl Portrait', 24, false);
		portraitD.setGraphicSize(Std.int(portraitD.width * PlayState.daPixelZoom * 0.3));
		portraitD.updateHitbox();
		portraitD.scrollFactor.set();
		add(portraitD);
		portraitD.visible = false;

		portraitE = new FlxSprite(-100, 0);
		portraitE.frames = Paths.getSparrowAtlas('rockconcert/expressions/punkwhatever');
		portraitE.animation.addByPrefix('enter', 'Punk Girl Portrait', 24, false);
		portraitE.setGraphicSize(Std.int(portraitE.width * PlayState.daPixelZoom * 0.3));
		portraitE.updateHitbox();
		portraitE.scrollFactor.set();
		add(portraitE);
		portraitE.visible = false;

		portraitRight = new FlxSprite(650, 0);
		portraitRight.frames = Paths.getSparrowAtlas('rockconcert/boyfriendPort');
		portraitRight.animation.addByPrefix('enter', 'BF Portrait Enter instance', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.3));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;

		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.2));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		}

		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
				{
			case 'dad':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
				}
					portraitLeft.animation.play('enter',true);
			case 'punkneutral':
				portraitRight.visible = false;
				portraitB.visible = false;
				portraitC.visible = false;
				portraitD.visible = false;
				portraitE.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
				}
					portraitLeft.animation.play('enter',true);
			case 'punkupset':
				portraitRight.visible = false;
				portraitB.visible = false;
				portraitC.visible = false;
				portraitD.visible = false;
				portraitE.visible = false;
				if (!portraitA.visible)
				{
					portraitA.visible = true;
				}
					portraitA.animation.play('enter',true);
			case 'punkangry':
				portraitRight.visible = false;
				portraitA.visible = false;
				portraitC.visible = false;
				portraitD.visible = false;
				portraitE.visible = false;
				if (!portraitB.visible)
				{
					portraitB.visible = true;
				}
					portraitB.animation.play('enter',true);
			case 'punkclosed':
				portraitRight.visible = false;
				portraitA.visible = false;
				portraitB.visible = false;
				portraitD.visible = false;
				portraitE.visible = false;
				if (!portraitC.visible)
				{
					portraitC.visible = true;
				}
					portraitC.animation.play('enter',true);
			case 'punkshocked':
				portraitRight.visible = false;
				portraitA.visible = false;
				portraitB.visible = false;
				portraitC.visible = false;
				portraitE.visible = false;
				if (!portraitD.visible)
				{
					portraitD.visible = true;
				}
					portraitD.animation.play('enter',true);
			case 'punkwhatever':
				portraitRight.visible = false;
				portraitA.visible = false;
				portraitB.visible = false;
				portraitC.visible = false;
				portraitD.visible = false;
				if (!portraitE.visible)
				{
					portraitE.visible = true;
				}
					portraitE.animation.play('enter',true);
			case 'bf':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
				}
					portraitRight.animation.play('enter',true);
			case 'bfpunk':
				portraitLeft.visible = false;
				portraitA.visible = false;
				portraitB.visible = false;
				portraitC.visible = false;
				portraitD.visible = false;
				portraitE.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
				}
					portraitRight.animation.play('enter',true);
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
