//
//  EnemyBulletProjectile.m
//  hanokam
//
//  Created by spotco on 25/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "EnemyBulletProjectile.h"
#import "GameEngineScene.h"
#import "PolyLib.h"
#import "Common.h"
#import "Player.h"
#import "GameUI.h"
#import "AirEnemyManager.h"
#import "GEventDispatcher.h"

@implementation EnemyBulletProjectile {
	Vec3D _vel;
	CCSprite *_img;
	
	BOOL _active;
}

+(EnemyBulletProjectile*)cons_pos:(CGPoint)pos vel:(Vec3D)vel g:(GameEngineScene *)g {
	return [[EnemyBulletProjectile node] cons_pos:pos vel:vel g:g];
}

-(EnemyBulletProjectile*)cons_pos:(CGPoint)pos vel:(Vec3D)vel g:(GameEngineScene*)g {
	_img = [CCSprite node];
	[_img runAction:animaction_cons(@[@"bullet_1.png",@"bullet_2.png",@"bullet_3.png"], 0.15, TEX_GAMEPLAY_ELEMENTS)];
	[self addChild:_img];
	
	_vel = vel;
	[self setPosition:pos];
	_active = YES;
	
	return self;
}

-(void)i_update:(id)ig {
	GameEngineScene *g = (GameEngineScene*)ig;
	
	[self setPosition:CGPointAdd(self.position, ccp(_vel.x*dt_scale_get(),_vel.y*dt_scale_get()))];
	
	if (hitrect_touch(self.get_hit_rect, g.player.get_hit_rect) && SAT_polyowners_intersect(self, g.player)) {
		_active = NO;
		[g.get_event_dispatcher push_event:[GEvent cons_context:g type:GEventType_BulletHitPlayer]];
		
	} else if (!hitrect_contains_point([g get_viewbox],self.position)) {
		_active = NO;
	}
}

-(int)get_render_ord {
	return GameAnchorZ_PlayerProjectiles;
}

-(BOOL)should_remove {
	return !_active;
}

-(HitRect)get_hit_rect {
	CGRect rect = [FileCache get_cgrect_from_plist:TEX_GAMEPLAY_ELEMENTS idname:@"bullet_1.png"];
	return satpolyowner_cons_hit_rect(self.position, rect.size.width, rect.size.height,1.5);
}
-(void)get_sat_poly:(SATPoly*)in_poly {
	CGRect rect = [FileCache get_cgrect_from_plist:TEX_GAMEPLAY_ELEMENTS idname:@"bullet_1.png"];
	return satpolyowner_cons_sat_poly(in_poly, self.position, 0, rect.size.width, rect.size.height, ccp(1,1),0.85);
}


@end
