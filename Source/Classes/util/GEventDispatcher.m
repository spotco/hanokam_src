#import "GEventDispatcher.h"
#import "ObjectPool.h"

@implementation GEvent {
	GEventType _type;
	id _context;
	id _target;
	float _float_value;
	BOOL _bool_value;
}
static NSMutableArray *_pool;
+(GEvent*)pool_get {
	return [ObjectPool depool:[GEvent class]];
}
+(void)pool_return:(GEvent*)tar {
	[tar cleanup];
	[ObjectPool repool:tar class:[GEvent class]];
}

+(GEvent*)cons_context:(id)context type:(GEventType)t {
	return [[GEvent pool_get] cons_context:context type:t];
}
-(GEvent*)cons_context:(id)context type:(GEventType)t {
	_type = t;
	_context = context;
	return self;
}
-(GEventType)type { return _type; }
-(id)context { return _context; }
-(GEvent*)set_target:(id)target { _target = target; return self; }
-(id)target { return _target; }
-(GEvent*)set_float_value:(float)tar { _float_value = tar; return self; }
-(GEvent*)set_bool_value:(BOOL)tar { _bool_value = tar; return self; }
-(float)float_value{ return _float_value; }
-(BOOL)bool_value{ return _bool_value; }
-(void)cleanup {
	_context = NULL;
	_target = NULL;
}
@end

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
	[GEvent pool_return:e];
}
@end
