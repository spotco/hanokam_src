//
//  EnemyWarningUI.m
//  hanokam
//
//  Created by spotco on 23/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "EnemyWarningUI.h"
#import "AirEnemyManager.h"
#import "GameEngineScene.h"
#import "Resource.h" 
#import "FileCache.h"

@interface EnemyWarningUIIcon : CCSprite
@end
@implementation EnemyWarningUIIcon {
	float _t;
}
+(EnemyWarningUIIcon*)cons { return [[EnemyWarningUIIcon node] cons]; }
-(EnemyWarningUIIcon*)cons {
	[self setTexture:[Resource get_tex:TEX_HUD_SPRITESHEET]];
	[self setTextureRect:[FileCache get_cgrect_from_plist:TEX_HUD_SPRITESHEET idname:@"alert_icon.png"]];
	[self setScale:0.5];
	[self setOpacity:0.5];
	return self;
}
-(void)i_update:(GameEngineScene*)g {
	_t += 0.25 * dt_scale_get();
	self.opacity = (sin(_t) + 1) / 2.0 * 0.75;
	self.scale = self.opacity * 0.25 + 0.25;
}
@end

@implementation EnemyWarningUI {
	NSMutableDictionary *_enemy_future_spawns;
}

+(EnemyWarningUI*)cons:(GameEngineScene*)g {
	return [[EnemyWarningUI node] cons:g];
}
-(EnemyWarningUI*)cons:(GameEngineScene*)g {
	_enemy_future_spawns = [NSMutableDictionary dictionary];
	return self;
}
-(void)i_update:(GameEngineScene*)g {
	NSMutableSet *active_enemy_objhash = _enemy_future_spawns.keySet;
	for (BaseAirEnemyFutureSpawn *itr_enemy in g.get_air_enemy_manager.get_enemies_future_spawn) {
		NSNumber *itr_hash = @([itr_enemy hash]);
		if ([active_enemy_objhash containsObject:itr_hash]) {
			[active_enemy_objhash removeObject:itr_hash];
		} else {
			_enemy_future_spawns[itr_hash] = [EnemyWarningUIIcon cons];
			[self addChild:_enemy_future_spawns[itr_hash]];
		}
		EnemyWarningUIIcon *itr_healthbar = _enemy_future_spawns[itr_hash];
		[itr_healthbar setPosition:itr_enemy.get_screen_pos];
		[itr_healthbar i_update:g];
	}
	
	for (NSNumber *itr_hash in active_enemy_objhash) {
		EnemyWarningUIIcon *itr_healthbar = _enemy_future_spawns[itr_hash];
		[self removeChild:itr_healthbar];
		[_enemy_future_spawns removeObjectForKey:itr_hash];
	}
}
@end
