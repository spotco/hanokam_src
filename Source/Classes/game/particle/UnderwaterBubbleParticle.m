//
//  UnderwaterBubbleParticle.m
//  hanokam
//
//  Created by Shiny Yang on 6/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "UnderwaterBubbleParticle.h"
#import "Resource.h"
#import "FileCache.h"
#import "GameEngineScene.h"
#import "ObjectPool.h"
#import "Player.h"

@implementation UnderwaterBubbleParticle {
    int _render_ord;
    float _anim_t;
    float _wave_t;
    float _scale_start, _scale_end;
    float _opacity_start, _opacity_end;
    CGPoint _start, _end;
}

+(UnderwaterBubbleParticle*)cons_start:(CGPoint)start end:(CGPoint)end {
    return [[ObjectPool depool:[UnderwaterBubbleParticle class]] cons_start:start end:end];
}

-(UnderwaterBubbleParticle*)cons_start:(CGPoint)start end:(CGPoint)end {
    [self setTexture:[Resource get_tex:TEX_PARTICLES_SPRITESHEET]];
    [self setTextureRect:[FileCache get_cgrect_from_plist:TEX_PARTICLES_SPRITESHEET idname:@"particle_bubble.png"]];
    _render_ord = GameAnchorZ_UnderwaterForegroundElements;
    _anim_t = 0;
    _wave_t = float_random(-3.14, 3.13);
    _start = start;
    _end = end;
    [self set_scale_start:0.2 end:0.8];
    [self set_opacity_start:0.8 end:0.1];
    return self;
}

-(void)i_update:(id)g {
    _anim_t += dt_scale_get() * 0.05;
    _wave_t += dt_scale_get() * 0.05;
    float wave_offset = lerp(0, 20, _anim_t) * sinf(_wave_t);
    [self setPosition:CGPointAdd(lerp_point(_start, _end, _anim_t),ccp(wave_offset,0))];
    [self setOpacity:lerp(_opacity_start, _opacity_end, _anim_t)];
    [self setScale:lerp(_scale_start, _scale_end, _anim_t)];
    if (![((GameEngineScene*)g).player is_underwater:g]) _anim_t = 1;
}

-(UnderwaterBubbleParticle*)set_scale_start:(float)start end:(float)end {
    _scale_start = start;
    _scale_end = end;
    return self;
}
-(UnderwaterBubbleParticle*)set_opacity_start:(float)start end:(float)end {
    _opacity_start = start;
    _opacity_end = end;
    return self;
}

-(BOOL)should_remove {
    return _anim_t >= 1;
}

-(void)do_remove {
    [ObjectPool repool:self class:[UnderwaterBubbleParticle class]];
}

-(int)get_render_ord {
    return _render_ord;
}
@end
