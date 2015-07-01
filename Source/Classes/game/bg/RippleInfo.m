//
//  RippleInfo.m
//  hanokam
//
//  Created by Shiny Yang on 6/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "RippleInfo.h"
#import "GameEngineScene.h"

@implementation RippleInfo {
    float _ct;
    CGPoint _reflected_pos;
    CGPoint _default_pos;
}

-(id)initWithPosition:(CGPoint)pos game:(GameEngineScene*)game {
    self = [super init];
    _ct = 0;
    _default_pos = pos;
    pos.y = (game.REFLECTION_HEIGHT - game.HORIZON_HEIGHT) + pos.y;
    float flip_axis = game.REFLECTION_HEIGHT - game.HORIZON_HEIGHT - 10;
    _reflected_pos = ccp(pos.x,flip_axis - (pos.y - flip_axis));
    return self;
}

-(void)render_reflected:(CCSprite*)proto offset:(CGPoint)offset scymult:(float)scymult {
    [self render:proto pos:CGPointAdd(_reflected_pos,offset) scymult:scymult];
}
-(void)render_default:(CCSprite*)proto offset:(CGPoint)offset scymult:(float)scymult {
    [self render:proto pos:CGPointAdd(_default_pos, offset) scymult:scymult];
}
-(void)render:(CCSprite*)proto pos:(CGPoint)pos scymult:(float)scymult {
    CGPoint pre = proto.position;
    [proto setPosition:pos];
    [proto setScale:lerp(0.55, 1.5, _ct)];
    [proto setScaleY:proto.scale*scymult];
    [proto setOpacity:lerp(1.0, 0, _ct)];
    [proto visit];
    proto.position = pre;
}

-(void)i_update {
    _ct += 0.015 * dt_scale_get();
}

-(BOOL)should_remove {
    return _ct >= 1.0;
}

@end