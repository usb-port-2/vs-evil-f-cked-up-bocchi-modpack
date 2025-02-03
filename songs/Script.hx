import openfl.utils.Assets;
import flixel.util.FlxGradient;

PauseSubState.script = 'data/scripts/pause';
GameOverSubstate.script = 'data/scripts/gameover-' + SONG.meta.name.toLowerCase();

public var timerTxt = new FunkinText(5, 0, 0, "Time:0:00/" + Std.int(Std.int((inst.length) / 1000) / 60) + ":" + CoolUtil.addZeros(Std.string(Std.int((inst.length) / 1000) % 60), 2), 16);

public var camTXT:HudCamera = new HudCamera();
public var ogBarPos:Array<Float> = [];

var bnw:CustomShader = new CustomShader("black n white");
var titlecard:FunkinSprite = new FunkinSprite().loadGraphic(Paths.image("game/titlecards/" + SONG.meta.name));

function postCreate(){
    canPause = allowGitaroo = false;
    FlxG.cameras.add(camTXT, false);
    camTXT.bgColor = camHUD.bgColor;
    for(num => a in [iconP1, iconP2, healthBar, healthBarBG, accuracyTxt, timerTxt, scoreTxt, missesTxt]){
        a.y += 15;
        a.antialiasing = true;
        if(Std.isOfType(a, FlxText)) {
            a.alignment = "left";
            a.size *= 1.5;
            a.setPosition(5, FlxG.height - (a.height * (num-3)) - 5);
            a.camera = camTXT;
        } else
            if(!camHUD.downscroll) a.x += FlxG.width/7.5;
    }
    add(timerTxt);

    ogBarPos.push(healthBarBG.x);
    ogBarPos.push(healthBarBG.y);

    insert(0, titlecard).screenCenter();
    titlecard.camera = camTXT;
    titlecard.antialiasing = Options.antialiasing;
}

function onStrumCreation(e){
    e.cancelAnimation();
    e.strum.y = 25;
    if(SONG.meta.name != "Popular") e.strum.visible = e.player == (PlayState.opponentMode ? 0 : 1);
}

function postUpdate(elapsed) {
    if (Conductor.songPosition >= 0)
        timerTxt.text = "Time:" + Std.int(Std.int((Conductor.songPosition) / 1000) / 60) + ":" + CoolUtil.addZeros(Std.string(Std.int((Conductor.songPosition) / 1000) % 60), 2) + "/" + Std.int(Std.int((inst.length) / 1000) / 60) + ":" + CoolUtil.addZeros(Std.string(Std.int((inst.length) / 1000) % 60), 2);
}

function stepHit(curStep:Int)
    if (curStep == 0) {
        canPause = true;
        FlxTween.tween(titlecard, {alpha: 0}, (Conductor.stepCrochet/1000) * 8, {onComplete: (_) -> remove(titlecard.destroy())}); 
    }

function onGamePause()
    FlxG.game.addShader(bnw);

function onSubstateClose()
    FlxG.game.removeShader(bnw);
