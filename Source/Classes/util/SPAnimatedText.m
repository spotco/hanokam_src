//
//  SPAnimatedText.m
//  hanokam
//
//  Created by Kenneth Pu on 6/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "SPAnimatedText.h"
#import "SPAnimatedTextCharacter.h"
#import "GameEngineScene.h"

CGFloat CHAR_WIDTH = 9;
CGFloat SPACE_WIDTH = 6;

@interface SPAnimatedText()
@property (nonatomic, readwrite) AnimatedTextState state;
@end

@implementation SPAnimatedText {
    NSArray *_animatedTextCharacters;
    CGFloat t;
}

#pragma mark - Constructors

+(SPAnimatedText*)cons:(GameEngineScene*)game withText:(NSString*)text {
    return [(SPAnimatedText*)[SPAnimatedText node] cons:game withText:text];
}

-(SPAnimatedText*)cons:(GameEngineScene*)game withText:(NSString*)text {
    [self setAnchorPoint:ccp(0,0)];
    
    // Create array of character labels to display text
    NSMutableArray *textCharacterArray = [NSMutableArray array];
    CGFloat xPos = CHAR_WIDTH;
    for (int i=0; i< text.length; i++) {
        NSString *textCharacter = [text substringWithRange:NSMakeRange(i,1)];
        if (![textCharacter isEqualToString:@" "]) {
            // If current character is not a space, initialize an instance of SPAnimatedTextCharacter, increment xPos accordingly
            SPAnimatedTextCharacter *animatedTextChararcter = [SPAnimatedTextCharacter cons:game
                                                                 withCharacter:[text substringWithRange:NSMakeRange(i,1)]
                                                                         color:[CCColor whiteColor]
                                                                     amplitude:3];
            [animatedTextChararcter setScale:0.4f];
            [animatedTextChararcter setPosition:ccp(xPos,0)];
            [animatedTextChararcter setOpacity:0];
            [textCharacterArray addObject:animatedTextChararcter];
            [self addChild:animatedTextChararcter];
            xPos += CHAR_WIDTH;
        } else {
            // Otherwise simply incrment xPos
            xPos += SPACE_WIDTH;
        }
    }
    _animatedTextCharacters = [NSArray arrayWithArray:textCharacterArray];
    
    return self;
}

#pragma mark - State Machine

-(void)i_update:(GameEngineScene *)game {
    switch (self.state) {
        case AnimatedTextState_Hidden:;
            // Wait here until signalled to begin entering
            break;
        case AnimatedTextState_Entering:;
            // Animate in text characters
            t += 0.2*dt_scale_get();
            if (t < _animatedTextCharacters.count) {
                // Characters should begin appearing one after another
                int i = floor(t);
                [(SPAnimatedTextCharacter *)[_animatedTextCharacters objectAtIndex:i] beginEntering];
                for (int j=0; j<=i; j++) {
                    // All characters that have appeared need to continue updating
                    [(SPAnimatedTextCharacter *)[_animatedTextCharacters objectAtIndex:j] i_update:game ts:fmod((t-j),2*M_PI)];
                }
            } else {
                // Once all characters have appeared proceed to SHOWING state
                self.state = AnimatedTextState_Showing;
                for (int i=0; i<_animatedTextCharacters.count; i++) {
                    [(SPAnimatedTextCharacter *)[_animatedTextCharacters objectAtIndex:i] i_update:game
                                                                                    ts:fmod((t-i),2*M_PI)];
                }
            }
            break;
        case AnimatedTextState_Showing:
            // Keep t between 0 and 2PI
            t += 0.2*dt_scale_get();
            if (t >= 2*M_PI) {
                t -= 2*M_PI;
            }
            
            // Animate characters in wave pattern
            for (int i=0; i<_animatedTextCharacters.count; i++) {
                [(SPAnimatedTextCharacter *)[_animatedTextCharacters objectAtIndex:i] i_update:game
                                                                                ts:fmod((t-i),2*M_PI)+2*M_PI];
            }
            break;
        default:
            break;
    }
}

-(void)beginEntering {
    t = 0;
    
    // Proceed to ENTERING state
    self.state = AnimatedTextState_Entering;
}

-(void)forceShowing {
    // Force animated text characters to proceed directly to SHOWING state
    for (SPAnimatedTextCharacter *tc in _animatedTextCharacters) {
        [tc forceShowing];
    }
    
    // Proceed to SHOWING state
    self.state = AnimatedTextState_Showing;
}

@end
