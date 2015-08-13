
#import "Player.h"
#import "Common.h"
#import "Resource.h"
#import "FileCache.h"
#import "GameEngineScene.h"
#import "GameMain.h"

#import "SpriterNode.h"
#import "SpriterJSONParser.h"
#import "SpriterData.h"

#import "CCTexture_Private.h"
#import "ControlManager.h"

#import "PlayerSharedParams.h"
#import "OnGroundPlayerStateStack.h"

#import "AlphaGradientSprite.h"
#import "SPCCSpriteAnimator.h"
#import "InAirPlayerStateStack.h"

#import "BGCharacterPlayer.h"

#import "GameUI.h"

@implementation Player {
	SpriterNode *_img;
	CCNode *_swordplant_streak_root;
	CCSprite *_divereturn_behind_trail;
	CCNode *_arrow_charged_flash_root;
	CCSprite *_swordplant_behind_trail;
	NSString *_current_playing;
	NSString *_on_finish_play_anim;
	
	PlayerSharedParams *_player_shared_params;
	NSMutableArray *_player_state_stack;
	
	BGCharacterPlayer *_dialogue_character;
}

+(Player*)cons_g:(GameEngineScene*)g {
	return [[Player node] cons_g:g];
}
-(Player*)cons_g:(GameEngineScene*)g {
    _player_shared_params = [PlayerSharedParams cons];
	_player_state_stack = [NSMutableArray array];
	
	SpriterData *data = [SpriterData cons_data_from_spritesheetreaders:@[
		[SpriterJSONParser cons_texture:[Resource get_tex:TEX_SPRITER_CHAR_HANOKA_PLAYER] file:@"hanoka_player.json"],
		[SpriterJSONParser cons_texture:[Resource get_tex:TEX_SPRITER_CHAR_HANOKA_BOW] file:@"hanoka_bow.json"],
		[SpriterJSONParser cons_texture:[Resource get_tex:TEX_SPRITER_CHAR_HANOKA_SWORD] file:@"hanoka_sword.json"],
	] scml:@"hanoka_player.scml"];
	
	//[data replace_atlas_index:0 with:[SpriterJSONParser cons_texture:[Resource get_tex:TEX_SPRITER_CHAR_HANOKA_PLAYER_REDGARB] file:@"hanoka_player_redgarb.json"]];
	
	_img = [SpriterNode nodeFromData:data render_size:ccp(180,320)];
	[_img set_render_placement:ccp(0.5,0.3)];
	[_img playAnim:@"Idle" repeat:YES];
	[_img setScale:0.225];
	[self addChild:_img z:1];
	
	[self cons_swordplant_streak];
	_arrow_charged_flash_root = [CCSprite node];
	
	[_arrow_charged_flash_root runAction:animaction_cons(string_dofor_format(6, ^(int i){return strf("arrow_charge_start_%d.png",i);}), 0.05, TEX_EFFECTS_HANOKA)];
	[_arrow_charged_flash_root setScale:0.4];
	[_arrow_charged_flash_root setOpacity:0.8];
	[_arrow_charged_flash_root setPosition:ccp(13,7)];
	[self addChild:_arrow_charged_flash_root];
	
	self.position = ccp(game_screen_pct(0.5, 0).x,g.DOCK_HEIGHT);
	[g set_camera_height:150];
	[self push_state_stack:[IdlePlayerStateStack cons]];
	[self push_state_stack:[OnGroundPlayerStateStack cons:g]];
	
	_player_shared_params._calc_accel_x_pos = game_screen().width/2;
	_player_shared_params._reset_to_center = YES;
	
	_dialogue_character = [BGCharacterPlayer cons:g];
	
	return self;
}

-(BGCharacterBase*)get_player_dialogue_character {
	return _dialogue_character;
}

-(void)pop_state_stack:(GameEngineScene*)g {
	if (_player_state_stack.count > 0) {
		BasePlayerStateStack *state_stack_top = [_player_state_stack objectAtIndex:0];
		[state_stack_top on_state_end:g];
		[_player_state_stack removeObjectAtIndex:0];
	}
}
-(void)push_state_stack:(BasePlayerStateStack*)item {
	[_player_state_stack insertObject:item atIndex:0];
}

