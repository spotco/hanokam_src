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
arrow decreasing bar
energy bar
shoot arrow tap target ui effect
shoot arrow hold target line reticule
arrow initial inactive time
after sword enemy invuln time (chain sword hits)
enemy about to spawn from bottom/sides indicator
invulnerability time
touchtrackinglayer fadein/out

vulnerable enemy ui effect
enemy bullets with patterns
enemy invulnerable (arrow), vulnerable (sword) mode

TECH --
player control class make into state machine stack
make TGSpriter classes structs instead
*/

@implementation GameMain
+(CCScene*)main; {
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
