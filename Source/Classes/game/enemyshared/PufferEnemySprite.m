//
//  PufferEnemySprite.m
//  hanokam
//
//  Created by spotco on 01/07/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "PufferEnemySprite.h"
#import "FileCache.h" 
#import "Resource.h"

@implementation PufferEnemySprite
@synthesize _anim_attack,_anim_die,_anim_follow,_anim_hurt,_anim_idle;

+(PufferEnemySprite*)cons {
	return [[PufferEnemySprite node] cons];
}
-(PufferEnemySprite*)cons {
	[self cons_anims];
	[self setScale:0.35];
	[self update_playAnim:_anim_idle];
	return self;
}

-(void)cons_anims {
	NSMutableArray *anim_strs = [NSMutableArray array];
	float anim_interval = 0.055;
	
	DO_FOR(27, [anim_strs addObject:strf("puffer_idle__%03d.png",i)]; );
	self._anim_idle = animaction_cons(anim_strs, anim_interval, TEX_ENEMY_PUFFER);
	[anim_strs removeAllObjects];
	
	DO_FOR(5, [anim_strs addObject:strf("puffer_attack__%03d.png",i)]; );
	self._anim_attack = animaction_cons(anim_strs, anim_interval, TEX_ENEMY_PUFFER);
	[anim_strs removeAllObjects];
	
	DO_FOR(14, [anim_strs addObject:strf("puffer_die__%03d.png",i)]; );
	self._anim_die = animaction_nonrepeating_cons(anim_strs, anim_interval, TEX_ENEMY_PUFFER);
	[anim_strs removeAllObjects];
	
	DO_FOR(5, [anim_strs addObject:strf("puffer_follow__%03d.png",i)]; );
	self._anim_follow = animaction_cons(anim_strs, anim_interval, TEX_ENEMY_PUFFER);
	[anim_strs removeAllObjects];
	
	DO_FOR(5, [anim_strs addObject:strf("puffer_hurt__%03d.png",i)]; );
	self._anim_hurt = animaction_cons(anim_strs, anim_interval * 1.25, TEX_ENEMY_PUFFER);
	[anim_strs removeAllObjects];
}

-(HitRect)get_hit_rect_pos:(CGPoint)pos {
	CGRect rect = [FileCache get_cgrect_from_plist:TEX_ENEMY_PUFFER idname:@"puffer_idle__000.png"];
	return satpolyowner_cons_hit_rect(pos, rect.size.width, rect.size.height,0.25);
}
-(void)get_sat_poly:(SATPoly*)in_poly pos:(CGPoint)pos rot:(float)rot {
	CGRect rect = [FileCache get_cgrect_from_plist:TEX_ENEMY_PUFFER idname:@"puffer_idle__000.png"];
	return satpolyowner_cons_sat_poly(in_poly, pos, rot, rect.size.width, rect.size.height, ccp(0.5,0.9),0.25);
}

@end
