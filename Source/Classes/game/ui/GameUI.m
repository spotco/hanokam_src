#import "GameUI.h"
#import "Resource.h" 
#import "FileCache.h"
#import "Common.h"
#import "GameEngineScene.h"
#import "HealthBar.h"
#import "Particle.h"
#import "UIBossIntroParticle.h"
#import "Player.h"
#import "PlayerUIHealthIndicator.h"
#import "PlayerChargeIndicator.h"
#import "PlayerUIAimReticule.h"
#import "VillageUI.h"
#import "DialogUI.h"
#import "EnemyUIHealthIndicators.h"
#import "EnemyWarningUI.h"
#import "PlayerUIArrowsIndicator.h"

typedef enum _GameUIBossIntroMode {
	GameUIBossIntroMode_None,
	GameUIBossIntroMode_FillInToBoss,
	GameUIBossIntroMode_Boss
} GameUIBossIntroMode;

@implementation GameUI {
	//TODO -- move this to new class
	HealthBar *_boss_health_bar;
	CCLabelTTF *_boss_health_label;
	GameUIBossIntroMode _current_boss_mode;
	float _boss_fillin_pct;
	//
	
	ParticleSystem *_particles;
	
	//TODO -- move this to new class
	CCSprite *_depth_bar_back;
	CCSprite *_depth_bar_fill;
	CCSprite *_depth_bar_icon_player, *_depth_bar_icon_boss;
	//
	
	//TODO -- organize these to hud class
	PlayerUIHealthIndicator *_player_health_ui;
	PlayerChargeIndicator *_player_charge_ui;
	PlayerUIAimReticule *_player_aim_reticule;
	PlayerUIArrowsIndicator *_player_arrows_indicator;
	EnemyUIHealthIndicators *_enemy_ui_health_indicators;
	EnemyWarningUI *_enemy_warning_ui;
	
    VillageUI *_villageUI;
    
    DialogUI *_dialogUI;
	
	CCNode *_red_flash_overlay;
	CCNode *_black_fadeout_overlay;
	float _tar_black_fadeout_overlay_alpha;
}

+(GameUI*)cons:(GameEngineScene*)game {
	return [(GameUI*)[GameUI node] cons:game];
}

