import hxvlc.flixel.FlxVideoSprite;
import lime.system.System;

var curSelect:Int = 0;
var gallery:Array<Array<String>> = [
    // [image, desc, link (optional)]
    ["oh my sprite concepts", "Sprites concept\n(by 8r1o)"],
    ["oh my stage concepts", "Stage concept\n(by 8r1o)"],
    ["starry", "Full Background\n(by 8r1o)"],
    ["evil", "First ever Evil Bocchi concept\n(by Tedyes)"],
    ["bocchi but aethos", "Bocchi but edited to be aethos\n(by Nep)"],
    ["evil bocchi", "Bocchi but edited to be aethos\n(by 8r1o)"],
    ["jakehomys", "Bad Ending\n(by Jakehomys)"],
    ["eviler", "By Tedyes"],
    ["evilest", "By Tedyes"],
    ["evilester", "By Tedyes"],
    ["evilestest", "By Tedyes"],
    ["evilestester", "By Tedyes"],
    ["evilestestest", "By Tedyes"],
    ["evilestestester", "By Tedyes"],
    ["nijika", "I wonder where she is during all of this..."],
    ["dorito", "Sunday, September 8, 2024 1:45 PM"],
    ["menu concept", "Menu concept\n(by MerilynC)"],
    ["sake", "The drunk woman song\n(by StrangerKwid)"],
    ["old green bocchi real concept", "Old concept for the Midori vs Blue Kita song\n(by Jakehomys)"],
    ["sake concept", "\"Sake!\" stage concept\n(by 8r1o)"],
    ["those who concept", "Concept for the \"Unknown Song\" on the wiki\n(by 8r1o)"],
    ["grunt guitar", "Guitar sprites concept\n(by Grunt, went unfinished)", "https://twitter.com/madnescobat"],
    ["canon", "canon?"],
    ["big melons", "Inside dev team joke about goonerbait"],
    ["v2 leak", "D-Side Guitarvillain??\n(Art in image is by the_freakin_yui, amazing artist)", "https://twitter.com/the_freakin_yui"],
    ["guitarvillaib", "guitarvillaib", "https://yxtwitter.com"],
    ["album1", "Album Art 1\n(by Rio)"],
    ["album2", "Album Art 2\n(by Rio)"],
    ["album3", "Album Art 3\n(by Tedyes)"],
    ["hazeypurple", "Art by HazeyPurple", "https://twitter.com/HazeyPurple_"],
    ["reyreychan", "Art by Reyreychan", "https://youtube.com/@reyshapa20"],
    ["reyreychan2", "Art by Reyreychan", "https://youtube.com/@reyshapa20"],
    ["shishi sprite thing", "Art by Shishi", "https://twitter.com/shishi760_/status/1848592658190491730"],
    ["lex2", "Hi LexodiuS", "https://twitter.com/n3therwordly"]

];
var images:Array<FunkinSprite> = [];

var descTxt:FunkinText = new FunkinText(0, 0, FlxG.width - 32, "idk", 32, true);

function create() {
    CoolUtil.playMenuSong();

    add(vid = new FlxVideoSprite()).load(Assets.getPath(Paths.file('videos/menubg.mp4')), ['input-repeat=65535']);
    vid.play();

    add(new Alphabet(FlxG.width/2, 2, "Gallery", true)).screenCenter(FlxAxes.X);

    for (num => a in gallery) {
        images.push(new FunkinSprite().loadGraphic(Paths.image("menus/gallery/" + a[0])));
        add(images[num]).screenCenter(FlxAxes.Y);
        images[num].antialiasing = Options.antialiasing;
        images[num].x = FlxG.width / 2 * (num + 1 - curSelect) - images[num].width / 2;
        images[num].scale.set(Math.min(500/images[num].width, 500/images[num].height), Math.min(500/images[num].width, 500/images[num].height));
    }

    add(descTxt).antialiasing = Options.antialiasing;
    descTxt.screenCenter(FlxAxes.X);
    descTxt.alignment = "center";

    add(pressButtonTo = new FunkinText(4, FlxG.height - 20, 0, "", 16, true)).antialiasing = Options.antialiasing;

    for (a in 0...2) {
        var arrow = new Alphabet(0, 0, ">", true);
        add(arrow).screenCenter(FlxAxes.Y);
        arrow.flipX = a == 0;
        arrow.scale.x = arrow.scale.y = 2;
        arrow.x = (a == 0 ? 50 : FlxG.width - 50 - arrow.width);
    }
    changeSelect(0);

    #if TOUCH_CONTROLS
    addVirtualPad("LEFT_RIGHT", "A_B_C");
    #end
}

function update(elapsed) {        
    if (controls.BACK)
        FlxG.switchState(new ModState("Menus"));

    if (controls.LEFT_P || controls.RIGHT_P)
        changeSelect(controls.LEFT_P ? -1 : 1);

    if (controls.ACCEPT && gallery[curSelect][2] != null)
        CoolUtil.openURL(gallery[curSelect][2]);
    
    if (#if TOUCH_CONTROLS virtualPad.buttonC.justPressed || #end FlxG.keys.justPressed.TAB)
        System.openFile(Assets.getPath(Paths.image("menus/gallery/" + gallery[curSelect][0])));

    for (a in 0...images.length)
        images[a].x = FlxMath.lerp(images[a].x, FlxG.width / 2 * (a + 1 - curSelect) - images[a].width / 2, 0.04);
}

function changeSelect(_:Int) {
    CoolUtil.playMenuSFX();
    curSelect = FlxMath.wrap(curSelect + _, 0, gallery.length - 1);

    for(a in 0...images.length)
        images[a].alpha = a == curSelect ? 1 : 0.1;

    FlxTween.cancelTweensOf(descTxt);
    descTxt.text = gallery[curSelect][1];
    descTxt.y = 634 + (768 - 634) / 2 - descTxt.height / 2 - 5;
    FlxTween.tween(descTxt, {y: 634 + (768 - 634) / 2 - descTxt.height / 2}, 0.2);

    var tab:String = #if TOUCH_CONTROLS (controls.touchC) ? "C" : #end "TAB";
    var enter:String = #if TOUCH_CONTROLS (controls.touchC) ? "A" : #end "ENTER";

    pressButtonTo.text = "Press [" + tab + "] to open image" + (gallery[curSelect][2] != null ? " | Press " + enter + " to visit link" : "");
}