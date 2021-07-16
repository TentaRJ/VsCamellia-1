package;

import flixel.input.gamepad.FlxGamepad;
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.tweens.FlxEase;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

import TitleState._camsave;

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	public static var firstStart:Bool = true;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.5.4" + nightly;
	public static var gameVer:String = "0.2.7.1";

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	public static var finishedFunnyMove:Bool = false;

	// public var boyfriend:Boyfriend;
	// public var gf:Character;
	// public var dad:Character;
	public var funny:FlxSprite;
	public var funnyText:FlxText;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.set(0, 0);
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		// add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		camFollow.setPosition(658, -220);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		bg.scrollFactor.set(0, 0);
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		// add(magenta);
		// magenta.scrollFactor.set();

		var bgCity:FlxSprite = new FlxSprite(-316,-829).loadGraphic(Paths.image('BG_CITY', 'camelliaweek'));
		// bgCity.scrollFactor.set(0.0357, 0);
		// bgCity.scale.set(1.55, 1.55);
		bgCity.antialiasing = true;
		bgCity.active = false;
		bgCity.setGraphicSize(Std.int(bg.width * 1.1));
		add(bgCity);

		var logoBl = new FlxSprite(485, -630);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		// logoBl.scrollFactor.set(0.1, 0);
		logoBl.setGraphicSize(Std.int(logoBl.width * 0.78));
		logoBl.updateHitbox();
		logoBl.screenCenter(X);
		add(logoBl);

		funny = new FlxSprite(0,900).loadGraphic(Paths.image('death', 'camelliaweek'));
		funny.setGraphicSize(Std.int(funny.width * 9));
		funny.screenCenter(X);
		funny.antialiasing=true;
		add(funny);

		FlxG.watch.addQuick("logo", logoBl.getPosition());
		FlxG.watch.addQuick("funny", funny.getPosition());

		var wall:FlxSprite = new FlxSprite(-316, -829).loadGraphic(Paths.image('BG_WALL', 'camelliaweek'));
		// wall.scrollFactor.set(0.05, 0);
		// wall.scale.set(1.55, 1.55);
		wall.antialiasing = true;
		wall.active = false;
		wall.screenCenter(X);
		wall.setGraphicSize(Std.int(wall.width * 0.9));
		add(wall);

		var stage:FlxSprite = new FlxSprite(-316,-829).loadGraphic(Paths.image('FG_Floor', 'camelliaweek'));
		// stage.scrollFactor.set(0.05, 0);
		// stage.scale.set(1.55, 1.55);
		stage.antialiasing = true;
		stage.active = false;
		stage.setGraphicSize(Std.int(stage.width * 0.9));
		add(stage);

		funnyText = new FlxText(0, -120, 0, "Only a little bit!", 64);
		funnyText.screenCenter(X);
		funnyText.visible = false;
		add(funnyText);

		//GF x y 400 130
		//BF x y 1120 525
		//Dad x y -400 91

		// boyfriend = new Boyfriend(1120, 525, "bf");
		// gf = new Character(400, 130, "gf");
		// dad = new Character(100, 100, "camellia");

		// add(gf);
		// add(boyfriend);
		// add(dad);

		// dad.playAnim('idle');
		// gf.dance();
		// boyfriend.playAnim('idle');

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		new FlxTimer().start(2, function(tmr:FlxTimer){if(FlxG.random.bool(10)){FlxTween.tween(funny, {y:-200}, 2.4, {ease:FlxEase.expoInOut});trace("we do a little trolling");funnyText.visible=true;}else{trace("You were spared... for now...");}});

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 0);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set(0, 1);
			menuItem.antialiasing = true;
			if(i == 0){menuItem.setGraphicSize(Std.int(menuItem.width * 0.77));}
			else{menuItem.setGraphicSize(Std.int(menuItem.width * 0.68));}
			// menuItem.setGraphicSize(Std.int(menuItem.width * 0.75));
			// if (firstStart)
			// 	FlxTween.tween(menuItem,{x : -425 + (i*500), y:0},1 + (i * 0.25) ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
			// 		{ 
			// 			finishedFunnyMove = true; 
			// 			changeItem();
			// 		}});
			// else
			// {
			// }
			menuItem.x = 4 + (i * 450);
			menuItem.y = 0;
			finishedFunnyMove = true; 			
			trace(menuItem.getPosition());
			// menuPlace(menuItem);
		}
		changeItem();

		firstStart = false;

		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FNF - " + kadeEngineVer + " Kade Engine" : ""), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	function menuPlace(option:FlxSprite)
	{
		switch (option.ID)
		{
			case 0:
			{
				option.setPosition(20, 0);
				option.setGraphicSize(Std.int(option.width * 0.5));
			}
			case 1:
			{
				option.setPosition(445, 0);
				option.setGraphicSize(Std.int(option.width * 0.5));
			}
			case 2:
			{
				option.setPosition(870, 0);
				option.setGraphicSize(Std.int(option.width * 0.5));
			}
		}
		trace("id " + option.ID + " pos " + option.getPosition() + " size " + option.width);
	}

	override function update(elapsed:Float)
	{
		#if debug
		if(FlxG.keys.justPressed.T){trace("Hi Tenta!");trace(_camsave.data);}
		#end

		// if(FlxG.keys.justPressed.SIX){FlxG.switchState(new AnimationDebug("camellia"));}

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

			if (gamepad != null)
			{
				if (gamepad.justPressed.DPAD_UP)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(-1);
				}
				if (gamepad.justPressed.DPAD_DOWN)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(1);
				}
			}

			if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.LEFT)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.RIGHT)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			// Crashes lmao
			// if (controls.BACK)
			// {
			// 	FlxG.switchState(new TitleState());
			// }

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					fancyOpenURL("https://ninja-muffin24.itch.io/funkin");
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					
					// if (FlxG.save.data.flashing)
					// 	FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {y:300, alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
							// gf.playAnim('cheer');
							// boyfriend.playAnim('hey');
						}
						else
						{
							if (FlxG.save.data.flashing)
							{
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									goToState();
								});
							}
							else
							{
								new FlxTimer().start(1, function(tmr:FlxTimer)
								{
									goToState();
								});
							}
						}
					});
				}
			}
		}

		super.update(elapsed);

		// menuItems.forEach(function(spr:FlxSprite)
		// {
		// 	spr.screenCenter(X);
		// });
	}
	
	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		// FlxTween.tween(camFollow, {})

		switch (daChoice)
		{
			case 'story mode':
				FlxG.switchState(new StoryMenuState());
				trace("Story Menu Selected");
			case 'freeplay':
				FlxG.switchState(new FreeplayState());

				trace("Freeplay Menu Selected");

			case 'options':
				FlxG.switchState(new OptionsMenu());
		}
	}

	function changeItem(huh:Int = 0)
	{
		if (finishedFunnyMove)
		{
			curSelected += huh;

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
		}
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected && finishedFunnyMove)
			{
				spr.animation.play('selected');
				// camFollow.setPosition(spr.getGraphicMidpoint().x + 210, spr.getGraphicMidpoint().y - 310);
				// trace(camFollow.getPosition().x + "" + camFollow.getPosition().y);
			}

			spr.updateHitbox();
		});
	}
}
