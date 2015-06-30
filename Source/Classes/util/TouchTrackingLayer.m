#import "TouchTrackingLayer.h"
#import "Resource.h"
#import "FileCache.h"
#import "Common.h"
#import "FlashEvery.h"

@implementation TouchTrackingLayer {
    CCMotionStreak *_motion_streak;
    CCSprite *_touch_button;
	BOOL _is_touch_down;
	FlashEvery *_touch_hold_pulse;
	int _hide_touch_hold_pulse_ct;
}

-(id)init{
    self=[super init];
	_motion_streak = [CCMotionStreak streakWithFade:0.15 minSeg:10 width:10 color:[CCColor whiteColor] texture:[Resource get_tex:TEX_BLANK]];
	[self addChild:_motion_streak];
	
	_touch_button = [CCSprite spriteWithTexture:[Resource get_tex:TEX_PARTICLES_SPRITESHEET] rect:[FileCache get_cgrect_from_plist:TEX_PARTICLES_SPRITESHEET idname:@"grey_particle"]];
    [self addChild:_touch_button];
    [_touch_button setOpacity:0];
	
	_touch_hold_pulse = [FlashEvery cons_time:20];
	
    return self;
}


-(void)update:(CCTime)delta {
	[_touch_hold_pulse i_update:dt_scale_get()];
	if (_is_touch_down && _hide_touch_hold_pulse_ct <= 0) {
		_touch_button.scale = drpt(_touch_button.scale, 1, 1/30.0);
		_touch_button.opacity = drpt(_touch_button.opacity, 0.25, 1/30.0);
		if ([_touch_hold_pulse do_flash]) {
			_touch_button.opacity = 1;
			_touch_button.scale = 6;
		}
	} else {
		_touch_button.scale = drpt(_touch_button.scale, 1, 1/20.0);
		_touch_button.opacity = drpt(_touch_button.opacity, 0, 1/20.0);
		if (_hide_touch_hold_pulse_ct > 0) _touch_button.opacity = 0;
	}
	
	if (_hide_touch_hold_pulse_ct > 0) _hide_touch_hold_pulse_ct--;
}

-(void)hide_touch_hold_pulse {
	_hide_touch_hold_pulse_ct = 2;
}

-(void)touch_begin:(CGPoint)pt {
	_is_touch_down = YES;
	[_motion_streak reset];
	_touch_button.opacity = 1;
	_touch_button.scale = 6;
	[_touch_button setPosition:pt];
	[_motion_streak setPosition:pt];
}
-(void)touch_move:(CGPoint)pt {
	_is_touch_down = YES;
	_touch_button.opacity = 1;
	[_touch_button setPosition:pt];
	[_motion_streak setPosition:pt];
}
-(void)touch_end:(CGPoint)pt {
	_is_touch_down = NO;
	//[_motion_streak reset];
}

@end
