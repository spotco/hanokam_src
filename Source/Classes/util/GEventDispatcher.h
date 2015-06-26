#import <Foundation/Foundation.h>

typedef enum {
    GEventType_BulletHitPlayer
} GEventType;

#define GEventKey_BulletHitPlayer_EffectParams @"GEventKey_BulletHitPlayer_EffectParams"

@interface GEvent : NSObject
+(GEvent*)cons_context:(id)context type:(GEventType)t;
-(GEventType)type;
-(id)context;
-(GEvent*)add_key:(NSString*)k value:(id)v;
-(id)get_value:(NSString*)key;
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
