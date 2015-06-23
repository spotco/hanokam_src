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
pufferenemy real health, not hack with ui healthbars
enemy about to spawn from bottom/sides indicator
enemy bullets with patterns
curved swipe direction a la speedypups
 
 hanoka char art in

 
arrow bounce off + (clear player projectiles after airbattle end)
dropping arrows after end
 homing arrow

QUESTS ARE CHALLENGES - let no enemies escape
 
TECH --
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
