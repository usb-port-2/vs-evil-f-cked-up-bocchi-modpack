import funkin.backend.utils.ShaderResizeFix;
import flixel.util.FlxGradient;
import openfl.display.BlendMode;
import hxvlc.flixel.FlxVideoSprite;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextFormat;

var ddd:CustomShader = new CustomShader("3D");
ddd.xrot = 45;
ddd.ypos = (ddd.xrot/100)/4;
ddd.zpos = (ddd.xrot/100)/1.5;

var bop:Bool = false;
var cameraMoveAngle:Bool = false;

var angle:Float = 0.0;

function onDadHit(e)
    if((PlayState.opponentMode ? iconP2 : iconP1).animation.curAnim.curFrame != 1) health += (PlayState.opponentMode ? 0.02875 : -0.023);

function postCreate() {
    #if android
    setOrientation(1024, 768, false, "LandscapeRight");
    #end

    add(vid = new FlxVideoSprite()).load(Assets.getPath(Paths.file('videos/menubg.mp4')), ['input-repeat=65535']);
    vid.play();
    vid.scale.set(1.5, 1.5);
    vid.blend = BlendMode.ADD;
    vid.scrollFactor.x = vid.scrollFactor.y = camHUD.alpha = strumLines.members[0].characters[1].alpha = accuracyTxt.alpha = timerTxt.alpha = scoreTxt.alpha = missesTxt.alpha = 0;

    camGame.fade(FlxColor.BLACK, 0);
    for(a in 0...2)
        strumLines.members[a].characters[0].animateAtlas.colorTransform.color = strumLines.members[a].characters[0].colorTransform.color = strumLines.members[a].characters[0].iconColor;
    
    for(a in stage.stageSprites)
        a.visible = false;
    defaultCamZoom -= 0.1;

    add(gradient = new FlxGradient().createGradientFlxSprite((strumLines.members[0].members[0].width * 4.5), 768, [FlxColor.TRANSPARENT, FlxColor.TRANSPARENT, FlxColor.TRANSPARENT, FlxColor.BLACK], 1, 270, true)).screenCenter(FlxAxes.X);
    gradient.camera = camHUD;
    gradient.alpha = 0.5;

    doIconBop = bop = cameraMoveAngle = gradient.visible = vid.visible = strumLines.members[0].characters[1].visible = bgVid.visible = false;
   
    if(!PlayState.opponentMode){
        add(dontMiss = new FunkinText(0, FlxG.height - 40, 0, "", 24, true)).camera = camTXT;
        dontMiss.applyMarkup("When Bocchi plays her guitar, *don't miss*!", [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.RED), "*")]);
        dontMiss.screenCenter(FlxAxes.X);
        dontMiss.antialiasing = Options.antialiasing;
    }
}

