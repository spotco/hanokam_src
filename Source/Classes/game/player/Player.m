
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

#import "GameUI.h"

@implementation Player {
	SpriterNode *_img;
	CCNode *_swordplant_streak_root;
	NSString *_current_playing;
	NSString *_on_finish_play_anim;
	
	PlayerSharedParams *_player_shared_params;
	NSMutableArray *_player_state_stack;
		
	float _current_health;
	int _max_health;
}

+(Player*)cons_g:(GameEngineScene*)g {
	return [[Player node] cons_g:g];
}
-(Player*)cons_g:(GameEngineScene*)g {
	_player_shared_params = [[PlayerSharedParams alloc] init];
	_player_state_stack = [NSMutableArray array];
	
	_img = [SpriterNode nodeFromData:[FileCache spriter_scml_data_from_file:@"hanokav2.scml" json:@"hanokav2.json" texture:[Resource get_tex:TEX_SPRITER_CHAR_HANOKA_V2]]];
	[self play_anim:@"idle" repeat:YES];
	[self addChild:_img z:1];
	
	[self cons_swordplant_streak];
	
	self.position = ccp(game_screen_pct(0.5, 0).x,g.DOCK_HEIGHT);
	[g set_camera_height:150];
	[self push_state_stack:[IdlePlayerStateStack cons]];
	[self push_state_stack:[OnGroundPlayerStateStack cons:g]];
	
	[_img set_scale:0.25];
	
	_player_shared_params._calc_accel_x_pos = game_screen().width/2;
	_player_shared_params._reset_to_center = YES;
	
	_max_health = 3;
	_current_health = _max_health;
	
	return self;
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
	AlphaGradientSprite *streak_left = [AlphaGradientSprite cons_tex:[Resource get_tex:TEX_GAMEPLAY_ELEMENTS]
															 texrect:[FileCache get_cgrect_from_plist:TEX_GAMEPLAY_ELEMENTS idname:@"vfx_swordplant_0.png"]
																size:CGSizeMake(21*1.5, 83*1.5)
														 anchorPoint:ccp(0.5,0)
															   color:[CCColor whiteColor]
															  alphaX:CGRangeMake(1, 1)
															  alphaY:CGRangeMake(0.8, 0)];
	[streak_left setPosition:ccp(-15,-20)];
	[_swordplant_streak_root addChild:streak_left];
	SPCCSpriteAnimator *streak_left_animate = [SPCCSpriteAnimator cons_target:streak_left speed:4.12];
	[streak_left_animate add_frame:[FileCache get_cgrect_from_plist:TEX_GAMEPLAY_ELEMENTS idname:@"vfx_swordplant_0.png"]];
	[streak_left_animate add_frame:[FileCache get_cgrect_from_plist:TEX_GAMEPLAY_ELEMENTS idname:@"vfx_swordplant_1.png"]];
	[streak_left_animate add_frame:[FileCache get_cgrect_from_plist:TEX_GAMEPLAY_ELEMENTS idname:@"vfx_swordplant_2.png"]];
	[streak_left addChild:streak_left_animate];
	
	AlphaGradientSprite *streak_right = [AlphaGradientSprite cons_tex:[Resource get_tex:TEX_GAMEPLAY_ELEMENTS]
															 texrect:[FileCache get_cgrect_from_plist:TEX_GAMEPLAY_ELEMENTS idname:@"vfx_swordplant_0.png"]
																size:CGSizeMake(21*1.5, 83*1.5)
														 anchorPoint:ccp(0.5,0)
															   color:[CCColor whiteColor]
															  alphaX:CGRangeMake(1, 1)
															  alphaY:CGRangeMake(0.8, 0)];
	[streak_right setPosition:ccp(15,-20)];
	[streak_right setScaleX:-1];
	[_swordplant_streak_root addChild:streak_right];
	SPCCSpriteAnimator *streak_right_animate = [SPCCSpriteAnimator cons_target:streak_right speed:3.75];
	[streak_right_animate add_frame:[FileCache get_cgrect_from_plist:TEX_GAMEPLAY_ELEMENTS idname:@"vfx_swordplant_1.png"]];
	[streak_right_animate add_frame:[FileCache get_cgrect_from_plist:TEX_GAMEPLAY_ELEMENTS idname:@"vfx_swordplant_2.png"]];
	[streak_right_animate add_frame:[FileCache get_cgrect_from_plist:TEX_GAMEPLAY_ELEMENTS idname:@"vfx_swordplant_0.png"]];
	[streak_right addChild:streak_right_animate];
	[self swordplant_streak_set_visible:NO];
}

-(void)swordplant_streak_set_visible:(BOOL)tar { _swordplant_streak_root.visible = tar; }

-(void)set_health:(float)val { _current_health = val; }
-(void)add_health:(float)val g:(GameEngineScene*)g {
	_current_health += val;
	[g.get_ui pulse_heart_lastfill];
}
-(int)get_max_health { return _max_health; }
-(float)get_current_health { return _current_health; }

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
		((160 + g.get_control_manager.get_frame_accel_x_vel * 320) - from_val) * .07 ,
		-7 , 7)
		* dt_scale_get();
}
//move get next mapped accel position (TOFIX: MODIFIES FIELDS WHEN drps to center)
-(float)get_next_update_accel_x_position:(GameEngineScene*)g {
	float target_delta = accel_x_move_val(g, _player_shared_params._calc_accel_x_pos);
	_player_shared_params._calc_accel_x_pos += target_delta;
	if (_player_shared_params._reset_to_center) {
		_player_shared_params._s_pos = ccp(
			drp(_player_shared_params._s_pos.x, _player_shared_params._calc_accel_x_pos, 10),
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
	return self.position.y < 0 && self.get_player_state != PlayerState_InAir;
}

-(CGPoint)get_size { return ccp(40,130); }
-(HitRect)get_hit_rect {
	return satpolyowner_cons_hit_rect(self.position, self.get_size.x, self.get_size.y);
}
-(void)get_sat_poly:(SATPoly*)in_poly {
	return satpolyowner_cons_sat_poly(in_poly, self.position, self.rotation, self.get_size.x, self.get_size.y, ccp(1,1));
}
@end