-(void)cons_swordplant_streak {
	_swordplant_streak_root = [CCNode node];
	[self addChild:_swordplant_streak_root];
	AlphaGradientSprite *streak_left = [AlphaGradientSprite cons_tex:[Resource get_tex:TEX_EFFECTS_HANOKA]
															 texrect:[FileCache get_cgrect_from_plist:TEX_EFFECTS_HANOKA idname:@"sword_plant_energy_000.png"]
																size:CGSizeMake(21*1.5, 83*1.5)
														 anchorPoint:ccp(0.5,0)
															   color:[CCColor whiteColor]
															  alphaX:CGRangeMake(1, 1)
															  alphaY:CGRangeMake(0.8, 0)];
	[streak_left setPosition:ccp(-15,-20)];
	[streak_left setScaleX:-1];
	[_swordplant_streak_root addChild:streak_left];
	SPCCSpriteAnimator *streak_left_animate = [SPCCSpriteAnimator cons_target:streak_left speed:2.15];
	[streak_left_animate add_frame:[FileCache get_cgrect_from_plist:TEX_EFFECTS_HANOKA idname:@"sword_plant_energy_000.png"]];
	[streak_left_animate add_frame:[FileCache get_cgrect_from_plist:TEX_EFFECTS_HANOKA idname:@"sword_plant_energy_001.png"]];
	[streak_left_animate add_frame:[FileCache get_cgrect_from_plist:TEX_EFFECTS_HANOKA idname:@"sword_plant_energy_002.png"]];
	[streak_left addChild:streak_left_animate];
	
	AlphaGradientSprite *streak_right = [AlphaGradientSprite cons_tex:[Resource get_tex:TEX_EFFECTS_HANOKA]
															 texrect:[FileCache get_cgrect_from_plist:TEX_EFFECTS_HANOKA idname:@"vfx_swordplant_0.png"]
																size:CGSizeMake(21*1.5, 83*1.5)
														 anchorPoint:ccp(0.5,0)
															   color:[CCColor whiteColor]
															  alphaX:CGRangeMake(1, 1)
															  alphaY:CGRangeMake(0.8, 0)];
	[streak_right setPosition:ccp(15,-20)];
	[streak_right setScaleX:1];
	[_swordplant_streak_root addChild:streak_right];
	SPCCSpriteAnimator *streak_right_animate = [SPCCSpriteAnimator cons_target:streak_right speed:1.75];
	[streak_right_animate add_frame:[FileCache get_cgrect_from_plist:TEX_EFFECTS_HANOKA idname:@"sword_plant_energy_000.png"]];
	[streak_right_animate add_frame:[FileCache get_cgrect_from_plist:TEX_EFFECTS_HANOKA idname:@"sword_plant_energy_001.png"]];
	[streak_right_animate add_frame:[FileCache get_cgrect_from_plist:TEX_EFFECTS_HANOKA idname:@"sword_plant_energy_002.png"]];
	[streak_right addChild:streak_right_animate];
	[_swordplant_streak_root setVisible:NO];
	
	_swordplant_behind_trail = [CCSprite spriteWithTexture:[Resource get_tex:TEX_EFFECTS_HANOKA] rect:[FileCache get_cgrect_from_plist:TEX_EFFECTS_HANOKA idname:@"sword_stab-fall-air.png"]];
	[_swordplant_behind_trail set_anchor_pt:ccp(0.5,0)];
	[_swordplant_behind_trail setScale:0.3];
	[_swordplant_behind_trail setOpacity:0.0];
	[self addChild:_swordplant_behind_trail];
	
	_divereturn_behind_trail = [CCSprite spriteWithTexture:[Resource get_tex:TEX_EFFECTS_HANOKA] rect:[FileCache get_cgrect_from_plist:TEX_EFFECTS_HANOKA idname:@"sword_stab-fall-air.png"]];
	[_divereturn_behind_trail set_anchor_pt:ccp(0.5,0)];
	[_divereturn_behind_trail setScale:0.3];
	[_divereturn_behind_trail setOpacity:0.0];
	[_divereturn_behind_trail setRotation:180];
	[self addChild:_divereturn_behind_trail];
}

-(void)i_update:(GameEngineScene*)g {
	if (self.get_player_state == PlayerState_OnGround && [g.player.get_top_state on_land:g]) {
		[self setZOrder:GameAnchorZ_Player];
	} else {
		[self setZOrder:GameAnchorZ_Player_Out];
	}
	
	
	if (!_img.current_anim_repeating && _img.current_anim_finished && _on_finish_play_anim != NULL) {
		[_img playAnim:_on_finish_play_anim repeat:YES];
		_on_finish_play_anim = NULL;
	}
	
	[[self get_top_state] i_update:g];
	
	BasePlayerStateStack *top_ele = self.get_top_state;
	
	[_swordplant_streak_root setVisible:NO];
	[_arrow_charged_flash_root setVisible:NO];
	
	if (top_ele.cond_get_inair_combat_params != NULL) {
		PlayerAirCombatParams *air_params = top_ele.cond_get_inair_combat_params;
		if (air_params._hold_ct >= air_params.ARROW_AIM_TIME && g.get_control_manager.this_touch_can_proc_tap) {
			[_arrow_charged_flash_root setVisible:YES];
			[_arrow_charged_flash_root setPosition:ccp(-signum(_img.scaleX)*ABS(_arrow_charged_flash_root.position.x),7)];
		}
		if (air_params._sword_out) {
			_swordplant_behind_trail.opacity = drpt(_swordplant_behind_trail.opacity, 0.7, 1/7.0);
			_swordplant_behind_trail.rotation = 0;
			[_swordplant_streak_root setVisible:YES];
			[_swordplant_behind_trail setVisible:YES];
		} else {
			_swordplant_behind_trail.opacity = 0;
		}
	} else {
		
		_swordplant_behind_trail.opacity = 0;
	}
	
	float tar_divereturn_behind_trail_opacity = 0;
	if (top_ele.cond_get_underwater_combat_params != NULL) {
		if (top_ele.cond_get_underwater_combat_params._vel.y >= 10) {
			tar_divereturn_behind_trail_opacity = 0.7;
		}
	}
	_divereturn_behind_trail.opacity = drpt(_divereturn_behind_trail.opacity, tar_divereturn_behind_trail_opacity, 1/7.0);
}

