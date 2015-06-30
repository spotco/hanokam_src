#import "GameMain.h"
#import "GameEngineScene.h"
#import "MainMenuScene.h"
#import "ShopScene.h"
#import "DataStore.h"
#import "TestScene.h"

#import "Resource.h"
#import "ShaderManager.h"
#import "SpriterUtil.h"
#import "SPDeviceAccelerometer.h"

/*
TODO --
GAMEPLAY IDEAS:
underwater breath bar, immediate restore health village
underwater bubbles anim (foreground and from character)
underwater quests reach certain depth/attract certain number of enemies

fix anims
	-air hurt anim play
	-bow shoot anim hold rotation
	-village walk anim fix
	-try dash spin anim hit
	
enemies shoot bullet pause animation
no arrows popup dialogue

QUESTS ARE CHALLENGES - let no enemies escape

arrow bounce off + (clear player projectiles after airbattle end)
dropping arrows after end
 homing arrow

TECH --
spriterdata cache
pool arrows and other stuff
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
	//return [TestScene cons];
	//return [ShopScene cons];
}
+(void)to_scene:(CCScene*)tar {
	[[CCDirector sharedDirector] replaceScene:tar];
}

@end
