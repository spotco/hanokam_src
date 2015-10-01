//
//  QuestMenuUI.h
//  hanokam
//
//  Created by spotco on 14/08/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameUI.h"
@class QuestInfo;

@interface QuestMenuUI : GameUISubView

+(QuestMenuUI*)cons:(GameEngineScene*)g;
-(void)set_questinfo:(QuestInfo*)questinfo;

@end
