//
//  DialogueBubble.h
//  hanokam
//
//  Created by Kenneth Pu on 6/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface DialogueBubble : CCNode

+(DialogueBubble*)cons;
-(void)i_update:(BOOL)shouldShow;

@end
