//
//  SPAnimatedTextCharacter.m
//  hanokam
//
//  Created by Kenneth Pu on 6/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "SPAnimatedTextCharacter.h"
#import "GameEngineScene.h"
#import "Resource.h"
#import "FileCache.h"
#import "ControlManager.h"

NSString *FONT_FILE = @"korean_calligraphy.fnt";
CGFloat CHAR_DROP_HEIGHT = 20;

@interface SPAnimatedTextCharacter()
@property (nonatomic, readwrite) AnimatedTextState state;
@end

@implementation SPAnimatedTextCharacter {
    CCLabelBMFont *_characterLabel;
    CGFloat _amplitude;
}

#pragma mark - Constructors

+(SPAnimatedTextCharacter*)cons:(GameEngineScene*)game
                  withCharacter:(NSString*)character
                          color:(CCColor*)color
                      amplitude:(CGFloat)amplitude {
    return [(SPAnimatedTextCharacter*)[SPAnimatedTextCharacter node] cons:game
                                                            withCharacter:character
                                                                    color:color
                                                                amplitude:amplitude];
}

-(SPAnimatedTextCharacter*)cons:(GameEngineScene*)game
                  withCharacter:(NSString*)character
                          color:(CCColor*)color
                      amplitude:(CGFloat)amplitude {
    [self setAnchorPoint:ccp(0,0)];
    
    // Initialize character label
    _characterLabel = [CCLabelBMFont labelWithString:character
                                          fntFile:FONT_FILE];
    [_characterLabel setAnchorPoint:ccp(0.5,0)];
    [_characterLabel setColor:color];
    [_characterLabel setOpacity:0];
    [self addChild:_characterLabel];

    // Save amplitude
    _amplitude = amplitude;
    
    return self;
}

#pragma mark - State Machine

-(void)i_update:(GameEngineScene *)game
             ts:(CGFloat)ts {
    switch (self.state) {
        case AnimatedTextState_Hidden:
            // Wait here until signalled to begin entering
            break;
        case AnimatedTextState_Entering:
            if (ts < 1) {
                // fade in and drop animations for character label
                [_characterLabel setOpacity:ts];
                [_characterLabel setPosition:ccp(self.position.x,self.position.y+(1-ts)*CHAR_DROP_HEIGHT)];
            } else {
                // Once max is reached, proceed to SHOWING state
                [_characterLabel setOpacity:1];
                [_characterLabel setPosition:ccp(self.position.x,self.position.y)];
                self.state = AnimatedTextState_Showing;
            }
            break;
        case AnimatedTextState_Showing:
            // Sine wave style oscillation
            [_characterLabel setPosition:ccp(self.position.x,self.position.y+_amplitude*sinf(ts))];
            break;
        case AnimatedTextState_Exiting:
            if (ts < 1) {
                // fade out animation for character label
                [_characterLabel setOpacity:1-ts];
            } else {
                // Once min is reached, proceed to CAN_REMOVE state
                [_characterLabel setOpacity:0];
                self.state = AnimatedTextState_CanRemove;
            }
            break;
        case AnimatedTextState_CanRemove:
            // Wait here to be removed
            break;
        default:
            break;
    }
}

-(void)beginEntering {
    // Proceed to ENTERING state
    self.state = AnimatedTextState_Entering;
}

-(void)forceShowing {
    // Proceed to SHOWING state, force any in-progress animations to finished state
    [_characterLabel setOpacity:1];
    [_characterLabel setPosition:ccp(self.position.x,self.position.y)];
    self.state = AnimatedTextState_Showing;
    
}

-(void)beginExiting {
    // Proceed to EXITING state
    self.state = AnimatedTextState_Exiting;
}

@end
