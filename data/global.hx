import funkin.backend.system.framerate.Framerate;
import funkin.backend.utils.ShaderResizeFix;
import funkin.menus.BetaWarningState;
import openfl.system.Capabilities;
import funkin.backend.utils.WindowUtils;
#if android
import lime.system.JNI;
#end

#if android
public static var setOrientation:Dynamic = JNI.createStaticMethod('org/libsdl/app/SDLActivity', 'setOrientation', '(IIZLjava/lang/String;)V');
#end

var redirectStates:Map<FlxState, String> = [
	BetaWarningState => "Disclaimer",
    TitleState => "Menus"
	MainMenuState => "Menus",
	FreeplayState => "Freeplay"
];

function new(){
	window.title = WindowUtils.winTitle = "Vs Evil F*cked Up Bocchi (DEMO)";
	windowShit(1024, 768);
	Framerate.codenameBuildField.visible = FlxG.stage.window.resizable = false;
}

function preStateSwitch()
	for (redirectState in redirectStates.keys()) 
		if (Std.isOfType(FlxG.game._requestedState, redirectState)) 
			FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));

function postStateSwitch()
	if(Framerate.codenameBuildField.visible == true) Framerate.codenameBuildField.visible = false;

function update(elapsed:Float)
	if (FlxG.keys.justPressed.F5)
		FlxG.resetState();

function destroy()
	windowShit(1280, 720);

var winWidth = Math.floor(Capabilities.screenResolutionX * (3 / 4)) > Capabilities.screenResolutionY ? Math.floor(Capabilities.screenResolutionY * (4 / 3)) : Capabilitities.screenResolutionX;
var winHeight = Math.floor(Capabilities.screenResolutionX * (3 / 4)) > Capabilities.screenResolutionY ? Capabilities.screenResolutionY : Math.floor(Capabilities.screenResolutionX * (3 / 4));

public static function windowShit(newWidth:Int, newHeight:Int){
 	if(newWidth == 1024 && newHeight == 768)
		FlxG.resizeWindow(winWidth * 0.9, winHeight * 0.9);
	else
		FlxG.resizeWindow(newWidth, newHeight);
	FlxG.resizeGame(newWidth, newHeight);
	FlxG.scaleMode.width = FlxG.width = FlxG.initialWidth = newWidth;
	FlxG.scaleMode.height = FlxG.height = FlxG.initialHeight = newHeight;
	ShaderResizeFix.doResizeFix = true;
	ShaderResizeFix.fixSpritesShadersSizes();
	window.x = Capabilities.screenResolutionX/2 - window.width/2;
	window.y = Capabilities.screenResolutionY/2 - window.height/2;
}