-(GameUI*)cons:(GameEngineScene*)game {
	[self setAnchorPoint:ccp(0,0)];
	
	_red_flash_overlay = [CCNodeColor nodeWithColor:[CCColor redColor]];
	[_red_flash_overlay setOpacity:0];
	[self addChild:_red_flash_overlay];
	
	_black_fadeout_overlay = [CCNodeColor nodeWithColor:[CCColor blackColor]];
	_tar_black_fadeout_overlay_alpha = 0;
	[_black_fadeout_overlay setOpacity:_tar_black_fadeout_overlay_alpha];
	[self addChild:_black_fadeout_overlay];
	
	_boss_health_bar = [HealthBar cons_pooled_size:CGSizeMake(game_screen().width-10, 15) anchor:ccp(0,0)];
	[_boss_health_bar setPosition:game_screen_anchor_offset(ScreenAnchor_BL, ccp(5,5))];
	[self addChild:_boss_health_bar];
	[_boss_health_bar set_pct:0.5];
	_boss_health_label = (CCLabelTTF*)[label_cons(ccp(0,15), ccc3(255, 255, 255), 6, @"Big Badass Boss") set_anchor_pt:ccp(0,0)];
	[_boss_health_bar addChild:_boss_health_label];
	_particles = [ParticleSystem cons_anchor:self];
	_current_boss_mode = GameUIBossIntroMode_None;
	
	_enemy_ui_health_indicators = [EnemyUIHealthIndicators cons:game];
	[self addChild:_enemy_ui_health_indicators];
	
	_enemy_warning_ui = [EnemyWarningUI cons:game];
	[self addChild:_enemy_warning_ui];
	
	_depth_bar_back = [CCSprite spriteWithTexture:[Resource get_tex:TEX_HUD_SPRITESHEET] rect:[FileCache get_cgrect_from_plist:TEX_HUD_SPRITESHEET idname:@"hudicon_depthbar_back.png"]];
	[_depth_bar_back setAnchorPoint:ccp(0,0.5)];
	[_depth_bar_back setPosition:game_screen_anchor_offset(ScreenAnchor_ML, ccp(10,0))];
	[_depth_bar_back setScale:0.85];
	[self addChild:_depth_bar_back];
	
	_depth_bar_fill = [CCSprite spriteWithTexture:[Resource get_tex:TEX_HUD_SPRITESHEET] rect:[FileCache get_cgrect_from_plist:TEX_HUD_SPRITESHEET idname:@"hudicon_depthbar_fill.png"]];
	[_depth_bar_fill setAnchorPoint:ccp(0,0)];
	[_depth_bar_back addChild:_depth_bar_fill];
	
	_depth_bar_icon_player = [CCSprite spriteWithTexture:[Resource get_tex:TEX_HUD_SPRITESHEET] rect:[FileCache get_cgrect_from_plist:TEX_HUD_SPRITESHEET idname:@"hudicon_selector.png"]];
	[_depth_bar_icon_player setPosition:ccp(10,100)];
	[_depth_bar_icon_player setScale:0.15];
	[_depth_bar_icon_player addChild:
		[[[CCSprite spriteWithTexture:[Resource get_tex:TEX_HUD_SPRITESHEET]
							   rect:[FileCache get_cgrect_from_plist:TEX_HUD_SPRITESHEET idname:@"hudicon_hanoka.png"]] set_scale:3] set_pos:ccp(250,45)]
	];
	[_depth_bar_back addChild:_depth_bar_icon_player];
	
	_depth_bar_icon_boss = [CCSprite spriteWithTexture:[Resource get_tex:TEX_HUD_SPRITESHEET] rect:[FileCache get_cgrect_from_plist:TEX_HUD_SPRITESHEET idname:@"hudicon_selector.png"]];
	[_depth_bar_icon_boss setPosition:ccp(10,10)];
	[_depth_bar_icon_boss setScale:0.15];
	[_depth_bar_icon_boss addChild:
		[[[CCSprite spriteWithTexture:[Resource get_tex:TEX_HUD_SPRITESHEET]
							   rect:[FileCache get_cgrect_from_plist:TEX_HUD_SPRITESHEET idname:@"hudicon_skull.png"]] set_scale:3] set_pos:ccp(250,45)]
	];
	[_depth_bar_back addChild:_depth_bar_icon_boss];
	
	CGRect heart_size = [FileCache get_cgrect_from_plist:TEX_HUD_SPRITESHEET idname:@"heart_fill.png"];
	_player_health_ui = [PlayerUIHealthIndicator cons:game];
	[_player_health_ui setPosition:game_screen_anchor_offset(ScreenAnchor_TL, ccp((heart_size.size.width*0.5 + 3),-(heart_size.size.height*0.5 + 3)))];
	[self addChild:_player_health_ui];
	
	_player_arrows_indicator = [PlayerUIArrowsIndicator cons:game];
	[self addChild:_player_arrows_indicator];
	
	_player_charge_ui = [PlayerChargeIndicator cons];
	[self addChild:_player_charge_ui];
	
	_player_aim_reticule = [PlayerUIAimReticule cons];
	[self addChild:_player_aim_reticule];
	
    _villageUI = [VillageUI cons:game];
    [self addChild:_villageUI];
    
	return self;
}

//TODO -- move me to new class
-(float)depth_bar_from_top_fill_pct:(float)pct {
	CGRect rect = [FileCache get_cgrect_from_plist:TEX_HUD_SPRITESHEET idname:@"hudicon_depthbar_fill.png"];
	float hei = rect.size.height * (1-pct);
	rect.origin.y += hei;
	rect.size.height -= hei;
	_depth_bar_fill.textureRect = rect;
	[_depth_bar_fill setPosition:ccp(0,hei)];
	return hei;
}

