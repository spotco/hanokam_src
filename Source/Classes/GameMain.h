#import <Foundation/Foundation.h>
#import "cocos2d.h"

//#define HMCFG_DRAW_HITBOXES
#define HMCFG_ON_SIMULATOR 0


@interface GameMain : NSObject
+(CCScene*)main;
+(void)to_scene:(CCScene*)tar;
@end
