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
 dash hit sword
 hold super arrow
 arrow sticks
 
when enemy stunned dash through or touch kill
when hold spinning, sword
sword slash effects
 
arrow decreasing bar
energy bar
shoot arrow tap target ui effect
arrow initial inactive time
after sword enemy invuln time (chain sword hits)
enemy about to spawn from bottom/sides indicator
invulnerability time
touchtrackinglayer fadein/out
homing arrow
enemy bullets with patterns

TECH --
player control class make into state machine stack
scale player accel movement based on screen size
curved swipe direction a la speedypups
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
