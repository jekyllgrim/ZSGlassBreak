# ZScript GlassBreak by Agent_Ash

This small library recreates the [GlassBreak](https://zdoom.org/wiki/GlassBreak) ACS function in a more flexible ZScript variant that is also callable from ACS and allows adjusting the appearance of the effect.

## How to use

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
	ScriptCall("JGP_GlassBreak", "BreakGlassTag", 5);
}
```

This script will perform the glass break function on all linedefs with the tag 5. You can apply this script to a switch, or to the lines themselves with "Projectile impact" activation method, or anything else. You can also apply more arguments to the script to make it more flexible.

This version of the script supports all the same arguments as `BreakGlassLine()`, except the first argument is a line tag instead of a Line pointer (since ACS, obviously, doesn't have those).
