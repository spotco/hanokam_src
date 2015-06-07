//
//  VillageUI.m
//  hanokam
//
//  Created by Kenneth Pu on 6/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "VillageUI.h"
#import "Resource.h"
#import "FileCache.h"
#import "Common.h"
#import "GameEngineScene.h"
#import "BGCharacterBase.h"
#import "BGVillage.h"
#import "DialogueBubble.h"

@implementation VillageUI {
    // Dictionary to keep track of dialogue bubbles for background characters
    NSMutableDictionary *_bgCharacterDialogueBubbles;
}

+(VillageUI*)cons:(GameEngineScene*)game {
    return [(VillageUI*)[VillageUI node] cons:game];
}

-(VillageUI*)cons:(GameEngineScene*)game {
    [self setAnchorPoint:ccp(0,0)];
    
    // Initialize DialogueBubbles for each villager currently in the village
    _bgCharacterDialogueBubbles = [NSMutableDictionary dictionary];
    for (BGCharacterBase *itrChar in game.get_bg_village.getVillagers) {
        NSNumber *itr_hash = @([itrChar hash]);
        _bgCharacterDialogueBubbles[itr_hash] = [DialogueBubble cons];
        [self addChild:_bgCharacterDialogueBubbles[itr_hash]];
    }
    
    return self;
}

-(void)i_update:(GameEngineScene *)game {
    // Update dialogue bubbles
    [self updateBgCharacterDialogueBubbles:game];
}

-(void)updateBgCharacterDialogueBubbles:(GameEngineScene *)game {
    for (BGCharacterBase *itrChar in game.get_bg_village.getVillagers) {
        NSNumber *itr_hash = @([itrChar hash]);
        DialogueBubble *itrBubble = _bgCharacterDialogueBubbles[itr_hash];
        
        // Update dialogue bubble positions to keep them with their corresponding villagers
		CGPoint offset = itrChar.dialogueOffset;
		offset.x *= game.get_zoom;
		offset.y *= game.get_zoom;
        [itrBubble setPosition:CGPointAdd([itrChar convertToWorldSpace:CGPointZero],offset)];
        
        // Fade dialogue bubbles in and out where appropriate
        if (itrChar.state == BGCharacter_CanSpeak) {
            [itrBubble i_update:game shouldShow:YES];
        } else {
            [itrBubble i_update:game shouldShow:NO];
        }
    }  
}

@end