function stepHit(curStep:Int) {
    switch(curStep) {
        case 0:
            if(!PlayState.opponentMode)
                FlxTween.tween(dontMiss, {alpha: 0}, (Conductor.stepCrochet/1000) * 8, {onComplete: (_) -> remove(dontMiss.destroy())});
        case 8:
            for (a in [accuracyTxt, timerTxt, scoreTxt, missesTxt])
                FlxTween.tween(a, {alpha: 1}, (Conductor.stepCrochet/1000) * 16);
            FlxTween.tween(camHUD, {alpha: 1}, (Conductor.stepCrochet/1000) * 16);
        case 16:
            camGame.fade(FlxColor.BLACK, (Conductor.stepCrochet/1000) * 16, true);
        case 271 | 281:
            defaultCamZoom += 0.1;
        case 289:
            defaultCamZoom += 0.1;
            camGame.flash(FlxColor.WHITE, (Conductor.stepCrochet/1000) * 16);
            for(a in 0...2){
                strumLines.members[a].characters[0].animateAtlas.setColorTransform();
                strumLines.members[a].characters[0].setColorTransform();
            }
            for(a in stage.stageSprites)
                a.visible = true;
            defaultCamZoom -= 0.15;
            cameraMoveAngle = bop = bgVid.visible = true;
        case 801:
            defaultCamZoom = 0.45;
            FlxTween.num(defaultCamZoom, 0.6, (Conductor.stepCrochet/1000) * 256, {}, _ -> defaultCamZoom = _);
        case 1313 | 1419 | 1355:
            defaultCamZoom -= 0.1;
        case 1345 | 1349 | 1353 | 1409 | 1413 | 1417 | 2849 | 2853 | 2857:
            defaultCamZoom += 0.05;
        case 1423 | 1359:
            defaultCamZoom = 0.55;
        case 1441:
            defaultCamZoom = 0.6;
        case 1568 | 2209:
            camGame.flash(FlxColor.WHITE, (Conductor.stepCrochet/1000) * 16);
            if(curStep == 2209) {
                for(a in 0...2)
                    strumLines.members[a].characters[0].color = FlxColor.WHITE;
                for(a in stage.stageSprites)
                    a.setColorTransform();
                defaultCamZoom = camGame.zoom = 0.7;
                cameraMoveAngle = bgVid.visible = true;
            }
            defaultCamZoom = 0.7;
            vid.visible = !vid.visible;
        case 1792:
            FlxTween.tween(vid, {alpha: 0}, (Conductor.stepCrochet/1000) * 32, {onComplete: (_) -> {vid.visible = false; vid.alpha = 1;}});
        case 2081:
            camGame.flash(FlxColor.WHITE, (Conductor.stepCrochet/1000) * 16);
            defaultCamZoom = 0.45;
            cameraMoveAngle = bgVid.visible = false;
            for(a in 0...2)
                strumLines.members[a].characters[0].color = FlxColor.BLACK;
            for(a in stage.stageSprites)
                a.colorTransform.color = FlxColor.WHITE;
        case 2328:
            if(PlayState.opponentMode){
                #if android
                setOrientation(1024, 768, false, 'Portrait');
                #end
                FlxTween.tween(camTXT, {alpha: 0}, (Conductor.stepCrochet/1000) * 16);     
                FlxTween.tween(camHUD, {alpha: 0}, (Conductor.stepCrochet/1000) * 16, {onComplete: function(twn) {      
                    camHUD.addShader(ddd);
                    camHUD.downscroll = camTXT.downscroll = gradient.visible = !(iconP1.visible = iconP2.visible = false);
                    healthBar.angle = healthBarBG.angle = -90;
                    for(num => a in [healthBarBG, healthBar]) {
                        a.x = strumLines.members[0].members[3].x/1.3 + (num * 4);
                        a.screenCenter(FlxAxes.Y);
                    }
                }});
            }
        case 2335:
            defaultCamZoom -= 0.3;
            FlxTween.tween(camHUD, {alpha: 0}, (Conductor.stepCrochet/1000) * 8);
            FlxTween.tween(camTXT, {alpha: 0}, (Conductor.stepCrochet/1000) * 8);
            FlxTween.tween(vid, {alpha: 0}, (Conductor.stepCrochet/1000) * 8);
            FlxTween.num(vid.scale.x, vid.scale.x + 0.75, (Conductor.stepCrochet/1000) * 8, {}, _ -> vid.scale.x = vid.scale.y = _);
            for(a in 0...2)
                FlxTween.tween(strumLines.members[a].characters[0], {alpha: 0}, (Conductor.stepCrochet/1000) * 8);
            for(a in stage.stageSprites)
                FlxTween.tween(a, {alpha: 0}, (Conductor.stepCrochet/1000) * 8);
        case 2353 | 2357 | 2361 | 2365:
            strumLines.members[0].characters[1].visible = true;
            //FlxTween.cancelTweensOf(stage.stageSprites["fuck"]);
            //stage.stageSprites["fuck"].color = [0xffeeb8c5, 0xffd1564e, 0xffe6d57b, 0xff3f61a0][[2353, 2357, 2361, 2365].indexOf(curStep)];
            //stage.stageSprites["fuck"].alpha = 0.25;
            //FlxTween.tween(stage.stageSprites["fuck"], {alpha: 0}, (Conductor.stepCrochet/1000) * 4);
            if(PlayState.opponentMode){
                camHUD.alpha = camTXT.alpha += 0.25;
            }
            defaultCamZoom = camGame.zoom += 0.05;
            strumLines.members[0].characters[1].alpha = vid.alpha += 0.25;
        case 2489:
            if(!PlayState.opponentMode) {
                FlxTween.tween(camHUD, {alpha: 1}, (Conductor.stepCrochet/1000) * 8);
                FlxTween.tween(camTXT, {alpha: 1}, (Conductor.stepCrochet/1000) * 8);
            }
        case 2625:
            defaultCamZoom += 0.3;
            FlxTween.tween(strumLines.members[0].characters[1], {alpha: 0}, (Conductor.stepCrochet/1000) * 11, {onComplete: (_) -> {
                strumLines.members[0].characters[1].visible = false;
                for(a in 0...2)
                    FlxTween.tween(strumLines.members[a].characters[0], {alpha: 1}, (Conductor.stepCrochet/1000) * 8);
                for(a in stage.stageSprites)
                    FlxTween.tween(a, {alpha: 1}, (Conductor.stepCrochet/1000) * 8);
            }});
            FlxTween.tween(vid, {alpha: 0}, (Conductor.stepCrochet/1000) * 8);
            FlxTween.num(vid.scale.x, vid.scale.x - 0.75, (Conductor.stepCrochet/1000) * 8, {}, _ -> vid.scale.x = vid.scale.y = _);

            if(PlayState.opponentMode){
                FlxTween.tween(camTXT, {alpha: 0}, (Conductor.stepCrochet/1000) * 11);
                FlxTween.tween(camHUD, {alpha: 0}, (Conductor.stepCrochet/1000) * 11, {onComplete: function(twn) {
                    #if android
                    setOrientation(1024, 768, false, "LandscapeRight");
                    #end
                    camHUD.removeShader(ddd);
                    camHUD.downscroll = Options.downscroll;
                    iconP1.visible = iconP2.visible = !(gradient.visible = camTXT.downscroll = false);
                    healthBar.angle = healthBarBG.angle = 0;
                    for(num => a in [healthBarBG, healthBar])
                        a.setPosition(ogBarPos[0] + (4*num), ogBarPos[1] + (4*num));
                    FlxTween.tween(camTXT, {alpha: 1}, (Conductor.stepCrochet/1000) * 16);     
                    FlxTween.tween(camHUD, {alpha: 1}, (Conductor.stepCrochet/1000) * 16);        
                }});
            }
        case 2689 | 2863:
            defaultCamZoom = 0.5;
        case 2877:
            defaultCamZoom = 0.6;
            bop = false;
            camGame.fade(FlxColor.BLACK, (Conductor.stepCrochet/1000) * 8, false, () -> camGame.fade(FlxColor.BLACK, 0));
        case 2887:
            defaultCamZoom = (PlayState.opponentMode ? 0.45 : 0.55);
            if(PlayState.opponentMode){
                for(a in 0...2)
                    strumLines.members[a].characters[0].animateAtlas.colorTransform.color = strumLines.members[a].characters[0].colorTransform.color = strumLines.members[a].characters[0].iconColor;
                for(a in stage.stageSprites)
                    a.visible = false;
                bgVid.visible = false;
            }
        case 2897:
            camGame.fade(FlxColor.WHITE, (Conductor.stepCrochet/1000) * 8, true);
            defaultCamZoom -= 0.1;
        case 3039 | 3040 | 3071 | 3081 | 3161:
            defaultCamZoom += 0.075;
        case 3051 | 3089:
            defaultCamZoom = 0.45;
        case 3151:
            defaultCamZoom += 0.075;
            FlxTween.tween(camGame, {alpha: 0}, (Conductor.stepCrochet/1000) * 26);
        case 3169:
            camGame.fade(FlxColor.BLACK, (Conductor.stepCrochet/1000) * 8);
            defaultCamZoom += 0.075;
    }
}

function beatHit(curBeat:Int) {
    if(bop)
        for(a in [iconP1, iconP2]) {
			a.angle = (curBeat - 1) % 2 == 0 ? 25 : -25;
			FlxTween.cancelTweensOf(a);
			FlxTween.tween(a, {angle: 0}, 0.5, {ease: FlxEase.circOut});
        }
}

function postUpdate() {
    camGame.angle = Math.sin(Conductor.songPosition / 1000) * 2;
    switch((strumLines.members[0].characters[1].visible ? strumLines.members[0].characters[1] : strumLines.members[curCameraTarget].characters[0]).getAnimName()){
        case "singLEFT":
            camFollow.x -= 20;
        case "singRIGHT":
            camFollow.x += 20;
        case "singDOWN":
            camFollow.y += 20;
        case "singUP":
            camFollow.y -= 20;
    }
}

function onSubstateOpen() {
    for(a in [iconP1, iconP2])
        FlxTween.cancelTweensOf(a);
    FlxTween.cancelTweensOf(camHUD);
}

function onPlayerMiss(e)
    if (e.note.noteType == "Evil Notes")
        health = 0;

#if android
function onSongEnd()
    setOrientation(1024, 768, false, "LandscapeRight");
#end