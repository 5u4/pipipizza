package openfl8;

import flixel.system.FlxAssets.FlxShader;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.VarTween;

class FlashEffect
{
	var target = 0.0;
	var tween:VarTween;

	public var shader(default, null):FlashShader;

	public function new()
	{
		shader = new FlashShader();
	}

	public function apply()
	{
		target = 0.5;

		if (tween != null)
		{
			tween.cancel();
			tween = null;
		}
		tween = FlxTween.tween(this, {target: 0.0}, 0.15, {ease: FlxEase.quadInOut});
	}

	public function update()
	{
		shader.target.value = [target];
	}
}

class FlashShader extends FlxShader
{
	@:glFragmentSource('
        #pragma header

        uniform float target;

        void main()
        {
            vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
            gl_FragColor = vec4(color.rgb + target, color.a);
        }
    ')
	public function new()
	{
		super();
	}
}
