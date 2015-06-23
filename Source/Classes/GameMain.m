#import "GameMain.h"
#import "GameEngineScene.h"
#import "MainMenuScene.h"
#import "ShopScene.h"
#import "DataStore.h"

#import "Resource.h"
#import "ShaderManager.h"
#import "SpriterUtil.h"
#import "SPDeviceAccelerometer.h"

/*
TODO --
GAMEPLAY IDEAS:
 super arrow only stun
 pufferenemy real health, not hack with ui healthbars
 basicenemy end on off screen not t
 
arrow decreasing bar
energy bar
arrow initial inactive time
enemy about to spawn from bottom/sides indicator
invulnerability time anim on player
touchtrackinglayer fadein/out
homing arrow
 curved swipe direction a la speedypups
enemy bullets with patterns
arrow bounce off + (clear player projectiles after airbattle end)
dropping arrows after end

QUESTS ARE CHALLENGES - let no enemies escape
 
TECH --
player control class make into state machine stack
scale player accel movement based on screen size

make TGSpriter classes structs instead
*/

@implementation GameMain
+(CCScene*)main {
	calc_table_scubic_point_for_t();
	[Resource load_all];
	[ShaderManager load_all];
	[DataStore cons];
	[SPDeviceAccelerometer start];
	
	NSLog(@"CC2DV:%@",cocos2dVersion());
	//return [MainMenuScene cons];
	return [GameEngineScene cons];
	//return [ShopScene cons];
}
+(void)to_scene:(CCScene*)tar {
	[[CCDirector sharedDirector] replaceScene:tar];
}

@end
