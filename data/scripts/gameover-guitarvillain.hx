import hxvlc.flixel.FlxVideoSprite;

function create(e) {
    e.cancel();

    #if android
    setOrientation(1024, 768, false, "LandscapeRight");
    #end

    FlxG.cameras.add(camera = dieCam = new FlxCamera(), false).bgColor = FlxColor.TRANSPARENT;

    add(vid = new FlxVideoSprite()).load(Assets.getPath(Paths.file('videos/' + (PlayState.opponentMode ? "guitarvillain-die.mp4" : "ryo-die.webm"))));
    vid.bitmap.onEndReached.add(function() FlxG.switchState(new PlayState()));
    vid.play();
    vid.scale.x = vid.scale.y *= 2;
    vid.x += 270;
    vid.y += 250;
}