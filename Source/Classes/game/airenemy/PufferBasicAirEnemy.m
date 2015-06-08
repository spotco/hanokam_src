//
//  PufferBasicAirEnemy.m
//  hobobob
//
//  Created by spotco on 17/05/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "PufferBasicAirEnemy.h"
#import "Resource.h" 
#import "FileCache.h"
#import "GameEngineScene.h" 
#import "Player.h"
#import "FlashCount.h"

@implementation PufferBasicAirEnemy {
	CCSprite_Animated *_img;
	
	CCAction *_anim_idle, *_anim_attack, *_anim_die, *_anim_follow, *_anim_hurt;
	int _angry_ct;
	
	ccColor4F _tar_color;
	FlashCount *_flashcount;
}

+(PufferBasicAirEnemy*)cons_g:(GameEngineScene*)g relstart:(CGPoint)relstart relend:(CGPoint)relend {
	return (PufferBasicAirEnemy*)[[PufferBasicAirEnemy node] cons_g:g relstart:relstart relend:relend];
}

-(void)hit_projectile:(GameEngineScene*)g {
	[super hit_projectile:g];
	[_flashcount reset];
}

-(BasicAirEnemy*)cons_g:(GameEngineScene*)g relstart:(CGPoint)relstart relend:(CGPoint)relend {
	[super cons_g:g relstart:relstart relend:relend];
	
	[self cons_anims];
	_img = [CCSprite_Animated node];
	[self addChild:_img];
	[_img update_playAnim:_anim_idle];
	[_img setScale:0.35];
	
	_tar_color = ccc4f(1.0, 1.0, 1.0, 1.0);
	
	_flashcount = [FlashCount cons];
	[_flashcount add_flash_at_times:@[@150,@135,@120,@100,@80,@60,@40,@20,@10]];
	
	return self;
}

-(void)update_death:(GameEngineScene *)g {
	[_img update_playAnim:_anim_die];
}

-(void)update_stunned:(GameEngineScene *)g {
	[_img update_playAnim:_anim_hurt];
	_angry_ct = 50;
	if ([_flashcount do_flash_given_time:[self get_stunned_anim_ct]]) {
		_tar_color.b = 0.0;
		_tar_color.g = 0.0;
	}
}

-(void)i_update:(GameEngineScene *)game {
	[super i_update:game];
	[_img setColor4f:_tar_color];
	_tar_color.b = drp(_tar_color.b, 1.0, 20.0);
	_tar_color.g = drp(_tar_color.g, 1.0, 25.0);
}

-(void)update_alive:(GameEngineScene *)g {
	if (_angry_ct > 0) {
		[_img update_playAnim:_anim_follow];
		_angry_ct -= dt_scale_get();
		
	} else if (CGPointDist(self.position, g.player.position) < 150) {
		[_img update_playAnim:_anim_attack];
		
	} else {
		[_img update_playAnim:_anim_idle];
	
	}
}

-(void)cons_anims {
	NSMutableArray *anim_strs = [NSMutableArray array];
	float anim_interval = 0.055;
	
	DO_FOR(27, [anim_strs addObject:strf("puffer_idle__%03d.png",i)]; );
	_anim_idle = animaction_cons(anim_strs, anim_interval, TEX_ENEMY_PUFFER);
	[anim_strs removeAllObjects];
	
	DO_FOR(5, [anim_strs addObject:strf("puffer_attack__%03d.png",i)]; );
	_anim_attack = animaction_cons(anim_strs, anim_interval, TEX_ENEMY_PUFFER);
	[anim_strs removeAllObjects];
	
	DO_FOR(14, [anim_strs addObject:strf("puffer_die__%03d.png",i)]; );
	_anim_die = animaction_nonrepeating_cons(anim_strs, anim_interval, TEX_ENEMY_PUFFER);
	[anim_strs removeAllObjects];
	
	DO_FOR(5, [anim_strs addObject:strf("puffer_follow__%03d.png",i)]; );
	_anim_follow = animaction_cons(anim_strs, anim_interval, TEX_ENEMY_PUFFER);
	[anim_strs removeAllObjects];
	
	DO_FOR(5, [anim_strs addObject:strf("puffer_hurt__%03d.png",i)]; );
	_anim_hurt = animaction_cons(anim_strs, anim_interval * 1.25, TEX_ENEMY_PUFFER);
	[anim_strs removeAllObjects];
}

-(HitRect)get_hit_rect {
	CGRect rect = [FileCache get_cgrect_from_plist:TEX_ENEMY_PUFFER idname:@"puffer_idle__000.png"];
	return satpolyowner_cons_hit_rect(self.position, rect.size.width, rect.size.height);
}
-(void)get_sat_poly:(SATPoly*)in_poly {
	CGRect rect = [FileCache get_cgrect_from_plist:TEX_ENEMY_PUFFER idname:@"puffer_idle__000.png"];
	return satpolyowner_cons_sat_poly(in_poly, self.position, self.rotation, rect.size.width, rect.size.height, ccp(0.5,0.9));
}

@end
