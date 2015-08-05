#import "cocos2d.h"
#import "Common.h"
#import "RippleInfo.h"
#import "DelayAction.h"

@class GameObject;
@class Particle;
@class Player;
@class BGVillage;
@class AirEnemyManager;
@class ControlManager;
@class PlayerProjectile;
@class GameUI;
@class TouchTrackingLayer;
@class SpriterNodeCache;
@class EnemyProjectile;
@class GEventDispatcher;
@class WaterEnemyManager;
@class BGWater;

typedef enum _PlayerState {
	PlayerState_Dive = 0,
	PlayerState_DiveReturn = 1,
	PlayerState_InAir = 2,
	PlayerState_OnGround = 3,
	PlayerState_AirToGroundTransition = 4,
    PlayerState_InDialogue = 5
} PlayerState;

typedef enum _GameAnchorZ {
	GameAnchorZ_UI = 5000,
	GameAnchorZ_BlurTex = 4500,
	GameAnchorZ_DebugDraw = 999,
	
	GameAnchorZ_BGWater_WaterLineBelow = 101,
	GameAnchorZ_BGSky_SurfaceReflection = 100,
	
    GameAnchorZ_UnderwaterForegroundElements = 83,
	GameAnchorZ_PlayerAirEffects = 82,
	GameAnchorZ_Enemies_Air = 81,
	GameAnchorZ_PlayerProjectiles = 80,
	
	GameAnchorZ_BGSky_SurfaceGradient = 80,
	GameAnchorZ_Player_Out = 79,
	GameAnchorZ_BGSky_Docks_Pillars_Front = 52,
	GameAnchorZ_Player = 51,
	
	GameAnchorZ_BGSky_Sky_SideCliffs = 40,
	
	GameAnchorZ_BGSky_Docks = 13,
	GameAnchorZ_BGSky_Elements = 12,
	GameAnchorZ_BGWater_Reflection = 11,
	GameAnchorZ_Enemies_Underwater = 8,
	GameAnchorZ_BGWater_I1 = 7,
	GameAnchorZ_BGSky_BackgroundElements = 6,
	
	GameAnchorZ_BGSky_Sky_Islands = 4,
	GameAnchorZ_BGSky_Sky_Arcs = 3,
	
	GameAnchorZ_BGWater_WaterLineAbove = 8,
	GameAnchorZ_BGSky_RepeatBG = -9,
	GameAnchorZ_BGWater_Ground = -11,
	GameAnchorZ_BGWater_Elements = -12,
	GameAnchorZ_BGWater_RepeatBG = -13
} GameAnchorZ;

@interface GameEngineScene : CCScene

+(GameEngineScene*)cons;

-(Player*)player;

-(void)add_particle:(Particle*)p;
-(void)shake_for:(float)ct distance:(float)distance;
-(void)shake_slow_for:(float)ct distance:(float)distance;
-(void)freeze_frame:(int)ct;

-(float)tick;

-(PlayerState)get_player_state;
-(HitRect)get_viewbox;
-(CCNode*)get_anchor;
-(WaterEnemyManager*)get_water_enemy_manager;
-(AirEnemyManager*)get_air_enemy_manager;
-(GameUI*)get_ui;
-(TouchTrackingLayer*)get_touch_tracking_layer;
-(NSArray*)get_player_projectiles;

-(void)set_camera_height:(float)tar;
-(void)set_zoom:(float)tar;
-(float)get_zoom;
-(void)imm_set_camera_hei:(float)hei;
-(float)get_current_camera_center_y;

-(float) REFLECTION_HEIGHT;
-(float) HORIZON_HEIGHT;
-(float) DOCK_HEIGHT;

-(ControlManager*)get_control_manager;

-(NSNumber*)get_tick_mod_pi;

-(void)add_ripple:(CGPoint)pos;
-(NSArray*)get_ripple_infos;
-(CCSprite*)get_ripple_proto;

-(BGVillage*)get_bg_village;
-(BGWater*)get_bg_water;

-(GEventDispatcher*)get_event_dispatcher;

-(void)add_delayed_action:(DelayAction*)delayed_action;

-(void)add_player_projectile:(PlayerProjectile*)tar;
-(void)add_enemy_projectile:(EnemyProjectile*)tar;

-(void)blur_and_pulse;
@end

@interface BGElement : NSObject
-(void)i_update:(GameEngineScene*)game;
@end
