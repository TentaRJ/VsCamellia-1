package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GF_assets','shared');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');
			case 'camellia':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/camellia');
				frames = tex;
				animation.addByPrefix('idle', 'Camellia_Idle', 24);
				if(!isPlayer)
				{
				animation.addByPrefix('singUP', 'Camellia_Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Camellia_Right', 24, false);
				animation.addByPrefix('singDOWN', 'Camellia_Down', 24, false);
				animation.addByPrefix('singLEFT', 'Camellia_Left', 24, false);
				}
				else
				{
				animation.addByPrefix('singUP', 'Camellia_Up', 24, false);
				animation.addByPrefix('singLEFT', 'Camellia_Right', 24, false);
				animation.addByPrefix('singDOWN', 'Camellia_Down', 24, false);
				animation.addByPrefix('singRIGHT', 'Camellia_Left', 24, false);
				animation.addByPrefix('singUPmiss', 'Camellia_Up', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Camellia_Right', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Camellia_Down', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Camellia_Left', 24, false);
				}

				addOffset('idle');

				if(!isPlayer)
				{
				addOffset("singUP", 4, 75);
				addOffset("singRIGHT", 0, -3);
				addOffset("singLEFT", 80, 16);
				addOffset("singDOWN", 0, 78);
				addOffset("singUPmiss", 4, 75);
				addOffset("singRIGHTmiss", 0, -3);
				addOffset("singLEFTmiss", 80, 16);
				addOffset("singDOWNmiss", 0, 78);
				}
				else
				{
				addOffset("singUP", 0, 86);
				addOffset("singRIGHT", -3, -3);
				addOffset("singLEFT", 0, 18);
				addOffset("singDOWN", 0, 83);
				addOffset("singUPmiss", 0, 86);
				addOffset("singRIGHTmiss", -3, -3);
				addOffset("singLEFTmiss", 0, 18);
				addOffset("singDOWNmiss", 0, 93);
				}
				
				playAnim('idle');
			case 'cam-dead':
				tex = Paths.getSparrowAtlas('characters/camellia');
				frames=tex;
				animation.addByPrefix('firstDeath', "Camellia_Right", 24, false);
				animation.addByPrefix('deathLoop', "Camellia_Idle", 24, true);
				animation.addByPrefix('deathConfirm', "Cammellia_Up", 24, false);
				animation.play('firstDeath');

				addOffset('firstDeath');
				addOffset('deathLoop', -37);
				addOffset('deathConfirm', -37);

				playAnim('firstDeath');

			case 'bf':
				var tex = Paths.getSparrowAtlas('characters/BOYFRIEND','shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'BF idle dance', 24, true);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;
		}

		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}


	
	override function update(elapsed:Float)
	{
		if (!isPlayer)
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 8;
			switch (curCharacter)
			{
				case "dad":{dadVar = 6.1;}
				case "camellia":{dadVar = 10.8;}
			}

			var daHoldLimit:Float = Conductor.stepCrochet * dadVar * 0.001;

			FlxG.watch.addQuick("holdShit", holdTimer * 100);
			FlxG.watch.addQuick("holdLimit", daHoldLimit * 100);

			//stepCrotchet 150

			if (holdTimer >= daHoldLimit)
			{
				trace('dance');
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				case 'gf':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');

				default:
					playAnim('idle');
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}

	public function loadOffsetFile(character:String)
		{
			var offset:Array<String> = CoolUtil.coolTextFile(Paths.offset('images/characters/' + character + "Offsets", "shared"));
	
			for (i in 0...offset.length)
			{
				var data:Array<String> = offset[i].split(' ');
				addOffset(data[0], Std.parseInt(data[1]), Std.parseInt(data[2]));
			}
		}
}
