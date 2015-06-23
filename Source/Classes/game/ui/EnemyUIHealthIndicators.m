//
//  EnemyUIHealthIndicators.m
//  hanokam
//
//  Created by spotco on 23/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "EnemyUIHealthIndicators.h"
#import "AirEnemyManager.h"
#import "GameEngineScene.h"
#import "HealthBar.h"

@implementation EnemyUIHealthIndicators {
	NSMutableDictionary *_enemy_health_bars;
}

+(EnemyUIHealthIndicators*)cons:(GameEngineScene*)g {
	return [[EnemyUIHealthIndicators node] cons:g];
}

-(EnemyUIHealthIndicators*)cons:(GameEngineScene*)g {
	_enemy_health_bars = [NSMutableDictionary dictionary];
	
	return self;
}

-(void)i_update:(GameEngineScene*)g {
	NSMutableSet *active_enemy_objhash = _enemy_health_bars.keySet;
	for (BaseAirEnemy *itr_enemy in g.get_air_enemy_manager.get_enemies) {
		if (![itr_enemy should_show_health_bar]) continue;
		NSNumber *itr_hash = @([itr_enemy hash]);
		if ([active_enemy_objhash containsObject:itr_hash]) {
			[active_enemy_objhash removeObject:itr_hash];
		} else {
			_enemy_health_bars[itr_hash] = [HealthBar cons_pooled_size:CGSizeMake(20, 4) anchor:ccp(0.5,0.5)];
			[self addChild:_enemy_health_bars[itr_hash]];
		}
		HealthBar *itr_healthbar = _enemy_health_bars[itr_hash];
		[itr_healthbar setPosition:CGPointAdd([itr_enemy convertToWorldSpace:CGPointZero],[itr_enemy get_healthbar_offset])];
		[itr_healthbar set_pct:[itr_enemy get_health_pct]];
	}
	
	for (NSNumber *itr_hash in active_enemy_objhash) {
		HealthBar *itr_healthbar = _enemy_health_bars[itr_hash];
		[self removeChild:itr_healthbar];
		[_enemy_health_bars removeObjectForKey:itr_hash];
		[itr_healthbar repool];
	}
}

@end
