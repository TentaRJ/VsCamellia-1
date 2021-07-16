package;

import flixel.addons.effects.FlxSkewedSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end
import PlayState;

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;
	public var baseStrum:Float = 0;
	
	public var rStrumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var rawNoteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;
	public var modifiedByLua:Bool = false;
	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;
	public var originColor:Int = 0; // The sustain note's original note's color
	public var noteSection:Int = 0;

	public var noteScore:Float = 1;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	public var rating:String = "shit";

	public var modAngle:Float = 0; // The angle set by modcharts
	public var localAngle:Float = 0; // The angle to be edited inside Note.hx

	public var dataColor:Array<String> = ['purple', 'blue', 'green', 'red'];
	public var quantityColor:Array<Int> = [RED_NOTE, 2, BLUE_NOTE, 2, PURP_NOTE, 2, BLUE_NOTE, 2];
	public var arrowAngles:Array<Int> = [180, 90, 270, 0];

	public var isParent:Bool = false;
	public var parent:Note = null;
	public var death:Bool;
	public var spotInLine:Int = 0;
	public var sustainActive:Bool = true;

	public var children:Array<Note> = [];

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?inCharter:Bool = false, ?death:Bool = false)
	{
		super();

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;

		if (inCharter)
		{
			this.strumTime = strumTime;
			rStrumTime = strumTime;
		}
		else
		{
			this.strumTime = Math.round(strumTime);
			rStrumTime = strumTime - (FlxG.save.data.offset + PlayState.songOffset);
		}


		this.death = death;

		if (this.strumTime < 0 )
			this.strumTime = 0;

		if(isSustainNote && prevNote.death) { 
			death = true;
		}


		this.noteData = noteData;

		var daStage:String = PlayState.curStage;

		//defaults if no noteStyle was found in chart
		var noteTypeCheck:String = 'normal';
		if (PlayState.curStage.startsWith('school'))
			noteTypeCheck = 'pixel';
		if(!death)
			{
		if (inCharter)
		{
			frames = Paths.getSparrowAtlas('NOTE_assets');

			for (i in 0...4)
			{
				animation.addByPrefix(dataColor[i] + 'Scroll', dataColor[i] + ' alone'); // Normal notes
				animation.addByPrefix(dataColor[i] + 'hold', dataColor[i] + ' hold'); // Hold
				animation.addByPrefix(dataColor[i] + 'holdend', dataColor[i] + ' tail'); // Tails
			}

			setGraphicSize(Std.int(width * 0.7));
			updateHitbox();
			antialiasing = true;
		}
		else
		{

			if (PlayState.SONG.noteStyle == null) {
				switch(PlayState.storyWeek) {case 6: noteTypeCheck = 'pixel';}
			} else {noteTypeCheck = PlayState.SONG.noteStyle;}
	
			if (FlxG.save.data.sm)
				noteTypeCheck = 'stepmania';
			
			switch (noteTypeCheck)
			{
				case 'pixel':
					loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels', 'week6'), true, 17, 17);
					if (isSustainNote)
						loadGraphic(Paths.image('weeb/pixelUI/arrowEnds', 'week6'), true, 7, 6);

					for (i in 0...4)
					{
						animation.add(dataColor[i] + 'Scroll', [i + 4]); // Normal notes
						animation.add(dataColor[i] + 'hold', [i]); // Holds
						animation.add(dataColor[i] + 'holdend', [i + 4]); // Tails
					}

					setGraphicSize(Std.int(width * PlayState.daPixelZoom));
					updateHitbox();
				case 'stepmania':
					frames = Paths.getSparrowAtlas('NOTE_assets', 'camelliaweek');

					animation.addByPrefix('greenScroll', 'green0');
					animation.addByPrefix('redScroll', 'red0');
					animation.addByPrefix('blueScroll', 'blue0');
					animation.addByPrefix('purpleScroll', 'purple0');

					animation.addByPrefix('purpleholdend', 'pruple end hold');
					animation.addByPrefix('greenholdend', 'green hold end');
					animation.addByPrefix('redholdend', 'red hold end');
					animation.addByPrefix('blueholdend', 'blue hold end');

					animation.addByPrefix('purplehold', 'purple hold piece');
					animation.addByPrefix('greenhold', 'green hold piece');
					animation.addByPrefix('redhold', 'red hold piece');
					animation.addByPrefix('bluehold', 'blue hold piece');
					
					setGraphicSize(Std.int(width * 0.7));
					updateHitbox();
					antialiasing = true;
				default:
					frames = Paths.getSparrowAtlas('NOTE_assets');

					animation.addByPrefix('greenScroll', 'green instance 1');
					animation.addByPrefix('redScroll', 'red instance 1');
					animation.addByPrefix('blueScroll', 'blue instance 1');
					animation.addByPrefix('purpleScroll', 'purple instance 1');

					animation.addByPrefix('purpleholdend', 'pruple end hold instance 1');
					animation.addByPrefix('greenholdend', 'green hold end instance 1');
					animation.addByPrefix('redholdend', 'red hold end instance 1');
					animation.addByPrefix('blueholdend', 'blue hold end instance 1');

					animation.addByPrefix('purplehold', 'purple hold piece instance 1');
					animation.addByPrefix('greenhold', 'green hold piece instance 1');
					animation.addByPrefix('redhold', 'red hold piece instance 1');
					animation.addByPrefix('bluehold', 'blue hold piece instance 1');

					setGraphicSize(Std.int(width * 0.7));
					updateHitbox();
					antialiasing = true;
			}
		}
		}
		else
			{
			frames = Paths.getSparrowAtlas('death','camelliaweek');
			animation.addByPrefix('greenScroll', 'death');
			animation.addByPrefix('redScroll', 'death');
			animation.addByPrefix('blueScroll', 'death');
			animation.addByPrefix('purpleScroll', 'death');
			noteData = -noteData - 1;
	
			setGraphicSize(Std.int(width * 0.7));
			updateHitbox();
			antialiasing = true;
			}

		x += swagWidth * noteData;
		animation.play(dataColor[noteData] + 'Scroll');
		originColor = noteData; // The note's origin color will be checked by its sustain notes

		if (FlxG.save.data.stepMania && !isSustainNote)
		{
			var strumCheck:Float = rStrumTime;

			// I give up on fluctuating bpms. something has to be subtracted from strumCheck to make them look right but idk what.
			// I'd use the note's section's start time but neither the note's section nor its start time are accessible by themselves
			//strumCheck -= ???

			var ind:Int = Std.int(Math.round(strumCheck / (Conductor.stepCrochet / 2)));

			var col:Int = 0;
			col = quantityColor[ind % 8]; // Set the color depending on the beats

			animation.play(dataColor[col] + 'Scroll');
			localAngle -= arrowAngles[col];
			localAngle += arrowAngles[noteData];
			originColor = col;
		}
		
		// we make sure its downscroll and its a SUSTAIN NOTE (aka a trail, not a note)
		// and flip it so it doesn't look weird.
		// THIS DOESN'T FUCKING FLIP THE NOTE, CONTRIBUTERS DON'T JUST COMMENT THIS OUT JESUS
		// then what is this lol
		if (FlxG.save.data.downscroll && sustainNote) 
			flipY = true;

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;

			originColor = prevNote.originColor; 

			animation.play(dataColor[originColor] + 'holdend'); // This works both for normal colors and quantization colors
			updateHitbox();

			x -= width / 2;

			if (noteTypeCheck == 'pixel')
				x += 30;

			if (inCharter)
				x += 30;

			if (prevNote.isSustainNote)
			{
				prevNote.animation.play(dataColor[prevNote.originColor] + 'hold');

				if(FlxG.save.data.scrollSpeed != 1)
					prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * FlxG.save.data.scrollSpeed;
				else
					prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		angle = modAngle + localAngle;

		if (!modifiedByLua)
			if (!sustainActive)
				alpha = 0.4;

		if (mustPress)
		{
			// ass
			if (isSustainNote)
			{
				if (strumTime > Conductor.songPosition - (Conductor.safeZoneOffset * 1.5)
					&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
					canBeHit = true;
				else
					canBeHit = false;
			}
			else
			{
				if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
					&& strumTime < Conductor.songPosition + Conductor.safeZoneOffset)
					canBeHit = true;
				else
					canBeHit = false;
			}

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset * Conductor.timeScale && !wasGoodHit)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}
