// hi this code is a mess i coded it in class
import hxvlc.flixel.FlxVideoSprite;
import openfl.utils.Assets;
import StringTools;
import funkin.savedata.FunkinSave;
import funkin.savedata.FunkinSave.HighscoreChange;

var songList:Array<Array<String>> = [
  //["Song Name", "Composer"]
    ["Guitarvillain", "Rio"]
];
var curSelect:Int = 0;

var txts:Array<Alphabet> = [];
var composer:FunkinText;

var accuracyText:FunkinText;
var coopText:FunkinText;
var scoreBG:FunkinSprite;

var freeplayArt:FunkinSprite;

var lerpAcc:Float = 0;
var intendedAcc:Float = 0;

var oppMode:Bool = false;

function create() {
    CoolUtil.playMenuSong();
    FlxG.cameras.add(camTxts = new FlxCamera(350), false).bgColor = FlxColor.TRANSPARENT;
    camTxts.zoom -= 0.125;

    add(vid = new FlxVideoSprite()).load(Assets.getPath(Paths.file('videos/menubg.mp4')), ['input-repeat=65535']);
    vid.play();
    
    add(new FunkinSprite(20, 20).makeGraphic(385, 385));
    add(freeplayArt = new FunkinSprite(25, 25).makeGraphic(375, 375, FlxColor.RED)).antialiasing = Options.antialiasing;

    for (a in 0...songList.length) {
        txts.push(new Alphabet(0, (70 * a) + 30, songList[a][0], true));
        add(txts[a]).camera = camTxts;
    }

    add(scoreBG = new FunkinSprite(FlxG.width * 0.7 - 6, 0).makeGraphic(1, 1, 0xFF000000));
    add(coopText = new FunkinText(FlxG.width * 0.7, 38, 1024 - FlxG.width * 0.7, (#if TOUCH_CONTROLS (controls.touchC) ? "[C] " : #end "[TAB] ") + "Normal Mode", 24, true)).antialiasing = Options.antialiasing;
    add(accuracyText = new FunkinText(FlxG.width * 0.7, 5, 1024 - FlxG.width * 0.7, "", 32, true)).antialiasing = Options.antialiasing;

    add(composer = new FunkinText(0, freeplayArt.y + freeplayArt.height + 10, 0, "By Rio", 24, true)).antialiasing = Options.antialiasing;

    changeSelect(0);

    #if TOUCH_CONTROLS
    addVirtualPad("UP_DOWN", "A_B_C");
    #end
}

function update(elapsed) {
    scoreBG.scale.set(Math.max(accuracyText.width, coopText.width) + 8, (coopText.visible ? coopText.y + coopText.height : 66));
    scoreBG.updateHitbox();
    scoreBG.x = FlxG.width - scoreBG.width;

    lerpAcc = lerp(lerpAcc, intendedAcc, 0.4);

    accuracyText.text = "Accuracy:" + CoolUtil.quantize(lerpAcc * 100, 100) + "%";

    if (FlxG.mouse.wheel != 0)
        changeSelect(-FlxG.mouse.wheel);
        
    if (controls.BACK)
        FlxG.switchState(new ModState("Menus"));

    if (#if TOUCH_CONTROLS virtualPad.buttonC.justPressed || #end FlxG.keys.justPressed.TAB) {
        oppMode = !oppMode;
        coopText.text = (#if TOUCH_CONTROLS (controls.touchC) ? "[C] " : #end "[TAB] ") + (oppMode ? "Opponent" : "Normal") + " Mode";
        intendedAcc = FunkinSave.getSongHighscore(songList[curSelect][0], "normal", (oppMode ? [HighscoreChange.COpponentMode] : [])).accuracy;
    }

    if (controls.ACCEPT) {
        PlayState.loadSong(songList[curSelect][0], "normal", oppMode);
        FlxG.switchState(new PlayState());
    }

    if (controls.UP_P || controls.DOWN_P)
        changeSelect(controls.UP_P ? -1 : 1);

    for (a in 0...songList.length) {
        txts[a].x = FlxMath.lerp(txts[a].x, Math.sin(Math.abs(a - curSelect)) * 100, 0.04);
        txts[a].y = FlxMath.lerp(txts[a].y, FlxG.height / 2 - txts[a].height/2 + 175 * (a - curSelect), 0.04);
        txts[a].alpha = FlxMath.lerp(txts[a].alpha, 1 - (Math.abs(a - curSelect) / 2.25), 0.04);
    }
}

function changeSelect(_:Int) {
    CoolUtil.playMenuSFX();
    curSelect = FlxMath.wrap(curSelect + _, 0, songList.length - 1);
    freeplayArt.loadGraphic(Paths.image("menus/freeplay/" + songList[curSelect][0]));
    composer.text = "Composed by " + songList[curSelect][1];
    composer.x = freeplayArt.x + freeplayArt.width / 2 - composer.width / 2;
    intendedAcc = FunkinSave.getSongHighscore(songList[curSelect][0], "normal", (oppMode ? [HighscoreChange.COpponentMode] : [])).accuracy;
}
