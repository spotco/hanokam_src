//
//  DialogEvent.m
//  hanokam
//
//  Created by spotco on 11/08/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "DialogEvent.h"

@implementation DialogEvent {
	NSString* _text;
}

+(DialogEvent*)cons_text:(NSString*)text {
	return [[[DialogEvent alloc] init] cons_text:text];
}
-(DialogEvent*)cons_text:(NSString*)text {
	_text = text;
	return self;
}
-(NSString*)get_text {
	return _text;
}
-(void)i_update:(GameEngineScene*)g {}
-(BOOL)is_animation_finished {
	return YES;
}

@end
