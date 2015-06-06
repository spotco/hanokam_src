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
    NSMutableDictionary *_bgCharacterDialogueBubbles;
}

+(VillageUI*)cons:(GameEngineScene*)game {
    return [(VillageUI*)[VillageUI node] cons:game];
}

-(VillageUI*)cons:(GameEngineScene*)game {
    [self setAnchorPoint:ccp(0,0)];
    
    _bgCharacterDialogueBubbles = [NSMutableDictionary dictionary];
    for (BGCharacterBase *itrChar in game.get_bg_village.getVillagers) {
        NSNumber *itr_hash = @([itrChar hash]);
        _bgCharacterDialogueBubbles[itr_hash] = [DialogueBubble cons];
        [self addChild:_bgCharacterDialogueBubbles[itr_hash]];
    }
    
    return self;
}

-(void)i_update:(GameEngineScene *)game {
    [self updateBgCharacterDialogueBubbles:game];
}

-(void)updateBgCharacterDialogueBubbles:(GameEngineScene *)game {
    for (BGCharacterBase *itrChar in game.get_bg_village.getVillagers) {
        NSNumber *itr_hash = @([itrChar hash]);
        DialogueBubble *itrBubble = _bgCharacterDialogueBubbles[itr_hash];
        [itrBubble setPosition:CGPointAdd([itrChar convertToWorldSpace:CGPointZero],itrChar.dialogueOffset)];
        
        if (itrChar.state == BGCharacter_CanSpeak) {
            [itrBubble i_update:YES];
        } else {
            [itrBubble i_update:NO];
        }
    }
//
//    
//    NSMutableSet *active_dialogue_objhash = _bgCharacterDialogueBubbles.keySet;
//    for (BGCharacterBase *itrChar in game.get_bg_village.getVillagers) {
//        if (itrChar.state == BGCharacter_CanSpeak) {
//            NSNumber *itr_hash = @([itrChar hash]);
//            if ([active_dialogue_objhash containsObject:itr_hash]) {
//                [active_dialogue_objhash removeObject:itr_hash];
//            } else {
//                _bgCharacterDialogueBubbles[itr_hash] = [DialogueBubble cons_pos:CGPointAdd([itrChar convertToWorldSpace:CGPointZero],itrChar.dialogueOffset)];
//                [self addChild:_bgCharacterDialogueBubbles[itr_hash]];
//            }
//            DialogueBubble *itrBubble = _bgCharacterDialogueBubbles[itr_hash];
//            [itrBubble setPosition:CGPointAdd([itrChar convertToWorldSpace:CGPointZero],itrChar.dialogueOffset)];
//        }
//    }
//    
//    for (NSNumber *itr_hash in active_dialogue_objhash) {
//        DialogueBubble *itrBubble = _bgCharacterDialogueBubbles[itr_hash];
//        [self removeChild:itrBubble];
//        [_bgCharacterDialogueBubbles removeObjectForKey:itr_hash];
//    }    
}

@end
