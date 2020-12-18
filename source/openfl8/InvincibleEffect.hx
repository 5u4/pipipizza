package openfl8;

import flixel.system.FlxAssets.FlxShader;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class InvincibleEffect
{
	var target = 0.0;

	public var shader(default, null):InvincibleShader;

	public function new()
	{
		shader = new InvincibleShader();
		FlxTween.tween(this, {target: 1.0}, 0.1, {type: PINGPONG, ease: FlxEase.quadInOut});
	}

	public function apply()
	{
		shader.target.value = [target];
	}

	public function reset()
	{
		shader.target.value = [0.0];
	}
}

class InvincibleShader extends FlxShader
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