-(float)depth_bar_from_bottom_fill_pct:(float)pct {
	[_depth_bar_fill setPosition:ccp(0,0)];
	CGRect rect = [FileCache get_cgrect_from_plist:TEX_HUD_SPRITESHEET idname:@"hudicon_depthbar_fill.png"];
	rect.size.height *= pct;
	[_depth_bar_fill setTextureRect:rect];
	return rect.size.height;
}

-(void)start_boss:(NSString*)title sub:(NSString*)sub {
	[_particles add_particle:[UIBossIntroParticle cons_header:title sub:sub]];
	_current_boss_mode = GameUIBossIntroMode_FillInToBoss;
	_boss_fillin_pct = 0;
	[_boss_health_bar setVisible:YES];
	[_boss_health_label setString:title];
}
//

//TODO -- these should be done as events instead
-(void)flash_red {
	[_red_flash_overlay setOpacity:0.5];
}

-(void)hold_reticule_visible:(float)variance {
	[_player_aim_reticule hold_visible:variance];
}

-(void)fadeout:(BOOL)tar {
	_tar_black_fadeout_overlay_alpha = tar?1:0;
}
-(BOOL)is_faded_out {
	return _black_fadeout_overlay.opacity >= 1;
}
-(BOOL)is_faded_in {
	return _black_fadeout_overlay.opacity <= 0;
}
-(void)pulse_heart_lastfill {
	[_player_health_ui pulse_heart_lastfill];
}

-(void)set_charge_pct:(float)pct g:(GameEngineScene*)g {
	[_player_charge_ui set_pct:pct g:g];
}

-(void)charge_fail {
	[_player_charge_ui fadeout_fail];
}

-(void)i_update:(GameEngineScene*)game {
	[_player_charge_ui i_update:game];
	[self update_boss_ui:game];
	[_enemy_ui_health_indicators i_update:game];
	[_enemy_warning_ui i_update:game];
	[_player_health_ui i_update:game];
	[_particles update_particles:self];
	[_red_flash_overlay setOpacity:MAX(0,_red_flash_overlay.opacity-0.025*dt_scale_get())];
	[_black_fadeout_overlay setOpacity:(_tar_black_fadeout_overlay_alpha>0.5)?MIN(1,_black_fadeout_overlay.opacity+0.01*dt_scale_get()):MAX(0,_black_fadeout_overlay.opacity-0.01*dt_scale_get())];
	[_player_aim_reticule i_update:game];
	[_player_arrows_indicator i_update:game];
	
	if ([game get_player_state] == PlayerState_Dive) {
		[_depth_bar_back setVisible:YES];
		float hei_from_top = [self depth_bar_from_top_fill_pct:game.player.position.y/game.get_ground_depth];
		[_depth_bar_icon_player setPosition:ccp(_depth_bar_icon_player.position.x,hei_from_top)];
		
	} else if ([game get_player_state] == PlayerState_InAir) {
		[_depth_bar_back setVisible:NO];
		[self depth_bar_from_bottom_fill_pct:0.5];
		
	} else {
        [_villageUI i_update:game];
		[_depth_bar_back setVisible:NO];
	}
}

//todo -- move me to new class
-(void)update_boss_ui:(GameEngineScene*)game {
	switch (_current_boss_mode) {
		case GameUIBossIntroMode_None:;
			[_boss_health_bar setVisible:NO];
		break;
		case GameUIBossIntroMode_FillInToBoss:;
			_boss_fillin_pct += 0.025 * dt_scale_get();
			[_boss_health_bar setVisible:YES];
			[_boss_health_label setVisible:NO];
			[_boss_health_bar set_pct:_boss_fillin_pct];
			if (_boss_fillin_pct >= 1) _current_boss_mode = GameUIBossIntroMode_Boss;
		break;
		case GameUIBossIntroMode_Boss:;
			[_boss_health_bar setVisible:YES];
			[_boss_health_label setVisible:YES];
			[_boss_health_bar set_pct:1.0];
		break;
	}
}

@end
