#import "WaterEnemyManager.h"
#import "GameEngineScene.h"
#import "PufferBasicWaterEnemy.h"

@implementation BaseWaterEnemy
-(void)i_update:(GameEngineScene*)game{}
-(BOOL)should_remove{return NO;}
-(void)do_remove:(GameEngineScene*)g{}
-(HitRect)get_hit_rect{ return hitrect_cons_xy_widhei(0, 0, 0, 0); }
-(void)get_sat_poly:(SATPoly *)in_poly { }
@end

@implementation WaterEnemyManager {
	NSMutableArray *_enemies;
}

+(WaterEnemyManager*)cons:(GameEngineScene*)g {
	return [[[WaterEnemyManager alloc] init] cons:g];
}
-(WaterEnemyManager*)cons:(GameEngineScene*)g {
	_enemies = [NSMutableArray array];
	
	return self;
}

static NSMutableArray *do_remove;
-(void)i_update:(GameEngineScene*)g {
	for (long i = _enemies.count-1; i >= 0; i--) {
		BaseWaterEnemy *itr = [_enemies objectAtIndex:i];
		[itr i_update:g];
		if ([itr should_remove]) {
			[itr do_remove:g];
			[[g get_anchor] removeChild:itr];
			[do_remove addObject:itr];
		}
	}
	[_enemies removeObjectsInArray:do_remove];
	[do_remove removeAllObjects];
}

-(NSArray*)get_enemies {
	return _enemies;
}

-(void)add_enemy:(BaseWaterEnemy*)enemy game:(GameEngineScene*)g {
	[[g get_anchor] addChild:enemy z:GameAnchorZ_Enemies_Air];
	[_enemies addObject:enemy];
}

-(void)remove_all_enemies:(GameEngineScene*)g {
	for (BaseWaterEnemy *itr in _enemies) {
		[itr do_remove:g];
		[[g get_anchor] removeChild:itr];
	}
	[_enemies removeAllObjects];
}

@end
