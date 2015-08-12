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
    for (BGCharacterBase *itrChar in game.get_bg_village.get_villagers) {
        NSNumber *itr_hash = @([itrChar hash]);
        _bgCharacterDialogueBubbles[itr_hash] = [DialogueBubble cons];
        [self addChild:_bgCharacterDialogueBubbles[itr_hash]];
    }
	
	/*
	SPLabel *test = [SPLabel cons_texkey:TEX_HUD_FONT];
	[test setPosition:game_screen_pct(0.5, 0.5)];
	[test set_fillcolor:ccc4f(62/255.0, 56/255.0, 64/255.0, 1.0) strokecolor:ccc4f(189/255.0, 247/255.0, 255/255.0, 1.0)];
	[test add_char_offset:'m' size_increase:ccp(0,0) offset:ccp(10,-20)];
	[test set_string:@"1m 5%"];
	[self addChild:test];
	*/
    return self;
}

-(void)i_update:(GameEngineScene *)game {
    // Update dialogue bubbles
    [self updateBgCharacterDialogueBubbles:game];
}

-(void)updateBgCharacterDialogueBubbles:(GameEngineScene *)game {
    for (BGCharacterBase *itrChar in game.get_bg_village.get_villagers) {
        NSNumber *itr_hash = @([itrChar hash]);
        DialogueBubble *itrBubble = _bgCharacterDialogueBubbles[itr_hash];
        
        // Update dialogue bubble positions to keep them with their corresponding villagers
		CGPoint offset = itrChar.get_dialog_icon_offset;
		offset.x *= game.get_zoom;
		offset.y *= game.get_zoom;
        [itrBubble setPosition:CGPointAdd([itrChar convertToWorldSpace:CGPointZero],offset)];
		
		[itrBubble i_update:game shouldShow:YES];
    }  
}

@end
