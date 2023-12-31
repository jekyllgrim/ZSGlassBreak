class JGP_GlassBreak play
{
	static void BreakGlassTag(int lineID, string newTex = "", int numDebris = 20, int speed = 5, string snd = "GlassShatter", string debristype = "")
	{
		for (int i = 0; i < Level.Lines.Size(); i++)
		{
			Line l = Level.Lines[i];
			if (l)
			{
				int id;
				for (int i = 0; (id = l.GetID(i)) != 0; i++)
				{
					if (id == lineID)
					{
						BreakGlassLine(l, newTex, numDebris, speed, snd, debristype);
						break;
					}
				}
			}
		}
	}

	static Line BreakGlassLine(Line l, string newTex = "", int numDebris = 20, int speed = 5, sound snd = "GlassShatter", string debristype = "")
	{
		// This only works on double-sided linedefs:
		Side s1 = l.sideDef[Line.front];
		Side s2 = l.sideDef[Line.back];
		if (!s1 || !s2)
			return null;
		
		Sector sec = l.frontsector;
		if (!sec) 
			return null;

		l.flags &= ~Line.ML_BLOCKING;
		l.flags &= ~Line.ML_BLOCKMONSTERS;
		l.flags &= ~Line.ML_SOUNDBLOCK;
		l.flags &= ~Line.ML_SOUNDBLOCK;
		l.flags &= ~Line.ML_BLOCK_PLAYERS;
		l.flags &= ~Line.ML_BLOCKEVERYTHING;
		l.flags &= ~Line.ML_BLOCKPROJECTILE;
		l.flags &= ~Line.ML_BLOCKUSE;
		l.flags &= ~Line.ML_BLOCKSIGHT;
		l.flags &= ~Line.ML_BLOCKHITSCAN;
		l.flags &= ~Line.ML_3DMIDTEX_IMPASS;

		l.activation &= ~SPAC_Impact;
		l.activation &= ~SPAC_PCross;
		l.activation &= ~SPAC_Push;
		l.activation &= ~SPAC_Damage;

		// Only works on textured linedefs:
		TextureID tex = s1.GetTexture(Side.mid);
		if (tex.isValid())
		{
			vector2 size = TexMan.GetScaledSize(tex);
			double lineAngle = atan2(l.delta.y, l.delta.x) + 90;
			vector2 lineDelta = l.delta;
			vector2 midPos = (l.v1.p + l.v2.p) * 0.5;

			double floorBot = sec.floorplane.ZAtPoint(midpos);
			double ceilingTop = sec.ceilingplane.ZAtPoint(midpos);
			double zOfs = s1.GetTextureYOffset(Side.mid);
			double zScale = s1.GetTextureYScale(Side.mid);
			double textureTop = (size.y) / zscale;
			double textureBot = zOfs / zScale;
			double zTop;
			double zBot;
			// Extend to sector ceiling if this is
			// a wrapped texture:
			if (s1.flags & Side.WALLF_WRAP_MIDTEX)
			{
				zTop = ceilingTop;
				zBot = floorBot;
			}
			// Otherwise do not go above ceiling
			// or the height of the texture:
			else
			{
				zBot = max(floorBot, floorBot + textureBot);
				zTop = min(ceilingTop, zBot + textureTop);
			}

			// Need an actor to play the sound:
			let as = Actor.Spawn("DynamicLight", (midpos, zBot + zTop * 0.5));
			if (as)
			{
				as.A_StartSound(snd);
				as.Destroy();
			}
			
			if (numDebris > 0)
			{
				FSpawnParticleParams junk;
				class<Actor> debris = debristype;
				if (!debristype)
				{
					junk.color1 = "";
					junk.flags = SPF_ROLL|SPF_REPLACE;
					junk.style = STYLE_Normal;
					junk.startalpha = 0.5;
					junk.fadestep = -1;
					junk.accel.z = -Level.Gravity / 800;
					junk.texture = s1.GetTexture(Side.mid);
				}
				for (int i = 0; i < numDebris; i++)
				{
					// Offset alongside the line:
					vector3 junk_pos = (l.v1.p + lineDelta * frandom[gbj](0.1, 0.9), zBot + (zTop - zBot) * frandom[gbj](0.1, 0.9));
					vector3 junk_vel;
					if (speed > 0)
					{
						junk_vel.xy = Actor.RotateVector((speed * (frandom[gbj](0.5, 1.0)), 0), frandompick(lineAngle, lineAngle + 180) + frandom[gbj](-15, 15));
						junk_vel.z = junk.vel.xy.Length() * 0.5;
					}
					if (debris)
					{
						let deb = Actor.Spawn(debris, junk_pos);
						if (deb)
							deb.vel = junk_vel;
					}
					else
					{
						junk.pos = junk_pos;
						junk.vel = junk_vel;
						junk.lifetime = random[gbj](30, 50);
						junk.size = frandom[gbj](3, 10);
						junk.rollvel = frandom[gbj](-15, 15);
						Level.SpawnParticle(junk);
					}
				}
			}
			
			s1.SetTexture(Side.mid, TexMan.CheckForTexture(newTex));
			s2.SetTexture(Side.mid, TexMan.CheckForTexture(newTex));
		}

		return l;
	}
}