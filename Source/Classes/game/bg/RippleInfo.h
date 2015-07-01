//
//  RippleInfo.h
//  hanokam
//
//  Created by Shiny Yang on 6/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "cocos2d.h"
@class GameEngineScene;

@interface RippleInfo : NSObject
-(id)initWithPosition:(CGPoint)pos game:(GameEngineScene*)game;

-(void)render_reflected:(CCSprite*)proto offset:(CGPoint)offset scymult:(float)scymult;
-(void)render_default:(CCSprite*)proto offset:(CGPoint)offset scymult:(float)scymult;

-(void)render:(CCSprite*)proto pos:(CGPoint)pos scymult:(float)scymult;
-(void)i_update;
-(BOOL)should_remove;
@end
