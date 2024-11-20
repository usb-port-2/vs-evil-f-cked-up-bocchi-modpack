import hxvlc.flixel.FlxVideoSprite;
public var bgVid = new FlxVideoSprite(800, 350);
function postCreate() {
    insert(0, bgVid).load(Assets.getPath(Paths.file('videos/menubg.mp4')), ['input-repeat=65535']);
    bgVid.play();
    bgVid.scale.x = bgVid.scale.y = 2.84765625;
}