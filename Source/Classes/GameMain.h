#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define HMCFG_DRAW_HITBOXES 0
#define HMCFG_ON_SIMULATOR 1


@interface GameMain : NSObject
+(CCScene*)main;
+(void)to_scene:(CCScene*)tar;
@end
