import hxvlc.flixel.FlxVideoSprite;

function postCreate() {
    lastState = new ModState("Menus");
    insert(1, vid = new FlxVideoSprite()).load(Assets.getPath(Paths.file('videos/menubg.mp4')), ['input-repeat=65535']);
    vid.play();
    vid.scrollFactor.x = 0;
}