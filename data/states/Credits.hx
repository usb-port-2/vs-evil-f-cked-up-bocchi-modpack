import hxvlc.flixel.FlxVideoSprite;
import openfl.display.BlendMode;

var curSelect:Int = 0;
var creds:Array<Array<String>> = [
    // [name, desc, link, color]
    ["ryofanbtr9934", "Mod Director, Programmer", "https://twitter.com/ryofanbtr9934", 0xff723193],
    ["Rio", "Guitarvillain Composer", "https://twitter.com/RioTorresMusic", 0xffff0055],
    ["8r1o", "Guitarvillain Artist, Credit Icons\n(i am so sorry for making you do all that)", "https://twitter.com/Xx_8r1o_xX", 0xffb60014],
    ["Sopas", "Chromatics, Menu & Pause music", "https://twitter.com/landelsoup", 0xff683550],
    ["Oily Elegant Man", "Charter (goated)", "https://twitter.com/PlayGoji", 0xffe1e8ea],
    ["MerilynC", "Menu Assets", "https://twitter.com/MerilynCist", 0xff312b51],
    ["Nep", "Animator", "https://www.youtube.com/@neptvne_z", 0xffa9acc2],
    ["Grunt", "Animator (Guitar sprites)", "https://www.twitter.com/madnescobat", 0xffd8428d],
    ["JakeHomys", "Artist, Upcoming stuffs", "https://twitter.com/JakeHomys", 0xff1b0504],
    ["Sinwalker", "Composer, Upcoming stuffs", "https://twitter.com/SinwalkerMusic", 0xfff3eb4a],
    ["StrangerKwid", "Composer, Upcoming stuffs", "https://twitter.com/StrangerKwid", 0xffc57b29],
    ["Frakits", "Playtester, helped with like one line of code", "https://twitter.com/frakitss", 0xff464555]
];
var icons:Array<HealthIcon> = [];
var txts:Array<Alphabet> = [];

var descTxt:FunkinText = new FunkinText(0, 0, 0, "idk", 32, true);

function create() {
    CoolUtil.playMenuSong();

    add(vid = new FlxVideoSprite()).load(Assets.getPath(Paths.file('videos/menubg.mp4')), ['input-repeat=65535']);
    vid.play();

    add(overlay = new FunkinSprite().makeSolid(FlxG.width, FlxG.height)).color = 0xff723193;
    overlay.blend = BlendMode.MULTIPLY;

    add(new Alphabet(FlxG.width/2, 2, "Credits", true)).screenCenter(FlxAxes.X);

    for (num => a in creds) {
        txts.push(new Alphabet(175, FlxG.width / 4 + 175 * (num - curSelect), a[0], false));
        add(txts[num]).screenCenter(FlxAxes.X);

        icons.push(new HealthIcon('credits/' + a[0]));
        icons[num].setPosition(txts[num].x - icons[num].width - 5, FlxG.width / 4 + 175 * (num - curSelect));
        insert(members.indexOf(overlay) + 1, icons[num]);
    }
    add(descTxt).antialiasing = Options.antialiasing;
    descTxt.alignment = "center";
    changeSelect(0);

    #if TOUCH_CONTROLS
    addVirtualPad("UP_DOWN", "A_B");
    #end
}

function update(elapsed) {
    if (FlxG.mouse.wheel != 0)
        changeSelect(-FlxG.mouse.wheel);
        
    if (controls.BACK)
        FlxG.switchState(new ModState("Menus"));

    if (controls.ACCEPT)
        CoolUtil.openURL(creds[curSelect][2]);

    if (controls.UP_P || controls.DOWN_P)
        changeSelect(controls.UP_P ? -1 : 1);

    for (a in 0...txts.length) {
        txts[a].y = FlxMath.lerp(txts[a].y, FlxG.width / 4 + 175 * (a - curSelect), 0.04);
        icons[a].y = FlxMath.lerp(icons[a].y, FlxG.width / 4 + 175 * (a - curSelect), 0.04);
        txts[a].alpha = FlxMath.lerp(txts[a].alpha, 1 - (Math.abs(a - curSelect) / 2.25), 0.04);
        icons[a].alpha = FlxMath.lerp(icons[a].alpha, 1 - (Math.abs(a - curSelect) / 2.25), 0.04);
    }
    
    txts[0].text = curSelect == 0 ? "Care (usb_port_2)" : "ryofanbtr9934";
    txts[0].screenCenter(FlxAxes.X);
    icons[0].x = txts[0].x - icons[0].width - 5;
}

function changeSelect(_:Int) {
    CoolUtil.playMenuSFX();
    FlxTween.cancelTweensOf(overlay);
    FlxTween.cancelTweensOf(descTxt);

    icons[curSelect].health = 1;
    curSelect = FlxMath.wrap(curSelect + _, 0, txts.length - 1);
    icons[curSelect].health = 0;

    FlxTween.color(overlay, 0.5, overlay.color, creds[curSelect][3]);

    descTxt.text = creds[curSelect][1];
    descTxt.y = FlxG.height - descTxt.height - 6;
    descTxt.screenCenter(FlxAxes.X);
    FlxTween.tween(descTxt, {y: FlxG.height - descTxt.height - 3}, 0.2);
}