-(void)play_anim:(NSString*)anim repeat:(BOOL)repeat {
	_on_finish_play_anim = NULL;
	if(_current_playing != anim) {
		_current_playing = anim;
		[_img playAnim:anim repeat:repeat];
	}
}

-(void)play_anim:(NSString*)anim1 on_finish_anim:(NSString*)anim2 {
	_current_playing = anim1;
	[_img playAnim:anim1 repeat:NO];
	_on_finish_play_anim = anim2;
}

//mapped move direction+value
float accel_x_move_val(GameEngineScene *g, float from_val) {
	return clampf(
		((game_screen().width/2 + g.get_control_manager.get_frame_accel_x_vel * game_screen().width) - from_val) * .07 ,
		-7 , 7)
		* dt_scale_get();
}
//move get next mapped accel position (TOFIX: MODIFIES FIELDS WHEN drps to center)
-(float)get_next_update_accel_x_position:(GameEngineScene*)g {
	float target_delta = accel_x_move_val(g, _player_shared_params._calc_accel_x_pos);
	_player_shared_params._calc_accel_x_pos += target_delta;
	if (_player_shared_params._reset_to_center) {
		_player_shared_params._s_pos = ccp(
			drpt(_player_shared_params._s_pos.x, _player_shared_params._calc_accel_x_pos, 1/10.0),
			_player_shared_params._s_pos.y
		);
	}
	return clampf(
		_player_shared_params._reset_to_center?_player_shared_params._s_pos.x:_player_shared_params._s_pos.x + target_delta,
		0,
		game_screen().width
	);
}
//get how much next mapped accel will move
-(float)get_next_update_accel_x_position_delta:(GameEngineScene*)g {
	return accel_x_move_val(g,_player_shared_params._calc_accel_x_pos);
}
//move to next mapped accel position
-(void)update_accel_x_position:(GameEngineScene*)g {
	float x_pos = [self get_next_update_accel_x_position:g];
	_player_shared_params._s_pos = ccp(x_pos,_player_shared_params._s_pos.y);
	self.position = ccp(_player_shared_params._s_pos.x,self.position.y);
}

//set real position to value in _s_pos (screen position)
-(void)apply_s_pos:(GameEngineScene*)g {
	self.position = CGPointAdd(
		_player_shared_params._s_pos,
		ccp(g.get_viewbox.x1,g.get_viewbox.y1)
	);
}
//set _s_pos to current position
-(void)read_s_pos:(GameEngineScene*)g {
	_player_shared_params._s_pos = CGPointSub(
		self.position,
		ccp(g.get_viewbox.x1,g.get_viewbox.y1)
	);
}

-(PlayerState)get_player_state {
	return [self get_top_state].get_state;
}
-(BasePlayerStateStack*)get_top_state {
	return [_player_state_stack objectAtIndex:0];
}

-(PlayerSharedParams*)shared_params { return _player_shared_params; }
-(SpriterNode*)img { return _img; }

-(BOOL)is_underwater:(GameEngineScene *)g {
	return (self.get_player_state == PlayerState_DiveReturn && g.get_current_camera_center_y < 0) ||
	(self.position.y < 0 && self.get_player_state != PlayerState_InAir);
}

-(CGPoint)get_size { return ccp(40,130); }
-(HitRect)get_hit_rect {
	SATPoly poly;
	[self get_sat_poly:&poly];
	return SAT_poly_to_bounding_hitrect(&poly,ccp(-10,-10),ccp(10,10));
}
-(void)get_sat_poly:(SATPoly*)in_poly {
	satpolyowner_cons_sat_poly_with_basis_offset(in_poly, self.position, self.rotation, self.get_size.x, self.get_size.y, ccp(1,1),0.25,ccp(10,0));
}
-(CGPoint)get_center {
	HitRect hitrect = [self get_hit_rect];
	return ccp((hitrect.x1+hitrect.x2)/2, (hitrect.y1+hitrect.y2)/2);
}

@end
