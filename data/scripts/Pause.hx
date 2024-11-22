import flixel.util.FlxGradient;

var menuItems:Array<FunkinText> = [];
var curSelect:Int = 0;

function create(e){
    e.cancel();

    camera = pauseCam = new FlxCamera();
    pauseCam.bgColor = FlxColor.TRANSPARENT;
    FlxG.cameras.add(pauseCam, false);

    for(num => z in [
        new FunkinText(0, 50, 0, "PAUSED", 48, true).screenCenter(FlxAxes.X),
        leftCursor = new FunkinText(0, 0, 0, ">", 16, true),
        rightCursor = new FunkinText(0, 0, 0, "<", 16, true)
    ]) {
        add(z);
        if(num == 0)
            FlxTween.tween(z, {alpha: 0}, 1, {type: FlxTween.PINGPONG});
        z.antialiasing = true;
    }

    for(a in 0...3) {
        menuItems.push(new FunkinText(0, FlxG.height/9 * (a + 3), 0, ["Resume", "Restart", "Leave"][a], 32, true).screenCenter(FlxAxes.X));
        menuItems[a].antialiasing = Options.antialiasing;
        add(menuItems[a]);
    }

    leftCursor.y = rightCursor.y = menuItems[0].y + menuItems[0].height/2 - leftCursor.height/2;
    leftCursor.x = menuItems[0].x - leftCursor.width - 5;
    rightCursor.x = menuItems[0].x + menuItems[0].width + rightCursor.width - 7.5;

    #if TOUCH_CONTROLS
    addVirtualPad("UP_DOWN", "A");
    addVirtualPadCamera();
    #end
}

function update(){
    if(controls.ACCEPT)
        switch(curSelect){
            case 0:
                close();
            case 1:
                FlxG.switchState(new PlayState());
            case 2:
                FlxG.switchState(new FreeplayState());
        }
    if(controls.UP_P || controls.DOWN_P)
        changeSelect(controls.UP_P ? -1 : 1);
}

function changeSelect(a:Int) {
    curSelect = FlxMath.wrap(curSelect + a, 0, 2);
    for(num => a in [leftCursor, rightCursor])
        FlxTween.tween(a, {
            y: menuItems[curSelect].y + menuItems[curSelect].height/2 - a.height/2,
            x: 
            num == 0 ? menuItems[curSelect].x - a.width - 5
            : menuItems[curSelect].x + menuItems[curSelect].width + a.width - 10
        }, 0.1);
}