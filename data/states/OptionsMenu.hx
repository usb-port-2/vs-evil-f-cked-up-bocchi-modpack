import hxvlc.flixel.FlxVideoSprite;

function create() {
    lastState = new ModState("Menus");
    insert(0, vid = new FlxVideoSprite()).load(Assets.getPath(Paths.file('videos/menubg.mp4')), ['input-repeat=65535']);
    vid.play();
    vid.scrollFactor.x = 0;
}