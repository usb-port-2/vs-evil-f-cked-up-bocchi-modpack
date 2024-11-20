//
import funkin.backend.utils.DiscordUtil;

function onDiscordPresenceUpdate(e) {
	if(e.presence.button1Label == null) e.presence.button1Label = "ryofanbtr9934";
	if(e.presence.button1Url == null) e.presence.button1Url = "https://twitter.com/ryofanbtr9934";
	if(e.presence.button2Label == null) e.presence.button2Label = "Download the mod";
	if(e.presence.button2Url == null) e.presence.button2Url = "https://gamebanana.com/mods/556103";
}

function onPlayStateUpdate() {
	DiscordUtil.changeSongPresence(
		(PlayState.instance.paused ? "Paused:" : "Playing:"),
		PlayState.SONG.meta.displayName,
		PlayState.instance.inst.length,
		PlayState.instance.getIconRPC()
	);
}

function onMenuLoaded(name:String)
	DiscordUtil.changePresenceSince("In the Menus", null);