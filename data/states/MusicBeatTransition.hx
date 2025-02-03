function create() {
    transitionTween.cancel();
    remove(blackSpr);
    remove(transitionSprite);
    transitionCamera.fade(FlxColor.BLACK, 0.625, newState == null, () -> finish());
}