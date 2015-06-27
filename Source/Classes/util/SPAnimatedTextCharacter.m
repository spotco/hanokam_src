//
//  SPAnimatedTextCharacter.m
//  hanokam
//
//  Created by Kenneth Pu on 6/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "SPAnimatedTextCharacter.h"
#import "GameEngineScene.h"

NSString *FONT_FILE = @"korean_calligraphy.fnt";
CGFloat CHAR_DROP_HEIGHT = 20;

@interface SPAnimatedTextCharacter()
@property (nonatomic, readwrite) AnimatedTextCharacterState state;
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
        case AnimatedTextCharacterState_Hidden:
            // Wait here until signalled to begin entering
            break;
        case AnimatedTextCharacterState_Entering:
            if (ts < 1) {
                // fade in and drop animations for character label
                [_characterLabel setOpacity:ts];
                [_characterLabel setPosition:ccp(self.position.x,self.position.y+(1-ts)*CHAR_DROP_HEIGHT)];
            } else {
                // Once max is reached, proceed to SHOWING state
                [_characterLabel setOpacity:1];
                [_characterLabel setPosition:ccp(self.position.x,self.position.y)];
                self.state = AnimatedTextCharacterState_Showing;
            }
            break;
        case AnimatedTextCharacterState_Showing:
            // Sine wave style oscillation
            [_characterLabel setPosition:ccp(self.position.x,self.position.y+_amplitude*sinf(ts-1))];
            break;
        default:
            break;
    }
}

-(void)beginEntering {
    // Proceed to ENTERING state
    self.state = AnimatedTextCharacterState_Entering;
}

-(void)forceShowing {
    // Proceed to SHOWING state, force any in-progress animations to finished state
    [_characterLabel setOpacity:1];
    [_characterLabel setPosition:ccp(self.position.x,self.position.y)];
    self.state = AnimatedTextCharacterState_Showing;
    
}

@end
