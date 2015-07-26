#import "GameMain.h"
#import "GameEngineScene.h"
#import "MainMenuScene.h"
#import "DataStore.h"
#import "TestScene.h"

#import "Resource.h"
#import "ShaderManager.h"
#import "SpriterUtil.h"
#import "SPDeviceAccelerometer.h"

/*
--TODO
new dive end animation
dive in spin anim
targeting reticule in air fade in

quest + dialogue system stubs + simple quests
	-quest1 attract certain number of enemies, ui
	-quest2 reach certain depth (underwater temple)
	
dive return transition emphasize depth and enemies attracted
perf run, village and etc hiding
air and underwater mode powerup/gold drops

fix anims
	-player hitbox fix
	-player run or walk on land
	-inair pick back up, revert to idle animation and 0 rotation
	-arrow shoot spawn location
	-air hurt anim play
	-bow shoot anim hold rotation
	-village walk anim fix
	-try dash spin anim hit

	
enemies shoot bullet pause animation
enemy ideas:
	-spikes until shoot with arrow
	-treasure bag enemy
	
no arrows popup dialogue

enemy patterns - 4 air enemy patterns
enemy patterns - 4 water enemy patterns

magic system - charge up energy bar, tap button to unleash

quest challenge mechanics - let no enemies escape
	underwater quests reach certain depth/

first boss
store and equipment mechanics

--MISC IDEAS
arrow bounce off + (clear player projectiles after airbattle end)
dropping arrows after end
homing arrow

--ART REQUESTS
special fast swim animation

--TECH
spriterdata cache
pool arrows and other stuff
check leaks
scale player accel movement based on screen size
make TGSpriter classes structs instead
*/

@interface SplashScreen : CCScene
@end
@implementation SplashScreen
-(void)setup {
	CCSprite *img = [CCSprite spriteWithImageNamed:@"Default.png"];
	[self addChild:img];
}
@end

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
