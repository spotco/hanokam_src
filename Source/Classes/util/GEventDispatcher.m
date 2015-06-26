#import "GEventDispatcher.h"

@implementation GEventDispatcher {
	NSMutableArray *_listeners;
}
+(GEventDispatcher*)cons {
	return [[[GEventDispatcher alloc] init] cons];
}
-(GEventDispatcher*)cons {
	_listeners = [NSMutableArray array];
	return self;
}
-(void)add_listener:(id<GEventListener>)tar {
	[_listeners addObject:tar];
}
-(void)remove_all_listeners {
	[_listeners removeAllObjects];
}
-(void)remove_listener:(id<GEventListener>)tar {
	[_listeners removeObject:tar];
}
-(void)push_event:(GEvent*)e {
	for (long i = _listeners.count-1; i >= 0; i--) {
		id<GEventListener> itr = _listeners[i];
		[itr dispatch_event:e];
	}
}
@end

@implementation GEvent {
	GEventType _type;
	NSMutableDictionary *_dict;
	id _context;
}
+(GEvent*)cons_context:(id)context type:(GEventType)t {
	return [[[GEvent alloc] init] cons_context:context type:t];
}
-(GEvent*)cons_context:(id)context type:(GEventType)t {
	_type = t;
	_context = context;
	return self;
}
-(GEventType)type { return _type; }
-(id)context { return _context; }
-(GEvent*)add_key:(NSString*)k value:(id)v {
	if (_dict == NULL) _dict = [NSMutableDictionary dictionary];
	_dict[k] = v;
	return self;
}
-(id)get_value:(NSString*)key {
	return [_dict objectForKey:key];
}
@end
