#import "Particle.h"
@class SPCCTimedSpriteAnimator;
@interface RotateFadeOutParticle : Particle
+(RotateFadeOutParticle*)cons_tex:(CCTexture*)tex rect:(CGRect)rect;
-(RotateFadeOutParticle*)set_ctmax:(float)ctmax;
-(RotateFadeOutParticle*)set_vr:(float)vr;
-(RotateFadeOutParticle*)set_render_ord:(int)tar;
-(RotateFadeOutParticle*)set_scale_min:(float)scmin max:(float)scmax;
-(RotateFadeOutParticle*)set_vel:(CGPoint)vel;
-(RotateFadeOutParticle*)set_gravity:(float)gravity;
-(RotateFadeOutParticle*)set_alpha_start:(float)start end:(float)end;
-(RotateFadeOutParticle*)set_timed_sprite_animator:(SPCCTimedSpriteAnimator*)animator;
@end
