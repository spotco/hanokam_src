#import "GameUI.h"
#import "Resource.h" 
#import "FileCache.h"
#import "Common.h"
#import "GameEngineScene.h"
#import "Particle.h"
#import "Player.h"

#import "PlayerChargeIndicator.h"

#import "InAirUI.h"
#import "VillageUI.h"
#import "DialogUI.h"
#import "DiveUI.h"
#import "QuestMenuUI.h"

@implementation GameUISubView
-(void)show_start:(GameEngineScene *)g{}
-(void)i_update:(GameEngineScene *)g{}
@end

@implementation GameUI {
	//shared ui
	ParticleSystem *_particles;
	PlayerChargeIndicator *_player_charge_ui;
	CCNode *_red_flash_overlay;
	CCNode *_black_fadeout_overlay;
	float _tar_black_fadeout_overlay_alpha;
	
	//modal ui
	InAirUI *_in_air_ui;
    VillageUI *_villageUI;
    DialogUI *_dialogUI;
	DiveUI *_dive_ui;
	QuestMenuUI *_quest_menu_ui;
	NSArray *_gameui_subviews;
}

+(GameUI*)cons:(GameEngineScene*)g {
	return [[GameUI node] cons:g];
}

-(GameUI*)cons:(GameEngineScene*)g {
	[g.get_event_dispatcher add_listener:self];
	[self setAnchorPoint:ccp(0,0)];
	
	_particles = [ParticleSystem cons_anchor:self];
	
	_dialogUI = [DialogUI cons:g];
    _villageUI = [VillageUI cons:g];
	_in_air_ui = [InAirUI cons:g];
	_dive_ui = [DiveUI cons:g];
	_quest_menu_ui = [QuestMenuUI cons:g];
	
	_gameui_subviews = @[_villageUI,_in_air_ui,_dialogUI,_dive_ui,_quest_menu_ui];
    for (GameUISubView *itr in _gameui_subviews) [self addChild:itr];
	
	_red_flash_overlay = [CCNodeColor nodeWithColor:[CCColor redColor]];
	[_red_flash_overlay setOpacity:0];
	[self addChild:_red_flash_overlay];
	_player_charge_ui = [PlayerChargeIndicator cons];
	[self addChild:_player_charge_ui];
	_black_fadeout_overlay = [CCNodeColor nodeWithColor:[CCColor blackColor]];
	_tar_black_fadeout_overlay_alpha = 0;
	[_black_fadeout_overlay setOpacity:_tar_black_fadeout_overlay_alpha];
	[self addChild:_black_fadeout_overlay];
	
	return self;
}

-(void)flash_red {
	[_red_flash_overlay setOpacity:0.5];
}

-(void)dispatch_event:(GEvent *)e {
	GameEngineScene *g = e.context;
	switch (e.type) {
	case GEventType_PlayerTakeDamage: {
		[self flash_red];
	}
	break;
	case GEventType_PlayerChargePct : {
		[_player_charge_ui set_pct:e.float_value g:g];
	}
	break;
	case GEventType_PlayerChargeFail : {
		[_player_charge_ui fadeout_fail];
	};
	break;
	default: {}
	}
}

-(GameUISubView*)ui_for_playerstate:(PlayerState)state {
	switch (state) {
		case PlayerState_OnGround: return _villageUI;
		case PlayerState_AirToGroundTransition: return NULL;
		case PlayerState_Dive: return _dive_ui;
		case PlayerState_DiveReturn: return NULL;
		case PlayerState_InAir: return _in_air_ui;
		case PlayerState_InDialogue: return _dialogUI;
		case PlayerState_InQuestMenu: return _quest_menu_ui;
	}
}

-(void)fadeout:(BOOL)tar {
	_tar_black_fadeout_overlay_alpha = tar ? 1 : 0;
}
-(BOOL)is_faded_out {
	return _black_fadeout_overlay.opacity >= 1;
}
-(BOOL)is_faded_in {
	return _black_fadeout_overlay.opacity <= 0;
}

-(void)i_update:(GameEngineScene*)game {
	[_player_charge_ui i_update:game];
	[_particles update_particles:self];
	[_red_flash_overlay setOpacity:MAX(0,_red_flash_overlay.opacity-0.025*dt_scale_get())];
	[_black_fadeout_overlay setOpacity:(_tar_black_fadeout_overlay_alpha>0.5)?MIN(1,_black_fadeout_overlay.opacity+0.01*dt_scale_get()):MAX(0,_black_fadeout_overlay.opacity-0.01*dt_scale_get())];
	
	GameUISubView *current_ui = [self ui_for_playerstate:game.get_player_state];
	for (GameUISubView *itr in _gameui_subviews) {
		if (itr == current_ui) {
			if (itr.visible == NO) {
				[itr show_start:game];
			}
			[itr setVisible:YES];
			
		} else if (itr != current_ui) {
			[itr setVisible:NO];
		}
	}
	[current_ui i_update:game];
	
	//[_dive_ui setVisible:YES];
	//[_dialogUI setVisible:YES];
	//[_dialogUI i_update:game];
	//[_in_air_ui setVisible:YES];
	//[_quest_menu_ui setVisible:YES];
	//[_quest_menu_ui i_update:game];
}
-(void)add_particle:(Particle*)tar {
	[_particles add_particle:tar];
}
@end

/*
typedef enum _GameUIBossIntroMode {
	GameUIBossIntroMode_None,
	GameUIBossIntroMode_FillInToBoss,
	GameUIBossIntroMode_Boss
} GameUIBossIntroMode;

	//TODO -- move this to new class
	HealthBar *_boss_health_bar;
	CCLabelTTF *_boss_health_label;
	GameUIBossIntroMode _current_boss_mode;
	float _boss_fillin_pct;
	
		_boss_health_bar = [HealthBar cons_pooled_size:CGSizeMake(game_screen().width-10, 15) anchor:ccp(0,0)];
	[_boss_health_bar setPosition:game_screen_anchor_offset(ScreenAnchor_BL, ccp(5,5))];
	[self addChild:_boss_health_bar];
	[_boss_health_bar set_pct:0.5];
	_boss_health_label = (CCLabelTTF*)[label_cons(ccp(0,15), ccc3(255, 255, 255), 6, @"Big Badass Boss") set_anchor_pt:ccp(0,0)];
	[_boss_health_bar addChild:_boss_health_label];
	_current_boss_mode = GameUIBossIntroMode_None;
	
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

-(void)start_boss:(NSString*)title sub:(NSString*)sub {
	[_particles add_particle:[UIBossIntroParticle cons_header:title sub:sub]];
	_current_boss_mode = GameUIBossIntroMode_FillInToBoss;
	_boss_fillin_pct = 0;
	[_boss_health_bar setVisible:YES];
	[_boss_health_label setString:title];
}
*/
