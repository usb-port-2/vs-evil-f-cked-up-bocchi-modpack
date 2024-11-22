import funkin.backend.system.framerate.Framerate;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextFormat;
import openfl.display.BlendMode;
import hxvlc.flixel.FlxVideoSprite;
#if TOUCH_CONTROLS
import mobile.funkin.backend.utils.TouchUtil;
#end

var texts:Array<FunkinText> = [];

function postCreate() {
    Framerate.debugMode = #if mobile 1 #else 0 #end;

    add(new Alphabet(FlxG.width/2, 175, "Quick Message", true)).screenCenter(FlxAxes.X);

    for (num => a in [
        "This mod is still a *demo*, with *more content planned*.",
        "\nThis is a fan creation based off of the anime \"*Bocchi The Rock*\", which we recommend you watch.",
        "We *do not support* the original aethos creator or their actions.",
        "\n\n\n" + (#if TOUCH_CONTROLS (controls.touchC) ? "Tap Your Screen to begin" : #end "Press ENTER to begin")
    ]) {
        texts.push(new FunkinText(0, 275 + (num != 0 ? texts[num - 1].height : 40) * num, FlxG.width - 32, "", 32, true));
        texts[num].alignment = "center";
        texts[num].applyMarkup(a, [new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFF4444), "*")]);
        texts[num].screenCenter(FlxAxes.X);
        texts[num].alpha = 0;
        add(texts[num]).antialiasing = Options.antialiasing;
        FlxTween.tween(texts[num], {alpha: 1}, 1, {startDelay: num});
    }

    add(vid = new FlxVideoSprite()).load(Assets.getPath(Paths.file('videos/menubg.mp4')), ['input-repeat=65535']);
    vid.play();
    vid.blend = BlendMode.ADD;
}


function update() {
    if(#if TOUCH_CONTROLS TouchUtil.justPressed || #end controls.ACCEPT) FlxG.switchState(new ModState("Menus"));
}