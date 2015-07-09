//
//  PlayerSharedParams.m
//  hanokam
//
//  Created by spotco on 06/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "PlayerSharedParams.h"
#import "GameEngineScene.h"
#import "GEventDispatcher.h"

@implementation PlayerSharedParams {
    float _current_health;
    int _max_health;
    
    float _current_breath;
    int _max_breath;
}
@synthesize _s_pos;
@synthesize _calc_accel_x_pos;
@synthesize _reset_to_center;

+(PlayerSharedParams*)cons { return [[[PlayerSharedParams alloc] init] cons]; }
-(PlayerSharedParams*)cons {
    _max_health = 3;
    _current_health = _max_health;
    
    _max_breath = 600;
    _current_breath = _max_breath;
    return self;
}

-(void)set_health:(float)val { _current_health = val; }
-(void)add_health:(float)val g:(GameEngineScene*)g {
    _current_health += val;
    [g.get_event_dispatcher push_event:[GEvent cons_context:g type:GEventType_PlayerHealthHeal]];
}
-(int)get_max_health { return _max_health; }
-(float)get_current_health { return _current_health; }

-(float)get_current_breath { return _current_breath; }
-(void)set_breath:(float)val { _current_breath = val; }
-(float)get_max_breath { return _max_breath; }

@end
