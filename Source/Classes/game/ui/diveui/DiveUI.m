//
//  DiveUI.m
//  hanokam
//
//  Created by spotco on 30/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "DiveUI.h"

@implementation DiveUI
+(DiveUI*)cons:(GameEngineScene*)g {
	return [[DiveUI node] cons:g];
}
-(DiveUI*)cons:(GameEngineScene*)g {
	return self;
}
-(void)i_update:(GameEngineScene *)g {

}
@end
