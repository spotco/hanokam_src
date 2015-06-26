#import <Foundation/Foundation.h>

typedef enum {
    GEventType_BulletHitPlayer,
	GEventType_PlayerHitEnemySword,
	GEventType_PlayerHitEnemyDash,
	GEventType_PlayerTouchEnemy
	
} GEventType;

@interface GEvent : NSObject
+(GEvent*)cons_context:(id)context type:(GEventType)t;
-(GEventType)type;
-(id)context;
-(GEvent*)set_target:(id)target;
-(id)target;
@end

@protocol GEventListener <NSObject>
@required
-(void)dispatch_event:(GEvent*)e ;
@end

@interface GEventDispatcher : NSObject
+(GEventDispatcher*)cons;
-(void)add_listener:(id<GEventListener>)tar;
-(void)remove_all_listeners;
-(void)remove_listener:(id<GEventListener>)tar;
-(void)push_event:(GEvent*)e;
@end
