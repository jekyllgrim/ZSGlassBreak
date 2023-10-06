# ZScript GlassBreak by Agent_Ash

This small library recreates the [GlassBreak](https://zdoom.org/wiki/GlassBreak) ACS function in a more flexible ZScript variant that is also callable from ACS and allows adjusting the appearance of the effect.

## How to use

*Note:* The library comes with an example map (the map can be reached with `map GlassExample`) with an ACS script, sounds and stained glass textures from Hexen. These are purely for demonstration and are NOT needed for the library to function. The library itself is wholly contained in `ZSGlassBreak/glassbreak.zs`.

### In Zscript

Call `JGP_GlassBreak.BreakGlassLine()`:

```csharp
static Line BreakGlassLine(Line l, string newTex = "", int numDebris = 20, int speed = 5, sound snd = "GlassShatter", string debristype = "")
```

Arguments:

1. `l` — a `Line` pointer to the line that should be affected. Only double-sided linedefs with a middle texture at least on the front side can be affected.

2. `newTex` — the name of the new texture to apply to the linedef after breaking. It'll be applied to both sides. Default: "" (simply removes the texture).

3. `numDebris` — the number of glass debris to spawn. Default: 20.

4. `speed` — the speed at which the debris will fly from the line. Upon spawning the horizontal speed will be set to a value between x0.5 and x1.0 of this number, and the vertical speed will be x0.5 of the horizontal speed. Default: 5.

5. `snd` — the name of the sound to play on the line when the glass breaks. Default: "GlassShatter" (the default Hexen glass break sound).

6. `debristype` — the name of the Actor class to use for debris. If left unspecified (or the actor with that name doesn't exist), the function will spawn particles that have the same texture as the line (but small in size).

Once the function executes, all blocking flags will be removed from the linedef: it will no longer block movement, attacks, sight, sound or Use actions.

## In ACS

Use [ScriptCall](https://zdoom.org/wiki/ScriptCall) to call `JGP_GlassBreak.BreakGlassTag()` function. For example:

```c
script "ZSGlassBreak" (void)
{
    ScriptCall("JGP_GlassBreak", "BreakGlassTag", 1, "W_273", 50, 5, "misc/breakglass", "Blood");
}
```

This script will perform the glass break function on all linedefs with the tag 1. The line's texture will change to W_273, it'll spawn 50 debris with horizontal speed of up to 5, it'll play the sound "misc/breakglass", and it'll spawn Blood actors for debris.

You can apply this script to a switch, or to the lines themselves with "Projectile impact" activation method, or anything else. You can also apply more arguments to the script to make it more flexible.

Arguments for `ScriptCall()`

1. `"JGP_GlassBreak"` — the name of the class containing the function

2. `"BreakGlassTag"` — the name of the function

3. int — the linedef tag

4. string — the name of the new texture to apply to the linedef after breaking. It'll be applied to both sides. Default: "" (simply removes the texture).

5. int — the number of glass debris to spawn. Default: 20.

6. int — the speed at which the debris will fly from the line. Upon spawning the horizontal speed will be set to a value between x0.5 and x1.0 of this number, and the vertical speed will be x0.5 of the horizontal speed. Default: 5.

7. string — the name of the sound to play on the line when the glass breaks. Default: "GlassShatter" (the default Hexen glass break sound).

8. string — the name of the Actor class to use for debris. If left unspecified (or the actor with that name doesn't exist), the function will spawn particles that have the same texture as the line (but small in size).
