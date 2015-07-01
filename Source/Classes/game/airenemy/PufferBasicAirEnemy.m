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

#import "EnemyBulletProjectile.h"
#import "PufferEnemySprite.h"

@implementation PufferBasicAirEnemy {
	PufferEnemySprite *_img;
	int _angry_ct;
	
	ccColor4F _tar_color;
	FlashCount *_flashcount;
	
	BOOL _started_death;
	BOOL _has_played_blood_anim;
	
	BOOL _has_shot_bullets;
}

+(PufferBasicAirEnemy*)cons_g:(GameEngineScene*)g relstart:(CGPoint)relstart relend:(CGPoint)relend {
	return (PufferBasicAirEnemy*)[[PufferBasicAirEnemy node] cons_g:g relstart:relstart relend:relend];
}

-(void)hit:(GameEngineScene*)g params:(PlayerHitParams *)params {
	[super hit:g params:params];
	[_flashcount reset];
}

-(BasicAirEnemy*)cons_g:(GameEngineScene*)g relstart:(CGPoint)relstart relend:(CGPoint)relend {
	[super cons_g:g relstart:relstart relend:relend];
	
	_img = [PufferEnemySprite cons];
	[self addChild:_img];
	
	_started_death = NO;
	_has_played_blood_anim = NO;
	
	_tar_color = ccc4f(1.0, 1.0, 1.0, 1.0);
	
	_flashcount = [FlashCount cons];
	[_flashcount add_flash_at_times:@[@150,@135,@120,@100,@80,@60,@40,@20,@10]];
	
	_has_shot_bullets = NO;
	
	return self;
}

-(void)update_death:(GameEngineScene *)g {
	[_img update_playAnim:_img._anim_die];
	_started_death = YES;
	if ([self get_death_anim_ct] < 20 && !_has_played_blood_anim) {
		[BaseAirEnemy particle_blood_effect:g pos:self.position ct:10];
		_has_played_blood_anim = YES;
	}
}

-(void)update_stunned:(GameEngineScene *)g {
	[_img update_playAnim:_img._anim_hurt];
	_angry_ct = 50;
	if ([_flashcount do_flash_given_time:[self get_stunned_anim_ct]]) {
		_tar_color.b = 0.0;
		_tar_color.g = 0.0;
	}
}

-(void)i_update:(GameEngineScene *)game {
	[super i_update:game];
	[_img setColor4f:_tar_color];
	_tar_color.b = drpt(_tar_color.b, 1.0, 1/20.0);
	_tar_color.g = drpt(_tar_color.g, 1.0, 1/25.0);
}

-(void)update_alive:(GameEngineScene *)g {
	if (_angry_ct > 0) {
		[_img update_playAnim:_img._anim_follow];
		_angry_ct -= dt_scale_get();
		
	} else if (CGPointDist(self.position, g.player.position) < 150) {
		[_img update_playAnim:_img._anim_attack];
		
	} else {
		[_img update_playAnim:_img._anim_idle];
	}
	
	if ([self get_anim_t] > 0.25 && CGPointDist(self.position, g.player.position) > 100 && !_has_shot_bullets) {
		float start_dir = float_random(-3.14, 3.14);
		float add_dir = 0;
		while (add_dir < 3.14*2) {
			Vec3D vel_vec = vec_cons_norm(cosf(start_dir+add_dir), sinf(start_dir+add_dir), 0);
			vec_scale_m(&vel_vec, 2);
			[g add_enemy_projectile:[EnemyBulletProjectile cons_pos:self.position vel:vel_vec g:g]];
			add_dir += (3.14*2)/(6.0);
		}
		_has_shot_bullets = YES;
	}
}

-(CGPoint)get_healthbar_offset { return ccp(0,30); }
-(BOOL)should_show_health_bar { return !_started_death && [super should_show_health_bar]; }

-(BOOL)arrow_drop_all {
	return (_started_death && [self get_death_anim_ct] < 20);
}

-(HitRect)get_hit_rect { return [_img get_hit_rect_pos:self.position]; }
-(void)get_sat_poly:(SATPoly*)in_poly { return [_img get_sat_poly:in_poly pos:self.position rot:self.rotation]; }

@end
