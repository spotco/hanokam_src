//
//  SPStrokeNumberLabel.h
//  hanokam
//
//  Created by spotco on 16/07/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface SPLabel : CCNode

+(SPLabel*)cons_texkey:(NSString*)texkey;
-(SPLabel*)set_fillcolor:(ccColor4F)fillcolor strokecolor:(ccColor4F)strokecolor;
-(SPLabel*)set_string:(NSString*)string;
-(SPLabel*)set_right_aligned;
-(SPLabel*)add_char_offset:(unichar)tchar size_increase:(CGPoint)tsizei offset:(CGPoint)toffset;

@end
