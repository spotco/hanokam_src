#import "GameEngineScene.h"
#import "GEventDispatcher.h"

@interface GameUISubView : CCNode
-(void)i_update:(GameEngineScene*)g;
@end

@interface GameUI : CCNode <GEventListener>
+(GameUI*)cons:(GameEngineScene*)g;
-(GameUISubView*)ui_for_playerstate:(PlayerState)state;
-(void)i_update:(GameEngineScene*)g;

-(void)fadeout:(BOOL)tar;
-(BOOL)is_faded_out;
-(BOOL)is_faded_in;

-(void)flash_red;

-(void)add_particle:(Particle*)tar;
@end
