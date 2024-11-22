import hxvlc.flixel.FlxVideoSprite;
import openfl.display.BlendMode;
import funkin.backend.system.macros.GitCommitMacro;
import funkin.options.OptionsMenu;
import funkin.menus.ModSwitchMenu;

var buttons:Array<FunkinSprite> = [];
var arrow:FunkinSprite;

var curSelect:Int = 0;

var evil:FunkinSprite;

function create() {
    CoolUtil.playMenuSong(true);

    var vid = new FlxVideoSprite();
    vid.load(Assets.getPath(Paths.file('videos/menubg.mp4')), ['input-repeat=65535']);
    vid.play();
    
    evil = new FunkinSprite(FlxG.width / 18);
    evil.frames = Paths.getSparrowAtlas("menus/main/evil");
    evil.animation.addByPrefix(":3", "bocchi", 12);
    evil.animation.play(":3");
    add(evil).y = FlxG.height - evil.height + 50;
    evil.updateHitbox();

    add(arrow = new FlxSprite()).frames = Paths.getSparrowAtlas("menus/main/arrow");
    arrow.animation.addByPrefix(":3", "arrow", 12);
    arrow.animation.play(":3");

    for (num => a in ["play", "options", "credits", "gallery"]) {
        var button:FunkinSprite = new FunkinSprite(750, [50, 200, 350, 500][num] + 62.5);
        button.frames = Paths.getSparrowAtlas("menus/main/" + a);
        button.animation.addByPrefix(":3", a, 12);
        button.animation.play(":3");
        buttons.push(button);
        add(buttons[num]).antialiasing = Options.antialiasing;
    }

    arrow.y = buttons[curSelect].y + buttons[curSelect].height / 2 - arrow.height/3;
    add(vid).blend = BlendMode.ADD;

    FlxG.cameras.add(overlay = new FlxCamera(), false).bgColor = FlxColor.TRANSPARENT;

    add(infoTxt = new FunkinText(4, FlxG.height - 36, 0, "Bocchithos Demo\nCodename Engine (" + GitCommitMacro.commitHash + ")", 16, true)).camera = overlay;
    
    evil.antialiasing = vid.antialiasing = arrow.antialiasing = infoTxt.antialiasing = Options.antialiasing;
    changeSelect(0);

    #if TOUCH_CONTROLS
    addVirtualPad("UP_DOWN", "A_B_C");
    addVirtualPadCamera();
    #end
}

function update(elapsed) {
    FlxG.camera.zoom = lerp(FlxG.camera.zoom, 1, 0.05);
    arrow.x = FlxG.width / 1.75 - arrow.width / 3 + (Math.sin(Conductor.songPosition / 100) * 5);

    if(controls.ACCEPT)
        FlxG.switchState([new ModState("Freeplay"), new OptionsMenu(), new ModState("Credits"), new ModState("Gallery")][curSelect]);

    if (FlxG.mouse.overlaps(evil) && FlxG.mouse.justPressed) {}

    if (controls.UP_P || controls.DOWN_P)
        changeSelect(controls.UP_P ? -1 : 1);
    
    if (FlxG.mouse.wheel != 0)
        changeSelect(-FlxG.mouse.wheel);

    if (#if TOUCH_CONTROLS virtualPad.buttonC.justPressed || #end controls.SWITCHMOD) {
        persistentUpdate = !(persistentDraw = true);
        openSubState(new ModSwitchMenu());
    }

    arrow.y = FlxMath.lerp(arrow.y, buttons[curSelect].y + buttons[curSelect].height / 2 - arrow.height/4, 0.04);
    for (a in 0...buttons.length) {
        buttons[a].alpha = FlxMath.lerp(buttons[a].alpha, a == curSelect ? 1 : 0.1, 0.04);
    }
}

function beatHit(curBeat:Int)
    FlxG.camera.zoom += 0.015;

function changeSelect(_:Int) {
    CoolUtil.playMenuSFX();
    curSelect = FlxMath.wrap(curSelect + _, 0, buttons.length - 1);
}
