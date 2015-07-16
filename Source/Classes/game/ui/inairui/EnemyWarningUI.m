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
@implementation EnemyWarningUIIcon
+(EnemyWarningUIIcon*)cons { return [[EnemyWarningUIIcon node] cons]; }
-(EnemyWarningUIIcon*)cons {
	[self setTexture:[Resource get_tex:TEX_EFFECTS_ENEMY]];
	[self setTextureRect:[FileCache get_cgrect_from_plist:TEX_EFFECTS_ENEMY idname:@"Enemy Warning.png"]];
	[self i_update:0];
	return self;
}
-(void)i_update:(float)t {
	if (t <= 0) {
		self.scale = 4 * 0.25;
		self.opacity = 0;
	} else if (t <= 0.8) {
		self.scale = drpt(self.scale, 1*0.25, 1/4.0);
		self.opacity = drpt(self.opacity, 0.7, 1/5.0);
	} else {
		self.scale = drpt(self.scale, 2*0.25, 1/4.0);
		self.opacity = drpt(self.opacity, 0, 1/5.0);
	}
}
-(void)setPosition:(CGPoint)position {
	[super setPosition:CGPointAdd(position, ccp(float_random(-1, 1),float_random(-1, 1)))];
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
		[itr_healthbar i_update:(1-itr_enemy.get_ct/itr_enemy.get_ctmax)];
	}
	
	for (NSNumber *itr_hash in active_enemy_objhash) {
		EnemyWarningUIIcon *itr_healthbar = _enemy_future_spawns[itr_hash];
		[self removeChild:itr_healthbar];
		[_enemy_future_spawns removeObjectForKey:itr_hash];
	}
}
@end
