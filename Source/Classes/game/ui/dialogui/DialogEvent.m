//
//  DialogEvent.m
//  hanokam
//
//  Created by spotco on 11/08/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "DialogEvent.h"
#import "BGCharacterBase.h"

@implementation DialogEvent {
	NSString *_text;
	BGCharacterBase *_speaker;
}

+(DialogEvent*)cons_text:(NSString*)text speaker:(BGCharacterBase*)speaker {
	return [[[DialogEvent alloc] init] cons_text:text speaker:speaker];
}
-(DialogEvent*)cons_text:(NSString*)text speaker:(BGCharacterBase*)speaker {
	_text = text;
	_speaker = speaker;
	return self;
}
-(NSString*)get_text {
	return _text;
}
-(BGCharacterBase*)get_speaker {
	return _speaker;
}
-(void)i_update:(GameEngineScene*)g {}
-(BOOL)is_animation_finished {
	return YES;
}

@end
